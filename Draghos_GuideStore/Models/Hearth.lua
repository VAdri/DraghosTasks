local HearthMixin = {};

Mixin(HearthMixin, ObservableMixin);

function HearthMixin:HearthInit(location)
    self.hearthNames = location and location.hearthNames;

    Draghos_GuideStore:RegisterForNotifications(self, "HEARTHSTONE_BOUND");
end

function HearthMixin:IsHearthAvailable()
    return true;
end

function HearthMixin:IsValidHearth()
    local hearthName = GetBindLocation();
    return self:GetHearthLabel() == hearthName;
end

function HearthMixin:GetHearthLabel()
    local locale = GetLocale();
    return self.hearthNames and self.hearthNames[locale] or nil;
end

DraghosMixins.Hearth = HearthMixin;
