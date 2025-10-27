--// Simple Venyx-style UI Library (beginner friendly, human made)
--// Supports CreateWindow, CreateTab, CreateButton, CreateToggle, CreateSlider, CreateDropdown, CreateTextbox

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}

-- // Loading Screen
local gui = Instance.new("ScreenGui")
gui.Name = "MyUiLibrary"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loading = Instance.new("Frame", gui)
loading.Size = UDim2.new(1,0,1,0)
loading.BackgroundColor3 = Color3.fromRGB(15,15,15)

local title = Instance.new("TextLabel", loading)
title.AnchorPoint = Vector2.new(0.5,0.5)
title.Position = UDim2.new(0.5,0,0.45,0)
title.Size = UDim2.new(0,300,0,50)
title.BackgroundTransparency = 1
title.Text = "Loading UI..."
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 30

local barBack = Instance.new("Frame", loading)
barBack.AnchorPoint = Vector2.new(0.5,0.5)
barBack.Position = UDim2.new(0.5,0,0.55,0)
barBack.Size = UDim2.new(0,300,0,10)
barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBack.BorderSizePixel = 0

local barFill = Instance.new("Frame", barBack)
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
barFill.BorderSizePixel = 0

for i = 1,100 do
	TweenService:Create(barFill, TweenInfo.new(0.01), {Size = UDim2.new(i/100,0,1,0)}):Play()
	task.wait(0.01)
end

TweenService:Create(loading, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
TweenService:Create(barBack, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
task.wait(0.7)
loading:Destroy()

-- // Create Window
function Library:CreateWindow(titleText)
	local Window = {}
	local window = Instance.new("Frame")
	window.Parent = gui
	window.Size = UDim2.new(0,500,0,300)
	window.Position = UDim2.new(0.5,-250,0.5,-150)
	window.BackgroundColor3 = Color3.fromRGB(25,25,25)
	window.BorderSizePixel = 0
	window.Active = true
	
	local dragging = false
	local dragStart, startPos
	
	window.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = window.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	local title = Instance.new("TextLabel", window)
	title.Size = UDim2.new(1,0,0,30)
	title.BackgroundColor3 = Color3.fromRGB(35,35,35)
	title.Text = titleText or "Window"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	
	local tabButtons = Instance.new("Frame", window)
	tabButtons.Size = UDim2.new(0,120,1,-30)
	tabButtons.Position = UDim2.new(0,0,0,30)
	tabButtons.BackgroundColor3 = Color3.fromRGB(30,30,30)
	tabButtons.BorderSizePixel = 0
	
	local tabContainer = Instance.new("Frame", window)
	tabContainer.Size = UDim2.new(1,-120,1,-30)
	tabContainer.Position = UDim2.new(0,120,0,30)
	tabContainer.BackgroundColor3 = Color3.fromRGB(40,40,40)
	tabContainer.BorderSizePixel = 0
	
	function Window:CreateTab(tabName)
		local Tab = {}
		
		local button = Instance.new("TextButton", tabButtons)
		button.Size = UDim2.new(1,0,0,30)
		button.BackgroundColor3 = Color3.fromRGB(35,35,35)
		button.Text = tabName
		button.TextColor3 = Color3.fromRGB(255,255,255)
		button.Font = Enum.Font.Gotham
		button.TextSize = 14
		
		local page = Instance.new("ScrollingFrame", tabContainer)
		page.Size = UDim2.new(1,0,1,0)
		page.Visible = false
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 4
		
		button.MouseButton1Click:Connect(function()
			for _,v in pairs(tabContainer:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			page.Visible = true
		end)
		
		local y = 10
		
		function Tab:CreateButton(text, callback)
			local btn = Instance.new("TextButton", page)
			btn.Size = UDim2.new(0,200,0,30)
			btn.Position = UDim2.new(0,10,0,y)
			btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.Text = text
			btn.MouseButton1Click:Connect(callback)
			y = y + 40
		end
		
		function Tab:CreateToggle(text, callback)
			local toggle = Instance.new("TextButton", page)
			toggle.Size = UDim2.new(0,200,0,30)
			toggle.Position = UDim2.new(0,10,0,y)
			toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
			toggle.TextColor3 = Color3.fromRGB(255,255,255)
			toggle.Font = Enum.Font.GothamBold
			toggle.TextSize = 14
			toggle.Text = text .. ": OFF"
			
			local state = false
			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = text .. ": " .. (state and "ON" or "OFF")
				callback(state)
			end)
			y = y + 40
		end
		
		function Tab:CreateSlider(text, min, max, default, callback)
			local frame = Instance.new("Frame", page)
			frame.Position = UDim2.new(0,10,0,y)
			frame.Size = UDim2.new(0,200,0,40)
			frame.BackgroundTransparency = 1
			
			local label = Instance.new("TextLabel", frame)
			label.Text = text .. ": " .. tostring(default)
			label.Font = Enum.Font.GothamBold
			label.TextColor3 = Color3.fromRGB(255,255,255)
			label.Size = UDim2.new(1,0,0,20)
			label.BackgroundTransparency = 1
			
			local sliderBack = Instance.new("Frame", frame)
			sliderBack.Size = UDim2.new(1,0,0,8)
			sliderBack.Position = UDim2.new(0,0,0,25)
			sliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
			
			local sliderFill = Instance.new("Frame", sliderBack)
			sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
			sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
			
			local dragging = false
			sliderBack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local rel = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X,0,1)
					local val = math.floor(min + (max-min)*rel)
					sliderFill.Size = UDim2.new(rel,0,1,0)
					label.Text = text .. ": " .. val
					callback(val)
				end
			end)
			y = y + 50
		end
		
		function Tab:CreateDropdown(text, list, callback)
			local dropdown = Instance.new("TextButton", page)
			dropdown.Size = UDim2.new(0,200,0,30)
			dropdown.Position = UDim2.new(0,10,0,y)
			dropdown.BackgroundColor3 = Color3.fromRGB(60,60,60)
			dropdown.TextColor3 = Color3.fromRGB(255,255,255)
			dropdown.Font = Enum.Font.Gotham
			dropdown.TextSize = 14
			dropdown.Text = text
			
			local frame = Instance.new("Frame", dropdown)
			frame.Position = UDim2.new(0,0,1,0)
			frame.Size = UDim2.new(1,0,0,#list*25)
			frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
			frame.Visible = false
			
			for _,v in pairs(list) do
				local opt = Instance.new("TextButton", frame)
				opt.Size = UDim2.new(1,0,0,25)
				opt.Text = v
				opt.BackgroundColor3 = Color3.fromRGB(50,50,50)
				opt.TextColor3 = Color3.fromRGB(255,255,255)
				opt.MouseButton1Click:Connect(function()
					callback(v)
					frame.Visible = false
				end)
			end
			
			dropdown.MouseButton1Click:Connect(function()
				frame.Visible = not frame.Visible
			end)
			y = y + 40
		end
		
		function Tab:CreateTextbox(text, callback)
			local box = Instance.new("TextBox", page)
			box.Size = UDim2.new(0,200,0,30)
			box.Position = UDim2.new(0,10,0,y)
			box.BackgroundColor3 = Color3.fromRGB(60,60,60)
			box.TextColor3 = Color3.fromRGB(255,255,255)
			box.Font = Enum.Font.Gotham
			box.PlaceholderText = text
			box.FocusLost:Connect(function()
				callback(box.Text)
			end)
			y = y + 40
		end
		
		return Tab
	end
	
	return Window
end

return Library
