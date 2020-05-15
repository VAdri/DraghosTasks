local StepCompleteQuestMixin = {};

Mixin(StepCompleteQuestMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepCompleteQuestMixin, DraghosMixins.Step);
Mixin(StepCompleteQuestMixin, DraghosMixins.Quest);

function StepCompleteQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    -- self:LocationInit(step.location);

    self:AddMultipleStepLines(self:CreateQuestObjectives(nil));
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
    return self:IsQuestCompleted();
end

function StepCompleteQuestMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

DraghosMixins.StepCompleteQuest = StepCompleteQuestMixin;
