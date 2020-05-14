local FP = DraghosUtils.FP;

StepProgressQuestObjectivesMixin = {};

Mixin(StepProgressQuestObjectivesMixin, Virtual_StepWithObjectivesMixin);
Mixin(StepProgressQuestObjectivesMixin, StepMixin);
Mixin(StepProgressQuestObjectivesMixin, QuestMixin);
-- Mixin(StepProgressQuestObjectiveMixin, LocationMixin);

function StepProgressQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);

    self:AddMultipleStepLines(self:CreateQuestObjectives(step.questObjectivesIndexes));

    self.completedAfterCompletedStepIDs = step.completedAfterCompletedStepIDs or {};
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
    return self:IsValidStep() and self:IsValidQuest();
end

function StepProgressQuestObjectivesMixin:IsPartial()
    return true;
end

local function GetStepByID(stepID)
    return Draghos_GuideStore:GetStepByID(stepID);
end

function StepProgressQuestObjectivesMixin:DependentStepsCompleted()
    return FP:All(FP:Map(self.completedAfterCompletedStepIDs, GetStepByID), FP:CallOnSelf("IsCompleted"));
end

function StepProgressQuestObjectivesMixin:IsCompleted()
    return self:IsQuestCompleted() or self:DependentStepsCompleted();
end

function StepProgressQuestObjectivesMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = StepMixin.RequiredStepsCompleted(self);
    return requiredStepsCompleted and StepPickUpQuestMixin.IsCompleted(self);
end
