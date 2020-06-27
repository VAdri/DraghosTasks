local Lambdas = DraghosUtils.Lambdas;

local Linq = LibStub("Linq");

--- @type Enumerable
local Enumerable = Linq.Enumerable;

local TargetMixin = {};

local function CreateNPC(npc)
    return Draghos_GuideStore:CreateBaseItem(DraghosMixins.NPC, npc);
end

function TargetMixin:TargetInit(targets, otherTargets)
    self.targets = Enumerable.From(targets or {}):Concat(otherTargets or {}):Select(CreateNPC):ToArray();
end

function TargetMixin:GetTargetNPCsEnumerable()
    -- if (not self:HasCache("GetTargetNPCs")) then
    --     self:SetCache(
    --         "GetTargetNPCs",
    --         M(self:GetStepLines()):filter(isNotCompleted):map(M.property("targets")):flatten(true):append(self.targets):value()
    --     );
    -- end
    -- return self:GetCache("GetTargetNPCs");
    return self:GetStepLines()
        :Where(Lambdas.Not(Lambdas.SelfResult("IsCompleted")))
        :SelectMany(Lambdas.Property("targets"))
        :Concat(self.targets);
end

function TargetMixin:GetTargetNPCs()
    return self:GetTargetNPCsEnumerable():ToArray();
end

function TargetMixin:HasTargets()
    return self:GetTargetNPCsEnumerable():Any();
end

function TargetMixin:HasInvalidTargets()
    -- if (not self:HasTargets()) then
    --     return false;
    -- end

    -- if (not self:HasCache("HasInvalidTargets")) then
    --     self:SetCache("HasInvalidTargets", );
    -- end
    -- return self:GetCache("HasInvalidTargets");
    return self:GetTargetNPCsEnumerable():Any(Lambdas.Not(Lambdas.SelfResult("IsValidNPC")));
end

function TargetMixin:GetTargetNames()
    -- if (not self:HasCache("GetTargetNames")) then
    --     self:SetCache("GetTargetNames", M(self:GetTargetNPCs()):map(getNPCName):value());
    -- end
    -- return self:GetCache("GetTargetNames");
    return self:GetTargetNPCsEnumerable():Select(Lambdas.SelfResult("GetNPCName")):ToArray();
end

function TargetMixin:GetTargetIDs()
    -- if (not self:HasCache("GetTargetIDs")) then
    --     self:SetCache("GetTargetIDs", M(self:GetTargetNPCs()):map(M.property("npcID")):value());
    -- end
    -- return self:GetCache("GetTargetIDs");
    return self:GetTargetNPCsEnumerable():Select(Lambdas.Property("npcID")):ToArray();
end

DraghosMixins.Target = TargetMixin;
