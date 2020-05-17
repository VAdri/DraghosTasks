local StepLineMixin = {};

Mixin(StepLineMixin, DraghosMixins.Observable);

function StepLineMixin:StepLineInit()
end

function StepLineMixin:IsValidStepLine()
    return true;
end

function StepLineMixin:IsValid()
    return self:IsValidStepLine();
end

function StepLineMixin:IsAvailable()
    return self.step and self.step:IsAvailable() or false;
end

function StepLineMixin:IsProgress()
    return false;
end

function StepLineMixin:CanAddWaypoints()
    return false;
end

function StepLineMixin:GetStepLines()
    return {};
end

function StepLineMixin:HasTargets()
    return false;
end

DraghosMixins.StepLine = StepLineMixin
