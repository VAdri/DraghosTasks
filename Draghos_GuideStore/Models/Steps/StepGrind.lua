local StepGrindMixin = {}

Mixin(StepGrindMixin, DraghosMixins.Step);
Mixin(StepGrindMixin, DraghosMixins.Experience);

function StepGrindMixin:Init(step)
    self:StepInit(step);
    self:ExperienceInit(step.experience);
    -- self:LocationInit(step.location);

    self:AddOneStepLine(Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepLineGrindProgress, step));
end

function StepGrindMixin:GetStepType()
    return "Grind";
end

function StepGrindMixin:GetLabel()
    return GRIND_TO:format(self:GetExperienceLabel());
end

function StepGrindMixin:IsValid()
    return self:IsValidStep() and self:IsValidExperience();
end

function StepGrindMixin:IsCompleted()
    return self:IsAboveLevelXP();
end

DraghosMixins.StepGrind = StepGrindMixin;