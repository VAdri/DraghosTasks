local M = LibStub("Moses");

local TargetMixin = {};

local function CreateNPC(npc)
    local createdNPC = CreateFromMixins(DraghosMixins.NPC);
    createdNPC:NPCInit(npc);
    return createdNPC;
end

function TargetMixin:TargetInit(targets)
    self.targets = M(targets or {}):map(CreateNPC):value();
end

local isNotCompleted = M.complement(M.partial(M.result, "_", "IsCompleted"));

function TargetMixin:GetTargetNPCs()
    return M(self:GetStepLines()):filter(isNotCompleted):map(M.property("targets")):flatten(true):append(self.targets)
               :value();
end

function TargetMixin:HasTargets()
    return #self:GetTargetNPCs() > 0;
end

local isNotValidNPC = M.complement(M.partial(M.result, "_", "IsValidNPC"));

function TargetMixin:HasInvalidTargets()
    return self:HasTargets() and M(self:GetTargetNPCs()):any(isNotValidNPC):value();
end

local getNPCName = M.partial(M.result, "_", "GetNPCName");

function TargetMixin:GetTargetNames()
    return M(self:GetTargetNPCs()):map(getNPCName):value();
end

function TargetMixin:GetTargetIDs()
    return M(self:GetTargetNPCs()):map(M.property("npcID")):value();
end

DraghosMixins.Target = TargetMixin;
