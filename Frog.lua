local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart

LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
end)

GuiService.ErrorMessageChanged:Connect(function(str)
    while wait() do
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

function Body_Noclip()
    if not HumanoidRootPart:FindFirstChild("Body Noclip") then
        local Body_Noclip = Instance.new("BodyVelocity")
        Body_Noclip.Name = "Body Noclip"
        Body_Noclip.Velocity = Vector3.new()
        Body_Noclip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        Body_Noclip.Parent = HumanoidRootPart
        return Body_Noclip
    end
end

function noclip()
    Noclipping = game:GetService('RunService').Stepped:Connect(function()
        if LocalPlayer.Character ~= nil then
            for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide then
                    child.CanCollide = false
                end
            end
        end
    end)
    return Noclipping
end

local Plot
for i=1,6 do
    local name = LocalPlayer.Name .. "'s Plot"
    Plot = game:GetService("Workspace")["Plot"..i]
    local owner = Plot.Fence.Sign.Sign.SignText.TextLabel

    if owner.Text == name then
        break
    end
end
print(Plot)

local Buttons = Plot.Buttons
local Money = LocalPlayer.leaderstats.Money
local Release = Buttons.OtherButtons.ReleaseButton.Button
local Barrie = game:GetService("Workspace").StaticObjects.ObbyDome
local ButtonData = require(game:GetService("ReplicatedStorage").ButtonData)
local Obby = game:GetService("Workspace").StaticObjects.Obby.ObbyButton.Button
local clientPickedUpFrog = game:GetService("ReplicatedStorage").RemoteEvents.clientPickedUpFrog

local keys = {}
local data = {}
for _, group in pairs(Buttons:GetChildren()) do
    if group.Name ~= "OtherButtons" then
        for _, button in pairs(group:GetChildren()) do
            if button.Name ~= "Plate" and button.Transparency == 0 then
                cost = ButtonData[button.Name]["cost"]
                table.insert(keys, cost)
                data[cost] = button
            end
        end
    end
end
table.sort(keys)


local cost
local focus = 1
local len_key = #keys
local nc = noclip()
local bv = Body_Noclip()

if focus > len_key then
    cost = math.huge
else
    cost = keys[focus]
end
while true do
    repeat wait()
        for i,v in pairs(Plot.SpawnedFrogs:GetChildren()) do
            pcall(function()
                if v.Parent then
                    local tar = CFrame.new(v.Position) + Vector3.new(0,2,0)
                    if tar.Position.Y > 6 then
                        return
                    end
                    local time = (tar.Position - HumanoidRootPart.Position).Magnitude / 14
                    local tw = TweenService:Create(
                        HumanoidRootPart,
                        TweenInfo.new(
                            time,
                            Enum.EasingStyle.Linear
                        ),
                        {
                            ["CFrame"] = (tar)
                        }
                    )
                    tw:Play()
                    task.wait(time)
                end
            end)
            task.wait()
        end
    until Barrie.Transparency == 1
    nc:Disconnect()
    bv:Destroy()
    repeat
        HumanoidRootPart.CFrame = Obby.CFrame * CFrame.new(0,5,0)
        wait(1)
    until Barrie.Transparency ~= 1
    HumanoidRootPart.CFrame = Release.CFrame * CFrame.new(0,5,0)
    wait(2)
    while Money.Value >= cost do
        repeat
            HumanoidRootPart.CFrame = data[keys[focus]].CFrame * CFrame.new(0,5,0)
            wait(1.5)
        until data[keys[focus]].Transparency ~= 0 or Money.Value < cost
        focus = focus + 1
        if focus > len_key then
            cost = math.huge
        else
            cost = keys[focus]
        end
    end
    HumanoidRootPart.CFrame = Release.CFrame * CFrame.new(0,5,0)
    wait(1)
    nc = noclip()
    bv = Body_Noclip()
end
