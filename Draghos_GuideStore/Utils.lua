DraghosUtils = {};
DraghosMixins = {};
DraghosEnums = {};
DraghosFlags = {};
Draghos_GuideStore = {};

-- *********************************************************************************************************************
-- ***** Enums and Flags
-- *********************************************************************************************************************

DraghosEnums.Mesages = {
    ToggleStepCompleted = 1, -- The UI send an event indicating that a step completed state has been manually changed
};

DraghosEnums.StepType = {
    Note = 1,
    PickupQuest = 2,
    ProgressQuestObjectives = 3,
    CompleteQuestObjectives = 4,
    CompleteQuest = 5,
    -- AbandonQuest = , -- Needed?
    HandinQuest = 6,
    Grind = 7, -- TODO: Grind reputation
    UseHearthstone = 8,
    SetHearth = 9,
    Go = 10,
    GetFlightPath = 11,
    -- Fly = ,
    -- Teleport = ,
    -- Discover = ,
    -- Train = , -- Can be for professions too, complete on specific spell or just for speaking to the trainer (add a "hint" before?)
    -- VendorRepair = ,
    -- Skip/SkipForNow = ,
    -- Buy = , -- Can require reput?
    -- Loot = , -- Loot an item on an npc or an object
    -- Craft = ,
    -- BankDeposit = ,
    -- BankWithdrawal = ,
    -- KeepItem = ,
    -- DestroyItem = ,
    -- UseObject = ,
    -- UseSpell = ,
    -- Equip = ,
    -- FindGroup = ,
    -- StartDungeon = ,
    -- FinishDungeon = ,
    -- Die = ,
    -- SpiritRez = ,
};

DraghosEnums.QuestObjectiveType = {
    Item = "item",
    Object = "object",
    Monster = "monster",
    Reputation = "reputation",
    Log = "log",
    Event = "event",
    Player = "player",
    ProgressBar = "progressbar",
    -- CustomSetFree = "setfree";
    CustomUseItem = "useitem",
}

DraghosFlags.NoteState = {
    Normal = 0x0, -- Default state
    Important = 0x1, -- The note is emphasized (in a red color for instance)
    Checked = 0x2, -- The note is displayed with a checkmark (only for subnotes)
    Disabled = 0x4, -- The note is not displayed
    Trivial = 0x8, -- The note is grayed out
};

-- *********************************************************************************************************************
-- ***** String Utilities
-- *********************************************************************************************************************

DraghosUtils.Str = {};

--- @param s string
--- @return boolean
function DraghosUtils.Str:Trim(s)
    local n = s:find("%S");
    return n and s:match(".*%S", n) or "";
end

--- @param s string
--- @return string
function DraghosUtils.Str:IsBlankString(s)
    return s == nil or DraghosUtils.Str:Trim(s) == "";
end

--- @param s string
--- @param prefix string
--- @return boolean
function DraghosUtils.Str:StartsWith(s, prefix)
    return s ~= nil and (prefix == "" or s:sub(1, prefix:len()) == prefix);
end

--- @param s string
--- @param suffix string
--- @return boolean
function DraghosUtils.Str:EndsWith(s, suffix)
    return s ~= nil and (suffix == "" or s:sub(-suffix:len()) == suffix);
end

-- *********************************************************************************************************************
-- ***** CALLBACKS
-- *********************************************************************************************************************

DraghosUtils.Callbacks = {};

local EventHandler = CreateFrame("Frame");

EventHandler.registeredCallbacks = {};

local pack = function(...)
    return {n = select("#", ...), ...};
end;

function EventHandler:OnEvent(event, ...)
    if self.registeredCallbacks[event] then
        for _, callbackInfo in pairs(self.registeredCallbacks[event]) do
            local callback = callbackInfo.callback;
            local args = callbackInfo.args;
            callback(unpack(args));
        end
        self.registeredCallbacks[event] = nil;
    end
end

function EventHandler:RegisterCallback(event, once, callback, ...)
    if not self:IsEventRegistered(event) then
        self:RegisterEvent(event);
    end

    if not self.registeredCallbacks[event] then
        self.registeredCallbacks[event] = {};
    elseif once then
        for _, callbackInfo in pairs(self.registeredCallbacks[event]) do
            if callbackInfo.callback == callback then
                -- Don't register the same callback more than once
                return;
            end
        end
    end

    local callbackInfo = {callback = callback, args = pack(...)};
    table.insert(self.registeredCallbacks[event], callbackInfo);
end

