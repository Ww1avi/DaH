local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "CustomUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = true
MainFrame.ClipsDescendants = true

-- Make GUI Draggable (Old Method)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Sidebar
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Tab Button Function
local function createTabButton(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.Text = name
    Button.Parent = Sidebar
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button

    return Button
end

local MainTabButton = createTabButton("Main")
local SellingTabButton = createTabButton("Selling") -- Changed name from Settings to Selling

-- Main Tab
local MainTab = Instance.new("Frame")
MainTab.Size = UDim2.new(1, -120, 1, -40)
MainTab.Position = UDim2.new(0, 120, 0, 40)
MainTab.BackgroundTransparency = 1
MainTab.Parent = MainFrame
MainTab.Visible = true

-- Open CashCounter Button
local CashCounterButton = Instance.new("TextButton")
CashCounterButton.Size = UDim2.new(0.9, 0, 0, 40)
CashCounterButton.Position = UDim2.new(0.05, 0, 0.1, 0)
CashCounterButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CashCounterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CashCounterButton.Font = Enum.Font.Gotham
CashCounterButton.TextSize = 16
CashCounterButton.Text = "Open CashCounter"
CashCounterButton.Parent = MainTab

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = CashCounterButton

CashCounterButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Ww1avi/Script/refs/heads/main/CashCounter.lua'))()
end)

-- Selling Tab
local SellingTab = Instance.new("Frame")
SellingTab.Size = UDim2.new(1, -120, 1, -40)
SellingTab.Position = UDim2.new(0, 120, 0, 40)
SellingTab.BackgroundTransparency = 1
SellingTab.Parent = MainFrame
SellingTab.Visible = false

-- Open Selling-Gui Button
local SellingGuiButton = Instance.new("TextButton")
SellingGuiButton.Size = UDim2.new(0.9, 0, 0, 40)
SellingGuiButton.Position = UDim2.new(0.05, 0, 0.1, 0)
SellingGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SellingGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SellingGuiButton.Font = Enum.Font.Gotham
SellingGuiButton.TextSize = 16
SellingGuiButton.Text = "Open Selling-Gui"
SellingGuiButton.Parent = SellingTab

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = SellingGuiButton

SellingGuiButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Ww1avi/Script/refs/heads/main/Selling.lua'))()
end)

-- Tab Switching Logic
MainTabButton.MouseButton1Click:Connect(function()
    MainTab.Visible = true
    SellingTab.Visible = false
end)

SellingTabButton.MouseButton1Click:Connect(function()
    MainTab.Visible = false
    SellingTab.Visible = true
end)

-- Open/Close Animation
local Open = false
local function ToggleUI()
    if Open then
        local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 0)})
        Tween:Play()
        Tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    else
        MainFrame.Visible = true
        local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 350)})
        Tween:Play()
    end
    Open = not Open
end

-- Toggle Keybind
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        ToggleUI()
    end
end)

-- Proper Dragging Script (New Method)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initial Open Animation
wait(0.1)
ToggleUI()
