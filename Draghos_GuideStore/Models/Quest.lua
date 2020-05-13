QuestMixin = {};

function QuestMixin:QuestInit(quest)
    self.questID = tonumber(quest.questID);
    C_QuestLog.RequestLoadQuestByID(self.questID);

    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_ACCEPTED");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_POI_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_LOG_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_QUEST_LOG_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "SUPER_TRACKED_QUEST_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_DATA_LOAD_RESULT");
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

function QuestMixin:IsValidQuest()
    return self.questID and HaveQuestData(self.questID) and All(self:GetQuestObjectives(), CallOnSelf("IsValid"));
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

function QuestMixin:GetQuestLogIndex()
    return GetQuestLogIndexByID(self.questID);
end

function QuestMixin:CanUseItem()
    local _, item = GetQuestLogSpecialItemInfo(self:GetQuestLogIndex());
    return not not item;
end

function QuestMixin:GetQuestObjectives()
    return FilterByProp(self.stepLines or {}, "QuestObjectiveInit", QuestObjectiveMixin.QuestObjectiveInit);
end

function QuestMixin:CreateQuestObjectives(questObjectivesIndexes)
    if not self:IsValidQuest() then
        return nil;
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
    if questObjectivesIndexes == nil then
        questObjectivesIndexes = questObjectivesIndexes or Keys(questObjectives);
    end

    local function CreateQuestObjective(questObjectiveIndex)
        return Draghos_GuideStore:CreateGuideItem(StepLineQuestObjectiveMixin, questObjectives[questObjectiveIndex]);
    end
    return Map(questObjectivesIndexes, CreateQuestObjective);
end
