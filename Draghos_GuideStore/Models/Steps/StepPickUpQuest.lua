StepPickUpQuestMixin = {};

Mixin(StepPickUpQuestMixin, StepMixin);
Mixin(StepPickUpQuestMixin, QuestMixin);
Mixin(StepPickUpQuestMixin, NPCMixin);
Mixin(StepPickUpQuestMixin, LocationMixin);

function StepPickUpQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    self:NPCInit(step.npc);
    self:LocationInit(step.location);
    self.stepLines = {CreateAndInitFromMixin(StepLineSpeakToMixin, step)};
end

function StepPickUpQuestMixin:GetStepType()
    return "PickUpQuest";
end

function StepPickUpQuestMixin:GetLabel()
    return PICKUP_QUEST:format(self:GetQuestLabel());
end

function StepPickUpQuestMixin:IsValid()
    return self:IsValidStep() and self:IsValidQuest() and self:IsValidNPC() and self:IsValidLocation();
end

function StepPickUpQuestMixin:IsCompleted()
    return self.questID and (C_QuestLog.IsOnQuest(self.questID) or C_QuestLog.IsQuestFlaggedCompleted(self.questID));
end
