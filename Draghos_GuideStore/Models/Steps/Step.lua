local M = LibStub("Moses");

--- @class Step
local StepMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepMixin, DraghosMixins.Cache);
Mixin(StepMixin, DraghosMixins.Observable);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

local function CreateNote(note)
    return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepLineNote, note);
end

function StepMixin:StepInit(step)
    self:CacheInit();

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
    if (not self:HasCache("IsValidStep")) then
        self:SetCache("IsValidStep", self.stepID and M(self:GetStepLines()):all(isValid):value());
    end
    return self:GetCache("IsValidStep");
end

function StepMixin:HasRequiredSteps()
    return #self.requiredStepIDs > 0;
end

function StepMixin:RequiredStepsCompleted()
    if (not self:HasRequiredSteps()) then
        -- No required steps
        return true;
    end

    if (not self:HasCache("RequiredStepsCompleted")) then
        self:SetCache("RequiredStepsCompleted", M(self.requiredStepIDs):map(getStepByID):all(isCompleted):value());
    end
    return self:GetCache("RequiredStepsCompleted");
end

function StepMixin:HasDependentSteps()
    return #self.completedAfterCompletedStepIDs > 0;
end

function StepMixin:DependentStepsCompleted()
    if (not self:HasDependentSteps()) then
        -- No dependent steps
        return true;
    end

    if (not self:HasCache("DependentStepsCompleted")) then
        self:SetCache(
            "DependentStepsCompleted", M(self.completedAfterCompletedStepIDs):map(getStepByID):all(isCompleted):value()
        );
    end
    return self:GetCache("DependentStepsCompleted");
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
    if (not self:HasCache("CanAddWaypoints")) then
        self:SetCache("CanAddWaypoints", M(self:GetStepLines()):any(canAddWaypoints):value());
    end
    return self:GetCache("CanAddWaypoints");
end

function StepMixin:GetWaypointsInfo()
    if (not self:HasCache("GetWaypointsInfo")) then
        self:SetCache(
            "GetWaypointsInfo",
            M(self:GetStepLines()):filter(canAddWaypoints):map(getWaypointsInfo):flatten(true):value()
        );
    end
    return self:GetCache("GetWaypointsInfo");
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
    if (not self:HasCache("GetTargetNPCs")) then
        self:SetCache("GetTargetNPCs", M(self:GetStepLines()):map(getTargetNPCs):flatten(true):value());
    end
    return self:GetCache("GetTargetNPCs");
end

function StepMixin:HasTargets()
    if (not self:HasCache("HasTargets")) then
        self:SetCache("HasTargets", M(self:GetStepLines()):any(hasTargets):value());
    end
    return self:GetCache("HasTargets");
end

function StepMixin:HasInvalidTargets()
    if (not self:HasCache("HasInvalidTargets")) then
        self:SetCache("HasInvalidTargets", M(self:GetStepLines()):any(hasInvalidTargets):value());
    end
    return self:GetCache("HasInvalidTargets");
end

function StepMixin:GetTargetNames()
    if (not self:HasCache("GetTargetNames")) then
        self:SetCache("GetTargetNames", M(self:GetStepLines()):map(getTargetNames):flatten(true):value());
    end
    return self:GetCache("GetTargetNames");
end

function StepMixin:GetTargetIDs()
    if (not self:HasCache("GetTargetIDs")) then
        self:SetCache("GetTargetIDs", M(self:GetStepLines()):map(getTargetIDs):flatten(true):value());
    end
    return self:GetCache("GetTargetIDs");
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
-- ***** Step Lines
-- *********************************************************************************************************************

local isNotDisabled = M.complement(M.partial(M.result, "_", "IsDisabled"));
function StepMixin:GetStepLines()
    if (not self:HasCache("GetStepLines")) then
        self:SetCache("GetStepLines", M.filter(self.stepLines or {}, isNotDisabled));
    end
    return self:GetCache("GetStepLines");
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
