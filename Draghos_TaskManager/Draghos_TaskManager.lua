-- *********************************************************************************************************************
-- ***** MAIN FRAME
-- *********************************************************************************************************************
UIPanelWindows["TaskManagerFrame"] = {area = "left", pushable = 1, whileDead = 1, width = 666, height = 488};

local STRIPE_COLOR = {r = 0.9, g = 0.9, b = 1};
local STEP_TITLE_HEIGHT = 22;

TaskManagerMixin = {};

function TaskManagerFrame_Toggle()
    if (not TaskManagerFrame:IsShown()) then
        ShowUIPanel(TaskManagerFrame);
    else
        HideUIPanel(TaskManagerFrame);
    end
end

function TaskManagerMixin:OnLoad()
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function TaskManagerMixin:OnShow()
    PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
end

function TaskManagerMixin:OnHide()
    PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
end

function TaskManagerMixin:OnEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD");

        -- Initialize portrait texture
        self:SetPortraitToAsset("Interface\\Icons\\inv_misc_scrollunrolled03");

        -- Set the title
        self:SetTitle(TASK_MANAGER_TITLE);

        -- Title of the "Steps" groupbox
        self.StepsGroupBox.Title:SetText(TASK_MANAGER_STEPS_GROUPBOX_TITLE);

        -- Setup tabs
        ButtonFrameTemplate_HideButtonBar(self);

        -- Setup form
        TaskManagerFrame_InitializeForm();

        -- Setup scroll list
        TaskManagerFrame_InitializeSummaryList();

        -- Function called when the task store is updated
        Draghos_TaskLog:Subscribe(
            function(objectType, ...)
                if objectType == TaskMixin then
                    TaskManagerFrame.SummaryList:RefreshScrollFrame();
                    TaskManagerFrame_OnSummaryLineSelectedChanged();
                elseif objectType == StepMixin then
                    TaskManagerFrame.SummaryList:RefreshScrollFrame();
                    local taskID, stepIndex, changes = ...;
                    if #changes == 1 and changes[1] == "lastCompleted" then
                        -- Avoid updating the whole form when the event comes from another event
                        TaskManagerFrame.StepsGroupBox.StepsScrollFrame:UpdateStep(taskID, stepIndex);
                    else
                        -- Otherwise we can refresh the form
                        TaskManagerFrame_OnSummaryLineSelectedChanged();
                    end
                end
            end
        );
    end
end

-- *********************************************************************************************************************
-- ***** SCROLL
-- *********************************************************************************************************************

TaskManagerFrameSummaryListMixin = {};

function TaskManagerFrame_SelectTask(taskID)
    if not TaskManagerFrame:IsShown() then
        TaskManagerFrame_Toggle();
    end
    local index = Draghos_TaskLog:GetTaskIndexByTaskID(taskID);
    if index then
        TaskManagerFrame.SummaryList:SetSelectedListIndex(index);
    end
end

local function GetTaskFromListIndex(listIndex)
    local task = Draghos_TaskLog:GetTaskForTaskLogIndex(listIndex);
    if task then
        return task;
    end

    return nil;
end

function TaskManagerFrame_OnSummaryLineSelectedChanged(listIndex)
    if not listIndex then
        listIndex = TaskManagerFrame.SummaryList:GetSelectedListIndex();
    end
    local task = GetTaskFromListIndex(listIndex);
    TaskManagerFrame_SetFormData(task);
end

local function GetNumResultsFunction()
    return Draghos_TaskLog:GetNumTaskLog() + 1;
end

function TaskManagerFrame_InitializeSummaryList()
    TaskManagerFrame.SummaryList:SetGetNumResultsFunction(GetNumResultsFunction);
    TaskManagerFrame.SummaryList:SetSelectionCallback(TaskManagerFrame_OnSummaryLineSelectedChanged);
    TaskManagerFrame.SummaryList:SetLineTemplate("TaskManagerSummaryLineTemplate", TaskManagerFrame);

    TaskManagerFrame.SummaryList:SetSelectedListIndex(1);
