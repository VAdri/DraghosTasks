local StepHandInQuestMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepHandInQuestMixin, DraghosMixins.Step);
Mixin(StepHandInQuestMixin, DraghosMixins.Quest);
Mixin(StepHandInQuestMixin, DraghosMixins.NPC);
Mixin(StepHandInQuestMixin, DraghosMixins.Location);
Mixin(StepHandInQuestMixin, DraghosMixins.Target);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepHandInQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    self:NPCInit(step.npc);
    self:TargetInit();
    self:LocationInit(step.location);

    self:AddOneStepLine(Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepLineSpeakTo, step));
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepHandInQuestMixin:GetStepType()
    return "HandInQuest";
end

function StepHandInQuestMixin:GetLabel()
    return HANDIN_QUEST:format(self:GetQuestLabel());
end

function StepHandInQuestMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and self:IsValidNPC() and self:IsValidLocation();
end

function StepHandInQuestMixin:IsCompleted()
    return self:IsQuestTurnedIn();
end

-- *********************************************************************************************************************
-- ***** Override Step
-- *********************************************************************************************************************

function StepHandInQuestMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = DraghosMixins.Step.RequiredStepsCompleted(self);
    return requiredStepsCompleted and self:IsQuestCompleted();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepHandInQuest = StepHandInQuestMixin;
