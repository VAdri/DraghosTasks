--- @param t table
--- @param func function
--- @return table
function Filter(t, func)
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
function FilterByProp(t, prop, val)
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
function FilterByPropIndexed(t, prop, val)
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
function FilterIndexed(t, func)
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
function Find(t, func)
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
function FindIndex(t, func)
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
function FindByProp(t, prop, val)
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
function Map(t, func)
    local _t = {};
    for index, value in pairs(t) do
        _t[#_t + 1] = func(value, index);
    end
    return _t;
end

--- @param t table
--- @param func function
--- @return table
function MapIndexed(t, func)
    local _t = {};
    for index, value in pairs(t) do
        _t[index] = func(value, index);
    end
    return _t;
end

--- @param t table
--- @param func function|any
--- @return boolean
function Any(t, func)
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
function All(t, func)
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
--- @param func function|any
--- @return number
function Count(t, func)
    return #Filter(t, func);
end

--- @param t table
--- @return table
function Keys(t)
    local _t = {};
    for key, _ in pairs(t) do
        _t[#_t + 1] = key;
    end
    return _t;
end

--- @param method function
--- @return function
function CallOnSelf(method, ...)
    --- @param object table
    --- @return any
    return function(object, ...)
        return object[method](object, ...);
    end;
end

--- @param s string
--- @return boolean
function Trim(s)
    local n = s:find("%S");
    return n and s:match(".*%S", n) or "";
end

--- @param s string
--- @return string
function IsBlankString(s)
    return s == nil or Trim(s) == "";
end

--- @class ElapsedResult
--- @field public years number
--- @field public months number
--- @field public days number
--- @field public hours number
--- @field public minutes number

--- @param startTime number
--- @param endTime number
--- @return ElapsedResult
function Elapsed(startTime, endTime)
    local remainder;
    local diff = endTime - startTime;

    local years = math.floor(diff / 31557600);
    remainder = diff % 31557600;
    local months = math.floor(remainder / 2629800);
    remainder = diff % 2629800;
    local days = math.floor(remainder / 86400);
    remainder = diff % 86400;
    local hours = math.floor(remainder / 3600);
    remainder = diff % 3600;
    local minutes = math.floor(remainder / 60);

    return {years = years, months = months, days = days, hours = hours, minutes = minutes};
end

--- @return table
function GetSupportedLocales()
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

-- function Draghos_Dump(value)
--     LoadAddOn("Blizzard_DebugTools");
--     DevTools_Dump(value)
-- end
