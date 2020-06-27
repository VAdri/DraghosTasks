local StepProgressQuestObjectivesMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Step);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Quest);
-- Mixin(StepProgressQuestObjectiveMixin, LocationMixin);
Mixin(StepProgressQuestObjectivesMixin, DraghosMixins.Target);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);
    self:TargetInit(step.targets, step.quest.targets);

    self.questObjectivesIndexes = step.questObjectivesIndexes;
    self:AddMultipleStepLines(self:CreateQuestObjectives());
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "ProgressQuestObjectives";
end

function StepProgressQuestObjectivesMixin:GetLabel()
    return PROGRESS_QUEST_OBJECTIVES:format(self:GetStepLines():Count(), self:GetQuestLabel());
end

function StepProgressQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and not self:HasInvalidTargets();
end

function StepProgressQuestObjectivesMixin:IsCompleted()
    return self:IsQuestCompleted() or self:DependentStepsCompleted();
end

-- *********************************************************************************************************************
-- ***** Quest with objectives
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:IsPartial()
    return true;
end

-- *********************************************************************************************************************
-- ***** Styling
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:IsTrivial()
    return true;
end

-- *********************************************************************************************************************
-- ***** Waypoints
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:SkipWaypoint()
    -- The waypoint will be set for the next step
    return true;
end

-- *********************************************************************************************************************
-- ***** Override Step
-- *********************************************************************************************************************

function StepProgressQuestObjectivesMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepProgressQuestObjectives = StepProgressQuestObjectivesMixin;
