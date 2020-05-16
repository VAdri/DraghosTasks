DraghosUtils = {};
DraghosMixins = {};
Draghos_GuideStore = {};

-- *********************************************************************************************************************
-- ***** Functional Programming
-- *********************************************************************************************************************

DraghosUtils.FP = {};

--- @param t table
--- @param func function
--- @return table
function DraghosUtils.FP:Filter(t, func)
    local _t = {};
    for index, value in pairs(t) do
        if func(value, index) then
            _t[#_t + 1] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param prop any
--- @param val any
--- @return table
function DraghosUtils.FP:FilterByProp(t, prop, val)
    local _t = {};
    for _, value in pairs(t) do
        if value[prop] == val then
            _t[#_t + 1] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param prop any
--- @param val any
--- @return table
function DraghosUtils.FP:FilterByPropIndexed(t, prop, val)
    local _t = {};
    for index, value in pairs(t) do
        if value[prop] == val then
            _t[index] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param func function
--- @return table
function DraghosUtils.FP:FilterIndexed(t, func)
    local _t = {};
    for index, value in pairs(t) do
        if func(value, index) then
            _t[index] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param func function
--- @return any|nil
function DraghosUtils.FP:Find(t, func)
    for index, value in pairs(t) do
        if func(value, index) then
            return value;
        end
    end
    return nil;
end

--- @param t table
--- @param func function
--- @return number|nil
function DraghosUtils.FP:FindIndex(t, func)
    for index, value in pairs(t) do
        if func(value, index) then
            return index;
        end
    end
    return nil;
end

--- @param t table
--- @param prop any
--- @param val any
--- @return number|nil
function DraghosUtils.FP:FindByProp(t, prop, val)
    for _, value in pairs(t) do
        if value[prop] == val then
            return value;
        end
    end
    return nil;
end

--- @param t table
--- @param func function
--- @return table
function DraghosUtils.FP:Map(t, func)
    local _t = {};
    for index, value in pairs(t) do
        _t[#_t + 1] = func(value, index);
    end
    return _t;
end

--- @param t table
--- @param prop any
--- @return table
function DraghosUtils.FP:MapProp(t, prop)
    local _t = {};
    for _, value in pairs(t) do
        _t[#_t + 1] = value[prop];
    end
    return _t;
end

--- @param t table
--- @param func function
--- @return table
function DraghosUtils.FP:MapIndexed(t, func)
    local _t = {};
    for index, value in pairs(t) do
        _t[index] = func(value, index);
    end
    return _t;
end

--- @param t table
--- @return table
function DraghosUtils.FP:Flatten(t)
    local _t = {};
    for _, subTable in pairs(t) do
        for _, value in pairs(subTable) do
            _t[#_t + 1] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param func function|any
--- @return boolean
function DraghosUtils.FP:Any(t, func)
    local _f = func;
    if type(func) ~= "function" then
        _f = function(v)
            return v == func;
        end;
    end
    for index, value in pairs(t) do
        if _f(value, index) then
            return true;
        end
    end
    return false;
end

--- @param t table
--- @param func function|any
--- @return boolean
function DraghosUtils.FP:All(t, func)
    local _f = func;
    if type(func) ~= "function" then
        _f = function(v)
            return v == func;
        end;
    end
    for index, value in pairs(t) do
        if not _f(value, index) then
            return false;
        end
    end
    return true;
end

--- @param t table
--- @param prop any
function DraghosUtils.FP:SortByProp(t, prop)
    local sort = function(item1, item2)
        return item1[prop] < item2[prop];
    end;
    table.sort(t, sort);
end

--- @param t table
--- @param func function|any
--- @return number
function DraghosUtils.FP:Count(t, func)
    return #DraghosUtils.FP:Filter(t, func);
end

--- @return table
function DraghosUtils.FP:Concat(...)
    local _t = {};
    for i = 1, select("#", ...) do
        for _, v in pairs(select(i, ...)) do
            _t[#_t + 1] = v;
        end
    end
    return _t;
end

--- @param t table
--- @param item any
--- @return table
function DraghosUtils.FP:Append(t, item)
    return DraghosUtils.FP:Concat(t, {item});
end

--- @param prop any
--- @return function
function DraghosUtils.FP:PropsAreEqual(prop)
    return function(v1, v2)
        return v1[prop] == v2[prop];
    end
end

local function BaseCompare(v1, v2)
    return v1 == v2;
end

--- @param t table
--- @return table
function DraghosUtils.FP:Unique(t)
    return self:UniqueWith(t, BaseCompare);
end

--- @param t table
--- @param func function
--- @return table
function DraghosUtils.FP:UniqueWith(t, func)
    local _t = {};
    for _, v1 in pairs(t) do
        local isUnique = true;
        for _, v2 in pairs(_t) do
            if func(v1, v2) then
                isUnique = false;
                break
            end
        end
        if isUnique then
            _t[#_t + 1] = v1;
        end
    end
    return _t;
end

--- @param t table
--- @param prop any
--- @return table
function DraghosUtils.FP:UniqueBy(t, prop)
    return self:UniqueWith(t, self:PropsAreEqual(prop));
end

--- @param func function
--- @return function
function DraghosUtils.FP:ReverseResult(func)
    return function(...)
        return not func(...);
    end
end

--- @param t1 table
--- @param t2 table
--- @return table
function DraghosUtils.FP:Intersection(t1, t2)
    local _t = {};
    for _, v1 in pairs(t1) do
        for _, v2 in pairs(t2) do
            if v1 == v2 then
                _t[#_t + 1] = v1;
                break
            end
        end
    end
    return _t;
end

--- @param t1 table
--- @param t2 table
--- @return table
function DraghosUtils.FP:Difference(t1, t2)
    local _t = {};
    for _, v1 in pairs(t1) do
        _t[#_t + 1] = v1;
        for _, v2 in pairs(t2) do
            if v1 == v2 then
                _t[#_t] = nil;
                break
            end
        end
    end
    return _t;
end

--- @param t1 table
--- @param t2 table
--- @return table
function DraghosUtils.FP:XOR(t1, t2)
    local _t1 = DraghosUtils.FP:Difference(t1, t2);
    local _t2 = DraghosUtils.FP:Difference(t2, t1);
    return DraghosUtils.FP:Unique(DraghosUtils.FP:Concat(_t1, _t2));
end

--- @param t table
--- @return table
function DraghosUtils.FP:Keys(t)
    local _t = {};
    for key, _ in pairs(t) do
        _t[#_t + 1] = key;
    end
    return _t;
end

--- @param method function
--- @return function
function DraghosUtils.FP:CallOnSelf(method, ...)
    --- @param object table
    --- @return any
    return function(object, ...)
        return object[method](object, ...);
    end;
end

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

-- *********************************************************************************************************************
-- ***** Hacks
-- *********************************************************************************************************************

DraghosUtils.Hacks = {};

local NamedFramePoolMixin = {};

NamedFramePoolMixin = CreateFromMixins(ObjectPoolMixin);

local function FramePoolFactory(framePool)
    local name = framePool.nameSuffix .. (framePool.numActiveObjects + 1);
    return CreateFrame(framePool.frameType, name, framePool.parent, framePool.frameTemplate);
end

function NamedFramePoolMixin:OnLoad(frameType, parent, frameTemplate, resetterFunc, nameSuffix)
    ObjectPoolMixin.OnLoad(self, FramePoolFactory, resetterFunc);
    self.frameType = frameType;
    self.parent = parent;
    self.frameTemplate = frameTemplate;
    self.nameSuffix = nameSuffix;
end

function NamedFramePoolMixin:GetTemplate()
    return self.frameTemplate;
end

function DraghosUtils.Hacks:CreateNamedFramePool(frameType, parent, frameTemplate, resetterFunc, nameSuffix)
    local framePool = CreateFromMixins(NamedFramePoolMixin);
    framePool:OnLoad(frameType, parent, frameTemplate, resetterFunc or FramePool_HideAndClearAnchors, nameSuffix);
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
