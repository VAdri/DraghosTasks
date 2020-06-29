local StepPickUpQuestMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepPickUpQuestMixin, DraghosMixins.Step);
Mixin(StepPickUpQuestMixin, DraghosMixins.Quest);
Mixin(StepPickUpQuestMixin, DraghosMixins.NPC);
Mixin(StepPickUpQuestMixin, DraghosMixins.Location);
Mixin(StepPickUpQuestMixin, DraghosMixins.Target);

local StepPickUpQuestMT = {__index = function(t, key, ...) return StepPickUpQuestMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepPickUpQuestMixin.New(step)
    local item = setmetatable({}, StepPickUpQuestMT);
    item:Init(step);
    return item;
end

function StepPickUpQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    self:NPCInit(step.npc);
    self:TargetInit();
    self:LocationInit(step.location);

    self:AddOneStepLine(DraghosMixins.StepLineSpeakTo.New(step));
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepPickUpQuestMixin:GetStepType()
    return "PickUpQuest";
end

function StepPickUpQuestMixin:GetLabel()
    return PICKUP_QUEST:format(self:GetQuestLabel());
end

function StepPickUpQuestMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and self:IsValidNPC() and self:IsValidLocation();
end

function StepPickUpQuestMixin:IsAvailable()
    return self:IsQuestAvailable() and self:IsStepAvailable();
end

function StepPickUpQuestMixin:IsCompleted()
    return (C_QuestLog.IsOnQuest(self.questID) or self:IsQuestCompleted());
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepPickUpQuest = StepPickUpQuestMixin;
