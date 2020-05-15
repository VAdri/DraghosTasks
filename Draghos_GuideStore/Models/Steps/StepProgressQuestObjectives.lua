local FP = DraghosUtils.FP;

local StepProgressQuestObjectivesMixin = {};

Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Step);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Quest);
-- Mixin(StepProgressQuestObjectiveMixin, LocationMixin);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Target);

function StepProgressQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);
    self:TargetInit(FP:Concat(step.targets or {}, step.quest.targets or {}));

    self:AddMultipleStepLines(self:CreateQuestObjectives(step.questObjectivesIndexes));
end

function StepProgressQuestObjectivesMixin:SkipWaypoint()
    -- The waypoint will be set for the next step
    return true;
end

function StepProgressQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "ProgressQuestObjectives";
end

function StepProgressQuestObjectivesMixin:GetLabel()
    return PROGRESS_QUEST_OBJECTIVES:format(#self.stepLines, self:GetQuestLabel());
end

function StepProgressQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and not self:HasInvalidTargets();
end

function StepProgressQuestObjectivesMixin:IsPartial()
    return true;
end

function StepProgressQuestObjectivesMixin:IsCompleted()
    return self:IsQuestCompleted() or self:DependentStepsCompleted();
end

function StepProgressQuestObjectivesMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

DraghosMixins.StepProgressQuestObjectives = StepProgressQuestObjectivesMixin;
