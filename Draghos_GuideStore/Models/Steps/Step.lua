local Lambdas = DraghosUtils.Lambdas;

local Linq = LibStub("Linq");

--- @type List|ReadOnlyCollection|OrderedEnumerable|Enumerable
local List = Linq.List;
--- @type Enumerable
local Enumerable = Linq.Enumerable;

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
    return DraghosMixins.StepLineNote.New(note);
end

function StepMixin:StepInit(step)
    self:CacheInit();

    self.stepID = tonumber(step.id);
    self.stepLines = List.New();
    self.requiredStepIDs = Enumerable.From(step.requiredStepIDs or {}); -- TODO: Detect potential circular references
    self.completedAfterCompletedStepIDs = Enumerable.From(step.completedAfterCompletedStepIDs or {}); -- TODO: Detect potential circular references

    if (step.notes and #step.notes > 0) then
        self:AddMultipleStepLines(Enumerable.From(step.notes):Select(CreateNote):ToArray());
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

local isValid = Lambdas.SelfResult("IsValid");
local isCompleted = Lambdas.SelfResult("IsCompleted");

local function getStepByID(stepID)
    return Draghos_GuideStore:GetStepByID(stepID);
end

function StepMixin:IsStepAvailable()
    return self:RequiredStepsCompleted();
end

function StepMixin:IsValidStep()
    -- if (not self:HasCache("IsValidStep")) then
    --     self:SetCache("IsValidStep", self.stepID and M(self:GetStepLines()):all(isValid):value());
    -- end
    -- return self:GetCache("IsValidStep");
    return self:GetStepLines():All(isValid);
end

function StepMixin:HasRequiredSteps()
    return self.requiredStepIDs:Any();
end

function StepMixin:RequiredStepsCompleted()
    if (not self:HasRequiredSteps()) then
        -- No required steps
        return true;
    end

    if (not self:HasCache("RequiredStepsCompleted")) then
        self:SetCache("RequiredStepsCompleted", self.requiredStepIDs:Select(getStepByID):All(isCompleted));
    end
    return self:GetCache("RequiredStepsCompleted");
end

function StepMixin:HasDependentSteps()
    return self.completedAfterCompletedStepIDs:Any();
end

function StepMixin:DependentStepsCompleted()
    if (not self:HasDependentSteps()) then
        -- No dependent steps
        return true;
    end

    if (not self:HasCache("DependentStepsCompleted")) then
        self:SetCache(
            "DependentStepsCompleted", self.completedAfterCompletedStepIDs:Select(getStepByID):All(isCompleted)
        );
    end
    return self:GetCache("DependentStepsCompleted");
end

-- *********************************************************************************************************************
-- ***** Waypoints
-- *********************************************************************************************************************

local canAddWaypoints = Lambdas.SelfResult("CanAddWaypoints");
local getWaypointsInfo = Lambdas.SelfResult("GetWaypointsInfo");

function StepMixin:SkipWaypoint()
    return false;
end

function StepMixin:CanAddWaypoints()
    -- if (not self:HasCache("CanAddWaypoints")) then
    --     self:SetCache("CanAddWaypoints", M(self:GetStepLines()):any(canAddWaypoints):value());
    -- end
    -- return self:GetCache("CanAddWaypoints");
    return self:GetStepLines():Any(canAddWaypoints);
end

function StepMixin:GetWaypointsInfo()
    -- if (not self:HasCache("GetWaypointsInfo")) then
    --     self:SetCache(
    --         "GetWaypointsInfo",
    --         M(self:GetStepLines()):filter(canAddWaypoints):map(getWaypointsInfo):flatten(true):value()
    --     );
    -- end
    -- return self:GetCache("GetWaypointsInfo");
    return self:GetStepLines():Where(canAddWaypoints):SelectMany(getWaypointsInfo):ToArray();
end

-- *********************************************************************************************************************
-- ***** Target Button
-- *********************************************************************************************************************

local getTargetNPCs = Lambdas.SelfResult("GetTargetNPCs");
local hasTargets = Lambdas.SelfResult("HasTargets");
local hasInvalidTargets = Lambdas.SelfResult("HasInvalidTargets");
local getTargetNames = Lambdas.SelfResult("GetTargetNames");
local getTargetIDs = Lambdas.SelfResult("GetTargetIDs");

function StepMixin:GetTargetNPCs()
    -- if (not self:HasCache("GetTargetNPCs")) then
    --     self:SetCache("GetTargetNPCs", M(self:GetStepLines()):map(getTargetNPCs):flatten(true):value());
    -- end
    -- return self:GetCache("GetTargetNPCs");
    return self:GetStepLines():SelectMany(getTargetNPCs):ToArray();
end

function StepMixin:HasTargets()
    -- if (not self:HasCache("HasTargets")) then
    --     self:SetCache("HasTargets", M(self:GetStepLines()):any(hasTargets):value());
    -- end
    -- return self:GetCache("HasTargets");
    return self:GetStepLines():Any(hasTargets);
end

function StepMixin:HasInvalidTargets()
    -- if (not self:HasCache("HasInvalidTargets")) then
    --     self:SetCache("HasInvalidTargets", M(self:GetStepLines()):any(hasInvalidTargets):value());
    -- end
    -- return self:GetCache("HasInvalidTargets");
    return self:GetStepLines():Any(hasInvalidTargets);
end

function StepMixin:GetTargetNames()
    -- if (not self:HasCache("GetTargetNames")) then
    --     self:SetCache("GetTargetNames", M(self:GetStepLines()):map(getTargetNames):flatten(true):value());
    -- end
    -- return self:GetCache("GetTargetNames");
    return self:GetStepLines():SelectMany(getTargetNames):ToArray();
end

function StepMixin:GetTargetIDs()
    -- if (not self:HasCache("GetTargetIDs")) then
    --     self:SetCache("GetTargetIDs", M(self:GetStepLines()):map(getTargetIDs):flatten(true):value());
    -- end
    -- return self:GetCache("GetTargetIDs");
    return self:GetStepLines():SelectMany(getTargetIDs):ToArray();
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

-- local isNotDisabled = M.complement(M.partial(M.result, "_", "IsDisabled"));
local isNotDisabled = Lambdas.Not(Lambdas.SelfResult("IsDisabled"));

function StepMixin:GetStepLines()
    -- if (not self:HasCache("GetStepLines")) then
    --     local enabledStepLines = self.stepLines:Where(function(stepLine) return not stepLine:IsDisabled(); end):ToArray();
    --     self:SetCache("GetStepLines", enabledStepLines);
    -- end
    -- return self:GetCache("GetStepLines");
    -- return self.stepLines:Where(function(stepLine) return not stepLine:IsDisabled(); end);
    return self.stepLines:Where(isNotDisabled);
end

function StepMixin:AddOneStepLine(stepLine)
    stepLine.step = self;
    self.stepLines:Add(stepLine);
    stepLine.lineIndex = self.stepLines.Length;
end

function StepMixin:AddMultipleStepLines(stepLines)
    self.stepLines:AddRange(stepLines);
    for i, stepLine in self.stepLines:GetEnumerator() do
        stepLine.lineIndex = i;
    end
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.Step = StepMixin;
