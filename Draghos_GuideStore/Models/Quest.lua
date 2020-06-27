local Lambdas = DraghosUtils.Lambdas;

local Linq = LibStub("Linq");

--- @type Enumerable
local Enumerable = Linq.Enumerable;

local QuestMixin = {};

local getQuest = function(questID)
    return Draghos_GuideStore:GetQuestByID(questID) or false;
end

function QuestMixin:QuestInit(quest)
    self.questID = tonumber(quest.questID);
    C_QuestLog.RequestLoadQuestByID(self.questID);

    self.requiredQuests = Enumerable.From(quest.requiredQuestIDs or {}):Select(getQuest):ToList();

    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_ACCEPTED");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_POI_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_LOG_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_QUEST_LOG_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "SUPER_TRACKED_QUEST_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_DATA_LOAD_RESULT");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_LOG_CRITERIA_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_AUTOCOMPLETE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_TURNED_IN");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_REMOVED");
end

function QuestMixin:GetQuestLabel()
    return self.questID and C_QuestLog.GetQuestInfo(self.questID); -- TODO: Test with "QuestUtils_GetQuestName(self.questID)"
end

function QuestMixin:IsQuestAvailable()
    return true; -- TODO: return false if faction/class/level/... requirements not met
end

local isNotValid = Lambdas.Not(Lambdas.SelfResult("IsValid"));

function QuestMixin:IsValidQuest()
    if (not self:HasCache("IsValidQuest")) then
        self:SetCache(
            "IsValidQuest",
            self.questID and HaveQuestData(self.questID) and not self:GetQuestObjectives():Any(isNotValid) and
                not self.requiredQuests:Any(function(quest) return quest == false; end)
        );
    end
    return self:GetCache("IsValidQuest");
end

function QuestMixin:IsQuestFinishedButNotTurnedIn()
    -- IsQuestComplete is true if the quest is both in the quest log and is complete, false otherwise.
    return IsQuestComplete(self.questID);
end

function QuestMixin:IsQuestTurnedIn()
    return C_QuestLog.IsQuestFlaggedCompleted(self.questID);
end

function QuestMixin:IsQuestCompleted()
    return self:IsQuestFinishedButNotTurnedIn() or self:IsQuestTurnedIn();
end

function QuestMixin:HasRequiredQuests()
    return self.requiredQuests:Any();
end

local isQuestCompleted = function(quest)
    return quest and QuestMixin.IsQuestTurnedIn(quest);
end

function QuestMixin:RequiredQuestsCompleted()
    if (not self:HasRequiredQuests()) then
        return true;
    end

    if (not self:HasCache("RequiredQuestsCompleted")) then
        self:SetCache("RequiredQuestsCompleted", self.requiredQuests:All(isQuestCompleted));
    end
    return self:GetCache("RequiredQuestsCompleted");
end

function QuestMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and self:RequiredQuestsCompleted();
end

function QuestMixin:GetQuestLogIndex()
    return GetQuestLogIndexByID(self.questID);
end

function QuestMixin:CanUseItem()
    local _, itemID = GetQuestLogSpecialItemInfo(self:GetQuestLogIndex());
    return itemID ~= nil;
end

function QuestMixin:IsQuestItemToUse()
    return true;
end

local isQuestObjectiveMixin = function(stepLine)
    return stepLine.QuestObjectiveInit == DraghosMixins.QuestObjective.QuestObjectiveInit;
end;

function QuestMixin:GetQuestObjectives()
    -- if (not self.stepLines) then
    --     return {};
    -- end
    -- if (not self:HasCache("GetQuestObjectives")) then
    --     -- ! Do not use self:GetStepLines() to avoid circular reference within Virtual_StepWithObjectivesMixin:GetStepLines()
    --     self:SetCache(
    --         -- "GetQuestObjectives", M(self.stepLines and self.stepLines:ToArray() or {}):where(
    --         --     {QuestObjectiveInit = DraghosMixins.QuestObjective.QuestObjectiveInit}
    --         -- ):value()
    --         "GetQuestObjectives", self.stepLines:Where(isQuestObjectiveMixin)
    --     );
    -- end
    -- return self:GetCache("GetQuestObjectives");
    -- ! Do not use self:GetStepLines() to avoid circular reference within Virtual_StepWithObjectivesMixin:GetStepLines()
    return self.stepLines:Where(isQuestObjectiveMixin);
end

function QuestMixin:CreateQuestObjectives()
    local isValidQuest = self:IsValidQuest();

    -- Clearing the quest objectives cache because new quest objectives may be added
    self:ClearCache("GetQuestObjectives");
    self:ClearCache("GetObjectivesType");

    if (not isValidQuest) then
        return {};
    end

    local questObjectives = Draghos_GuideStore:GetQuestByID(self.questID).questObjectives;
    if not questObjectives or #questObjectives == 0 then
        -- No quest objective given: we create all the quest objectives returned by Blizzard's API
        local numQuestObjectives = C_QuestLog.GetNumQuestObjectives(self.questID);
        questObjectives = {};
        for i = 1, numQuestObjectives do
            table.insert(questObjectives, {questObjective = {questID = self.questID, index = i}});
        end
    end

    -- No quest objective found
    if not questObjectives or #questObjectives == 0 then
        return {};
    end

    -- If no index was supplied we create all the objectives
    local questObjectivesIndexes = self.questObjectivesIndexes
        and Enumerable.From(self.questObjectivesIndexes)
        or Enumerable.From(questObjectives):Select(Lambdas.SelectKey);

    local function CreateQuestObjective(questObjectiveIndex)
        return Draghos_GuideStore:CreateGuideItem(
                   DraghosMixins.StepLineQuestObjective, questObjectives[questObjectiveIndex]
               );
    end
    return questObjectivesIndexes:Select(CreateQuestObjective);
end

DraghosMixins.Quest = QuestMixin;
