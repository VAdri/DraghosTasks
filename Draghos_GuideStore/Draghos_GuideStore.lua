local CreateAndInitFromMixin = CreateAndInitFromMixin;

local Str = DraghosUtils.Str;
local FP = DraghosUtils.FP;

-- *********************************************************************************************************************
-- ***** LOADING AND RETRIEVING OBJECTS FROM THE STORE
-- *********************************************************************************************************************

local function InitStep(step)
    if step.stepType == STEP_TYPE_PICKUP_QUEST then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepPickUpQuest, step);
    elseif step.stepType == STEP_TYPE_PROGRESS_QUEST_OBJECTIVE then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepProgressQuestObjectives, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST_OBJECTIVE then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepCompleteQuestObjectives, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepCompleteQuest, step);
    elseif step.stepType == STEP_TYPE_HANDIN_QUEST then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepHandInQuest, step);
    elseif step.stepType == STEP_TYPE_GRIND then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepGrind, step);
    elseif step.stepType == STEP_TYPE_USE_HEARTHSTONE then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepUseHearthstone, step);
    elseif step.stepType == STEP_TYPE_SET_HEARTH then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepSetHearth, step);
    elseif step.stepType == STEP_TYPE_GET_FLIGHT_PATH then
        return Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepDiscoverTaxiNode, step);
    else
        -- ? return Draghos_GuideStore:CreateObject(StepUnknownMixin, step);
    end
end

function Draghos_GuideStore:LoadSteps()
    self.steps = FP:MapIndexed(self.steps, InitStep);
end

function Draghos_GuideStore:GetStepByID(stepID)
    return FP:FindByProp(self.steps, "stepID", stepID);
end

local function IsStepRemaining(step)
    return step:IsValid() and not step:IsCompleted();
end

function Draghos_GuideStore:GetRemainingSteps()
    local steps = FP:Filter(self.steps, IsStepRemaining);
    FP:SortByProp(steps, "stepID");
    return steps;
end

function Draghos_GuideStore:GetQuestByID(questID)
    return self.quests[questID];
    -- return FP:FindByProp(self.quests, "questID", questID);
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

-- TODO: Deactivate this on release builds

-- Trick from this conversation: http://lua-users.org/lists/lua-l/2011-05/msg00029.html
local function meta_tostring(object)
    -- Disable the custom __tostring to get the original value
    GuideItemMetatable.__tostring = nil;
    local originalString = tostring(object);

    -- Re-enable meta_tostring and return the result
    GuideItemMetatable.__tostring = meta_tostring;
    if object and type(object.GetLabel) == "function" then
        return "guide_item: " .. originalString:sub(8) .. " (" .. object:GetLabel() .. ")";
    else
        return originalString;
    end
end
GuideItemMetatable.__tostring = meta_tostring;

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
-- ***** HOOKS
-- *********************************************************************************************************************

local frame;

Draghos_GuideStore.customEventsSuffix = "DRAGHOS";

function GuideStoreFrame_OnLoad(self)
    frame = self;
    Draghos_GuideStore:LoadSteps();
    Draghos_GuideStore.initialized = true;
end

function GuideStoreFrame_OnEvent(self, event, ...)
    local notifiers = Draghos_GuideStore.notifiers and Draghos_GuideStore.notifiers[event] or {};
    for _, notifier in pairs(notifiers) do
        notifier:NotifyWatchers(event, ...);
    end
end

function Draghos_GuideStore:SendCustomEvent(event, ...)
    GuideStoreFrame_OnEvent(self, event, ...);
end

function Draghos_GuideStore:RegisterForNotifications(item, event)
    self.notifiers = self.notifiers or {};
    self.notifiers[event] = self.notifiers[event] or {};
    table.insert(self.notifiers[event], item);
    if Str:StartsWith(event, Draghos_GuideStore.customEventsSuffix) then
        -- This is not a real event we don't need to register it
    elseif not frame:IsEventRegistered(event) then
        frame:RegisterEvent(event, self.OnEvent);
    end
end

function Draghos_GuideStore:UnregisterForNotifications(item)
    self.notifiers = self.notifiers or {};
    self.notifiers[item] = nil;
end
