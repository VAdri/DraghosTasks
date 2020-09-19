local Rx;

if (LibStub) then
    local MAJOR, MINOR = "RxLua", 1;
    Rx = LibStub:NewLibrary(MAJOR, MINOR);
else
    require "globals";
    Rx = {};
end

local wipe = wipe;

-- *********************************************************************************************************************
-- ** Main
-- *********************************************************************************************************************

local dataKey = "__rxdata";

-- @@ifdebug@@
Rx.Usage = {};
-- @@endif@@

function Rx.GetMetatable(mixin)
    return {
        __index = function (obj, key)
            local method = mixin[key];
            if (method == nil) then
                -- Try to return the data
                local data = rawget(obj, dataKey)
                return data and data[key] or nil;
            elseif (type(method) ~= "function") then
                -- Not a method so we return the value directly
                return method;
            end

            if (obj.dirty == true) then
                -- Wipe cache if the object is dirty
                obj.dirty = false;
                wipe(obj.cache);
            end

-- @@ifdebug@@
            -- Get the current time and memory usage before the execution
            Rx.Usage[key] = Rx.Usage[key] or { Memory = 0, Count = 0, Time = 0 };
            local memory = collectgarbage("count");
            local t1 = time();
-- @@endif@@

            -- Get the value
            local result;
            if (type(obj.cache) ~= "table") then
                -- No cache
                result = method(obj);
            else
                -- Use cache
                result = obj.cache[key];
                if (result == nil) then
                    -- The result is not in the cache yet
                    result = method(obj);
                    obj.cache[key] = result;
                end
            end

-- @@ifdebug@@
            -- Profile the execution of this method
            local usage = Rx.Usage[key];
            local tDelta = time() - t1;
            local memoryDelta = collectgarbage("count") - memory;
            usage.Memory = usage.Memory + (memoryDelta > 0 and memoryDelta or 0);
            usage.Count = usage.Count + 1;
            usage.Time = usage.Time + tDelta;
-- @@endif@@

            -- Finally, return the result
            return result;
        end,

        __newindex = function (obj, key, value)
            -- Initialize the data
            local data = rawget(obj, dataKey);
            if (not data) then
                data = {};
                rawset(obj, dataKey, data);
            end

            if (key == "dirty" and value == true) then
                -- Propagate the dirty flag to the childs
                local childs = obj.childs;
                if (type(childs) == "table") then
                    for _, child in pairs(childs) do
                        child.dirty = true;
                    end
                end
            elseif (key ~= "dirty" and not obj.dirty) then
                -- Set the dirty flag when a value has changed
                local currentValue = data[key];
                if (currentValue ~= value) then
                    obj.dirty = true;
                end
            end

            -- Finally, set the value in the data
            data[key] = value;
        end
    };
end

-- *********************************************************************************************************************
-- ** Export
-- *********************************************************************************************************************

return Rx;
