local Helpers = DraghosUtils.Helpers;

-- Frame that tracks the end of cooldowns to fix the lack of event from Blizzard
local ItemWatcherFrame = CreateFrame("Frame");
ItemWatcherFrame.items = {};

local function WatchAvailability(elapsed)
    for itemID, item in pairs(ItemWatcherFrame.items) do
        if item:IsItemAvailableToUse() then
            item:NotifyWatchers("ITEM_AVAILABLE", itemID);
            ItemWatcherFrame.items[itemID] = nil;
        end
    end
end

ItemWatcherFrame:SetScript("OnUpdate", WatchAvailability);

-- Mixin
local UseItemMixin = {};

Mixin(UseItemMixin, DraghosMixins.Observable);

function UseItemMixin:UseItemInit(item)
    self.itemID = item.itemID;
    self.itemSpellID = item.spellID;
    self.item = item.itemID and Item:CreateFromItemID(self.itemID);
    self.spell = item and item.spellID and Spell:CreateFromSpellID(self.itemSpellID);

    Draghos_GuideStore:RegisterForNotifications(self, "BAG_UPDATE_COOLDOWN");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_SPELLCAST_SUCCEEDED");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_SPELLCAST_INTERRUPTED");
    Draghos_GuideStore:RegisterForNotifications(self, "SPELL_UPDATE_COOLDOWN");
    Draghos_GuideStore:RegisterForNotifications(self, "SPELL_UPDATE_USABLE");
end

function UseItemMixin:IsValidItemToUse()
    return self.item and --[[self.spell and]] self.item:IsItemDataCached();
end

function UseItemMixin:IsItemAvailableToUse()
    local spellID = self.spell and self.spell:GetSpellID();
    if spellID and Helpers:PlayerIsCastingSpellID(spellID) then
        -- Player is currently using the item
        return true;
    end

    local _, duration, enabled = GetItemCooldown(self.item:GetItemID());
    if duration == 0 and enabled == 1 then
        return true;
    else
        ItemWatcherFrame.items[self.item:GetItemID()] = self;
        return false;
    end
end

function UseItemMixin:GetItemLabel()
    return self.item:GetItemName();
end

function UseItemMixin:CanUseItem()
    return true;
end

function UseItemMixin:UsedItemID()
    return self.item.itemID;
end

DraghosMixins.UseItem = UseItemMixin;
