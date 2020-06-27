local Lambdas = DraghosUtils.Lambdas;

local StepCompleteQuestObjectivesMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Step);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Quest);
-- Mixin(StepCompleteQuestObjectiveMixin, LocationMixin);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Target);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepCompleteQuestObjectivesMixin:Init(step)
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

function StepCompleteQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "CompleteQuestObjectives";
end

function StepCompleteQuestObjectivesMixin:GetLabel()
    return COMPLETE_QUEST_OBJECTIVES:format(self:GetStepLines():Count(), self:GetQuestLabel());
end

function StepCompleteQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and not self:HasInvalidTargets();
end

function StepCompleteQuestObjectivesMixin:IsCompleted()
    -- if (not self:HasCache("IsCompleted")) then
    --     self:SetCache(
    --         "IsCompleted",
    --         self:IsQuestCompleted() or not self:GetQuestObjectives():Any(Lambdas.Not(Lambdas.SelfResult("IsQuestObjectiveCompleted")))
    --     );
    -- end
    -- return self:GetCache("IsCompleted");
    return self:IsQuestCompleted() or
               not self:GetQuestObjectives():Any(Lambdas.Not(Lambdas.SelfResult("IsQuestObjectiveCompleted")));
end

-- *********************************************************************************************************************
-- ***** Quest with objectives
-- *********************************************************************************************************************

function StepCompleteQuestObjectivesMixin:IsPartial()
    return false;
end

-- *********************************************************************************************************************
-- ***** Override Step
-- *********************************************************************************************************************

function StepCompleteQuestObjectivesMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepCompleteQuestObjectives = StepCompleteQuestObjectivesMixin;
