local addonName, addon = ...;

-- *********************************************************************************************************************
-- ***** TomTom arrow
-- *********************************************************************************************************************

local TomTomListener = CreateFrame("Frame");

local function OnStepUpdated(self, watchedItem, event, ...)
    TomTom.waydb:ResetProfile();
    TomTom:ReloadWaypoints();

    if not watchedItem:CanAddWaypoints() then
        self.watchedStep = nil;
        self:WatchNextStep();
        return;
    end

    local waypoints = watchedItem:GetWaypointsInfo();
    for _, waypoint in pairs(waypoints) do
        waypoint.options.callbacks = TomTom:DefaultCallbacks(waypoint.options);
        TomTom:AddWaypoint(waypoint.uiMapID, waypoint.x, waypoint.y, waypoint.options);
    end
    TomTom:SetClosestWaypoint();
end

function TomTomListener:WatchNextStep()
    local steps = Draghos_GuideStore:GetRemainingSteps();

    local stepIndex = 1;
    local watchedStep;
    repeat
        watchedStep = steps[stepIndex];
        stepIndex = stepIndex + 1;
    until (not watchedStep or not watchedStep:SkipWaypoint());

    if watchedStep and watchedStep:CanAddWaypoints() then
        watchedStep:Watch(self, OnStepUpdated);
        self.watchedStep = watchedStep;
    end
end

local function UpdateTomTomArrow(self, elapsed)
    self.elapsed = self.elapsed and self.elapsed + elapsed or 0;
    if self.elapsed > 1 then
        self.elapsed = 0;
        TomTom:SetClosestWaypoint();
    end
end

local function ToggleTomTomListener(self, event, ...)
    local loaded, finishedLoading = IsAddOnLoaded("TomTom");
    if loaded and finishedLoading then -- TODO: and Arrow option is true
        if not TomTomListener:GetScript("OnUpdate") then
            TomTomListener:WatchNextStep();
            TomTomListener:SetScript("OnUpdate", UpdateTomTomArrow);
        end
    elseif TomTomListener:GetScript("OnUpdate") then
        if self.watchedStep then
            self.watchedStep:Unwatch(TomTomListener);
            self.watchedStep = nil;
        end
        TomTomListener:SetScript("OnUpdate", nil);
    end
end

TomTomListener:SetScript("OnEvent", ToggleTomTomListener);

TomTomListener:RegisterEvent("PLAYER_ENTERING_WORLD");
TomTomListener:RegisterEvent("ADDON_LOADED");
TomTomListener:RegisterEvent("ADDONS_UNLOADING");
