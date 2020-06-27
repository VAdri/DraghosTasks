local ObservableMixin = {};

function ObservableMixin:Watch(frame, handler)
    assert(type(self) == "table", "Usage: ObservableMixin:Watch(frame, handler)");
    assert(type(frame) == "table", "Usage: ObservableMixin:Watch(frame, handler)");
    assert(type(handler) == "function", "Usage: ObservableMixin:Watch(frame, handler)");
    self.watchers = self.watchers or {};
    self.watchers[frame] = handler;

    -- Watch children
    for _, stepLine in self:GetStepLines():GetEnumerator() do
        stepLine:Watch(frame, handler);
    end
end

function ObservableMixin:Unwatch(frame)
    assert(type(self) == "table", "Usage: ObservableMixin:Watch(frame, handler)");
    assert(type(frame) == "table", "Usage: ObservableMixin:Watch(frame, handler)");
    if self.watchers and self.watchers[frame] then
        self.watchers[frame] = nil;
    end

    -- Unwatch children
    for _, stepLine in self:GetStepLines():GetEnumerator() do
        stepLine:Unwatch(frame);
    end
end

-- function ObservableMixin:NotifyWatchers(event, ...)
--     assert(type(self) == "table", "Usage: ObservableMixin:NotifyWatchers(event, ...)");
--     for frame, handler in pairs(self.watchers or {}) do
--         handler(frame, self, event, ...);
--     end
-- end

DraghosMixins.Observable = ObservableMixin;
