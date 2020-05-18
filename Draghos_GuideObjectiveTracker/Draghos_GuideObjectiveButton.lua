local Helpers = DraghosUtils.Helpers;
local Hacks = DraghosUtils.Hacks;
local Str = DraghosUtils.Str;
local FP = DraghosUtils.FP;

local defaultInitialAnchorOffsets = {0, 0};

function GuideObjective_SetupHeader(block, initialLineWidth)
    block.leftIcon = nil;
    block.leftCheckbox = nil;
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
-- Train: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Profession.PNG
-- Search: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/None.PNG
--         Interface/GuildFrame/Communities | communities-icon-searchmagnifyingglass
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
-- Undo: Interface/Glues/CharacterSelect/CharacterUndelete | characterundelete-RestoreButton
-- Stop?: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-StopButton.PNG
--        transmog-icon-remove
-- Plus: https://github.com/Gethe/wow-ui-textures/blob/live/PaperDollInfoFrame/Character-Plus.PNG
-- Set free: Interface/GuildFrame/Communities | communities-icon-lock
--           Interface/LFGFrame/LFG | Interface/LFGFrame/LFG
-- Star: Interface/Common/FavoritesIcon | PetJournal-FavoritesIcon
-- XP: Interface/Garrison/GarrisonCurrencyIcons | GarrMission_CurrencyIcon-Xp
-- Box: Interface/Garrison/GarrisonCurrencyIcons | GarrMission_CurrencyIcon-Material
-- Die: Interface/LFGFrame/LFG | DungeonTargetIndicator
-- Shovel: Interface/Garrison/MobileAppIcons | Mobile-Archeology
-- Alchemy: Interface/Garrison/MobileAppIcons | Mobile-Alchemy
-- First aid: Interface/Garrison/MobileAppIcons | Mobile-FirstAid
-- Cooking: Interface/Garrison/MobileAppIcons | Mobile-Cooking
-- Leatherworking: Interface/Garrison/MobileAppIcons | Mobile-Leatherworking
-- Mining: Interface/Garrison/MobileAppIcons | Mobile-Mining
-- Combat: Interface/Garrison/MobileAppIcons | Mobile-MechanicIcon-Powerful
-- Wait: Interface/Garrison/MobileAppIcons | Mobile-MechanicIcon-Slowing

local StepTypeIconTextureInfos = {
    ["PickUpQuest"] = {atlasName = "QuestNormal", x = 22, y = 20},
    ["HandInQuest"] = {atlasName = "QuestTurnin", x = 20, y = 20},
    ["CombatObjective"] = {atlasName = "Ammunition", x = 24, y = 24},
    ["Bank"] = {atlasName = "Banker", x = 20, y = 20},
    ["OtherObjective"] = {atlasName = "mechagon-projects", x = 16, y = 16},
    ["Grind"] = {atlasName = "GreenCross", x = 14, y = 14},
    ["Move"] = {atlasName = "FlightMaster", x = 18, y = 18},
    ["Hearth"] = {atlasName = "Innkeeper", x = 18, y = 18},
    ["FlightMaster"] = {atlasName = "FlightPath", x = 22, y = 20},
    ["Note"] = {atlasName = "poi-workorders", x = 22, y = 20},
    ["LootObjective"] = {atlasName = "ParagonReputation_Bag", x = 20, y = 20},
    ["Warning"] = {atlasName = "services-icon-warning", x = 20, y = 20},
};

local guideObjectiveLeftIconPool = CreateFramePool("Frame", nil, "GuideStepTypeIconTemplate", OnRelease);

local function AcquireLeftIcon(parent)
    local icon = guideObjectiveLeftIconPool:Acquire();
    icon:SetParent(parent);

    return icon;
end

