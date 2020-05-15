local defaultInitialAnchorOffsets = {0, 0};

function GuideObjective_SetupHeader(block, initialLineWidth)
    block.leftIcon = nil;
    block.rightButton = nil;
    block.lineWidth = initialLineWidth or OBJECTIVE_TRACKER_TEXT_WIDTH;
end

local function OnRelease(framePool, frame)
    frame:Hide();
    frame:ClearAllPoints();
    frame:SetParent(nil);
end

-- *****************************************************************************************************
-- ***** LEFT_ICON
-- *****************************************************************************************************

-- See https://www.wowinterface.com/forums/showthread.php?t=53870 for a complete list of objectIconIDs
-- Speak: https://github.com/Gethe/wow-ui-textures/blob/live/CHATFRAME/UI-ChatWhisperIcon.PNG
-- Rest: https://raw.githubusercontent.com/Gethe/wow-ui-textures/live/CHARACTERFRAME/UI-StateIcon.PNG
-- Information: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Profession.PNG
-- Search: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/None.PNG
-- Hearthstone: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Innkeeper.PNG
-- Food: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Food.PNG
-- Fly: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/FlightMaster.PNG
-- Spell: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Class.PNG
-- Buy/Sell: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Auctioneer.PNG or https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Coin-Up.PNG
-- Repair: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Repair.PNG
-- Really good quality: https://github.com/Gethe/wow-ui-textures/blob/live/Garrison/MobileAppIcons.PNG
-- Alert: https://github.com/Gethe/wow-ui-textures/blob/live/DialogFrame/UI-Dialog-Icon-AlertNew.PNG
-- Dices: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Dice-Up.PNG
-- Skip: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Pass-Up.PNG
-- Refresh: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-RefreshButton.PNG or https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UIFrameButtons.PNG
-- Stop?: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-StopButton.PNG
-- Plus: https://github.com/Gethe/wow-ui-textures/blob/live/PaperDollInfoFrame/Character-Plus.PNG

local StepTypeIconTextureInfos = {
    ["PickUpQuest"] = {filePath = "Interface\\MINIMAP\\ObjectIconsAtlas", objectIconID = 4726, x = 22, y = 20},
    ["HandInQuest"] = {filePath = "Interface\\MINIMAP\\ObjectIconsAtlas", objectIconID = 4699, x = 20, y = 20},
    ["CombatObjective"] = {
        filePath = "Interface\\CHARACTERFRAME\\UI-StateIcon",
        left = "0.5",
        right = "1",
        top = "0",
        bottom = "0.5",
        x = 24,
        y = 24,
    },
    ["LootObjective"] = {filePath = "Interface\\MINIMAP\\TRACKING\\Banker", x = 20, y = 20},
    -- ["ObjectInteractionObjective"] = {filePath = "Interface\\Scenarios\\ScenarioIcon-Interact", x = 16, y = 16},
    ["OtherObjective"] = {filePath = "Interface\\Scenarios\\ScenarioIcon-Interact", x = 16, y = 16},
    ["Grind"] = {filePath = "Interface\\PaperDollInfoFrame\\Character-Plus", x = 14, y = 14},
    ["Move"] = {filePath = "Interface\\MINIMAP\\TRACKING\\FlightMaster", x = 18, y = 18},
};

local guideObjectiveLeftIconPool = CreateFramePool("Frame", nil, "GuideStepTypeIconTemplate", OnRelease);

function GuideObjectiveBlock_AcquireLeftIcon(parent)
    local icon = guideObjectiveLeftIconPool:Acquire();
    icon:SetParent(parent);

    return icon;
end

function GuideObjectiveBlock_InitializeTexture(frame, textureInfo)
    frame.MainIcon:SetTexture(textureInfo.filePath);
    frame.MainIcon:SetSize(textureInfo.x, textureInfo.y);

    local left, right, top, bottom;
    if textureInfo.objectIconID then
        left, right, top, bottom = GetObjectIconTextureCoords(textureInfo.objectIconID);
    else
        left, right, top, bottom = textureInfo.left, textureInfo.right, textureInfo.top, textureInfo.bottom;
    end

    frame.MainIcon:SetTexCoord(left or 0, right or 1, top or 0, bottom or 1);
end

function GuideObjectiveBlock_AddLeftIcon(block, iconName, initialAnchorOffsets)
    local textureInfo = StepTypeIconTextureInfos[iconName];
    if not textureInfo then
        textureInfo = StepTypeIconTextureInfos["OtherObjective"];
    end

    local icon = block.leftIcon;
    if not icon then
        icon = GuideObjectiveBlock_AcquireLeftIcon(block);
        -- block.stepTypeIcon = icon;
    end

    GuideObjectiveBlock_InitializeTexture(icon, textureInfo);

    if block.leftIcon == icon then
        return;
    end

    icon:ClearAllPoints();

    local paddingBetweenButtons = block.module.paddingBetweenButtons or 0;

    if block.leftIcon then
        icon:SetPoint("LEFT", block.leftIcon, "RIGHT", -paddingBetweenButtons, 0);
    else
        initialAnchorOffsets = initialAnchorOffsets or defaultInitialAnchorOffsets;
        -- icon:SetPoint("TOPLEFT", block, initialAnchorOffsets[1], initialAnchorOffsets[2]);
        icon:SetPoint("RIGHT", block.HeaderText, "LEFT", -2, 0);
    end

    icon:Show();

    block.leftIcon = icon;
