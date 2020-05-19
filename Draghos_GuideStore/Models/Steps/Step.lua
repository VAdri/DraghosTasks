local FP = DraghosUtils.FP;

--- @class Step
local StepMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepMixin, DraghosMixins.Observable);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

local function CreateNote(note)
    return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepLineNote, note);
end

function StepMixin:StepInit(step)
    self.stepID = tonumber(step.id);
    self.stepLines = {};
    self.requiredStepIDs = step.requiredStepIDs or {}; -- TODO: Detect potential circular references
    self.completedAfterCompletedStepIDs = step.completedAfterCompletedStepIDs or {}; -- TODO: Detect potential circular references

    if step.notes and #step.notes > 0 then
        self:AddMultipleStepLines(FP:Map(step.notes, CreateNote));
    end
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepMixin:GetStepType()
    return "";
end

function StepMixin:GetLabel()
    return "";
end

function StepMixin:IsValid()
    -- Needs to be overriden to be valid
    return false;
end

function StepMixin:IsAvailable()
    return self:IsStepAvailable();
end

-- *********************************************************************************************************************
-- ***** Step
-- *********************************************************************************************************************

function StepMixin:IsStepAvailable()
    return self:RequiredStepsCompleted();
end

function StepMixin:IsValidStep()
    local function isValidStep()
        return FP:All(self:GetStepLines(), FP:CallOnSelf("IsValid"));
    end
    return self.stepID and FP:Memo("IsValidStep:" .. tostring(self), isValidStep);
end

local function GetStepByID(stepID)
    return Draghos_GuideStore:GetStepByID(stepID);
end

local function IsCompleted(stepID)
    local step = GetStepByID(stepID);
    return step and step:IsCompleted();
end

function StepMixin:RequiredStepsCompleted()
    local function requiredStepsCompleted()
        return FP:All(self.requiredStepIDs, IsCompleted);
    end
    return #self.requiredStepIDs == 0 or FP:Memo("RequiredStepsCompleted:" .. tostring(self), requiredStepsCompleted);
end

function StepMixin:HasDependentSteps()
    return #self.completedAfterCompletedStepIDs > 0;
end

function StepMixin:DependentStepsCompleted()
    local function dependentStepsCompleted()
        return FP:All(FP:Map(self.completedAfterCompletedStepIDs, GetStepByID), FP:CallOnSelf("IsCompleted"));
    end
    return FP:Memo("DependentStepsCompleted:" .. tostring(self), dependentStepsCompleted);
end

-- *********************************************************************************************************************
-- ***** Waypoints
-- *********************************************************************************************************************

function StepMixin:SkipWaypoint()
    return false;
end

function StepMixin:CanAddWaypoints()
    local function canAddWaypoints()
        return FP:Any(self:GetStepLines(), FP:CallOnSelf("CanAddWaypoints"));
    end
    return FP:Memo("CanAddWaypoints:" .. tostring(self), canAddWaypoints);
end

function StepMixin:GetWaypointsInfo()
    local function getWaypointsInfo()
        local stepLineLocations = FP:Filter(self:GetStepLines(), FP:CallOnSelf("CanAddWaypoints"));
        return FP:Flatten(FP:Map(stepLineLocations, FP:CallOnSelf("GetWaypointsInfo")));
    end
    return FP:Memo("GetWaypointsInfo:" .. tostring(self), getWaypointsInfo);
end

-- *********************************************************************************************************************
-- ***** Target Button
-- *********************************************************************************************************************

function StepMixin:GetTargetNPCs()
    local function getTargetNPCs()
        return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetNPCs"));
    end
    return FP:Memo("GetTargetNPCs:" .. tostring(self), getTargetNPCs);
end

function StepMixin:HasTargets()
    local function hasTargets()
        return FP:Any(self:GetStepLines(), FP:CallOnSelf("HasTargets"));
    end
    return FP:Memo("HasTargets:" .. tostring(self), hasTargets);
end

function StepMixin:HasInvalidTargets()
    local function hasInvalidTargets()
        return FP:Any(self:GetStepLines(), FP:CallOnSelf("HasInvalidTargets"));
    end
    return FP:Memo("HasInvalidTargets:" .. tostring(self), hasInvalidTargets);
end

function StepMixin:GetTargetNames()
    local function getTargetNames()
        return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetNames"));
    end
    return FP:Memo("GetTargetNames:" .. tostring(self), getTargetNames);
end

function StepMixin:GetTargetIDs()
    local function getTargetIDs()
        return FP:FlatMap(self:GetStepLines(), FP:CallOnSelf("GetTargetIDs"));
    end
    return FP:Memo("GetTargetIDs:" .. tostring(self), getTargetIDs);
end

-- *********************************************************************************************************************
-- ***** Item Button
-- *********************************************************************************************************************

function StepMixin:CanUseItem()
    return false;
end

-- *********************************************************************************************************************
-- ***** Quest Item Button
-- *********************************************************************************************************************

function StepMixin:IsQuestItemToUse()
    return false;
end

-- *********************************************************************************************************************
-- ***** Complete Step Checkbox
-- *********************************************************************************************************************

function StepMixin:IsManualCompletion()
    return false;
end

-- *********************************************************************************************************************
-- ***** Styling
-- *********************************************************************************************************************

function StepMixin:IsImportant()
    return false;
end

function StepMixin:IsTrivial()
    return false;
end

-- *********************************************************************************************************************
-- ***** StepLines
-- *********************************************************************************************************************

function StepMixin:GetStepLines()
    local function getStepLines()
        return FP:Filter(self.stepLines or {}, FP:ReverseResult(FP:CallOnSelf("IsDisabled")));
    end
    return FP:Memo("GetStepLines:" .. tostring(self), getStepLines);
end

function StepMixin:AddOneStepLine(stepLine)
    stepLine.step = self;
    self.stepLines = FP:Append(self:GetStepLines(), stepLine);
    stepLine.lineIndex = #self.stepLines;
end

function StepMixin:AddMultipleStepLines(stepLines)
    for i, stepLine in pairs(stepLines) do
        stepLine.step = self;
        stepLine.lineIndex = #self.stepLines + i;
    end
    self.stepLines = FP:Concat(self:GetStepLines(), stepLines);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.Step = StepMixin;
