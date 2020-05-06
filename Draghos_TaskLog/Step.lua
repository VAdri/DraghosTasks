--- @class Step
--- @field public type number
--- @field public label string|nil
--- @field public lastCompleted number|nil
StepMixin = {};

STEP_TYPE_MANUAL = 1;

StepTypes = {
    [STEP_TYPE_MANUAL] = {
        Label = STEP_TYPE_OPTION_MANUAL,
        --- @param step Step
        --- @return boolean
        IsValid = function(step)
            return not IsBlankString(step.label);
        end,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            return false;
        end,
        --- @param step Step
        --- @return string|nil
        GetLabel = function(step)
            return step.label;
        end,
        --- @param step Step
        --- @return string
        GetSummary = function(step)
            return STEP_SUMMARY.format(STEP_TYPE_OPTION_MANUAL, step.label or "");
        end,
        --- @param step1 Step
        --- @param step2 Step
        --- @return boolean
        AreEqual = function(step1, step2)
            return step1.label == step2.label;
        end,
        --- @param step Step
        --- @return table
        GetValues = function(step)
            return {type = step.type, label = step.label, lastCompleted = step.lastCompleted};
        end
    }
}

--- @param step Step
--- @return boolean
function StepMixin:Init(step)
    if not step then
        return false;
    end

    self.type = step.type;
    self.label = step.label;
    self.lastCompleted = step.lastCompleted;

    return true;
end

--- @return boolean
function StepMixin:IsValid()
    local stepType = StepTypes[self.type];
    return stepType and stepType.IsValid(self);
end

--- @return boolean
function StepMixin:IsCompleted()
    local stepType = StepTypes[self.type];
    return stepType and stepType.IsCompleted(self);
end

--- @param step Step
--- @return boolean
function StepMixin:IsEqual(step)
    local stepType = StepTypes[self.type];
    return stepType and stepType.AreEqual(self, step);
end

--- @return string
function StepMixin:GetLabel()
    local stepType = StepTypes[self.type];
    return stepType and stepType.GetLabel(self) or UNKNOWN;
end

--- @return string
function StepMixin:GetSummary()
    local stepType = StepTypes[self.type];
    return stepType and stepType.GetSummary(self) or UNKNOWN;
end

--- @return table
function StepMixin:GetValues()
    local stepType = StepTypes[self.type];
    return stepType and stepType.GetValues(self) or nil;
end
