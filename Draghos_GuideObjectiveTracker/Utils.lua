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
};

function GuideObjective_SetupHeader(block)
    block.leftIcon = nil;
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

local function OnRelease(framePool, frame)
    frame:Hide();
    frame:ClearAllPoints();
    frame:SetParent(nil);
end

local guideObjectiveLeftIconPool = CreateFramePool("Frame", nil, "GuideStepTypeIconTemplate", OnRelease);

function GuideObjectiveBlock_AcquireLeftIcon(parent)
    local icon = guideObjectiveLeftIconPool:Acquire();
    icon:SetParent(parent);

    return icon;
end

local defaultInitialAnchorOffsets = {0, 0};

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
