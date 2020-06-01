local CreateAndInitFromMixin = CreateAndInitFromMixin;

local Str = DraghosUtils.Str;

local M = LibStub("Moses");

-- *********************************************************************************************************************
-- ***** LOADING AND RETRIEVING OBJECTS FROM THE STORE
-- *********************************************************************************************************************

local function InitStep(step)
    if step.stepType == DraghosEnums.StepTypes.Note then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepNote, step);
    elseif step.stepType == DraghosEnums.StepTypes.PickupQuest then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepPickUpQuest, step);
    elseif step.stepType == DraghosEnums.StepTypes.ProgressQuestObjectives then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepProgressQuestObjectives, step);
    elseif step.stepType == DraghosEnums.StepTypes.CompleteQuestObjectives then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepCompleteQuestObjectives, step);
    elseif step.stepType == DraghosEnums.StepTypes.CompleteQuest then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepCompleteQuest, step);
    elseif step.stepType == DraghosEnums.StepTypes.HandinQuest then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepHandInQuest, step);
    elseif step.stepType == DraghosEnums.StepTypes.Grind then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepGrind, step);
    elseif step.stepType == DraghosEnums.StepTypes.UseHearthstone then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepUseHearthstone, step);
    elseif step.stepType == DraghosEnums.StepTypes.SetHearth then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepSetHearth, step);
    elseif step.stepType == DraghosEnums.StepTypes.Go then
        -- TODO: return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepGo, step);
    elseif step.stepType == DraghosEnums.StepTypes.GetFlightPath then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepDiscoverTaxiNode, step);
    else
        -- ? return Draghos_GuideStore:CreateObject(StepUnknownMixin, step);
    end
end

function Draghos_GuideStore:LoadSteps()
    self.steps = M(self.steps):map(InitStep):value();
end

function Draghos_GuideStore:GetStepByID(stepID)
    return M(self.steps):findWhere({stepID = stepID}):value();
end

local function IsStepRemaining(step)
    return step:IsValid() and not step:IsCompleted();
end

function Draghos_GuideStore:GetRemainingSteps()
    return M(self.steps):filter(IsStepRemaining):sortBy("stepID"):value();
end

function Draghos_GuideStore:GetQuestByID(questID)
    return self.quests[questID];
end

function Draghos_GuideStore:GetHearthstoneItemByID(itemID)
    return self.items.hearth[itemID];
end

function Draghos_GuideStore:GetTaxiNodeByID(nodeID)
    return self.taxiNodes[nodeID];
end

-- *********************************************************************************************************************
-- ***** OBJECTS CREATION
-- *********************************************************************************************************************

local GuideItemMetatable = {};

-- -- TODO: Deactivate this on release builds

-- -- Trick from this conversation: http://lua-users.org/lists/lua-l/2011-05/msg00029.html
-- local function meta_tostring(object)
--     -- Disable the custom __tostring to get the original value
--     GuideItemMetatable.__tostring = nil;
--     local originalString = tostring(object);

--     -- Re-enable meta_tostring and return the result
--     GuideItemMetatable.__tostring = meta_tostring;
--     if object and type(object.GetLabel) == "function" then
--         return "guide_item: " .. originalString:sub(8) .. " (" .. object:GetLabel() .. ")";
--     else
--         return originalString;
--     end
-- end
-- GuideItemMetatable.__tostring = meta_tostring;

function Draghos_GuideStore:CreateGuideItem(mixin, data)
    local object = CreateAndInitFromMixin(mixin, data);
    return setmetatable(object, GuideItemMetatable);
end

function Draghos_GuideStore:CreateBaseItem(mixin, data)
    local object = {};
    Mixin(object, mixin);
    object:InitBase(data);
    return setmetatable(object, GuideItemMetatable);
end

-- *********************************************************************************************************************
-- ***** INITIALIZATION
-- *********************************************************************************************************************

local frame;

function GuideStoreFrame_OnLoad(self)
    frame = self;
    Draghos_GuideStore.notifiers = {};
    Draghos_GuideStore.handlers = {};

    Draghos_GuideStore:LoadSteps();

    Draghos_GuideStore.initialized = true;
end

-- *********************************************************************************************************************
-- ***** EVENTS (from store to UI)
-- *********************************************************************************************************************

Draghos_GuideStore.customEventsPrefix = "DRAGHOS";

function GuideStoreFrame_OnEvent(self, event, ...)
    -- TODO: ClearMemo();
    local notifiers = Draghos_GuideStore.notifiers[event] or {};
    local handlers = M(notifiers):map(M.property("watchers")):flatten(true):unique():value();
    for _, handler in pairs(handlers) do
        handler();
    end
    -- TODO: ClearMemo();
    -- TODO: Helpers:StartGarbageCollection();
end

function Draghos_GuideStore:SendCustomEvent(event, ...)
    GuideStoreFrame_OnEvent(self, event, ...);
end

function Draghos_GuideStore:RegisterForNotifications(item, event)
    self.notifiers[event] = self.notifiers[event] or {};
    table.insert(self.notifiers[event], item);
    if Str:StartsWith(event, Draghos_GuideStore.customEventsPrefix) then
        -- This is not a real event we don't need to register it
    elseif not frame:IsEventRegistered(event) then
        frame:RegisterEvent(event);
    end
end

function Draghos_GuideStore:UnregisterForNotifications(item)
    self.notifiers = self.notifiers or {};
    self.notifiers[item] = nil;
end

-- *********************************************************************************************************************
-- ***** MESSAGES (from UI to store)
-- *********************************************************************************************************************

function Draghos_GuideStore:OnMessageReceived(messageType, handler)
    self.handlers[messageType] = self.handlers[messageType] or {};
    table.insert(self.handlers[messageType], handler);
end

function Draghos_GuideStore:SendMesage(messageType, ...)
    -- TODO: ClearMemo();
    local handlers = M(self.handlers[messageType] or {}):unique():value();
    for _, handler in pairs(handlers) do
        handler(...);
    end
    -- TODO: ClearMemo();
    -- ? Helpers:StartGarbageCollection();
end
