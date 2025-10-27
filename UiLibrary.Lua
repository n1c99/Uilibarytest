-- Sigma UI Library
local SigmaUI = {}
SigmaUI.__index = SigmaUI

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- Create a draggable frame
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create main UI window
function SigmaUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CollectionService:AddTag(screenGui, "main")

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 412, 0, 266)
    frame.Position = UDim2.new(0, 171, 0, 8)
    frame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    frame.BorderSizePixel = 0

    makeDraggable(frame)

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(0, 412, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    titleLabel.Text = title or "Sigma UI"
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local library = {}
    library.ScreenGui = screenGui
    library.Frame = frame
    library.Labels = {}

    setmetatable(library, SigmaUI)
    return library
end

-- Add a label to the window
function SigmaUI:CreateLabel(text, position, size, color)
    local lbl = Instance.new("TextLabel", self.Frame)
    lbl.Text = text or ""
    lbl.Position = position or UDim2.new(0, 0, 0, 50)
    lbl.Size = size or UDim2.new(0, 100, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.TextWrapped = true

    table.insert(self.Labels, lbl)
    return lbl
end

return SigmaUI
