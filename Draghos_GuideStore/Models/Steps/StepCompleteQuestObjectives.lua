StepCompleteQuestObjectivesMixin = {};

Mixin(StepCompleteQuestObjectivesMixin, Virtual_StepWithObjectivesMixin);
Mixin(StepCompleteQuestObjectivesMixin, StepMixin);
Mixin(StepCompleteQuestObjectivesMixin, QuestMixin);
-- Mixin(StepCompleteQuestObjectiveMixin, LocationMixin);

function StepCompleteQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);
    self.stepLines = self:CreateQuestObjectives(step.questObjectivesIndexes);
end

function StepCompleteQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "CompleteQuestObjectives";
end

function StepCompleteQuestObjectivesMixin:GetLabel()
    return COMPLETE_QUEST_OBJECTIVES:format(#self.stepLines, self:GetQuestLabel());
end

function StepCompleteQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest();
end

function StepCompleteQuestObjectivesMixin:IsCompleted()
    return self:IsQuestCompleted() or All(self:GetQuestObjectives(), CallOnSelf("IsQuestObjectiveCompleted"));
end

function StepCompleteQuestObjectivesMixin:IsPartial()
    return false;
end
