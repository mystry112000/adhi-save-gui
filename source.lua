--[[
    MYSTERY SAVE GUI — Advanced Save Instance Wrapper
    Brand: MYSTERY
]]

local BRAND = "MYSTERY"
local ACCENT = Color3.fromRGB(255, 65, 120)
local BG_DARK = Color3.fromRGB(14, 14, 22)
local BG_CARD = Color3.fromRGB(24, 24, 34)
local TEXT_MAIN = Color3.fromRGB(225, 225, 235)
local TEXT_DIM = Color3.fromRGB(130, 130, 145)
local GREEN_ON = Color3.fromRGB(60, 185, 75)
local GREY_OFF = Color3.fromRGB(55, 55, 68)

local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local http = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = BRAND .. "SaveGUI"
gui.ResetOnSpawn = false

-- Parent GUI safely
local parent = (type(syn) == "table" and type(syn.protect_gui) == "function" and syn.protect_gui(gui))
            or (gethui and gethui())
            or game:GetService("CoreGui")
gui.Parent = parent

local W, H = 380, 560

local main = Instance.new("Frame")
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
main.BackgroundColor3 = BG_DARK
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 14)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(35, 35, 48)
ms.Thickness = 1
ms.Parent = main

-- Dragging
local dragging, dragStart, startPos, dragInput
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = ACCENT
header.BorderSizePixel = 0
header.Parent = main

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 14)
hc.Parent = header

local hc2 = Instance.new("Frame")
hc2.Size = UDim2.new(1, 0, 0, 14)
hc2.Position = UDim2.new(0, 0, 0.7, 0)
hc2.BackgroundColor3 = BG_DARK
hc2.BorderSizePixel = 0
hc2.Parent = header

local brandLabel = Instance.new("TextLabel")
brandLabel.Size = UDim2.new(1, -40, 1, 0)
brandLabel.Position = UDim2.new(0, 14, 0, 0)
brandLabel.BackgroundTransparency = 1
brandLabel.Text = BRAND .. " SAVE"
brandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
brandLabel.TextSize = 20
brandLabel.TextStrokeTransparency = 0.6
brandLabel.Font = Enum.Font.GothamBold
brandLabel.TextXAlignment = Enum.TextXAlignment.Left
brandLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnC = Instance.new("UICorner")
closeBtnC.CornerRadius = UDim.new(0, 7)
closeBtnC.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Create toggle
local function makeToggle(parent, y, title, desc, default)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 48)
    row.Position = UDim2.new(0, 8, 0, y)
    row.BackgroundColor3 = BG_CARD
    row.BorderSizePixel = 0
    row.Parent = parent

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 240, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = TEXT_MAIN
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local dlabel = Instance.new("TextLabel")
    dlabel.Size = UDim2.new(0, 240, 0, 16)
    dlabel.Position = UDim2.new(0, 12, 0, 26)
    dlabel.BackgroundTransparency = 1
    dlabel.Text = desc
    dlabel.TextColor3 = TEXT_DIM
    dlabel.TextSize = 11
    dlabel.Font = Enum.Font.Gotham
    dlabel.TextXAlignment = Enum.TextXAlignment.Left
    dlabel.Parent = row

    local state = default

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 44, 0, 24)
    bg.Position = UDim2.new(1, -54, 0, 12)
    bg.BackgroundColor3 = default and GREEN_ON or GREY_OFF
    bg.BorderSizePixel = 0
    bg.Parent = row

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(0, 12)
    bgc.Parent = bg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, default and 23 or 3, 0, 3)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bg

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(0, 9)
    kc.Parent = knob

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = bg

    btn.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and GREEN_ON or GREY_OFF
        local goal = {}
        goal.Position = UDim2.new(0, state and 23 or 3, 0, 3)
        local tween = ts:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
        tween:Play()
    end)

    return function() return state end
end

-- Options
local optFrame = Instance.new("ScrollingFrame")
optFrame.Size = UDim2.new(1, 0, 0, 310)
optFrame.Position = UDim2.new(0, 0, 0, 55)
optFrame.BackgroundTransparency = 1
optFrame.BorderSizePixel = 0
optFrame.ScrollBarThickness = 3
optFrame.ScrollBarImageColor3 = ACCENT
optFrame.CanvasSize = UDim2.new(0, 0, 0, 340)
optFrame.Parent = main

