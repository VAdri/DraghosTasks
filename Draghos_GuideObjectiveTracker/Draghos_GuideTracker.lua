local band = bit.band;

GUIDE_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable();

GUIDE_TRACKER_UPDATE_ALL = 0xFFFFFFFF;

-- *****************************************************************************************************
-- ***** HOKS
-- *****************************************************************************************************

function GuideTrackerBlocksFrame_OnLoad(self)
end

function GuideTracker_OnLoad(self)
    -- create a line so we can get some measurements
    local line = CreateFrame("Frame", nil, self, DEFAULT_OBJECTIVE_TRACKER_MODULE.lineTemplate);
    line.Text:SetText("Double line|ntest");
    -- reuse it
    tinsert(DEFAULT_OBJECTIVE_TRACKER_MODULE.freeLines, line);
    -- get measurements
    OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT = math.ceil(line.Text:GetStringHeight());
    OBJECTIVE_TRACKER_DASH_WIDTH = line.Dash:GetWidth();
    OBJECTIVE_TRACKER_TEXT_WIDTH = OBJECTIVE_TRACKER_LINE_WIDTH - OBJECTIVE_TRACKER_DASH_WIDTH - 12;
    DEFAULT_OBJECTIVE_TRACKER_MODULE.lineWidth = OBJECTIVE_TRACKER_TEXT_WIDTH;
    GUIDE_TRACKER_MODULE.BlocksFrame = self.BlocksFrame;
    line.Text:SetWidth(OBJECTIVE_TRACKER_TEXT_WIDTH);

    local frameLevel = self.BlocksFrame:GetFrameLevel();
    self.HeaderMenu:SetFrameLevel(frameLevel + 2);

    self:RegisterEvent("PLAYER_ENTERING_WORLD");

    UIDropDownMenu_Initialize(self.BlockDropDown, nil, "MENU");
    -- QuestPOI_Initialize(self.BlocksFrame, function(self) self:SetScale(0.9); self:RegisterForClicks("LeftButtonUp", "RightButtonUp"); end );
end

function GuideTracker_Initialize(self)
    self.MODULES = {GUIDE_TRACKER_MODULE};
    self.MODULES_UI_ORDER = {GUIDE_TRACKER_MODULE};

    GuideObjectiveTrackerInitialize();

    self:RegisterEvent("PLAYER_REGEN_ENABLED");

    self.initialized = true;
end

function GuideTracker_OnEvent(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        if (not self.initialized) then
            GuideTracker_Initialize(self);
        end
        GuideTracker_Update();
    elseif (event == "PLAYER_REGEN_ENABLED") then
        -- GuideTracker_Update();
    end
end

function GuideTracker_OnSizeChanged(self)
    GuideTracker_Update();
end

function GuideTracker_OnUpdate(self)
    if self.isUpdateDirty then
        GuideTracker_Update();
    end
end

-- *****************************************************************************************************
-- ***** EXPAND/COLLAPSE
-- *****************************************************************************************************

local function GuideTracker_Expand()
    GuideTrackerFrame.collapsed = nil;
    GuideTrackerFrame.BlocksFrame:Show();
    GuideTrackerFrame.HeaderMenu.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 1);
    GuideTrackerFrame.HeaderMenu.MinimizeButton:GetPushedTexture():SetTexCoord(0.5, 1, 0.5, 1);
    GuideTrackerFrame.HeaderMenu.Title:Hide();
end

local function GuideTracker_Collapse()
    GuideTrackerFrame.collapsed = true;
    GuideTrackerFrame.BlocksFrame:Hide();
    GuideTrackerFrame.HeaderMenu.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.5);
    GuideTrackerFrame.HeaderMenu.MinimizeButton:GetPushedTexture():SetTexCoord(0.5, 1, 0, 0.5);
    GuideTrackerFrame.HeaderMenu.Title:Show();
end

function GuideTracker_MinimizeButton_OnClick(self)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    if (GuideTrackerFrame.collapsed) then
        GuideTracker_Expand();
    else
        GuideTracker_Collapse();
    end
    GuideTracker_Update();
end

-- *****************************************************************************************************
-- ***** UPDATE
-- *****************************************************************************************************

function GuideTracker_Update(reason, id)
    local tracker = GuideTrackerFrame;
    if tracker.isUpdating then
        -- Trying to update while we're already updating, try again next frame
        tracker.isUpdateDirty = true;
        return;
    end
    tracker.isUpdating = true;

    if (not tracker.initialized) then
        tracker.isUpdating = false;
        return;
    end

    tracker.BlocksFrame.maxHeight = GuideTrackerFrame.BlocksFrame:GetHeight();
    if (tracker.BlocksFrame.maxHeight == 0) then
        tracker.isUpdating = false;
        return;
    end

    tracker.isUpdateDirty = false;

    reason = reason or GUIDE_TRACKER_UPDATE_ALL;
    -- OBJECTIVE_TRACKER_UPDATE_ID = id;

    tracker.BlocksFrame.currentBlock = nil;
    tracker.BlocksFrame.contentsHeight = 0;

    -- mark headers unused
    for i = 1, #tracker.MODULES do
        if (tracker.MODULES[i].Header) then
            tracker.MODULES[i].Header.added = nil;
        end
    end

    -- run module updates
    local gotMoreRoomThisPass = false;
    for i = 1, #tracker.MODULES do
        local module = tracker.MODULES[i];
        if (band(reason, module.updateReasonModule + module.updateReasonEvents) > 0) then
            -- run a full update on this module
            module:Update();
            -- check if it's now taking up less space, using subtraction because of floats
            if (module.oldContentsHeight - module.contentsHeight >= 1) then
                -- it is taking up less space, might have freed room for other modules
                gotMoreRoomThisPass = true;
            end
        else
            -- this module's contents have not have changed
            -- but if we got more room and this module has unshown content, do a full update
            -- also do a full update if the header is animating since the module does not technically have any blocks at that point
            if ((module.hasSkippedBlocks and gotMoreRoomThisPass) or (module.Header and module.Header.animating)) then
                module:Update();
            else
                module:StaticReanchor();
            end
        end
    end
    -- ObjectiveTracker_ReorderModules();

    -- ObjectiveTracker_UpdatePOIs();

    -- hide unused headers
    for i = 1, #tracker.MODULES do
        ObjectiveTracker_CheckAndHideHeader(tracker.MODULES[i].Header);
    end

    if (tracker.BlocksFrame.currentBlock) then
        tracker.HeaderMenu:Show();
    else
        tracker.HeaderMenu:Hide();
    end

    tracker.BlocksFrame.currentBlock = nil;
    tracker.isUpdating = false;
end
