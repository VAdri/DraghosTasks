local FP = DraghosUtils.FP;

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

local function UpdateGuideObjectiveTracker()
    GUIDE_TRACKER_MODULE:ResetAnimations();
    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
end

function GuideObjectiveTrackerInitialize(self)
    if self.initialized or not ObjectiveTrackerFrame.initialized then
        return;
    end

    GUIDE_TRACKER_MODULE.header = CreateFrame(
                                      "Frame", "ObjectiveTrackerBlocksFrame.GuideHeader",
                                      ObjectiveTrackerFrame.BlocksFrame, "ObjectiveTrackerHeaderTemplate"
                                  );

    GUIDE_TRACKER_MODULE:SetHeader(GUIDE_TRACKER_MODULE.header, TRACKER_HEADER_GUIDE, OBJECTIVE_TRACKER_UPDATE_REASON);

    table.insert(ObjectiveTrackerFrame.MODULES, GUIDE_TRACKER_MODULE);
    table.insert(ObjectiveTrackerFrame.MODULES_UI_ORDER, GUIDE_TRACKER_MODULE);

    UpdateGuideObjectiveTracker();

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
        UpdateGuideObjectiveTracker();
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
    UpdateGuideObjectiveTracker();
end

-- *********************************************************************************************************************
-- ***** STYLING
-- *********************************************************************************************************************

local white = WHITE_FONT_COLOR;
local lightgray = CreateColor(0.8, 0.8, 0.8);
local gray = LIGHTGRAY_FONT_COLOR;
local darkgray = DISABLED_FONT_COLOR;

