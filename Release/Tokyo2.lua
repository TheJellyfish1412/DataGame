local RunService = game:GetService('RunService')
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
-- 15015165959

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
    Noclipping = RunService.Stepped:Connect(function()
        if LocalPlayer.Character ~= nil then
            for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide then
                    child.CanCollide = false
                end
            end
            -- HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(36), 0)
        end
    end)
    return Noclipping
end

local num = LocalPlayer.PlayerGui.MainGui.Right.FrameUR.Money.BG.BK.Money
local target = 800 + tonumber(num.Text)
local ti = tick()
local nc = noclip()
local bv = Body_Noclip()

LocalPlayer.Character.Humanoid.PlatformStand = true
LocalPlayer.Character.LowerTorso:Destroy()

while tonumber(num.Text) <= target do
    local select
    local dis
    for i,v in pairs(game:GetService("Workspace").Coins:GetChildren()) do
        if v.Transparency == 0 then
            local temp = (v.Position - HumanoidRootPart.Position).Magnitude
            if select then
                if temp < dis then
                    select = v
                    dis = temp
                    if dis <= 10 then
                        break
                    end
                end
            else
                select = v
                dis = temp
            end
        end
    end
    -- + Vector3.new(0,0,0)
    local t = tick()
    repeat
        local tw = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.2), {["CFrame"] = (CFrame.new(select.Position))})
        tw:Play()
        task.wait()
        if tick() - t > 1 then
            spawn(function()
                select.Transparency = 1
                wait(10)
                select.Transparency = 0
            end)
        end
    until select.Transparency ~= 0
end
nc:Disconnect()
bv:Destroy()

local Interact_Buildings = game:GetService("Workspace")["Tokyo_Modern"]["Interact_Buildings"]
for _,v in pairs(Interact_Buildings:GetChildren()) do
    if v.Name ~= "Animate_iMark" then
        for _,vv in pairs(v:GetChildren()) do
            if vv.Name:find("Interactive_") == 1 then
                fireproximityprompt(vv.ProximityPrompt)
                task.wait(.2)
                break
            end
        end
    end
end

local RF = game:GetService("ReplicatedStorage").Packages.Knit.Services.ShopService.RF
for i=1,5 do
    RF.BuyCosmetics:InvokeServer("\"Tokyo Tokyo\" Blue Maneki-neko")
end
RF.ClaimFreeUGC:InvokeServer("Mori Calliope Hat")