local StepGrindMixin = {}

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepGrindMixin, DraghosMixins.Step);
Mixin(StepGrindMixin, DraghosMixins.Experience);

local StepGrindMT = {__index = function(t, key, ...) return StepGrindMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepGrindMixin.New(step)
    local item = setmetatable({}, StepGrindMT);
    item:Init(step);
    return item;
end

function StepGrindMixin:Init(step)
    self:StepInit(step);
    self:ExperienceInit(step.experience);
    -- self:LocationInit(step.location);

    self:AddOneStepLine(DraghosMixins.StepLineGrindProgress.New(step));
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepGrindMixin:GetStepType()
    return "Grind";
end

function StepGrindMixin:GetLabel()
    return GRIND_TO:format(self:GetExperienceLabel());
end

function StepGrindMixin:IsValid()
    return self:IsValidStep() and self:IsValidExperience();
end

function StepGrindMixin:IsCompleted()
    return self:IsAboveLevelXP();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepGrind = StepGrindMixin;