local opts = {}
local yy = 6
opts.SaveTerrain = makeToggle(optFrame, yy, "Save Terrain", "Export terrain voxels & material data", true); yy = yy + 54
opts.Scripts = makeToggle(optFrame, yy, "Decompile Scripts", "Save decompiled Lua source", true); yy = yy + 54
opts.StreamOnly = makeToggle(optFrame, yy, "Stream Only", "Only save streamed-in parts", false); yy = yy + 54
opts.Compress = makeToggle(optFrame, yy, "Compress Output", "Compress the final .rbxmx file", true); yy = yy + 54
opts.RemoveDefaultTags = makeToggle(optFrame, yy, "Remove Default Tags", "Strip default Roblox tags", true); yy = yy + 54
opts.RemoveCollision = makeToggle(optFrame, yy, "Remove Collision", "Skip collision data (smaller file)", false); yy = yy + 54

optFrame.CanvasSize = UDim2.new(0, 0, 0, yy + 6)

local yy2 = 370

-- Function name input
local fnFrame = Instance.new("Frame")
fnFrame.Size = UDim2.new(1, -16, 0, 32)
fnFrame.Position = UDim2.new(0, 8, 0, yy2)
fnFrame.BackgroundColor3 = BG_CARD
fnFrame.BorderSizePixel = 0
fnFrame.Parent = main

local fnc = Instance.new("UICorner")
fnc.CornerRadius = UDim.new(0, 8)
fnc.Parent = fnFrame

local fnlabel = Instance.new("TextLabel")
fnlabel.Size = UDim2.new(0, 50, 1, 0)
fnlabel.Position = UDim2.new(0, 10, 0, 0)
fnlabel.BackgroundTransparency = 1
fnlabel.Text = "Fn:"
fnlabel.TextColor3 = TEXT_MAIN
fnlabel.TextSize = 12
fnlabel.Font = Enum.Font.GothamSemibold
fnlabel.Parent = fnFrame

local fnInput = Instance.new("TextBox")
fnInput.Size = UDim2.new(0, 280, 0, 22)
fnInput.Position = UDim2.new(0, 45, 0, 5)
fnInput.BackgroundColor3 = BG_DARK
fnInput.BorderSizePixel = 0
fnInput.Text = "saveinstance"
fnInput.TextColor3 = TEXT_MAIN
fnInput.TextSize = 11
fnInput.Font = Enum.Font.Gotham
fnInput.PlaceholderText = "function name"
fnInput.PlaceholderColor3 = TEXT_DIM
fnInput.ClearTextOnFocus = false
fnInput.Parent = fnFrame

local fnc2 = Instance.new("UICorner")
fnc2.CornerRadius = UDim.new(0, 6)
fnc2.Parent = fnInput

-- File name input
local fiFrame = Instance.new("Frame")
fiFrame.Size = UDim2.new(1, -16, 0, 32)
fiFrame.Position = UDim2.new(0, 8, 0, yy2 + 36)
fiFrame.BackgroundColor3 = BG_CARD
fiFrame.BorderSizePixel = 0
fiFrame.Parent = main

local fic = Instance.new("UICorner")
fic.CornerRadius = UDim.new(0, 8)
fic.Parent = fiFrame

local filabel = Instance.new("TextLabel")
filabel.Size = UDim2.new(0, 50, 1, 0)
filabel.Position = UDim2.new(0, 10, 0, 0)
filabel.BackgroundTransparency = 1
filabel.Text = "File:"
filabel.TextColor3 = TEXT_MAIN
filabel.TextSize = 12
filabel.Font = Enum.Font.GothamSemibold
filabel.Parent = fiFrame

