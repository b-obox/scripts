local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()


local player = game:GetService("Players").LocalPlayer
local shop = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("CoinsShop")

local Window = Fluent:CreateWindow({
    Title = game:GetService("MarketplaceService"):GetProductInfo(109983668079237).Name .. " 〢 box",
    SubTitle = "papi fez",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rocket" }),
}

local plotName
for _, plot in ipairs(workspace.Plots:GetChildren()) do
    if plot:FindFirstChild("YourBase", true).Enabled then
        plotName = plot.Name
        break
    end
end

local remainingTime = workspace.Plots[plotName].Purchases.PlotBlock.Main.BillboardGui.RemainingTime
local rtp = Tabs.Main:AddParagraph({ Title = "Lock Time: " .. remainingTime.Text })

task.spawn(function()
    while true do
        rtp:SetTitle("Lock Time: " .. remainingTime.Text)
        task.wait(0.25)
    end
end)

local SpeedSlider = Tabs.Main:AddSlider("Slider", {
    Title = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 6,
    Rounding = 1,
})

Tabs.Main:AddParagraph({
    Title = "Use Speed Coil/Invisibility Cloak For Higher Speed",
})

local currentSpeed = 0
SpeedSlider:OnChanged(function(Value)
    currentSpeed = tonumber(Value) or 0
end)

local function sSpeed(character)
    local hum = character:WaitForChild("Humanoid")
    local hb = game:GetService("RunService").Heartbeat
    
    task.spawn(function()
        while character and hum and hum.Parent do
            if currentSpeed > 0 and hum.MoveDirection.Magnitude > 0 then
                character:TranslateBy(hum.MoveDirection * currentSpeed * hb:Wait() * 10)
            end
            task.wait()
        end
    end)
end

local function onCharacterAdded(character)
    sSpeed(character)
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    onCharacterAdded(player.Character)
end


Tabs.Main:AddButton({
    Title = "Invisible",
    Description = "Use Invisibility Cloak",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local cloak = character:FindFirstChild("Invisibility Cloak")
        if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
            cloak.Parent = workspace
        else
            Fluent:Notify({ Title = "bobox", Content = "Use Invisibility Cloak First", Duration = 4 })
        end
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Window:SelectTab(1)
Explain
