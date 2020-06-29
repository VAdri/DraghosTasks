local StepLineNoteMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepLineNoteMixin, DraghosMixins.StepLine);
Mixin(StepLineNoteMixin, DraghosMixins.Note);

local StepLineNoteMT = {__index = function(t, key, ...) return StepLineNoteMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepLineNoteMixin.New(stepLine)
    local item = setmetatable({}, StepLineNoteMT);
    item:Init(stepLine);
    return item;
end

function StepLineNoteMixin:Init(note)
    self:StepLineInit();
    self:NoteInit(note);
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepLineNoteMixin:GetLabel()
    return self:GetNoteLabel();
end

function StepLineNoteMixin:IsValid()
    return self:IsValidNote();
end

function StepLineNoteMixin:IsCompleted()
    return self:IsChecked();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepLineNote = StepLineNoteMixin;
