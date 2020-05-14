StepHandInQuestMixin = {};

Mixin(StepHandInQuestMixin, StepMixin);
Mixin(StepHandInQuestMixin, QuestMixin);
Mixin(StepHandInQuestMixin, NPCMixin);
Mixin(StepHandInQuestMixin, LocationMixin);

function StepHandInQuestMixin:Init(step)
    self:StepInit(step);
    self:QuestInit(step.quest);
    self:NPCInit(step.npc);
    self:LocationInit(step.location);

    self:AddOneStepLine(Draghos_GuideStore:CreateGuideItem(StepLineSpeakToMixin, step));
end

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

function StepHandInQuestMixin:RequiredStepsCompleted()
    local requiredStepsCompleted = StepMixin.RequiredStepsCompleted(self);
    return requiredStepsCompleted and self:IsQuestCompleted();
end
