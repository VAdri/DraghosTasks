local FP = DraghosUtils.FP;

--- @class Step
StepMixin = {};

Mixin(StepMixin, ObservableMixin);

function StepMixin:StepInit(step)
    self.stepID = tonumber(step.id);
    self.requiredStepIDs = step.requiredStepIDs or {};
end

function StepMixin:IsAvailable()
    return self:RequiredStepsCompleted();
end

function StepMixin:IsValidStep()
    return (self.stepID and self.requiredStepIDs) and true or false;
end

function StepMixin:SkipWaypoint()
    return false;
end

function StepMixin:CanAddWaypoints()
    return FP:Any(self.stepLines or {}, FP:CallOnSelf("CanAddWaypoints"));
end

function StepMixin:GetWaypointsInfo()
    local stepLineLocations = FP:Filter(self.stepLines or {}, FP:CallOnSelf("CanAddWaypoints"));
    return FP:Flatten(FP:Map(stepLineLocations, FP:CallOnSelf("GetWaypointsInfo")));
end

function StepMixin:CanUseItem()
    return false;
end

local function IsCompleted(stepID)
    local step = Draghos_GuideStore:GetStepByID(stepID);
    return step and step:IsCompleted();
end

function StepMixin:RequiredStepsCompleted()
    return #self.requiredStepIDs == 0 or FP:All(self.requiredStepIDs, IsCompleted);
end
