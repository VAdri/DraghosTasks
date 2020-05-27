local M = LibStub("Moses");

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
        self:AddMultipleStepLines(M(step.notes):map(CreateNote):value());
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

local isValid = M.partial(M.result, "_", "IsValid");
local isCompleted = M.partial(M.result, "_", "IsCompleted");
local function getStepByID(stepID)
    return Draghos_GuideStore:GetStepByID(stepID);
end

function StepMixin:IsStepAvailable()
    return self:RequiredStepsCompleted();
end

function StepMixin:IsValidStep()
    return self.stepID and M(self:GetStepLines()):all(isValid):value();
end

function StepMixin:RequiredStepsCompleted()
    return #self.requiredStepIDs == 0 or M(self.requiredStepIDs):map(getStepByID):all(isCompleted):value();
end

function StepMixin:HasDependentSteps()
    return #self.completedAfterCompletedStepIDs > 0;
end

function StepMixin:DependentStepsCompleted()
    return not self:HasDependentSteps() or
               M(self.completedAfterCompletedStepIDs):map(getStepByID):all(isCompleted):value();
end

-- *********************************************************************************************************************
-- ***** Waypoints
-- *********************************************************************************************************************

local canAddWaypoints = M.partial(M.result, "_", "CanAddWaypoints");
local getWaypointsInfo = M.partial(M.result, "_", "GetWaypointsInfo");

function StepMixin:SkipWaypoint()
    return false;
end

function StepMixin:CanAddWaypoints()
    return M(self:GetStepLines()):any(canAddWaypoints):value();
end

function StepMixin:GetWaypointsInfo()
    return M(self:GetStepLines()):filter(canAddWaypoints):map(getWaypointsInfo):flatten(true):value();
end

-- *********************************************************************************************************************
-- ***** Target Button
-- *********************************************************************************************************************

local getTargetNPCs = M.partial(M.result, "_", "GetTargetNPCs");
local hasTargets = M.partial(M.result, "_", "HasTargets");
local hasInvalidTargets = M.partial(M.result, "_", "HasInvalidTargets");
local getTargetNames = M.partial(M.result, "_", "GetTargetNames");
local getTargetIDs = M.partial(M.result, "_", "GetTargetIDs");

function StepMixin:GetTargetNPCs()
    return M(self:GetStepLines()):map(getTargetNPCs):flatten(true):value();
end

function StepMixin:HasTargets()
    return M(self:GetStepLines()):any(hasTargets):value();
end

function StepMixin:HasInvalidTargets()
    return M(self:GetStepLines()):any(hasInvalidTargets):value();
end

function StepMixin:GetTargetNames()
    return M(self:GetStepLines()):map(getTargetNames):flatten(true):value();
end

function StepMixin:GetTargetIDs()
    return M(self:GetStepLines()):map(getTargetIDs):flatten(true):value();
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

local isNotDisabled = M.complement(M.partial(M.result, "_", "IsDisabled"));

function StepMixin:GetStepLines()
    return M(self.stepLines or {}):filter(isNotDisabled):value();
end

function StepMixin:AddOneStepLine(stepLine)
    stepLine.step = self;
    self.stepLines = M.addTop(self.stepLines, stepLine);
    stepLine.lineIndex = #self.stepLines;
end

function StepMixin:AddMultipleStepLines(stepLines)
    for i, stepLine in ipairs(stepLines) do
        stepLine.step = self;
        stepLine.lineIndex = #self.stepLines + i;
    end
    self.stepLines = M.append(self.stepLines, stepLines);
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.Step = StepMixin;
