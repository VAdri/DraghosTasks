StepLineSpeakToMixin = {};

Mixin(StepLineSpeakToMixin, StepLineMixin);
Mixin(StepLineSpeakToMixin, NPCMixin);
Mixin(StepLineSpeakToMixin, LocationMixin);

function StepLineSpeakToMixin:Init(stepLine)
    self:StepLineInit();
    self:NPCInit(stepLine.npc);
    self:LocationInit(stepLine.location);
end

function StepLineSpeakToMixin:GetLabel()
    return SPEAK_TO_NPC_IN_LOCATION:format(self:GetNPCName(), self:GetZoneName());
end

function StepLineSpeakToMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidNPC() and self:IsValidLocation();
end

function StepLineSpeakToMixin:IsCompleted()
    return false;
end