OBJECTIVE_TRACKER_COLOR["PartialHeader"] = {r = lightgray.r, g = lightgray.g, b = lightgray.b};
OBJECTIVE_TRACKER_COLOR["PartialHeaderHighlight"] = {r = white.r, g = white.g, b = white.b};
OBJECTIVE_TRACKER_COLOR["PartialHeader"].reverse = OBJECTIVE_TRACKER_COLOR["PartialHeaderHighlight"];
OBJECTIVE_TRACKER_COLOR["PartialHeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["PartialHeader"];

OBJECTIVE_TRACKER_COLOR["Partial"] = {r = darkgray.r, g = darkgray.g, b = darkgray.b};
OBJECTIVE_TRACKER_COLOR["PartialHighlight"] = {r = gray.r, g = gray.g, b = gray.b};
OBJECTIVE_TRACKER_COLOR["Partial"].reverse = OBJECTIVE_TRACKER_COLOR["PartialHighlight"];
OBJECTIVE_TRACKER_COLOR["PartialHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Partial"];

--- @param block table
--- @param step Step
function GUIDE_TRACKER_MODULE:SetBlockHeader(block, step)
    if step.questID and step:CanUseItem() then
        -- Display the item button (if necessary)
        local questLogIndex = step:GetQuestLogIndex();
        local isQuestComplete = step:IsQuestCompleted();

        QuestObjective_SetupHeader(block);

        local hasItem = QuestObjectiveSetupBlockButton_Item(block, questLogIndex, isQuestComplete);

        -- Special case for previous behavior...if there are no buttons then use default line width from module
        if not (hasItem) then
            block.lineWidth = nil;
        end
    end

    local color;
    if step.IsPartial and step:IsPartial() then
        -- Partial steps are grayed out
        color = OBJECTIVE_TRACKER_COLOR["PartialHeader"];
    else
        color = OBJECTIVE_TRACKER_COLOR["Header"];
    end

    -- Set the text
    block.HeaderText:SetWidth(block.lineWidth or OBJECTIVE_TRACKER_TEXT_WIDTH);
    local height = self:SetStringText(block.HeaderText, step:GetLabel(), nil, color);
    block.height = height;
end

local DefaultOnBlockHeaderEnter = DEFAULT_OBJECTIVE_TRACKER_MODULE.OnBlockHeaderEnter;
function GUIDE_TRACKER_MODULE:OnBlockHeaderEnter(block)
    -- Save the current color before using the default handler because it will erase it
    local headerColorStyle = block.HeaderText.colorStyle;
    DefaultOnBlockHeaderEnter(self, block);

    -- Show the highlight color
    if (block.HeaderText and block.step and block.step.IsPartial and block.step:IsPartial()) then
        local reverseColorStyle = headerColorStyle.reverse or headerColorStyle;
        block.HeaderText:SetTextColor(reverseColorStyle.r, reverseColorStyle.g, reverseColorStyle.b);
    end
    block.HeaderText.colorStyle = headerColorStyle;
end

local DefaultOnBlockHeaderLeave = DEFAULT_OBJECTIVE_TRACKER_MODULE.OnBlockHeaderLeave;
function GUIDE_TRACKER_MODULE:OnBlockHeaderLeave(block)
    -- Save the current color before using the default handler because it will erase it
    local headerColorStyle = block.HeaderText.colorStyle;
    DefaultOnBlockHeaderLeave(self, block)

    -- Show the normal color
    if (block.HeaderText and block.step and block.step.IsPartial and block.step:IsPartial()) then
        block.HeaderText:SetTextColor(headerColorStyle.r, headerColorStyle.g, headerColorStyle.b);
    end
    block.HeaderText.colorStyle = headerColorStyle;
end

-- *********************************************************************************************************************
-- ***** UPDATE FUNCTIONS
-- *********************************************************************************************************************

--- @param step Step
function GUIDE_TRACKER_MODULE:ShouldDisplayStep(step)
    return step:IsAvailable();
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

function GUIDE_TRACKER_MODULE:ResetAnimations()
    for _, block in pairs(GUIDE_TRACKER_MODULE.usedBlocks) do
        for _, line in pairs(block.lines) do
            local stepLine = line.stepLine;
            if (stepLine and not stepLine:IsCompleted() and line.state == "COMPLETED") then
                line.state = nil;
            end
        end
    end
end

--- @param step Step
--- @param stepIndex number
function GUIDE_TRACKER_MODULE:UpdateSingle(step, stepIndex)
    local stepID = step.stepID;

    local block = self:GetBlock(stepID);
    block.id = stepID;
    block.step = step;

    self:SetBlockHeader(block, step);

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
            line = self:AddObjective(
                       block, stepID .. ":" .. stepIndexIndex, stepLine:GetLabel(), LINE_TYPE_ANIM, nil,
                       OBJECTIVE_DASH_STYLE_SHOW,
                       step.IsPartial and step:IsPartial() and OBJECTIVE_TRACKER_COLOR["Partial"] or nil
                   );
            line.Check:Hide();
        end

        line.block = block;
        line.index = stepIndexIndex;
        line.stepLine = stepLine;
    end

    block:SetHeight(block.height);

    if ObjectiveTracker_AddBlock(block) then
        block:Show();
        self:FreeUnusedLines(block);

        -- Watch modifications on the step and stepLines
        block.step:Watch(self, UpdateGuideObjectiveTracker);
        for _, usedLine in pairs(block.lines or {}) do
            usedLine.stepLine:Watch(self, UpdateGuideObjectiveTracker);
        end

        -- Show the icon
        local stepTypeIconName = step:GetStepType();
        if stepTypeIconName then
            GuideObjective_SetupHeader(block);
            GuideObjectiveBlock_AddLeftIcon(block, stepTypeIconName)
            if block.leftIcon and block.leftIcon:IsShown() then
                if type(step.IsPartial) == "function" then
                    block.leftIcon.ProgressObjective:SetShown(step:IsPartial());
                    block.leftIcon.CompleteObjective:SetShown(not step:IsPartial());
                else
                    block.leftIcon.ProgressObjective:Hide();
                    block.leftIcon.CompleteObjective:Hide();
                end
            end
        end
    else
        block.used = false;
        return true; -- Can't add the block, we're done enumerating tasks
    end
end

function GUIDE_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)
    -- TODO
end

function GUIDE_TRACKER_MODULE:ClearBlockData(block)
    -- Hide icon
    GuideObjectiveBlock_ReleaseLeftIcon(block);

    -- Unwatch steps
    block.step:Unwatch(self);
    for _, line in pairs(block.lines or {}) do
        line.stepLine:Unwatch(self);
    end
end

function GUIDE_TRACKER_MODULE:OnFreeBlock(block)
    self:ClearBlockData(block);
end

function GUIDE_TRACKER_MODULE:Update()
    -- Clear
    for _, block in pairs(self.usedBlocks) do
        self:ClearBlockData(block);
    end
    local previouslyDisplayedIDs = FP:MapProp(self.usedBlocks, "id");
    self.wapypointStepIndex = 1;

    -- Update the blocks
    self:BeginLayout();
    self:EnumStepWatchData(self.UpdateSingle);
    self:EndLayout();

    -- Show animation if the steps have changed
    local displayedIDs = FP:MapProp(self.usedBlocks, "id");
    if #FP:XOR(previouslyDisplayedIDs, displayedIDs) > 0 then
        if (not GUIDE_TRACKER_MODULE.header.animating) then
            GUIDE_TRACKER_MODULE.header.animating = true;
            GUIDE_TRACKER_MODULE.header.HeaderOpenAnim:Stop();
            GUIDE_TRACKER_MODULE.header.HeaderOpenAnim:Play();
        end
    end
end
