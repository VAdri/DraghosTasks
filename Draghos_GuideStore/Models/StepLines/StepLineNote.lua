local Str = DraghosUtils.Str;
local band = bit.band;

local StepLineNoteMixin = {};

StepLineNoteMixin.NoteTypes = {Normal = 0x0, Important = 0x1, Completed = 0x2, Disabled = 0x4};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepLineNoteMixin, DraghosMixins.StepLine);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepLineNoteMixin:Init(note)
    self:StepLineInit();

    note = note or {};

    self.noteType = note.noteType or StepLineNoteMixin.NoteTypes.Normal;

    self.message = type(note.message) == "table" and note.message or nil;
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepLineNoteMixin:GetLabel()
    if not self.message then
        return nil;
    end

    local locale = GetLocale();
    local parentLocale = locale:sub(1, 2);
    if self.message[locale] then
        -- In the best case we return the translation for the exact locale of the player
        return self.message[locale];
    elseif self.message[parentLocale] then
        -- Otherwise we try to return the parent locale (e.g. "es" instead of "esES" or "esMX")
        return self.message[parentLocale];
    else
        -- If none were found we use the default locale (english)
        return self.message.enUS;
    end
end

function StepLineNoteMixin:IsValid()
    return self.message and not Str:IsBlankString(self.message.enUS) and not Str:IsBlankString(self:GetLabel());
end

function StepLineNoteMixin:IsCompleted()
    return band(self.noteType, StepLineNoteMixin.NoteTypes.Completed) ~= 0;
end

-- *********************************************************************************************************************
-- ***** Styling
-- *********************************************************************************************************************

function StepLineNoteMixin:IsImportant()
    return band(self.noteType, StepLineNoteMixin.NoteTypes.Important) ~= 0;
end

function StepLineNoteMixin:IsDisabled()
    return band(self.noteType, StepLineNoteMixin.NoteTypes.Disabled) ~= 0;
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepLineNote = StepLineNoteMixin;
