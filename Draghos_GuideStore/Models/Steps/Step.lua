--- @class Step
StepMixin = {};

STEP_TYPE_PICKUP_QUEST = 1;
STEP_TYPE_PROGRESS_QUEST_OBJECTIVE = 2;
STEP_TYPE_COMPLETE_QUEST_OBJECTIVE = 3;
STEP_TYPE_COMPLETE_QUEST = 4;
STEP_TYPE_HANDIN_QUEST = 5;

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
    return Any(self.stepLines or {}, CallOnSelf("CanAddWaypoints"));
end

function StepMixin:GetWaypointsInfo()
    local stepLineLocations = Filter(self.stepLines or {}, CallOnSelf("CanAddWaypoints"));
    return Flatten(Map(stepLineLocations, CallOnSelf("GetWaypointsInfo")));
end

function StepMixin:CanUseItem()
    return false;
end

local function IsCompleted(stepID)
    local step = Draghos_GuideStore:GetStepByID(stepID);
    return step and step:IsCompleted();
end

function StepMixin:RequiredStepsCompleted()
    return #self.requiredStepIDs == 0 or All(self.requiredStepIDs, IsCompleted);
end
