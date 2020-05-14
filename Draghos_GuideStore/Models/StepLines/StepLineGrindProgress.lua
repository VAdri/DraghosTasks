StepLineGrindProgressMixin = {};

Mixin(StepLineGrindProgressMixin, StepLineMixin);
Mixin(StepLineGrindProgressMixin, ExperienceMixin);

function StepLineGrindProgressMixin:Init(stepLine)
    self:StepLineInit();
    self:ExperienceInit(stepLine.experience);
end

function StepLineGrindProgressMixin:GetLabel()
    local isCurrentLevel = self:GetXPRequired();
    if isCurrentLevel then
        return GRIND_PROGRESS;
    else
        return GRIND_PROGRESS_TO_NEXT_LEVEL;
    end
end

function StepLineGrindProgressMixin:IsProgress()
    return true;
end

function StepLineGrindProgressMixin:GetProgressValues()
    local _, currentXP, requiredXP = self:GetXPRequired();
    return currentXP, requiredXP;
end

function StepLineGrindProgressMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidExperience();
end

function StepLineGrindProgressMixin:IsCompleted()
    return self:IsAboveLevelXP();
end
