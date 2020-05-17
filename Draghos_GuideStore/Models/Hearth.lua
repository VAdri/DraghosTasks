local Str = DraghosUtils.Str;

local HearthMixin = {};

Mixin(HearthMixin, DraghosMixins.Observable);
Mixin(HearthMixin, DraghosMixins.Zone);

function HearthMixin:HearthInit(location)
    self:ZoneInit(location);

    Draghos_GuideStore:RegisterForNotifications(self, "HEARTHSTONE_BOUND");
end

function HearthMixin:IsValidHearth()
    return not Str:IsBlankString(self:GetHearthLabel());
end

function HearthMixin:IsCurrentHearth()
    local hearthName = GetBindLocation();
    return self:GetHearthLabel() == hearthName;
end

function HearthMixin:IsPlayerAtHearth()
    local currentZoneName = GetSubZoneText();
    return not Str:IsBlankString(currentZoneName) and self:GetHearthLabel() == currentZoneName;
end

function HearthMixin:GetHearthLabel()
    return self.areaID and C_Map.GetAreaInfo(self.areaID);
end

DraghosMixins.Hearth = HearthMixin;
