local Str = DraghosUtils.Str;

local LocationMixin = {};

function LocationMixin:LocationInit(location)
    if not location then
        self.hasLocation = false;
        return;
    end

    self.hasLocation = true;
    self.uiMapID = location.uiMapID;
    self.locationType = location.locationType;
    if location.locationType == LOCATION_TYPE_COORDS then
        self.x = location.coords[1];
        self.y = location.coords[2];
    end
end

function LocationMixin:CanAddWaypoints()
    return self.locationType == LOCATION_TYPE_COORDS and self:IsValidLocation();
    -- ? and self:IsAvailable() and not self:IsCompleted();
end

function LocationMixin:GetZoneName()
    local mapInfo = self.uiMapID and C_Map.GetMapInfo(self.uiMapID);
    return mapInfo and mapInfo.name or nil;
end

function LocationMixin:GetWaypointsInfo()
    return {
        {
            uiMapID = self.uiMapID,
            x = self.x / 100,
            y = self.y / 100,
            options = {
                title = self:GetLabel(),
                from = "Draghos Guides",
                cleardistance = 0, -- The arrow is cleared when the step is completed
            },
        },
    };
end

function LocationMixin:IsValidLocation()
    return self.hasLocation and self.uiMapID and not Str:IsBlankString(self:GetZoneName());
end

DraghosMixins.Location = LocationMixin;
