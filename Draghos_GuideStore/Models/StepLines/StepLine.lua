StepLineMixin = {};

Mixin(StepLineMixin, ObservableMixin);

function StepLineMixin:StepLineInit()
end

function StepLineMixin:IsValidStepLine()
    return true;
end

function StepLineMixin:IsProgress()
    return false;
end

function StepLineMixin:CanAddWaypoints()
    return false;
end
