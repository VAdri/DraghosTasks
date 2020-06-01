local CacheMixin = {};

local cacheMaxAge = 0.2;

function CacheMixin:CacheInit()
    self.cache = setmetatable({}, {__mode = 'kv'});
    self.cacheAge = time();
end

function CacheMixin:HasCache(key)
    if (time() - self.cacheAge > cacheMaxAge) then
        self:ClearCache();
    end

    return self.cache[key] ~= nil;
end

function CacheMixin:GetCache(key)
    if (time() - self.cacheAge > cacheMaxAge) then
        self:ClearCache();
    end

    return self.cache[key];
end

function CacheMixin:SetCache(key, value)
    self.cache[key] = value;
end

function CacheMixin:ClearCache(key)
    if (key) then
        self.cache[key] = nil;
        return;
    end

    wipe(self.cache);
    self.cacheAge = time();

    if (self.stepLines) then
        -- Clear cache on children
        for _, stepLine in pairs(self.stepLines) do
            stepLine:ClearCache();
        end
    end
end

DraghosMixins.Cache = CacheMixin;
