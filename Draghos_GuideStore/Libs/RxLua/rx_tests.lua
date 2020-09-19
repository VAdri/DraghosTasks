local Rx = require "rx";

local Object = {};

local ObjectMT = Rx.GetMetatable(Object);

function Object.New()
    return setmetatable(
        { dirty = true, cache = {} },
        ObjectMT
    );
end

function Object:IsValid()
    return self.data == "blop";
end

function Object:Noop()
    return nil;
end

describe("An Rx object that has just been created", function()
    it("is initiated with a dirty flag and no cache", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.dirty);
        assert.is_nil(obj.cache.IsValid);
        assert.equal("blop", obj.__rxdata.data);
    end);

    it("calculates the value of a computed prop, keeps its result in the cache and set the dirty flag to false", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_true(obj.cache.IsValid);
        assert.is_false(obj.dirty);
        assert.equal("blop", obj.__rxdata.data);
    end);
end);

describe("An Rx object that has its data modified with the same value", function()
    it("keeps its dirty flag to false", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "blop";
        assert.is_false(obj.dirty);
    end);

    it("keeps its cache", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "blop";
        assert.is_true(obj.cache.IsValid);
    end);
end);

describe("An Rx object that has its data modified with a different value", function()
    it("sets its dirty flag to true", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "lapin";
        assert.is_true(obj.dirty);
    end);

    it("wipes its cache", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "lapin";
        assert.is_nil(obj.Noop);
        assert.is_nil(obj.cache.IsValid);
    end);

    it("recomputes its computed props", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "lapin";
        assert.is_nil(obj.Noop);
        assert.is_false(obj.IsValid);
        assert.is_false(obj.cache.IsValid);
    end);

-- @@ifdebug@@
    it("increases usage count", function()
        local obj = Object.New();
        local count = Rx.Usage.IsValid.Count;
        assert.is_false(obj.IsValid);
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        obj.data = "lapin";
        assert.is_false(obj.IsValid);
        assert.is_nil(obj.Noop);

        assert.equal(count + 3, Rx.Usage.IsValid.Count);
    end);
-- @@endif@@

    it("removes its dirty flag after recomputing", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        obj.data = "lapin";
        assert.is_true(obj.dirty);
        assert.is_nil(obj.Noop);
        assert.is_false(obj.dirty);
    end);
end);

describe("An Rx object that has its data modified using rawset", function()
    it("keeps its dirty flag to false", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        rawset(obj, "data", "lapin");
        assert.is_false(obj.dirty);
    end);

    it("keeps its cache", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        rawset(obj, "data", "lapin");
        assert.is_true(obj.cache.IsValid);
    end);

    it("doesn't recompute its computed props", function()
        local obj = Object.New();
        obj.data = "blop";
        assert.is_true(obj.IsValid);
        assert.is_false(obj.dirty);
        rawset(obj, "data", "lapin");
        assert.is_true(obj.cache.IsValid);
        assert.is_true(obj.IsValid);
    end);
end);
