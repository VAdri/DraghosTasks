local Str = DraghosUtils.Str;

local band = bit.band;

local NoteMixin = {};

function NoteMixin:NoteInit(note)
    note = note or {};

    self.noteType = note.noteType or DraghosFlags.NoteState.Normal;

    self.message = type(note.message) == "table" and note.message or nil;
end

function NoteMixin:GetNoteLabel()
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

function NoteMixin:IsValidNote()
    return self.message and not Str:IsBlankString(self.message.enUS) and not Str:IsBlankString(self:GetLabel());
end

function NoteMixin:IsChecked()
    return band(self.noteType, DraghosFlags.NoteState.Checked) ~= 0;
end

function NoteMixin:IsImportant()
    return band(self.noteType, DraghosFlags.NoteState.Important) ~= 0;
end

function NoteMixin:IsTrivial()
    return band(self.noteType, DraghosFlags.NoteState.Trivial) ~= 0;
end

function NoteMixin:IsDisabled()
    return band(self.noteType, DraghosFlags.NoteState.Disabled) ~= 0;
end

DraghosMixins.Note = NoteMixin;
