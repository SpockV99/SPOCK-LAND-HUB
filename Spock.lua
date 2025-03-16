-- CONFIG
local team = "Pirate" -- or "Marine"
local discordLink = "https://discord.gg/w9nrHXVH"
local correctKey = "EFB9NtXR" -- Key que será entregue no Discord

repeat wait() until game:IsLoaded()
local plr = game.Players.LocalPlayer
local tpService = game:GetService("TeleportService")

-- Key GUI
local function showKeyGUI()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 350, 0, 150)
    frame.Position = UDim2.new(0.5, -175, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local msg = Instance.new("TextLabel", frame)
    msg.Size = UDim2.new(1, -20, 0, 40)
    msg.Position = UDim2.new(0,10,0,10)
    msg.Text = "Get your KEY from our Discord:\n"..discordLink
    msg.TextColor3 = Color3.fromRGB(255,255,255)
    msg.TextWrapped = true
    msg.TextScaled = true
    msg.BackgroundTransparency = 1

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -20, 0, 40)
    box.Position = UDim2.new(0,10,0,60)
    box.PlaceholderText = "Enter your KEY..."
    box.Text = ""
    box.TextScaled = true

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0,10,0,110)
    btn.Text = "Submit"

    btn.MouseButton1Click:Connect(function()
        if box.Text == correctKey then
            gui:Destroy()
        else
            box.Text = ""
            box.PlaceholderText = "Wrong key! Get it from Discord."
        end
    end)

    repeat wait() until not gui.Parent
end

showKeyGUI()

-- Anti AFK
plr.Idled:Connect(function()
    game.VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    wait(1)
    game.VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- FPS Boost
pcall(function()
    local l = game.Lighting
    l.GlobalShadows = false
    l.FogEnd = 1e10
    sethiddenproperty(l, "Technology", Enum.Technology.Compatibility)
    settings().Rendering.QualityLevel = "Level01"
    for _, v in pairs(l:GetChildren()) do if v:IsA("PostEffect") then v:Destroy() end end
    local t = workspace:FindFirstChildOfClass("Terrain")
    if t then t.WaterWaveSize, t.WaterWaveSpeed, t.WaterReflectance, t.WaterTransparency = 0,0,0,1 end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false
        elseif v:IsA("Explosion") or v:IsA("Texture") then v:Destroy()
        elseif v:IsA("Decal") then v.Transparency = 1 end
    end
end)

-- Auto Team + Rejoin
local function pickTeam(t)
    local ok, res = pcall(function()
        return game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", t)
    end)
    if ok and not res then
        tpService:Teleport(game.PlaceId, plr)
    end
end

pickTeam(team)

plr.OnTeleport:Connect(function(s)
    if s == Enum.TeleportState.Failed then
        wait(2)
        tpService:Teleport(game.PlaceId, plr)
    end
end)

-- Load your script
wait(2)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Spock/refs/heads/main/Spock.lua"))()
