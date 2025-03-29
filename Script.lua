-- Chargement des services nécessaires
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Création du GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 600, 0, 400)
Frame.Position = UDim2.new(0.5, -300, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Ajout du menu des catégories
local Categories = Instance.new("Frame", Frame)
Categories.Size = UDim2.new(0, 150, 1, 0)
Categories.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local SellingButton = Instance.new("TextButton", Categories)
SellingButton.Size = UDim2.new(1, 0, 0, 50)
SellingButton.Text = "Selling Gui"
SellingButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

-- Add CashCounter button under the Selling button
local CashCounterButton = Instance.new("TextButton", Categories)
CashCounterButton.Size = UDim2.new(1, 0, 0, 50)
CashCounterButton.Position = UDim2.new(0, 0, 0, 50)
CashCounterButton.Text = "CashCounter"
CashCounterButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

-- Set Goal functionality
local GoalLabel = Instance.new("TextLabel", Frame)
GoalLabel.Size = UDim2.new(0, 300, 0, 50)
GoalLabel.Position = UDim2.new(0, 160, 0, 250)
GoalLabel.Text = "Goal Set: 0"
GoalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GoalLabel.TextScaled = true
GoalLabel.BackgroundTransparency = 1

local GoalTextbox = Instance.new("TextBox", Frame)
GoalTextbox.Size = UDim2.new(0, 100, 0, 50)
GoalTextbox.Position = UDim2.new(0, 160, 0, 300)
GoalTextbox.PlaceholderText = "Set Goal"
GoalTextbox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GoalTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)

local SetGoalButton = Instance.new("TextButton", Frame)
SetGoalButton.Size = UDim2.new(0, 100, 0, 50)
SetGoalButton.Position = UDim2.new(0, 270, 0, 300)
SetGoalButton.Text = "Set Goal"
SetGoalButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local currentGoal = 0

-- When SetGoalButton is clicked
SetGoalButton.MouseButton1Click:Connect(function()
    local goalValue = tonumber(GoalTextbox.Text)
    if goalValue then
        currentGoal = goalValue
        GoalLabel.Text = "Goal Set: " .. currentGoal
    else
        GoalLabel.Text = "Invalid Goal"
    end
end)

-- When CashCounter button is clicked, it runs the external script
CashCounterButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Ww1avi/Script/refs/heads/main/CashCounter.lua'))()
end)

-- Contenu principal
title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, -150, 0, 50)
title.Position = UDim2.new(0, 150, 0, 0)
title.Text = "Category"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.BackgroundTransparency = 1

local SearchBar = Instance.new("TextBox", Frame)
SearchBar.Size = UDim2.new(1, -170, 0, 40)
SearchBar.Position = UDim2.new(0, 160, 0, 60)
SearchBar.PlaceholderText = "Selling Gui"
SearchBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.Visible = false

local AvatarImage = Instance.new("ImageLabel", Frame)
AvatarImage.Size = UDim2.new(0, 100, 0, 100)
AvatarImage.Position = UDim2.new(0.05, 160, 0.3, 0)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = ""

local NameLabel = Instance.new("TextLabel", Frame)
NameLabel.Size = UDim2.new(0.6, 0, 0, 50)
NameLabel.Position = UDim2.new(0.2, 160, 0.3, 0)
NameLabel.Text = "User: "
NameLabel.TextWrapped = true
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextScaled = true

local CashLabel = Instance.new("TextLabel", Frame)
CashLabel.Size = UDim2.new(0.6, 0, 0, 50)
CashLabel.Position = UDim2.new(0.2, 160, 0.45, 0)
CashLabel.Text = "Cash: "
CashLabel.TextWrapped = true
CashLabel.BackgroundTransparency = 1
CashLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CashLabel.TextScaled = true

SellingButton.MouseButton1Click:Connect(function()
    title.Text = "Selling Gui"
    SearchBar.Visible = true
end)

local function findPlayer(name)
    name = name:lower():gsub("@", "")
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
        end
    end
    return nil
end

local function getCash(player)
    if player:FindFirstChild("leaderstats") then
        for _, stat in ipairs(player.leaderstats:GetChildren()) do
            if stat:IsA("NumberValue") and (stat.Name:lower():find("cash") or stat.Name:lower():find("money") or stat.Name:lower():find("dhc")) then
                return stat.Value
            end
        end
    end
    if player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Currency") then
        return player.DataFolder.Currency.Value
    end
    return "?"
end

SearchBar.FocusLost:Connect(function()
    local player = findPlayer(SearchBar.Text)
    if player then
        local userId = player.UserId
        AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=100&height=100&format=png"
        NameLabel.Text = "Pseudo: "..player.Name
        task.spawn(function()
            while player and player.Parent do
                local cash = getCash(player)
                CashLabel.Text = "Cash: "..cash
                if tonumber(cash) >= currentGoal then
                    -- Send notification to Discord webhook
                    local webhookUrl = "https://discord.com/api/webhooks/1348234829715734588/ntOoi_968JSCSs1HA6gBxdkqnAQSVMHyiMrs0v_NNzW7YRNb8xVnFDczt_SzlMZBj8Y1"
                    local data = {
                        content = "Goal Reached🤟"
                    }
                    HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
                end
                wait(0.5)
            end
        end)
    else
        NameLabel.Text = "Joueur non trouvé"
        CashLabel.Text = ""
        AvatarImage.Image = ""
    end
end)
