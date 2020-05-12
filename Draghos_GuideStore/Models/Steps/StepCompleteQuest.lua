StepCompleteQuestMixin = {};

Mixin(StepCompleteQuestMixin, Virtual_StepWithObjectivesMixin);
Mixin(StepCompleteQuestMixin, StepMixin);
Mixin(StepCompleteQuestMixin, QuestMixin);

function StepCompleteQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);
    self.stepLines = self:CreateQuestObjectives(nil);
end

function StepCompleteQuestMixin:GetStepType()
    return self:GetObjectivesType() or "CompleteQuest";
end

function StepCompleteQuestMixin:GetLabel()
    return COMPLETE_QUEST:format(self:GetQuestLabel());
end

function StepCompleteQuestMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest();
end

function StepCompleteQuestMixin:IsCompleted()
    -- IsQuestComplete is true if the quest is both in the quest log and is complete, false otherwise.
    return IsQuestComplete(self.questID) or C_QuestLog.IsQuestFlaggedCompleted(self.questID);
end