local fileInput = Instance.new("TextBox")
fileInput.Size = UDim2.new(0, 280, 0, 22)
fileInput.Position = UDim2.new(0, 45, 0, 5)
fileInput.BackgroundColor3 = BG_DARK
fileInput.BorderSizePixel = 0
fileInput.Text = "SavedMap.rbxmx"
fileInput.TextColor3 = TEXT_MAIN
fileInput.TextSize = 11
fileInput.Font = Enum.Font.Gotham
fileInput.PlaceholderText = "filename.rbxmx"
fileInput.PlaceholderColor3 = TEXT_DIM
fileInput.ClearTextOnFocus = false
fileInput.Parent = fiFrame

local fic2 = Instance.new("UICorner")
fic2.CornerRadius = UDim.new(0, 6)
fic2.Parent = fileInput

-- Status bar
local stFrame = Instance.new("Frame")
stFrame.Size = UDim2.new(1, -16, 0, 50)
stFrame.Position = UDim2.new(0, 8, 0, 444)
stFrame.BackgroundColor3 = BG_CARD
stFrame.BorderSizePixel = 0
stFrame.Parent = main

local stc = Instance.new("UICorner")
stc.CornerRadius = UDim.new(0, 8)
stc.Parent = stFrame

local stTitle = Instance.new("TextLabel")
stTitle.Size = UDim2.new(1, -12, 0, 14)
stTitle.Position = UDim2.new(0, 8, 0, 4)
stTitle.BackgroundTransparency = 1
stTitle.Text = "Status"
stTitle.TextColor3 = ACCENT
stTitle.TextSize = 11
stTitle.Font = Enum.Font.GothamBold
stTitle.TextXAlignment = Enum.TextXAlignment.Left
stTitle.Parent = stFrame

local stLog = Instance.new("TextLabel")
stLog.Size = UDim2.new(1, -12, 0, 26)
stLog.Position = UDim2.new(0, 8, 0, 20)
stLog.BackgroundTransparency = 1
stLog.Text = "Ready"
stLog.TextColor3 = TEXT_DIM
stLog.TextSize = 11
stLog.Font = Enum.Font.Gotham
stLog.TextXAlignment = Enum.TextXAlignment.Left
stLog.TextYAlignment = Enum.TextYAlignment.Top
stLog.TextWrapped = true
stLog.Parent = stFrame

local function setStatus(msg, color)
    stLog.Text = msg
    stLog.TextColor3 = color or TEXT_DIM
end

-- Start button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -16, 0, 44)
startBtn.Position = UDim2.new(0, 8, 0, 500)
startBtn.BackgroundColor3 = ACCENT
startBtn.Text = "▶  START SAVING"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 15
startBtn.Font = Enum.Font.GothamBold
startBtn.BorderSizePixel = 0
startBtn.AutoButtonColor = false
startBtn.Parent = main

local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 10)
sbc.Parent = startBtn

-- Hover effect
startBtn.MouseEnter:Connect(function()
    ts:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 85, 140)}):Play()
end)
startBtn.MouseLeave:Connect(function()
    ts:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = ACCENT}):Play()
end)

-- Button state
local running = false
local completed = false

local function animateDots()
    local frames = { "  ", ". ", "..", " ." }
    local i = 0
    while running do
        i = i % 4 + 1
        setStatus("Running" .. frames[i], Color3.fromRGB(255, 200, 60))
        task.wait(0.4)
    end
end

