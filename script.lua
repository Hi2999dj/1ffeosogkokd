-- Freeze Trade GUI (MOBILE DRAG FIX)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui:FindFirstChild("FreezeTradeGUI"):Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreezeTradeGUI"
screenGui.Parent = CoreGui
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 170)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -85)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- TITLE BAR (DRAG AREA)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Freeze Trade"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = titleBar

-- TOGGLES
local function createToggle(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = mainFrame
    btn.BorderSizePixel = 0

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local enabled = false

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and " [ON]" or " [OFF]")

        TweenService:Create(btn, TweenInfo.new(0.25), {
            BackgroundColor3 = enabled and Color3.fromRGB(0,170,255) or Color3.fromRGB(40,40,60)
        }):Play()
    end)
end

createToggle("Freeze Trade", 45)
createToggle("Auto Accept", 100)

-- 🔥 MOBILE + PC DRAG SYSTEM
local dragging = false
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            update(input)
        end
    end
end)

print("Freeze Trade GUI (MOBILE DRAG FIXED) loaded!")
