local FP = DraghosUtils.FP;

--- @class Step
local StepMixin = {};

Mixin(StepMixin, DraghosMixins.Observable);

-- *********************************************************************************************************************
-- ***** Step
-- *********************************************************************************************************************

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
    return self.stepID and FP:All(self:GetStepLines(), FP:CallOnSelf("IsValid"));
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

-- *********************************************************************************************************************
-- ***** Location
-- *********************************************************************************************************************

function StepMixin:SkipWaypoint()
    return false;
end

function StepMixin:CanAddWaypoints()
    return FP:Any(self:GetStepLines(), FP:CallOnSelf("CanAddWaypoints"));
end

function StepMixin:GetWaypointsInfo()
    local stepLineLocations = FP:Filter(self:GetStepLines(), FP:CallOnSelf("CanAddWaypoints"));
    return FP:Flatten(FP:Map(stepLineLocations, FP:CallOnSelf("GetWaypointsInfo")));
end

-- *********************************************************************************************************************
-- ***** Target
-- *********************************************************************************************************************

function StepMixin:GetTargetNPCs()
    return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetNPCs"));
end

function StepMixin:HasTargets()
    return FP:Any(self:GetStepLines(), FP:CallOnSelf("HasTargets"));
end

function StepMixin:HasInvalidTargets()
    return FP:Any(self:GetStepLines(), FP:CallOnSelf("HasInvalidTargets"));
end

function StepMixin:GetTargetNames()
    return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetNames"));
end

function StepMixin:GetTargetIDs()
    return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetIDs"));
end

-- *********************************************************************************************************************
-- ***** Item
-- *********************************************************************************************************************

function StepMixin:CanUseItem()
    return false;
end

-- *********************************************************************************************************************
-- ***** Quest
-- *********************************************************************************************************************

function StepMixin:IsQuestItemToUse()
    return false;
end

-- *********************************************************************************************************************
-- ***** StepLines
-- *********************************************************************************************************************

function StepMixin:GetStepLines()
    return self.stepLines or {};
end

function StepMixin:AddOneStepLine(stepLine)
    stepLine.step = self;
    self.stepLines = FP:Append(self:GetStepLines(), stepLine);
end

function StepMixin:AddMultipleStepLines(stepLines)
    for _, stepLine in pairs(stepLines) do
        stepLine.step = self;
    end
    self.stepLines = FP:Concat(self:GetStepLines(), stepLines);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.Step = StepMixin;