end

function TaskManagerFrameSummaryListMixin:OnLoad()
    self.InsetFrame:Hide();

    local selectedHighlight = self:GetSelectedHighlight();
    selectedHighlight:SetAtlas("auctionhouse-ui-row-select", true);
    selectedHighlight:SetBlendMode("ADD");
    selectedHighlight:SetAlpha(0.8);
end

TaskManagerSummaryLineMixin = {};

function TaskManagerSummaryLineMixin:OnLoad()
end

function TaskManagerSummaryLineMixin:InitLine(taskManagerFrame)
    self.taskManagerFrame = taskManagerFrame;
end

function TaskManagerSummaryLineMixin:UpdateDisplay()
    local task = GetTaskFromListIndex(self:GetListIndex());
    if task then
        self.Icon:SetShown(false);
        self.Text:SetText(task.title);
        self.Text:SetPoint("LEFT", 8, 0);
        if not task.isActive then
            self.Text:SetFontObject("GameFontDisable");
        elseif task:IsCompleted() then
            self.Text:SetFontObject("GameFontGreen");
        else
            self.Text:SetFontObject("GameFontNormal");
        end
    else
        self.Icon:SetShown(true);
        self.Icon:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus");
        self.Text:SetText(TASKLOG_ADD_NEW_TASK);
        self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 4, 0);
        self.Text:SetFontObject("GameFontWhite");
    end
end

function TaskManagerSummaryLineMixin:OnSelected()
end

function TaskManagerSummaryLineMixin:OnEnter()
    -- Show tooltip
end

function TaskManagerSummaryLineMixin:OnLeave()
    -- Hide tooltip
end

-- *********************************************************************************************************************
-- ***** MAIN FORM
-- *********************************************************************************************************************

local function SelectRepeatValue(self)
    UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, self.value);
    TaskManagerFrame_UpdateFormStatus();
end

local function InitializeRepeatDropDown()
    local selectedValue = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.RepeatDropDown);
    local info = UIDropDownMenu_CreateInfo();

    info.func = SelectRepeatValue;

    for key, value in pairs(TaskRepeats) do
        info.text = value.Label;
        info.value = key;
        info.checked = selectedValue == info.value;
        UIDropDownMenu_AddButton(info);
    end

    if selectedValue and TaskRepeats[selectedValue] then
        UIDropDownMenu_SetText(TaskManagerFrame.RepeatDropDown, TaskRepeats[selectedValue].Label);
    end
end

function TaskManagerFrame_InitializeForm()
    UIDropDownMenu_Initialize(TaskManagerFrame.RepeatDropDown, InitializeRepeatDropDown);
end

--- @return Task
local function GetFormTask()
    local task = {
        taskID = TaskManagerFrame.taskID,
        title = TaskManagerFrame.TitleEditBox:GetText(),
        isActive = TaskManagerFrame.ActivateCheckButton:GetChecked(),
        repeating = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.RepeatDropDown),
        steps = TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps
    };
    return CreateAndInitFromMixin(TaskMixin, task);
end

--- @param task Task|nil
function TaskManagerFrame_SetFormData(task)
    if task then
        TaskManagerFrame.taskID = task.taskID;
        TaskManagerFrame.TitleEditBox:SetText(task.title);
        TaskManagerFrame.ActivateCheckButton:SetChecked(task.isActive);
        UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, task.repeating);
        TaskManagerFrame.RemoveButton:Show();
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps = task:GetSteps();
    else
        TaskManagerFrame.taskID = nil;
        TaskManagerFrame.TitleEditBox:SetText("");
        TaskManagerFrame.ActivateCheckButton:SetChecked(true);
        UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, TASK_REPEAT_NEVER);
        TaskManagerFrame.RemoveButton:Hide();
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps = {};
    end
    TaskManagerFrame_UpdateFormStatus();
    TaskManagerFrame_InitializeForm();
    TaskManagerFrameSteps_UpdateScrollFrame();
