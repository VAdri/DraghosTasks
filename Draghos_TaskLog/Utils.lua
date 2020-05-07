--- @param t table
--- @param f function
--- @return table
function Filter(t, f)
    local _t = {};
    for index, value in pairs(t) do
        if f(value, index) then
            _t[#_t + 1] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param f function
--- @return table
function FilterIndexed(t, f)
    local _t = {};
    for index, value in pairs(t) do
        if f(value, index) then
            _t[index] = value;
        end
    end
    return _t;
end

--- @param t table
--- @param f function
--- @return any|nil
function Find(t, f)
    for index, value in pairs(t) do
        if f(value, index) then
            return value;
        end
    end
    return nil;
end

--- @param t table
--- @param f function
--- @return number|nil
function FindIndex(t, f)
    for index, value in pairs(t) do
        if f(value, index) then
            return index;
        end
    end
    return nil;
end

--- @param t table
--- @param f function
--- @return table
function Map(t, f)
    local _t = {};
    for index, value in pairs(t) do
        _t[#_t + 1] = f(value, index);
    end
    return _t;
end

--- @param t table
--- @param f function|any
--- @return boolean
function Any(t, f)
    local _f = f;
    if type(f) ~= "function" then
        _f = function(v)
            return v == f;
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
--- @param f function|any
--- @return boolean
function All(t, f)
    local _f = f;
    if type(f) ~= "function" then
        _f = function(v)
            return v == f;
        end;
    end
    for index, value in pairs(t) do
        if not _f(value, index) then
            return false;
        end
    end
    return true;
end

--- @param s string
--- @return boolean
function IsBlankString(s)
    return not (s ~= nil and s:match("%S") ~= nil);
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

-- function Draghos_Dump(value)
--     LoadAddOn("Blizzard_DebugTools");
--     DevTools_Dump(value)
-- end
