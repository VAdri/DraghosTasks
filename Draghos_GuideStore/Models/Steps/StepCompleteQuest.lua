StepCompleteQuestMixin = {};

Mixin(StepCompleteQuestMixin, Virtual_StepWithObjectivesMixin);
Mixin(StepCompleteQuestMixin, StepMixin);
Mixin(StepCompleteQuestMixin, QuestMixin);

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
    local requiredStepsCompleted = StepMixin.RequiredStepsCompleted(self);
    return requiredStepsCompleted and StepPickUpQuestMixin.IsCompleted(self);
end
