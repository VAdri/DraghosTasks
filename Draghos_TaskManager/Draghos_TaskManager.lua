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

function TaskManagerFrame_InitializeForm()
end

--- @return Task
local function GetFormTask()
    local task = {
        taskID = TaskManagerFrame.taskID,
        title = TaskManagerFrame.TitleEditBox:GetText(),
        isActive = TaskManagerFrame.ActivateCheckButton:GetChecked(),
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
        TaskManagerFrame.RemoveButton:Show();
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = nil;
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps = task:GetSteps();
    else
        TaskManagerFrame.taskID = nil;
        TaskManagerFrame.TitleEditBox:SetText("");
        TaskManagerFrame.ActivateCheckButton:SetChecked(true);
        TaskManagerFrame.RemoveButton:Hide();
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = nil;
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps = {};
    end
    TaskManagerFrame_UpdateFormStatus();
    TaskManagerFrame_InitializeForm();
    TaskManagerFrame.StepsGroupBox.StepsScrollFrame:Update();
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

    if (scrollFrame.selected) then
        TaskManagerFrame.ModifyStepButton:Enable();
    else
        TaskManagerFrame.ModifyStepButton:Disable();
    end
end

function TaskManagerFrameSteps_SelectStep(button)
    TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = button.stepIndex;
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
    TaskManagerFrame.StepsGroupBox.StepsScrollFrame:Update();
end

function TaskManagerFrameSteps_ToggleCompleted(button)
    local stepIndex = button:GetParent().stepIndex;
    local step = stepIndex and TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps[stepIndex];
    if step then
        step:ToggleCompleted();
        TaskManagerFrame_UpdateFormStatus();
    end
end

function TaskManagerFrameSteps_RemoveStep(button)
    local stepIndex = button:GetParent().stepIndex;
    local step = stepIndex and TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps[stepIndex];
    if step then
        table.remove(TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps, stepIndex);
        TaskManagerFrame_UpdateFormStatus();
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame:Update();
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

TaskManagerModifyStepButtonMixin = {};

function TaskManagerModifyStepButtonMixin:OnClick()
    TaskManagerFrame.StepModalDialog.stepIndex = TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected;
    TaskManagerFrame.StepModalDialog:Show();
end

TaskManagerAddStepButtonMixin = {};

function TaskManagerAddStepButtonMixin:OnClick()
    TaskManagerFrame.StepModalDialog.stepIndex = #TaskManagerFrame.StepsGroupBox.StepsScrollFrame.steps + 1;
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
    CloseDropDownMenus();
end

local function InitializeStepTypeDropDown(self, level, menuList)
    local selectedValue = UIDropDownMenu_GetSelectedValue(self);
    local info = UIDropDownMenu_CreateInfo();

    if level == 1 then
        for key, value in pairs(StepTypes) do
            if not value.Group then
                info.text = value.Label;
                info.value = key;
                info.notCheckable = nil;
                info.hasArrow = false;
                info.menuList = nil;
                info.func = SelectStepType;
                info.checked = selectedValue == info.value;
                UIDropDownMenu_AddButton(info, 1);
            else
                info.text = value.Group;
                info.value = value.Group;
                info.notCheckable = 1;
                info.hasArrow = true;
                info.menuList = value.Group;
                info.func = nil;
                info.checked = false;
                UIDropDownMenu_AddButton(info, 1);
            end
        end
    elseif level == 2 and menuList then
        local function IsInGroup(stepType)
            return stepType.Group == menuList;
        end
        local stepTypes = FilterIndexed(StepTypes, IsInGroup);
        for key, value in pairs(stepTypes) do
            info.text = value.Label;
            info.value = key;
            info.func = SelectStepType;
            info.checked = selectedValue == info.value;
            UIDropDownMenu_AddButton(info, 2);
        end
    end
end

--- @return Step|nil
local function GetFormStep()
    local stepType = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown);
    if stepType == STEP_TYPE_MANUAL then
        local step = {
            taskID = TaskManagerFrame.taskID,
            type = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown),
            label = TaskManagerFrame.StepModalDialog.ManualStep.StepEditBox:GetText()
        }
        return CreateAndInitFromMixin(StepMixin, step);
    elseif stepType == STEP_TYPE_QUEST_PICKUP then
        local step = {
            taskID = TaskManagerFrame.taskID,
            type = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown),
            questID = TaskManagerFrame.StepModalDialog.QuestPickUpStep.QuestIDPicker.EditBox:GetText()
        }
        return CreateAndInitFromMixin(StepMixin, step);
    else
        return nil;
    end
