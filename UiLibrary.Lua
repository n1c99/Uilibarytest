--[[
	Simple UI Library with Working Dragging and Loading Screen
	Made beginner-friendly and human readable
--]]

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}

-- // Loading Screen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UiLibrary"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loading = Instance.new("Frame")
loading.Parent = ScreenGui
loading.Size = UDim2.new(1,0,1,0)
loading.BackgroundColor3 = Color3.fromRGB(15,15,15)

local text = Instance.new("TextLabel")
text.Parent = loading
text.AnchorPoint = Vector2.new(0.5,0.5)
text.Position = UDim2.new(0.5,0,0.5,0)
text.Size = UDim2.new(0,300,0,50)
text.Text = "Loading UI..."
text.TextColor3 = Color3.new(1,1,1)
text.Font = Enum.Font.GothamBold
text.TextSize = 30
text.BackgroundTransparency = 1

for i = 1,100 do
	TweenService:Create(text, TweenInfo.new(0.01), {TextTransparency = i/100}):Play()
	task.wait(0.005)
end
loading:Destroy()

-- // Dragging helper
local function makeDraggable(frame, dragArea)
	local dragging = false
	local dragStart, startPos

	dragArea.InputBegan:Connect(function(input)
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

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- // Create Window
function Library:CreateWindow(title)
	local Window = {}
	
	local main = Instance.new("Frame")
	main.Parent = ScreenGui
	main.Size = UDim2.new(0,450,0,300)
	main.Position = UDim2.new(0.5,-225,0.5,-150)
	main.BackgroundColor3 = Color3.fromRGB(25,25,25)
	main.BorderSizePixel = 0

	local topBar = Instance.new("TextLabel")
	topBar.Parent = main
	topBar.Size = UDim2.new(1,0,0,30)
	topBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
	topBar.Text = title or "UI Window"
	topBar.TextColor3 = Color3.fromRGB(255,255,255)
	topBar.Font = Enum.Font.GothamBold
	topBar.TextSize = 16

	makeDraggable(main, topBar)

	local tabButtons = Instance.new("Frame")
	tabButtons.Parent = main
	tabButtons.Size = UDim2.new(0,100,1,-30)
	tabButtons.Position = UDim2.new(0,0,0,30)
	tabButtons.BackgroundColor3 = Color3.fromRGB(35,35,35)

	local container = Instance.new("Frame")
	container.Parent = main
	container.Size = UDim2.new(1,-100,1,-30)
	container.Position = UDim2.new(0,100,0,30)
	container.BackgroundColor3 = Color3.fromRGB(45,45,45)

	function Window:CreateTab(name)
		local Tab = {}
		local btn = Instance.new("TextButton")
		btn.Parent = tabButtons
		btn.Size = UDim2.new(1,0,0,30)
		btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Text = name

		local page = Instance.new("ScrollingFrame")
		page.Parent = container
		page.Size = UDim2.new(1,0,1,0)
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 4
		page.Visible = false

		btn.MouseButton1Click:Connect(function()
			for _,v in pairs(container:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			page.Visible = true
		end)

		if #container:GetChildren() == 1 then
			page.Visible = true
		end

		function Tab:CreateButton(text, callback)
			local b = Instance.new("TextButton")
			b.Parent = page
			b.Size = UDim2.new(0,200,0,30)
			b.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			b.BackgroundColor3 = Color3.fromRGB(0,170,255)
			b.Text = text
			b.TextColor3 = Color3.new(1,1,1)
			b.Font = Enum.Font.GothamBold
			b.TextSize = 14
			b.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		function Tab:CreateToggle(text, callback)
			local t = Instance.new("TextButton")
			t.Parent = page
			t.Size = UDim2.new(0,200,0,30)
			t.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			t.BackgroundColor3 = Color3.fromRGB(80,80,80)
			t.TextColor3 = Color3.new(1,1,1)
			t.Font = Enum.Font.GothamBold
			t.TextSize = 14

			local state = false
			t.Text = text..": OFF"
			t.MouseButton1Click:Connect(function()
				state = not state
				t.Text = text..": "..(state and "ON" or "OFF")
				if callback then callback(state) end
			end)
		end

		function Tab:CreateSlider(name, min, max, start, callback)
			local f = Instance.new("Frame")
			f.Parent = page
			f.Size = UDim2.new(0,200,0,40)
			f.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			f.BackgroundTransparency = 1

			local title = Instance.new("TextLabel")
			title.Parent = f
			title.Size = UDim2.new(1,0,0,20)
			title.Text = name.." ("..start..")"
			title.TextColor3 = Color3.new(1,1,1)
			title.Font = Enum.Font.Gotham
			title.TextSize = 14
			title.BackgroundTransparency = 1

			local bar = Instance.new("Frame")
			bar.Parent = f
			bar.Position = UDim2.new(0,0,0,25)
			bar.Size = UDim2.new(1,0,0,5)
			bar.BackgroundColor3 = Color3.fromRGB(80,80,80)

			local fill = Instance.new("Frame")
			fill.Parent = bar
			fill.Size = UDim2.new((start-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

			local dragging = false
			bar.InputBegan:Connect(function(input)
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
					local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
					fill.Size = UDim2.new(rel,0,1,0)
					local val = math.floor(min + (max-min)*rel)
					title.Text = name.." ("..val..")"
					if callback then callback(val) end
				end
			end)
		end

		function Tab:CreateTextbox(name, callback)
			local label = Instance.new("TextLabel")
			label.Parent = page
			label.Size = UDim2.new(0,200,0,20)
			label.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1,1,1)
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.Text = name

			local box = Instance.new("TextBox")
			box.Parent = page
			box.Size = UDim2.new(0,200,0,25)
			box.Position = label.Position + UDim2.new(0,0,0,20)
			box.BackgroundColor3 = Color3.fromRGB(60,60,60)
			box.Text = ""
			box.TextColor3 = Color3.new(1,1,1)
			box.Font = Enum.Font.Gotham
			box.TextSize = 14
			box.FocusLost:Connect(function(enter)
				if enter and callback then callback(box.Text) end
			end)
		end

		return Tab
	end

	return Window
end

return Library