function DraghosUtils.Callbacks._BaseExecuteOutOfCombat(once, action, ...)
    if not InCombatLockdown() then
        action(...);
    else
        EventHandler:RegisterCallback("PLAYER_REGEN_ENABLED", once, action, ...);
    end
end

function DraghosUtils.Callbacks.ExecuteOutOfCombatOnce(action, ...)
    DraghosUtils.Callbacks._BaseExecuteOutOfCombat(true, action, ...);
end

function DraghosUtils.Callbacks.ExecuteOutOfCombat(action, ...)
    DraghosUtils.Callbacks._BaseExecuteOutOfCombat(false, action, ...);
end

EventHandler:SetScript("OnEvent", EventHandler.OnEvent);

-- *********************************************************************************************************************
-- ***** HELPERS
-- *********************************************************************************************************************

DraghosUtils.Helpers = {};

--- @return table
function DraghosUtils.Helpers:GetSupportedLocales()
    return {
        ["enUS"] = "English (United States)",
        ["esMX"] = "Spanish (Mexico)",
        ["ptBR"] = "Portuguese",
        ["deDE"] = "German",
        ["enGB"] = "English (Great Britain)",
        ["esES"] = "Spanish (Spain)",
        ["frFR"] = "French",
        ["itIT"] = "Italian",
        ["ruRU"] = "Russian",
        ["koKR"] = "Korean",
        ["zhTW"] = "Chinese (Traditional)",
        ["zhCN"] = "Chinese (Simplified)",
    };
end

--- @param guid string
--- @return number|nil
function DraghosUtils.Helpers:GetIDFromGUID(guid)
    return tonumber(guid:match("%d+", guid:match("%a+-0-%d+-%d+-%d+-%d+-"):len()));
end

--- @param unit string
--- @param id number
--- @return boolean
function DraghosUtils.Helpers:UnitHasUnitID(unit, id)
    return UnitExists(unit) and DraghosUtils.Helpers:GetIDFromGUID(UnitGUID(unit)) == id;
end

--- @param spellID number
--- @return boolean
function DraghosUtils.Helpers:PlayerIsCastingSpellID(spellID)
    if CastingInfo then
        -- Classic
        return select(9, CastingInfo()) == spellID;
    else
        -- Retail
        return select(9, UnitCastingInfo("player")) == spellID;
    end
end

function DraghosUtils.Helpers:StartGarbageCollection()
    if self.isCollectingGarbage then
        return;
    end

    -- print("garbage collection step at " .. time())
    self.isCollectingGarbage = true;
    self.isGarbageCollected = collectgarbage("step", 1000);

    if self.isGarbageCollected then
        self.isCollectingGarbage = false;
    else
        C_Timer.After(
            0.1, function()
                self.isCollectingGarbage = false;
                self:StartGarbageCollection();
            end
        );
    end
end

-- *********************************************************************************************************************
-- ***** Hacks
-- *********************************************************************************************************************

DraghosUtils.Hacks = {};

local NamedFramePoolMixin = {};

NamedFramePoolMixin = CreateFromMixins(ObjectPoolMixin);

local function FramePoolFactory(framePool)
    local name = framePool.namePrefix .. (framePool.numActiveObjects + 1);
    local frame = CreateFrame(framePool.frameType, name, framePool.parent, framePool.frameTemplate);
    frame:SetID(framePool.numActiveObjects + 1);
    return frame;
end

function NamedFramePoolMixin:OnLoad(frameType, parent, frameTemplate, resetterFunc, namePrefix)
    ObjectPoolMixin.OnLoad(self, FramePoolFactory, resetterFunc);
    self.frameType = frameType;
    self.parent = parent;
    self.frameTemplate = frameTemplate;
    self.namePrefix = namePrefix;
end

function NamedFramePoolMixin:GetTemplate()
    return self.frameTemplate;
end

function DraghosUtils.Hacks:CreateNamedFramePool(frameType, parent, frameTemplate, resetterFunc, namePrefix)
    local framePool = CreateFromMixins(NamedFramePoolMixin);
    framePool:OnLoad(frameType, parent, frameTemplate, resetterFunc or FramePool_HideAndClearAnchors, namePrefix);
    return framePool;
end

-- *********************************************************************************************************************
-- ***** DEBUG
-- *********************************************************************************************************************

-- TODO: Deactivate this on release builds

DraghosUtils.Debug = {};

--- @param value any
function DraghosUtils.Debug:Dump(value)
    LoadAddOn("Blizzard_DebugTools");
    DevTools_Dump(value)
end