end

TaskManagerStepModalDialogMixin = {};

function TaskManagerStepModalDialogMixin:OnLoad()
    UIDropDownMenu_Initialize(TaskManagerFrame.StepModalDialog.StepTypeDropDown, InitializeStepTypeDropDown);
end

function TaskManagerStepModalDialogMixin:OnShow()
    TaskManagerFrame.Overlay:Show();
    TaskManagerFrame.StepModalDialog.AcceptButton:Disable();
    self:SetFormData();
end

function TaskManagerStepModalDialogMixin:UpdateLayout()
    local selectedType = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown);

    TaskManagerFrame.StepModalDialog.ManualStep:Hide();
    TaskManagerFrame.StepModalDialog.QuestPickUpStep:Hide();

    if selectedType == STEP_TYPE_MANUAL then
        TaskManagerFrame.StepModalDialog.ManualStep:Show();
    elseif selectedType == STEP_TYPE_QUEST_PICKUP then
        TaskManagerFrame.StepModalDialog.QuestPickUpStep:Show();
    end
end

function TaskManagerStepModalDialogMixin:SetFormData()
    local task = GetFormTask();
    local step = task.steps[self.stepIndex];
    if step then
        UIDropDownMenu_SetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown, step.type);
        UIDropDownMenu_SetText(TaskManagerFrame.StepModalDialog.StepTypeDropDown, StepTypes[step.type].Label);
        if step.type == STEP_TYPE_MANUAL then
            TaskManagerFrame.StepModalDialog.ManualStep.StepEditBox:SetText(step.label);
        end
        self:UpdateLayout();
    end
end

function TaskManagerStepModalDialogMixin:UpdateFormStatus()
    local newStep = GetFormStep();
    if not newStep or not newStep:IsValid() then
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
    TaskManagerFrame.StepModalDialog.QuestPickUpStep:Hide();

    -- Clear data
    UIDropDownMenu_SetSelectedValue(TaskManagerFrame.StepModalDialog.StepTypeDropDown, 0);
    TaskManagerFrame.StepModalDialog.ManualStep.StepEditBox:SetText("");
    TaskManagerFrame.StepModalDialog.QuestPickUpStep.QuestIDPicker.EditBox:SetText("");
end

function TaskManagerStepModalDialogMixin:Accept()
    local stepIndex = self:GetParent().stepIndex;
    if stepIndex then
        local task = GetFormTask();
        local newStep = GetFormStep();
        task.steps[stepIndex] = newStep;
        TaskManagerFrame.StepsGroupBox.StepsScrollFrame.selected = stepIndex;

        TaskManagerFrame_SetFormData(task);

        self:GetParent().stepIndex = nil;

        self:Hide();
    end
end

QuestIDEditBoxMixin = {};

function QuestIDEditBoxMixin:OnShow()
    -- self:RegisterEvent("QUEST_DATA_LOAD_RESULT");
    self:RegisterEvent("QUEST_LOG_UPDATE");
end

function QuestIDEditBoxMixin:OnHide()
    -- self:UnregisterEvent("QUEST_DATA_LOAD_RESULT");
    self:UnregisterEvent("QUEST_LOG_UPDATE");
end

function QuestIDEditBoxMixin:OnEvent()
    self:OnTextChanged();
end

function QuestIDEditBoxMixin:OnTextChanged()
    local step = GetFormStep();
    self:GetParent().Title:SetText(step and step:GetLabel() or "");
    TaskManagerFrame.StepModalDialog:UpdateFormStatus();
end