local function InitializeLeftIconTexture(frame, textureInfo)
    if textureInfo.atlasName then
        frame.MainIcon:SetAtlas(textureInfo.atlasName);
    elseif textureInfo.filePath then
        frame.MainIcon:SetTexture(textureInfo.filePath);
        local left, right, top, bottom;
        if textureInfo.objectIconID then
            left, right, top, bottom = GetObjectIconTextureCoords(textureInfo.objectIconID);
        else
            left, right, top, bottom = textureInfo.left, textureInfo.right, textureInfo.top, textureInfo.bottom;
        end

        frame.MainIcon:SetTexCoord(left or 0, right or 1, top or 0, bottom or 1);
    else
        return;
    end

    frame.MainIcon:SetSize(textureInfo.x, textureInfo.y);
end

function GuideObjectiveBlock_AddLeftIcon(block, iconName, initialAnchorOffsets)
    local textureInfo = StepTypeIconTextureInfos[iconName];
    if not textureInfo then
        textureInfo = StepTypeIconTextureInfos["OtherObjective"];
    end

    local icon = block.leftIcon;
    if not icon then
        icon = AcquireLeftIcon(block);
        -- block.stepTypeIcon = icon;
    end

    InitializeLeftIconTexture(icon, textureInfo);

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
-- ***** LEFT CHECKBOX
-- *****************************************************************************************************

local guideObjectiveLeftCheckboxPool = CreateFramePool("CheckButton", nil, "GuideStepTypeCheckboxTemplate", OnRelease);

local function AcquireLeftCheckbox(parent)
    local checkbox = guideObjectiveLeftCheckboxPool:Acquire();
    checkbox:SetParent(parent);

    return checkbox;
end

function GuideObjectiveBlock_AddLeftCheckbox(block, initialAnchorOffsets)
    local checkbox = block.leftCheckbox;
    if not checkbox then
        checkbox = AcquireLeftCheckbox(block);
    end

    checkbox.block = block;

    if block.leftCheckbox == checkbox then
        return;
    end

    checkbox:ClearAllPoints();

    local paddingBetweenButtons = block.module.paddingBetweenButtons or 0;

    if block.leftIcon then
        checkbox:SetPoint("RIGHT", block.leftIcon, "LEFT", -paddingBetweenButtons, 0);
    else
        initialAnchorOffsets = initialAnchorOffsets or defaultInitialAnchorOffsets;
        -- icon:SetPoint("TOPLEFT", block, initialAnchorOffsets[1], initialAnchorOffsets[2]);
        checkbox:SetPoint("RIGHT", block.HeaderText, "LEFT", -2, 0);
    end

    checkbox:Show();

    block.leftCheckbox = checkbox;
end

function GuideObjectiveBlock_ReleaseLeftCheckbox(block)
    if block.leftCheckbox then
        block.leftCheckbox.block = nil;
        block.leftCheckbox:SetChecked(false);
        guideObjectiveLeftCheckboxPool:Release(block.leftCheckbox);
        block.leftCheckbox = nil;
    end
end

-- *****************************************************************************************************
-- ***** RIGHT BUTTON MANAGER
-- *****************************************************************************************************

local guideObjectiveButtonPool = Hacks:CreateNamedFramePool(
                                     "BUTTON", nil, "GuideObjectiveButtonTemplate", OnRelease, "GuideObjectiveButton"
                                 );

local function AcquireRightButton(parent)
    local button = guideObjectiveButtonPool:Acquire();
    button:SetParent(parent);
    return button;
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

function GuideObjectiveBlock_ReleaseRightButton(button)
    guideObjectiveButtonPool:Release(button);
end

-- *****************************************************************************************************
-- ***** BUTTON HOKS
-- *****************************************************************************************************

function GuideObjectiveButton_OnLoad(self)
    self:RegisterForClicks("AnyUp")
    self:HookScript("OnClick", GuideObjectiveButton_OnClick)
end

