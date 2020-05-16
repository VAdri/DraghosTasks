local FP = DraghosUtils.FP;

local StepCompleteQuestObjectivesMixin = {};

Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Step);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Quest);
-- Mixin(StepCompleteQuestObjectiveMixin, LocationMixin);
Mixin(StepCompleteQuestObjectivesMixin, DraghosMixins.Target);

function StepCompleteQuestObjectivesMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);
    self:TargetInit(FP:Concat(step.targets or {}, step.quest.targets or {}));

    self.questObjectivesIndexes = step.questObjectivesIndexes;
    self:AddMultipleStepLines(self:CreateQuestObjectives());
end

function StepCompleteQuestObjectivesMixin:GetStepType()
    return self:GetObjectivesType() or "CompleteQuestObjectives";
end

function StepCompleteQuestObjectivesMixin:GetLabel()
    return COMPLETE_QUEST_OBJECTIVES:format(#self:GetStepLines(), self:GetQuestLabel());
end

function StepCompleteQuestObjectivesMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and not self:HasInvalidTargets();
end

function StepCompleteQuestObjectivesMixin:IsCompleted()
    return self:IsQuestCompleted() or FP:All(self:GetQuestObjectives(), FP:CallOnSelf("IsQuestObjectiveCompleted"));
end

function StepCompleteQuestObjectivesMixin:IsPartial()
    return false;
end

function StepCompleteQuestObjectivesMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

DraghosMixins.StepCompleteQuestObjectives = StepCompleteQuestObjectivesMixin;
