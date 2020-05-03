-- NOTE: This code is a new way of using objects on 9.0,
--       it will not be necessary when it will be live.
function _Mixin(object, ...)
    -- where ​... are the mixins to mixin
    for i = 1, select("#", ...) do
        local mixin = select(i, ...);
        for k, v in pairs(mixin) do
            object[k] = v;
        end
    end

    return object;
end

function _CreateFromMixins(...)
    -- where ​... are the mixins to mixin
    return _Mixin({}, ...)
end

function _CreateAndInitFromMixin(mixin, ...)
    local object = _CreateFromMixins(mixin);
    object:Init(...);
    return object;
end
