local StepLineGrindProgressMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepLineGrindProgressMixin, DraghosMixins.StepLine);
Mixin(StepLineGrindProgressMixin, DraghosMixins.Experience);

local StepLineGrindProgressMT = {__index = function(t, key, ...) return StepLineGrindProgressMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepLineGrindProgressMixin.New(stepLine)
    local item = setmetatable({}, StepLineGrindProgressMT);
    item:Init(stepLine);
    return item;
end

function StepLineGrindProgressMixin:Init(stepLine)
    self:StepLineInit();
    self:ExperienceInit(stepLine.experience);
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepLineGrindProgressMixin:GetLabel()
    local isCurrentLevel = self:GetXPRequired();
    if isCurrentLevel then
        return GRIND_PROGRESS;
    else
        return GRIND_PROGRESS_TO_NEXT_LEVEL;
    end
end

function StepLineGrindProgressMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidExperience();
end

function StepLineGrindProgressMixin:IsCompleted()
    return self:IsAboveLevelXP();
end

-- *********************************************************************************************************************
-- ***** Progress Bar
-- *********************************************************************************************************************

function StepLineGrindProgressMixin:IsProgress()
    return true;
end

function StepLineGrindProgressMixin:GetProgressValues()
    local _, currentXP, requiredXP = self:GetXPRequired();
    return currentXP, requiredXP;
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepLineGrindProgress = StepLineGrindProgressMixin
