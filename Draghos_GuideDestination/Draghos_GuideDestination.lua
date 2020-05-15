local TomTomDestination = CreateFrame("Frame");

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

function TomTomDestination:WatchNextStep()
    local steps = Draghos_GuideStore:GetRemainingSteps();

    local stepIndex = 1;
    local watchedStep;
    repeat
        watchedStep = steps[stepIndex];
        stepIndex = stepIndex + 1;
    until (not watchedStep or not watchedStep:SkipWaypoint());

    -- We need to always watch a step even if we cannot put waypoints on it, otherwise TomTom will never show up
    if watchedStep --[[and watchedStep:CanAddWaypoints()]] then
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
