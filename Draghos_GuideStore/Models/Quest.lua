QuestMixin = {};

function QuestMixin:QuestInit(quest)
    self.questID = tonumber(quest.questID);
    C_QuestLog.RequestLoadQuestByID(self.questID);
end

function QuestMixin:GetQuestLabel()
    return self.questID and C_QuestLog.GetQuestInfo(self.questID);
end

function QuestMixin:IsQuestAvailable()
end

function QuestMixin:IsValidQuest()
    return self.questID and HaveQuestData(self.questID) and All(self:GetQuestObjectives(), CallOnSelf("IsValid"));
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
        return {};
    end

    local function CreateQuestObjective(questObjectiveIndex)
        return CreateAndInitFromMixin(StepLineQuestObjectiveMixin, questObjectives[questObjectiveIndex]);
    end

    -- If no index was supplied so we create all the objectives
    if questObjectivesIndexes == nil then
        questObjectivesIndexes = questObjectivesIndexes or Keys(questObjectives);
    end

    return Map(questObjectivesIndexes, CreateQuestObjective);
end