function GuideObjectiveButton_OnEvent(self, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        self.rangeTimer = -1;
    elseif (event == "BAG_UPDATE_COOLDOWN") then
        GuideObjectiveButton_UpdateCooldown(self);
    end
end

function GuideObjectiveButton_UpdateCooldown(self)
    if self.item then
        GuideObjectiveButton_UpdateItemCooldown(self);
        -- elseif self.spell then
        --     GuideObjectiveButton_UpdateSpellCooldown(self);
    end
end

function GuideObjectiveButton_OnUpdate(self, elapsed)
    if self.item then
        GuideObjectiveButton_UpdateItem(self, elapsed);
        -- elseif self.spell then
        --     GuideObjectiveButton_UpdateSpell(self, elapsed);
    elseif self.targets then
        GuideObjectiveButton_UpdateTarget(self, elapsed);
    end
end

function GuideObjectiveButton_OnShow(self)
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveButton_OnHide(self)
    self:UnregisterEvent("PLAYER_TARGET_CHANGED");
    self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveButton_OnEnter(self)
    if self.item then
        GuideObjectiveButton_ShowItemTooltip(self);
        -- elseif self.spell then
        --     GuideObjectiveButton_ShowSpellTooltip(self);
    elseif self.targets then
        GuideObjectiveButton_ShowTargetTooltip(self);
    end
end

function GuideObjectiveButton_OnClick(self, button)
    if self.item then
        GuideObjectiveButton_OnItemClick(self, button);
        -- elseif self.spell then
        --     GuideObjectiveButton_OnSpellClick(self, button);
    elseif self.targets then
        GuideObjectiveButton_OnTargetClick(self, button);
    end
end

-- *****************************************************************************************************
-- ***** ITEM BUTTON
-- *****************************************************************************************************

function GuideObjectiveButton_InitializeItem(itemButton, item)
    itemButton:SetID(item:GetItemID());
    itemButton:SetAttribute("type1", "item")
    itemButton:SetAttribute("item", item:GetItemName());
    itemButton.item = item;
    -- itemButton.charges = nil;
    itemButton.rangeTimer = -1;
    SetItemButtonTexture(itemButton, item:GetItemIcon());
    -- SetItemButtonCount(itemButton, itemButton.charges);
    GuideObjectiveButton_UpdateItemCooldown(itemButton);
end

function GuideObjectiveButton_ShowItemTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetItemByID(self:GetID());
end

function GuideObjectiveButton_OnItemClick(self, button)
    if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
        local link = self.item:GetItemLink();
        if (link) then
            ChatEdit_InsertLink(link);
        end
    end
end
function GuideObjectiveButton_UpdateItem(self, elapsed)
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

function GuideObjectiveButton_UpdateItemCooldown(itemButton)
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

function GuideObjectiveSetupBlockButton_Item(block, item)
    if item then
        local itemButton = block.itemButton;
        if not itemButton then
            itemButton = AcquireRightButton(block);
            block.itemButton = itemButton;
        end

        GuideObjectiveButton_InitializeItem(itemButton, item);
        GuideObjectiveSetupBlockButton_AddRightButton(block, itemButton, block.module.buttonOffsets.useItem);
        return true;
    else
        GuideObjectiveReleaseBlockButton_Item(block);
        return false;
    end
end

function GuideObjectiveReleaseBlockButton_Item(block)
    if block.itemButton then
        GuideObjectiveBlock_ReleaseRightButton(block.itemButton);
        block.itemButton = nil;
    end
end

-- *****************************************************************************************************
-- ***** TARGETS BUTTON
-- *****************************************************************************************************

-- TODO: Set the binding (CTRL-TAB) on the options
local bindingKey = "CTRL-TAB";

StaticPopupDialogs["DRAGHOS_GOT_KEYBIND_EXISTS"] = {
    text = TARGET_KEYBIND_ALREADY_EXISTS_DIALOG,
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        SetBinding(bindingKey, nil);
        SaveBindings(2)
        ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
    end,
    OnCancel = function(_, _, action)
        if action == "clicked" then
            -- TODO: Modify it in the options
            bindingKey = nil;
        end
    end,
    timeout = 0,
    whileDead = true,
    -- hideOnEscape = true,
};

local function TargetUnitMacro(name)
    return "/targetexact " .. name;
end

local buttonActionPattern = "CLICK " .. guideObjectiveButtonPool.namePrefix .. "(%d+):LeftButton";

local function CanSetBindingToTargetsButton(button)
    if not guideObjectiveButtonPool.currentTartgetBtnBind then
        -- No target button currently bound to the bindingKey
        return true;
    elseif guideObjectiveButtonPool.currentTartgetBtnBind:GetID() > button:GetID() then
        -- The target button currently bound to the bindingKey has least priority
        return true;
    else
        return false;
    end
end

function GuideObjectiveButton_InitializeTargets(targetsButton, step)
    local macroTargets = table.concat(FP:Map(step:GetTargetNames(), TargetUnitMacro), "\n");

    -- targetsButton:SetID(item:GetItemID());
    targetsButton.targets = step:GetTargetIDs();

    targetsButton:SetAttribute("type1", "macro");
    targetsButton:SetAttribute("macrotext", "/cleartaget\n" .. macroTargets);

    if bindingKey and CanSetBindingToTargetsButton(targetsButton) then
        local bindingAction = GetBindingAction(bindingKey);
        if not Str:IsBlankString(bindingAction) and not bindingAction:find(buttonActionPattern) then
            if not StaticPopup_Visible("DRAGHOS_GOT_KEYBIND_EXISTS") then
                local bindingActionName = _G["BINDING_NAME_" .. bindingAction];
                bindingActionName = bindingActionName and "'" .. bindingActionName .. "'" or ANOTHER_ACTION;
                StaticPopup_Show("DRAGHOS_GOT_KEYBIND_EXISTS", bindingKey, bindingActionName);
            end
        else
            SetBindingClick(bindingKey, targetsButton:GetName());
            targetsButton.hasTargetBinding = true;
            guideObjectiveButtonPool.currentTartgetBtnBind = targetsButton;
        end
    end

    targetsButton.HotKey:Hide();

    targetsButton.icon = targetsButton:CreateTexture(nil, "BORDER");
    targetsButton.icon:SetTexture("Interface\\Icons\\Ability_Hunter_SniperShot");
    targetsButton.icon:SetAllPoints(targetsButton);
end

function GuideObjectiveButton_ShowTargetTooltip(self)
    -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    -- GameTooltip:SetItemByID(self:GetID());
end

function GuideObjectiveButton_OnTargetClick(self, button)
    local function IsTarget(targetID)
        return Helpers:UnitHasUnitID("target", targetID);
    end

    -- Mark the target
    if not GetRaidTargetIndex("target") and FP:Any(self.targets, IsTarget) then
        if UnitIsFriend("player", "target") then
            -- With a star for friendly units
            SetRaidTarget("target", 1);
        else
            -- With a skull for ennemy units
            SetRaidTarget("target", 8);
        end
    end
end

function GuideObjectiveButton_UpdateTarget(self, elapsed)
end

function GuideObjectiveSetupBlockButton_Targets(block, step)
    if step:HasTargets() then
        local targetsButton = block.targetsButton;
        if not targetsButton then
            targetsButton = AcquireRightButton(block);
            block.targetsButton = targetsButton;
        end

        GuideObjectiveButton_InitializeTargets(targetsButton, step);
        GuideObjectiveSetupBlockButton_AddRightButton(block, targetsButton, block.module.buttonOffsets.useItem);
        return true;
    else
        GuideObjectiveReleaseBlockButton_Targets(block);
        return false;
    end
end

function GuideObjectiveReleaseBlockButton_Targets(block)
    if block.targetsButton then
        if block.targetsButton.hasTargetBinding then
            block.targetsButton.hasTargetBinding = false;
            guideObjectiveButtonPool.currentTartgetBtnBind = nil;
        end
        GuideObjectiveBlock_ReleaseRightButton(block.targetsButton);
        block.targetsButton = nil;
    end
end
