local M = LibStub("Moses");

local QuestMixin = {};

function QuestMixin:QuestInit(quest)
    self.questID = tonumber(quest.questID);
    C_QuestLog.RequestLoadQuestByID(self.questID);

    self.requiredQuestIDs = quest.requiredQuestIDs or {};

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
    return self.questID and C_QuestLog.GetQuestInfo(self.questID);
end

function QuestMixin:IsQuestAvailable()
    return true; -- TODO: return false if faction/class/level/... requirements not met
end

local isNotValid = M.complement(M.partial(M.result, "_", "IsValid"));

function QuestMixin:IsValidQuest()
    return self.questID and HaveQuestData(self.questID) and not M(self:GetQuestObjectives()):any(isNotValid):value();
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

local function IsRequiredQuestCompleted(questID)
    local quest = Draghos_GuideStore:GetQuestByID(questID);
    return quest and QuestMixin.IsQuestTurnedIn(quest);
end

function QuestMixin:RequiredQuestsCompleted()
    return #self.requiredQuestIDs == 0 or M(self.requiredQuestIDs):all(IsRequiredQuestCompleted):value();
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

function QuestMixin:GetQuestObjectives()
    -- ! Do not use self:GetStepLines() to avoid circular reference within Virtual_StepWithObjectivesMixin:GetStepLines()
    local questObjectives = M(self.stepLines or {}):where(
                                {QuestObjectiveInit = DraghosMixins.QuestObjective.QuestObjectiveInit}
                            ):value();
    return questObjectives or {};
end

function QuestMixin:CreateQuestObjectives()
    if not self:IsValidQuest() then
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
    local questObjectivesIndexes = self.questObjectivesIndexes;
    if questObjectivesIndexes == nil then
        questObjectivesIndexes = questObjectivesIndexes or M.keys(questObjectives);
    end

    local function CreateQuestObjective(questObjectiveIndex)
        return Draghos_GuideStore:CreateGuideItem(
                   DraghosMixins.StepLineQuestObjective, questObjectives[questObjectiveIndex]
               );
    end
    return M(questObjectivesIndexes):map(CreateQuestObjective):value();
end

DraghosMixins.Quest = QuestMixin;
