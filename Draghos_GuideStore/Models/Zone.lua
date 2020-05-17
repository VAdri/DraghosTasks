local Str = DraghosUtils.Str;

local ZoneMixin = {};

Mixin(ZoneMixin, DraghosMixins.Observable);

-- Init without registrating events
function ZoneMixin:InitBase(zone)
    zone = zone or {};

    self.areaID = tonumber(zone.areaID);

    if self.areaID then
        self.areaName = C_Map.GetAreaInfo(self.areaID);
    end
end

function ZoneMixin:ZoneInit(zone)
    self:InitBase(zone);

    Draghos_GuideStore:RegisterForNotifications(self, "ZONE_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "ZONE_CHANGED_INDOORS");
    Draghos_GuideStore:RegisterForNotifications(self, "ZONE_CHANGED_NEW_AREA");
    -- Draghos_GuideStore:RegisterForNotifications(self, "UPDATE_ALL_UI_WIDGETS");
    -- Draghos_GuideStore:RegisterForNotifications(self, "AREA_POIS_UPDATED");
    -- Draghos_GuideStore:RegisterForNotifications(self, "FOG_OF_WAR_UPDATED");
end

function ZoneMixin:IsValidZone()
    return self.areaID and not Str:IsBlankString(self.areaName);
end

function ZoneMixin:PlayerIsInZone()
    return self.areaName == GetSubZoneText(); -- ? or GetZoneText() or GetRealZoneText()
end

function ZoneMixin:GetZoneName()
    return self.areaName;
end

DraghosMixins.Zone = ZoneMixin;
