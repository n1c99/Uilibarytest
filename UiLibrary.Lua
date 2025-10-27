--// Simple UI Library with Loading Screen
--// looks human made, beginner friendly, all in one file

if game.CoreGui:FindFirstChild("MyUiLibrary") then
	game.CoreGui.MyUiLibrary:Destroy()
end

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "MyUiLibrary"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// loading screen
local loading = Instance.new("Frame")
loading.Parent = gui
loading.BackgroundColor3 = Color3.fromRGB(15,15,15)
loading.Size = UDim2.new(1,0,1,0)

local title = Instance.new("TextLabel")
title.Parent = loading
title.AnchorPoint = Vector2.new(0.5,0.5)
title.Position = UDim2.new(0.5,0,0.45,0)
title.Size = UDim2.new(0,300,0,50)
title.BackgroundTransparency = 1
title.Text = "Loading UI..."
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 30

local barBack = Instance.new("Frame")
barBack.Parent = loading
barBack.AnchorPoint = Vector2.new(0.5,0.5)
barBack.Position = UDim2.new(0.5,0,0.55,0)
barBack.Size = UDim2.new(0,300,0,10)
barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBack.BorderSizePixel = 0

local barFill = Instance.new("Frame")
barFill.Parent = barBack
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
barFill.BorderSizePixel = 0

for i = 1,100 do
	TweenService:Create(barFill, TweenInfo.new(0.02), {Size = UDim2.new(i/100,0,1,0)}):Play()
	task.wait(0.02)
end

TweenService:Create(loading, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
TweenService:Create(barBack, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
task.wait(0.7)
loading:Destroy()

--// Main window
local window = Instance.new("Frame")
window.Parent = gui
window.Size = UDim2.new(0,400,0,250)
window.Position = UDim2.new(0.5,-200,0.5,-125)
window.BackgroundColor3 = Color3.fromRGB(20,20,20)
window.BorderSizePixel = 0
window.Active = true

local dragToggle = false
local dragStart, startPos

window.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = true
		dragStart = input.Position
		startPos = window.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// Title bar
local titleBar = Instance.new("TextLabel")
titleBar.Parent = window
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.Text = "Venyx Style UI"
titleBar.TextColor3 = Color3.fromRGB(255,255,255)
titleBar.Font = Enum.Font.Gotham
titleBar.TextSize = 16

--// Tabs frame
local tabButtons = Instance.new("Frame")
tabButtons.Parent = window
tabButtons.Size = UDim2.new(0,100,1,-30)
tabButtons.Position = UDim2.new(0,0,0,30)
tabButtons.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabButtons.BorderSizePixel = 0

local tabContainer = Instance.new("Frame")
tabContainer.Parent = window
tabContainer.Size = UDim2.new(1,-100,1,-30)
tabContainer.Position = UDim2.new(0,100,0,30)
tabContainer.BackgroundColor3 = Color3.fromRGB(35,35,35)
tabContainer.BorderSizePixel = 0

local function createTab(name)
	local button = Instance.new("TextButton")
	button.Parent = tabButtons
	button.Size = UDim2.new(1,0,0,30)
	button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14

	local page = Instance.new("ScrollingFrame")
	page.Parent = tabContainer
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 4
	page.Visible = false

	button.MouseButton1Click:Connect(function()
		for _,v in pairs(tabContainer:GetChildren()) do
			if v:IsA("ScrollingFrame") then v.Visible = false end
		end
		page.Visible = true
	end)

	return page
end

--// Example Tabs
local mainTab = createTab("Main")
mainTab.Visible = true
local settingsTab = createTab("Settings")

--// Example Button
local exampleBtn = Instance.new("TextButton")
exampleBtn.Parent = mainTab
exampleBtn.Size = UDim2.new(0,150,0,30)
exampleBtn.Position = UDim2.new(0,10,0,10)
exampleBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
exampleBtn.Text = "Click Me"
exampleBtn.TextColor3 = Color3.fromRGB(255,255,255)
exampleBtn.Font = Enum.Font.GothamBold
exampleBtn.TextSize = 14

exampleBtn.MouseButton1Click:Connect(function()
	print("Button Clicked!")
end)

--// Example Toggle
local toggle = Instance.new("TextButton")
toggle.Parent = settingsTab
toggle.Size = UDim2.new(0,150,0,30)
toggle.Position = UDim2.new(0,10,0,10)
toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggle.Text = "Toggle: OFF"
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14

local state = false
toggle.MouseButton1Click:Connect(function()
	state = not state
	toggle.Text = "Toggle: " .. (state and "ON" or "OFF")
	print("Toggled:", state)
end)
