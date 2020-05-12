LocationMixin = {};

LOCATION_TYPE_COORDS = 1;
LOCATION_TYPE_PATH = 2;
LOCATION_TYPE_AREA = 3;

function LocationMixin:LocationInit(location)
    self.uiMapID = location.uiMapID;
    if location.locationType == LOCATION_TYPE_COORDS then
        self.x = location.coords[1];
        self.y = location.coords[2];
    end
end

function LocationMixin:GetZoneName()
    local mapInfo = C_Map.GetMapInfo(self.uiMapID);
    return mapInfo and mapInfo.name or nil;
end

function LocationMixin:GetWaypointInfo()
    return self.uiMapID, self.x / 100, self.y / 100, {title = self:GetLabel(), from = "Draghos Guides"};
end

function LocationMixin:IsValidLocation()
    return not IsBlankString(self:GetZoneName());
end
