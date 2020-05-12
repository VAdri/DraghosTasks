StepProgressQuestObjectivesMixin = {};

Mixin(StepProgressQuestObjectivesMixin, Virtual_StepWithObjectivesMixin);
Mixin(StepProgressQuestObjectivesMixin, StepMixin);
Mixin(StepProgressQuestObjectivesMixin, QuestMixin);
--Mixin(StepProgressQuestObjectiveMixin, LocationMixin);

function StepProgressQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    --self:LocationInit(step.location);
    self.stepLines = self:CreateQuestObjectives(step.questObjectivesIndexes);
end

function StepProgressQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "ProgressQuestObjectives";
end

function StepProgressQuestObjectivesMixin:GetLabel()
    return PROGRESS_QUEST_OBJECTIVES:format(#self.stepLines, self:GetQuestLabel());
end

function StepProgressQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() --[[and self:IsValidLocation()]];
end

function StepProgressQuestObjectivesMixin:IsPartial()
    return true;
end

function StepProgressQuestObjectivesMixin:IsCompleted()
    return self.isFlaggedCompleted; -- TODO
end
