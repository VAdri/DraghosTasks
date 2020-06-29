local StepNoteMixin = {}

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepNoteMixin, DraghosMixins.Step);
Mixin(StepNoteMixin, DraghosMixins.Note);
Mixin(StepNoteMixin, DraghosMixins.ManualCompletion);

local StepNoteMT = {__index = function(t, key, ...) return StepNoteMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepNoteMixin.New(step)
    local item = setmetatable({}, StepNoteMT);
    item:Init(step);
    return item;
end

function StepNoteMixin:Init(step)
    self:StepInit(step);
    self:NoteInit(step);
    self:ManualCompletionInit();

    Draghos_GuideStore:RegisterForNotifications(self, "DRAGHOS_STEP_COMPLETION_CHANGED")
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepNoteMixin:GetStepType()
    return "Note";
end

function StepNoteMixin:GetLabel()
    return self:GetNoteLabel();
end

function StepNoteMixin:IsValid()
    return self:IsValidStep() and self:IsValidNote();
end

function StepNoteMixin:IsAvailable()
    return not self:IsDisabled() and self:IsStepAvailable();
end

function StepNoteMixin:IsCompleted()
    return self:IsFlaggedManuallyCompleted() or (self:HasDependentSteps() and self:DependentStepsCompleted());
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepNote = StepNoteMixin;
