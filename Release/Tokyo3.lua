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

local TouchCoins = game:GetService("ReplicatedStorage").Packages.Knit.Services.PlayerManagerService.RE.TouchCoins
local num = LocalPlayer.PlayerGui.MainGui.Right.FrameUR.Money.BG.BK.Money

function getMoney()
    local text_num = string.gsub(num.Text, ",", "")
    return tonumber(text_num)
end

local target = 1000 + getMoney()
local nc = noclip()
local bv = Body_Noclip()

RunService:Set3dRenderingEnabled(false)
LocalPlayer.Character.Humanoid.PlatformStand = true
LocalPlayer.Character.LowerTorso:Destroy()

while getMoney() <= target do
    local select
    local dis
    for i,v in pairs(game:GetService("Workspace").Coins:GetChildren()) do
        while v.Transparency == 0 do
            HumanoidRootPart.CFrame = v.CFrame
            task.wait()
            TouchCoins:FireServer(v)
        end
    end
end
nc:Disconnect()
bv:Destroy()
RunService:Set3dRenderingEnabled(true)


local Services = game:GetService("ReplicatedStorage").Packages.Knit.Services

local NPC_Treasures = game:GetService("Workspace").NPCs.Treasure
for _,v in pairs(NPC_Treasures:GetChildren()) do
    HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
    task.wait(.5)
    Services.TreasureService.RF.Claim_TaskTreasure:InvokeServer(v.Name)
    wait(1)
    local timeout = tick()
    local Interact_Treasures = game:GetService("Workspace").Treasures
    for _,vv in pairs(Interact_Treasures:GetChildren()) do
        if vv:FindFirstChild("ProximityPrompt") then
            HumanoidRootPart.CFrame = vv.PrimaryPart.CFrame
            print(vv)
            while vv.PrimaryPart.Transparency == 0 do 
                fireproximityprompt(vv.ProximityPrompt)
                task.wait()
                if tick() - timeout > 2 then
                    break
                end
            end 
        end
    end
    wait(1)
    HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
    task.wait(.5)
    game:GetService("ReplicatedStorage").newtrace.RE.CallAPI:FireServer({
        [1] = "\227\131\136\227\131\188\227\130\175NPC",
        [2] = "NPC",
        [3] = v.Name
    })
    task.wait(.5)
end


for i=1,10 do
    Services.ShopService.RF.BuyCosmetics:InvokeServer("\"Tokyo Tokyo\" Blue Maneki-neko")
end

wait(1)
-- RF.ClaimFreeUGC:InvokeServer("Mori Calliope Hat")
