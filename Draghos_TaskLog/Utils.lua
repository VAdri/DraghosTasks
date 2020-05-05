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

--- @param s string
--- @return boolean
function IsBlankString(s)
    return not (s ~= nil and s:match("%S") ~= nil);
end