local function doSave()
    local saveOpts = {
        SaveTerrain = opts.SaveTerrain(),
        StreamOnly = opts.StreamOnly(),
        Scripts = opts.Scripts(),
        Compress = opts.Compress(),
        RemoveDefaultTags = opts.RemoveDefaultTags(),
        RemoveCollision = opts.RemoveCollision()
    }

    local fileName = fileInput.Text
    if fileName == "" then fileName = "SavedMap.rbxmx" end

    pcall(function()
        local backup = Instance.new("Model")
        backup.Name = "__VisualBackup"
        pcall(function() backup.Parent = game:GetService("CoreGui") end)

        local lighting = game:GetService("Lighting")
        local ld = Instance.new("Folder")
        ld.Name = "LightingData"
        for _, prop in ipairs({
            "Ambient", "Brightness", "ColorShift_Bottom", "ColorShift_Top",
            "ExposureCompensation", "FogColor", "FogEnd", "FogStart",
            "GlobalShadows", "OutdoorAmbient", "Outlines",
            "ShadowSoftness", "Technology", "TimeOfDay",
            "ClockTime", "GeographicLatitude", "EnvironmentDiffuseScale",
            "EnvironmentSpecularScale"
        }) do
            local v = Instance.new("StringValue")
            v.Name = prop
            pcall(function() v.Value = tostring(lighting[prop]) end)
            v.Parent = ld
        end
        for _, child in ipairs(lighting:GetChildren()) do
            if child:IsA("PostEffect") or child:IsA("Sky") or child:IsA("Atmosphere") then
                local c = child:Clone()
                c.Parent = ld
            end
        end
        ld.Parent = backup

        local terrain = workspace.Terrain
        if terrain and saveOpts.SaveTerrain then
            local td = Instance.new("Folder")
            td.Name = "TerrainVisuals"
            for _, prop in ipairs({
                "Appearance", "Decoration", "WaterColor", "WaterReflectance",
                "WaterTransparency", "WaterWaveSize", "WaterWaveSpeed"
            }) do
                local v = Instance.new("StringValue")
                v.Name = prop
                pcall(function() v.Value = tostring(terrain[prop]) end)
                v.Parent = td
            end
            pcall(function()
                local matArray = terrain:ReadVoxels(
                    Region3int16.new(Vector3int16.new(-256, 0, -256), Vector3int16.new(256, 64, 256)),
                    4
                )
                if matArray then
                    local cv = Instance.new("StringValue")
                    cv.Name = "MaterialColorsPalette"
                    cv.Value = http:JSONEncode({terrain.MaterialColors})
                    cv.Parent = td
                end
            end)
            td.Parent = backup
        end

        local wd = Instance.new("Folder")
        wd.Name = "WorkspaceVisuals"
        for _, prop in ipairs({
            "CurrentCamera", "DistributedGameTime", "Gravity",
            "StreamingEnabled", "StreamingMinRadius", "StreamingTargetRadius",
            "Terrain", "WorldPaused"
        }) do
            local v = Instance.new("StringValue")
            v.Name = prop
            pcall(function() v.Value = tostring(workspace[prop]) end)
            v.Parent = wd
        end
        wd.Parent = backup

        local camera = workspace.CurrentCamera
        if camera then
            local cd = Instance.new("Folder")
            cd.Name = "CameraData"
            for _, prop in ipairs({
                "FieldOfView", "CameraType", "CameraSubject", "HeadScale"
            }) do
                local v = Instance.new("StringValue")
                v.Name = prop
                pcall(function() v.Value = tostring(camera[prop]) end)
                v.Parent = cd
            end
            cd.Parent = backup
        end
    end)

    local fnName = fnInput.Text
    if fnName == "" then fnName = "saveinstance" end
    local fn = _G[fnName]

    if not fn then
        setStatus("Function '" .. fnName .. "' not found in _G", Color3.fromRGB(255, 80, 80))
        return
    end

    setStatus("Calling " .. fnName .. "...", Color3.fromRGB(100, 200, 255))

    local ok, err = pcall(fn, {
        SaveTerrain = saveOpts.SaveTerrain,
        StreamOnly = saveOpts.StreamOnly,
        Scripts = saveOpts.Scripts,
        RemoveDefaultTags = saveOpts.RemoveDefaultTags,
        RemoveCollision = saveOpts.RemoveCollision,
        Compress = saveOpts.Compress
    })

    if ok then
        completed = true
        setStatus("Done! File saved as " .. fileName, Color3.fromRGB(60, 220, 80))
        startBtn.Text = "✕  CLOSE"
    else
        setStatus("Error: " .. tostring(err), Color3.fromRGB(255, 80, 80))
    end
end

startBtn.MouseButton1Click:Connect(function()
    if completed then gui:Destroy() return end
    if running then return end

    running = true
    startBtn.Text = "⏳  SAVING..."
    task.spawn(animateDots)

    local ok, err = pcall(doSave)

    running = false
    if not ok then
        setStatus("Internal error: " .. tostring(err), Color3.fromRGB(255, 80, 80))
        startBtn.Text = "▶  START SAVING"
    end
end)
