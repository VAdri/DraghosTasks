local TomTomDestination = CreateFrame("Frame");

TomTom.waydb:ResetProfile();
TomTom:ReloadWaypoints();

local function OnStepUpdated()
    TomTom.waydb:ResetProfile();
    TomTom:ReloadWaypoints();

    if not TomTomDestination.watchedItem or not TomTomDestination.watchedItem:CanAddWaypoints() then
        TomTomDestination.watchedItem = nil;
        TomTomDestination:WatchNextStep();
        return;
    end

    if TomTomDestination.watchedItem:IsAvailable() and not TomTomDestination.watchedItem:IsCompleted() then
        local waypoints = TomTomDestination.watchedItem:GetWaypointsInfo();
        for _, waypoint in pairs(waypoints) do
            waypoint.options.callbacks = TomTom:DefaultCallbacks(waypoint.options);
            TomTom:AddWaypoint(waypoint.uiMapID, waypoint.x, waypoint.y, waypoint.options);
        end
        TomTom:SetClosestWaypoint();
    end
end

function TomTomDestination:WatchNextStep()
    local steps = Draghos_GuideStore:GetRemainingSteps();

    local stepIndex = 1;
    local watchedItem;
    repeat
        watchedItem = steps[stepIndex];
        stepIndex = stepIndex + 1;
    until (not watchedItem or (not watchedItem:SkipWaypoint() and watchedItem:CanAddWaypoints()));

    if watchedItem and watchedItem:CanAddWaypoints() then
        self.watchedItem = watchedItem;
        watchedItem:Watch(self, OnStepUpdated);
        OnStepUpdated();
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
    if loaded and finishedLoading then -- TODO: "and showArrow option is true"
        if not TomTomDestination:GetScript("OnUpdate") then
            TomTomDestination:WatchNextStep();
            TomTomDestination:SetScript("OnUpdate", UpdateTomTomArrow);
        end
    elseif TomTomDestination:GetScript("OnUpdate") then
        if self.watchedStep then
            self.watchedStep:Unwatch(TomTomDestination);
            self.watchedStep = nil;
        end
        TomTomDestination:SetScript("OnUpdate", nil);
    end
end

TomTomDestination:SetScript("OnEvent", ToggleTomTomListener);

TomTomDestination:RegisterEvent("PLAYER_ENTERING_WORLD");
TomTomDestination:RegisterEvent("ADDON_LOADED");
TomTomDestination:RegisterEvent("ADDONS_UNLOADING");