end

function GuideObjectiveBlock_ReleaseLeftIcon(block)
    if block.leftIcon then
        guideObjectiveLeftIconPool:Release(block.leftIcon);
        block.leftIcon = nil;
    end
end

-- *****************************************************************************************************
-- ***** RIGHT ITEM BUTTON
-- *****************************************************************************************************

local g_guideObjectiveItemPool = CreateFramePool("BUTTON", nil, "GuideObjectiveItemButtonTemplate", OnRelease);
function GuideObjectiveItem_AcquireButton(parent)
    local itemButton = g_guideObjectiveItemPool:Acquire();
    itemButton:SetParent(parent);

    return itemButton;
end

function GuideObjectiveItem_ReleaseButton(button)
    g_guideObjectiveItemPool:Release(button);
end

function GuideObjectiveItem_Initialize(itemButton, item)
    itemButton:SetID(item:GetItemID());
    itemButton:SetAttribute("type1", "item")
    itemButton:SetAttribute("item", item:GetItemName());
    itemButton.item = item;
    -- itemButton.charges = nil;
    itemButton.rangeTimer = -1;
    SetItemButtonTexture(itemButton, item:GetItemIcon());
    -- SetItemButtonCount(itemButton, itemButton.charges);
    GuideObjectiveItem_UpdateCooldown(itemButton);
end

function GuideObjectiveItem_OnLoad(self)
    self:RegisterForClicks("AnyUp")
    self:HookScript("OnClick", GuideObjectiveItem_OnClick)
end

function GuideObjectiveItem_OnEvent(self, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        self.rangeTimer = -1;
    elseif (event == "BAG_UPDATE_COOLDOWN") then
        GuideObjectiveItem_UpdateCooldown(self);
    end
end

function GuideObjectiveItem_OnUpdate(self, elapsed)
    -- -- Handle range indicator
    local rangeTimer = self.rangeTimer;
    if (rangeTimer) then
        rangeTimer = rangeTimer - elapsed;
        if (rangeTimer <= 0) then
            local count = self.HotKey;
            -- ! IsItemInRange return true, false or nil but IsSpellInRange return 1, 0 or nil
            local valid = IsItemInRange(self.item:GetItemName(), "player");
            if (valid == false) then
                count:Show();
                count:SetVertexColor(1.0, 0.1, 0.1);
            elseif (valid == true) then
                count:Show();
                count:SetVertexColor(0.6, 0.6, 0.6);
            else
                count:Hide();
            end
            rangeTimer = TOOLTIP_UPDATE_TIME;
        end

        self.rangeTimer = rangeTimer;
    end
end

function GuideObjectiveItem_OnShow(self)
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveItem_OnHide(self)
    self:UnregisterEvent("PLAYER_TARGET_CHANGED");
    self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveItem_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetItemByID(self:GetID());
end

function GuideObjectiveItem_OnClick(self, button)
    if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
        local link = self.item:GetItemLink();
        if (link) then
            ChatEdit_InsertLink(link);
        end
    end
end

function GuideObjectiveItem_UpdateCooldown(itemButton)
    local start, duration, enable = GetItemCooldown(itemButton:GetID());
    if (start) then
        CooldownFrame_Set(itemButton.Cooldown, start, duration, enable);
        if (duration > 0 and enable == 0) then
            SetItemButtonTextureVertexColor(itemButton, 0.4, 0.4, 0.4);
        else
            SetItemButtonTextureVertexColor(itemButton, 1, 1, 1);
        end
    end
end

function GuideObjectiveSetupBlockButton_AddRightButton(block, button, initialAnchorOffsets)
    if block.rightButton == button then
        -- TODO: Fix for real, some event causes the findGroup button to get added twice (could happen for any button)
        -- so it doesn't need to be reanchored another time
        return;
    end

    button:ClearAllPoints();

    local paddingBetweenButtons = block.module.paddingBetweenButtons or 0;

    if block.rightButton then
        button:SetPoint("RIGHT", block.rightButton, "LEFT", -paddingBetweenButtons, 0);
    else
        initialAnchorOffsets = initialAnchorOffsets or defaultInitialAnchorOffsets;
        button:SetPoint("TOPRIGHT", block, initialAnchorOffsets[1], initialAnchorOffsets[2]);
    end

    button:Show();

    block.rightButton = button;
    block.lineWidth = block.lineWidth - button:GetWidth() - paddingBetweenButtons;
end

function GuideObjectiveSetupBlockButton_Item(block, item)
    if item then
        local itemButton = block.itemButton;
        if not itemButton then
            itemButton = GuideObjectiveItem_AcquireButton(block);
            block.itemButton = itemButton;
        end

        GuideObjectiveItem_Initialize(itemButton, item);
        GuideObjectiveSetupBlockButton_AddRightButton(block, itemButton, block.module.buttonOffsets.useItem);
        return true;
    else
        GuideObjectiveReleaseBlockButton_Item(block);
        return false;
    end
end

function GuideObjectiveReleaseBlockButton_Item(block)
    if block.itemButton then
        GuideObjectiveItem_ReleaseButton(block.itemButton);
        block.itemButton = nil;
    end
end
