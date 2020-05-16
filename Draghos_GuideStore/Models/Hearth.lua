local Str = DraghosUtils.Str;

local HearthMixin = {};

Mixin(HearthMixin, DraghosMixins.Observable);

function HearthMixin:HearthInit(location)
    self.hearthNames = location and location.hearthNames;

    Draghos_GuideStore:RegisterForNotifications(self, "HEARTHSTONE_BOUND");
end

function HearthMixin:IsValidHearth()
    return not Str:IsBlankString(self:GetHearthLabel());
end

function HearthMixin:IsCurrentHearth()
    local hearthName = GetBindLocation();
    return self:GetHearthLabel() == hearthName;
end

function HearthMixin:GetHearthLabel()
    local locale = GetLocale();
    return self.hearthNames and self.hearthNames[locale] or nil;
end

DraghosMixins.Hearth = HearthMixin;
