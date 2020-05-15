local FP = DraghosUtils.FP;

--- @class Step
local StepMixin = {};

Mixin(StepMixin, DraghosMixins.Observable);

function StepMixin:StepInit(step)
    self.stepID = tonumber(step.id);
    self.stepLines = {};
    self.requiredStepIDs = step.requiredStepIDs or {}; -- TODO: Detect potential circular references
    self.completedAfterCompletedStepIDs = step.completedAfterCompletedStepIDs or {}; -- TODO: Detect potential circular references
end

function StepMixin:IsStepAvailable()
    return self:RequiredStepsCompleted();
end

function StepMixin:IsAvailable()
    return self:IsStepAvailable();
end

function StepMixin:IsValidStep()
    return self.stepID and true or false;
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

function StepMixin:IsQuestItemToUse()
    return false;
end

local function IsCompleted(stepID)
    local step = Draghos_GuideStore:GetStepByID(stepID);
    return step and step:IsCompleted();
end

function StepMixin:RequiredStepsCompleted()
    return #self.requiredStepIDs == 0 or FP:All(self.requiredStepIDs, IsCompleted);
end

local function GetStepByID(stepID)
    return Draghos_GuideStore:GetStepByID(stepID);
end

function StepMixin:DependentStepsCompleted()
    return FP:All(FP:Map(self.completedAfterCompletedStepIDs, GetStepByID), FP:CallOnSelf("IsCompleted"));
end

function StepMixin:AddOneStepLine(stepLine)
    self.stepLines = FP:Append(self.stepLines, stepLine);
end

function StepMixin:AddMultipleStepLines(stepLines)
    self.stepLines = FP:Concat(self.stepLines, stepLines);
end

DraghosMixins.Step = StepMixin;