end

function TaskManagerFrame_UpdateFormStatus()
    local newTask = GetFormTask();
    if not newTask:IsValid() or not newTask:IsModified() then
        TaskManagerFrame.SaveButton:Disable();
    else
        TaskManagerFrame.SaveButton:Enable();
    end
end

TaskManagerFormMixin = {};

function TaskManagerFormMixin:UpdateFormStatus()
    TaskManagerFrame_UpdateFormStatus();
end

TaskManagerStepsScrollFrameMixin = {};

function TaskManagerFrameSteps_UpdateScrollFrame()
    local scrollFrame = TaskManagerFrame.StepsGroupBox.StepsScrollFrame;
    local buttons = scrollFrame.buttons;
    local steps = scrollFrame.steps;
    local numButtons = #buttons;
    local scrollOffset = HybridScrollFrame_GetOffset(scrollFrame);
    local step, stepIndex;
    for i = 1, numButtons do
        stepIndex = i + scrollOffset;
        step = steps[stepIndex];
        if (step) then
            buttons[i]:Show();
            buttons[i].text:SetText(step:GetSummary());
            buttons[i].stepIndex = stepIndex;

            buttons[i].Check:SetChecked(step:IsCompleted());
            buttons[i].Check:EnableMouse(step:IsManual());

            if (scrollFrame.selected == stepIndex) then
                buttons[i].SelectedBar:Show();
            else
                buttons[i].SelectedBar:Hide();
            end

            if ((i + scrollOffset) == 1) then
                buttons[i].BgTop:Show();
                buttons[i].BgMiddle:SetPoint("TOP", buttons[i].BgTop, "BOTTOM");
            else
                buttons[i].BgTop:Hide();
                buttons[i].BgMiddle:SetPoint("TOP");
            end

            if ((i + scrollOffset) == #steps) then
                buttons[i].BgBottom:Show();
                buttons[i].BgMiddle:SetPoint("BOTTOM", buttons[i].BgBottom, "TOP");
            else
                buttons[i].BgBottom:Hide();
                buttons[i].BgMiddle:SetPoint("BOTTOM");
            end

            if ((i + scrollOffset) % 2 == 0) then
                buttons[i].Stripe:SetColorTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b);
                buttons[i].Stripe:SetAlpha(0.1);
                buttons[i].Stripe:Show();
            else
                buttons[i].Stripe:Hide();
            end
        else
            buttons[i]:Hide();
        end
    end
end

function TaskManagerFrameSteps_SelectStep(button)
    TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = button.stepIndex;
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    TaskManagerFrameSteps_UpdateScrollFrame();
end

function TaskManagerFrameSteps_ToggleCompleted(button)
    local step = TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps[button:GetParent().stepIndex];
    if step then
        step:ToggleCompleted();
        TaskManagerFrame_UpdateFormStatus();
    end
end

function TaskManagerStepsScrollFrameMixin:OnLoad()
    HybridScrollFrame_OnLoad(self);
    self.update = TaskManagerFrameSteps_UpdateScrollFrame;
    HybridScrollFrame_CreateButtons(self, "StepButtonTemplate", 2, -4);
end

