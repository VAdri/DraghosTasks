GUIDE_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable();

OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE = 0x200000;

GUIDE_TRACKER_MODULE.updateReasonModule = OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE;
GUIDE_TRACKER_MODULE.updateReasonEvents = 0;
GUIDE_TRACKER_MODULE.usedBlocks = {};

GUIDE_TRACKER_MODULE.buttonOffsets = {groupFinder = {7, 4}, useItem = {3, 1}};

GUIDE_TRACKER_MODULE.paddingBetweenButtons = 2;

-- *********************************************************************************************************************
-- ***** INITIALIZATION
-- *********************************************************************************************************************

function GuideObjectiveTracker_OnLoad(self, ...)
    GuideObjectiveTrackerInitialize(self);

    if not self.initialized then
        self:RegisterEvent("PLAYER_ENTERING_WORLD");
    end
end

function GuideObjectiveTracker_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        GuideObjectiveTrackerInitialize(self);
    end
end

function GuideObjectiveTrackerInitialize(self)
    if self.initialized or not ObjectiveTrackerFrame.initialized then
        return;
    end

    local guideHeaderFrame = CreateFrame(
                                 "Frame", "ObjectiveTrackerBlocksFrame.GuideHeader", ObjectiveTrackerFrame.BlocksFrame,
                                 "ObjectiveTrackerHeaderTemplate"
                             );

    GUIDE_TRACKER_MODULE:SetHeader(guideHeaderFrame, TRACKER_HEADER_GUIDE, OBJECTIVE_TRACKER_UPDATE_REASON);

    table.insert(ObjectiveTrackerFrame.MODULES, GUIDE_TRACKER_MODULE);
    table.insert(ObjectiveTrackerFrame.MODULES_UI_ORDER, GUIDE_TRACKER_MODULE);

    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);

    -- -- Function called when the task store is updated
    -- Draghos_TaskLog:Subscribe(
    --     function()
    --         ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
    --         GUIDE_TRACKER_MODULE:ResetAnimations();
    --     end
    -- );

    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    self.initialized = true;
end

-- *********************************************************************************************************************
-- ***** ANIMATIONS
-- *********************************************************************************************************************

local LINE_TYPE_ANIM = {template = "GuideObjectiveAnimLineTemplate", freeLines = {}};

function GuideObjectiveTracker_FinishGlowAnim(line)
    if (line.state == "ADDING") then
        line.state = "PRESENT";
    else
        -- local questID = line.block.id;
        -- if (IsQuestSequenced(questID)) then
        --     line.FadeOutAnim:Play();
        --     line.state = "FADING";
        -- else
        line.state = "COMPLETED";
        ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
        -- end
    end
end

function GuideObjectiveTracker_FinishFadeOutAnim(line)
    local block = line.block;
    block.module:FreeLine(block, line);
    for _, otherLine in pairs(block.lines) do
        if (otherLine.state == "FADING") then
            -- some other line is still fading
            return;
        end
    end
    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
end

-- *********************************************************************************************************************
-- ***** UPDATE FUNCTIONS
-- *********************************************************************************************************************

--- @param step Step
function GUIDE_TRACKER_MODULE:ShouldDisplayStep(step)
    return step:RequiredStepsCompleted();
end

function GUIDE_TRACKER_MODULE:BuildStepWatchInfos()
    local infos = {};

    local steps = Draghos_GuideStore:GetRemainingSteps();
    for index, step in pairs(steps) do
        if step and self:ShouldDisplayStep(step) then
            table.insert(infos, {step = step, index = index});
        end
    end

    return infos;
end

function GUIDE_TRACKER_MODULE:EnumStepWatchData(func)
    local infos = self:BuildStepWatchInfos();
    for _, stepWatchInfo in ipairs(infos) do
        if func(self, stepWatchInfo.step, stepWatchInfo.index) then
            return;
        end
    end
end

-- function GUIDE_TRACKER_MODULE:ResetAnimations()
--     for _, block in pairs(GUIDE_TRACKER_MODULE.usedBlocks) do
--         local task = Draghos_GuideStore:GetStepByStepID(block.id);
--         for _, line in pairs(block.lines) do
--             local step = task.???[line.index]
--             if (step and not step:IsCompleted() and line.state == "COMPLETED") then
--                 line.state = nil;
--             end
--         end
--     end
-- end

--- @param step Step
--- @param stepIndex number
function GUIDE_TRACKER_MODULE:UpdateSingle(step, stepIndex)
    if stepIndex == 1 and step:CanAddWaypoint() and IsAddOnLoaded("TomTom") then
        TomTom:AddWaypoint(step:GetWaypointInfo());
    end

    local stepID = step.stepID;

    local block = self:GetBlock(stepID);
    block.id = stepID;

    self:SetBlockHeader(block, step:GetLabel());

    for stepIndexIndex, stepLine in pairs(step.stepLines) do
        local line;
        if (stepLine:IsCompleted()) then
            line = self:AddObjective(
                       block, stepID .. ":" .. stepIndexIndex, stepLine:GetLabel(), LINE_TYPE_ANIM, nil,
                       OBJECTIVE_DASH_STYLE_HIDE, OBJECTIVE_TRACKER_COLOR["Complete"]
                   );
            line.Check:Show();
            if (not line.state or line.state == "PRESENT") then
                line.Sheen.Anim:Play();
                line.Glow.Anim:Play();
                line.CheckFlash.Anim:Play();
                line.state = "COMPLETING";
            end
        else
            line = self:AddObjective(block, stepID .. ":" .. stepIndexIndex, stepLine:GetLabel(), LINE_TYPE_ANIM);
            line.Check:Hide();
        end

        line.block = block;
        line.index = stepIndexIndex;
    end

    local stepTypeIcon = CreateFrame("Frame", nil, block, "GuideStepTypeIconTemplate");
    stepTypeIcon:SetPoint("RIGHT", block.HeaderText, "LEFT", -2, 0);

    local stepTypeIconName = step:GetStepType();
    if stepTypeIconName and stepTypeIcon[stepTypeIconName] then
        stepTypeIcon[stepTypeIconName]:Show();
        if type(step.IsPartial) == "function" then
            local partialStepTypeIcon = CreateFrame("Frame", nil, block, "GuideStepTypeIconTemplate");
            partialStepTypeIcon:SetPoint("RIGHT", block.HeaderText, "LEFT", -2, 0);
            partialStepTypeIcon.ProgressObjective:SetShown(step:IsPartial());
            partialStepTypeIcon.CompleteObjective:SetShown(not step:IsPartial());
        end
    end

    block:SetHeight(block.height);

    if ObjectiveTracker_AddBlock(block) then
        block:Show();
        self:FreeUnusedLines(block);
    else
        block.used = false;
        return true; -- Can't add the block, we're done enumerating tasks
    end
end

function GUIDE_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)
end

function GUIDE_TRACKER_MODULE:Update()
    -- TODO: Move TomTom somewhere else
    if IsAddOnLoaded("TomTom") and TomTom then
        TomTom.waydb:ResetProfile();
        TomTom:ReloadWaypoints();
    end

    -- Update the blocks
    self:BeginLayout();
    self:EnumStepWatchData(self.UpdateSingle);
    self:EndLayout();
end
