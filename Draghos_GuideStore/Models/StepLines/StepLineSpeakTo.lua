StepLineSpeakToMixin = {};

Mixin(StepLineSpeakToMixin, StepLineMixin);
Mixin(StepLineSpeakToMixin, NPCMixin);
Mixin(StepLineSpeakToMixin, LocationMixin);

function StepLineSpeakToMixin:Init(stepLine)
    self:StepLineInit();
    self:NPCInit(stepLine.npc);
    self:LocationInit(stepLine.location);

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
    return self:IsValidStepLine() and self:IsValidNPC() and self:IsValidLocation();
end

function StepLineSpeakToMixin:IsCompleted()
    return UnitHasUnitID("npc", self.npcID);
end
