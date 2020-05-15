local Helpers = DraghosUtils.Helpers;

local StepLineSpeakToMixin = {};

Mixin(StepLineSpeakToMixin, DraghosMixins.StepLine);
Mixin(StepLineSpeakToMixin, DraghosMixins.NPC);
Mixin(StepLineSpeakToMixin, DraghosMixins.Location);
Mixin(StepLineSpeakToMixin, DraghosMixins.Target);

function StepLineSpeakToMixin:Init(stepLine)
    self:StepLineInit();
    self:NPCInit(stepLine.npc);
    self:LocationInit(stepLine.location);
    self:TargetInit({stepLine.npc});

    -- When speaking to a standard NPC
    Draghos_GuideStore:RegisterForNotifications(self, "GOSSIP_SHOW");
    Draghos_GuideStore:RegisterForNotifications(self, "GOSSIP_CLOSED");

    -- When speaking to a quest giver/finisher
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_COMPLETE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_PROGRESS");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_FINISHED");

    -- When speaking to a merchant
    Draghos_GuideStore:RegisterForNotifications(self, "MERCHANT_SHOW");
    Draghos_GuideStore:RegisterForNotifications(self, "MERCHANT_CLOSED");
end

function StepLineSpeakToMixin:GetLabel()
    return SPEAK_TO_NPC_IN_LOCATION:format(self:GetNPCName(), self:GetZoneName());
end

function StepLineSpeakToMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidNPC() and self:IsValidLocation() and not self:HasInvalidTargets();
end

function StepLineSpeakToMixin:IsCompleted()
    return Helpers:UnitHasUnitID("npc", self.npcID);
end

DraghosMixins.StepLineSpeakTo = StepLineSpeakToMixin;