function TaskManagerStepsScrollFrameMixin:Update()
    local scrollFrame = TaskManagerFrame.StepsGroupBox.StepsScrollFrame;

    HybridScrollFrame_Update(scrollFrame, #scrollFrame.steps * STEP_TITLE_HEIGHT + 20, scrollFrame:GetHeight());
    TaskManagerFrameSteps_UpdateScrollFrame();
end

function TaskManagerStepsScrollFrameMixin:UpdateStep(taskID, stepIndex)
    local step = TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps[stepIndex];
    local storedStep = Draghos_TaskLog:GetStep(taskID, stepIndex);
    if step and step.taskID == taskID and storedStep then
        step.lastCompleted = storedStep.lastCompleted;
        local buttons = self.buttons;
        local numButtons = #buttons;
        for i = 1, numButtons do
            if buttons[i].stepIndex == stepIndex then
                buttons[i].Check:SetChecked(storedStep:IsCompleted());
                return;
            end
        end
    end
end

TaskManagerAddStepButtonMixin = {};

function TaskManagerAddStepButtonMixin:OnClick()
    TaskManagerFrame.StepModalDialog.stepIndex = self.stepIndex;
    TaskManagerFrame.StepModalDialog:Show();
end

TaskManagerSaveButtonMixin = {};

function TaskManagerSaveButtonMixin:OnLoad()
    self:Disable();
end

function TaskManagerSaveButtonMixin:OnClick()
    local newTask = GetFormTask();
    if newTask:IsValid() then
        newTask:Save();
    end
end

TaskManagerRemoveButtonMixin = {};

function TaskManagerRemoveButtonMixin:OnLoad()
    self:Hide();
end

function TaskManagerRemoveButtonMixin:OnClick()
    if TaskManagerFrame.taskID then
        Draghos_TaskLog:RemoveTaskByID(TaskManagerFrame.taskID);
    end
end

-- *********************************************************************************************************************
-- ***** STEP MODAL
-- *********************************************************************************************************************

local function SelectStepType(self)
    UIDropDownMenu_SetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown, self.value);
    TaskManagerFrame.StepModalDialog:UpdateLayout();
end

local function InitializeStepTypeDropDown()
    local selectedValue = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown);
    local info = UIDropDownMenu_CreateInfo();

    info.func = SelectStepType;

    for key, value in pairs(StepTypes) do
        info.text = value.Label;
        info.value = key;
        info.checked = selectedValue == info.value;
        UIDropDownMenu_AddButton(info);
    end
end

--- @return Step
local function GetFormStep()
    local step = {
        taskID = TaskManagerFrame.taskID,
        type = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown),
        label = TaskManagerFrame.StepModalDialog.ManualStep.StepEditBox:GetText()
    }
    return CreateAndInitFromMixin(StepMixin, step);
end

TaskManagerStepModalDialogMixin = {};

function TaskManagerStepModalDialogMixin:OnLoad()
    UIDropDownMenu_Initialize(TaskManagerFrame.StepModalDialog.StepTypeDropDown, InitializeStepTypeDropDown);
end

function TaskManagerStepModalDialogMixin:OnShow()
    TaskManagerFrame.Overlay:Show();
    TaskManagerFrame.StepModalDialog.AcceptButton:Disable();
end

function TaskManagerStepModalDialogMixin:UpdateLayout()
    local selectedType = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown);

    if selectedType == STEP_TYPE_MANUAL then
        TaskManagerFrame.StepModalDialog.ManualStep:Show();
    end
end

function TaskManagerStepModalDialogMixin:UpdateFormStatus()
    local newStep = GetFormStep();
    if not newStep:IsValid() then
        TaskManagerFrame.StepModalDialog.AcceptButton:Disable();
    else
        TaskManagerFrame.StepModalDialog.AcceptButton:Enable();
    end
end

function TaskManagerStepModalDialogMixin:Hide()
    -- Hide frame
    TaskManagerFrame.StepModalDialog:SetShown(false);
    TaskManagerFrame.Overlay:Hide();

    -- Hide layout
    TaskManagerFrame.StepModalDialog.ManualStep:Hide();

    -- Clear data
    UIDropDownMenu_SetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown, 0);
    TaskManagerFrame.StepModalDialog.ManualStep.StepEditBox:SetText("");
end

function TaskManagerStepModalDialogMixin:Accept()
    local task = GetFormTask();
    local newStep = GetFormStep();
    local index = self.index or #task.steps + 1;
    table.insert(task.steps, index, newStep);
    TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = index;

    TaskManagerFrame_SetFormData(task);

    self.index = nil;

    self:Hide();
end
