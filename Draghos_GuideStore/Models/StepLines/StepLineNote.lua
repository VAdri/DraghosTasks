local StepLineNoteMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepLineNoteMixin, DraghosMixins.StepLine);
Mixin(StepLineNoteMixin, DraghosMixins.Note);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

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
