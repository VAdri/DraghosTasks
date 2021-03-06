local StepCompleteQuestMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepCompleteQuestMixin, DraghosMixins.Step);
Mixin(StepCompleteQuestMixin, DraghosMixins.Virtual_StepWithObjectives);
Mixin(StepCompleteQuestMixin, DraghosMixins.Quest);
Mixin(StepCompleteQuestMixin, DraghosMixins.Target);

local StepCompleteQuestMT = {__index = function(t, key, ...) return StepCompleteQuestMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepCompleteQuestMixin.New(step)
    local item = setmetatable({}, StepCompleteQuestMT);
    item:Init(step);
    return item;
end

function StepCompleteQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    self:TargetInit(step.targets, step.quest.targets);
    -- self:LocationInit(step.location);

    self.questObjectivesIndexes = nil;
    self:AddMultipleStepLines(self:CreateQuestObjectives());
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepCompleteQuestMixin:GetStepType()
    return self:GetObjectivesType() or "CompleteQuest";
end

function StepCompleteQuestMixin:GetLabel()
    return COMPLETE_QUEST:format(self:GetQuestLabel());
end

function StepCompleteQuestMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and not self:HasInvalidTargets();
end

function StepCompleteQuestMixin:IsCompleted()
    return self:IsQuestCompleted();
end

-- *********************************************************************************************************************
-- ***** Override Step
-- *********************************************************************************************************************

function StepCompleteQuestMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and DraghosMixins.StepPickUpQuest.IsCompleted(self);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepCompleteQuest = StepCompleteQuestMixin;
