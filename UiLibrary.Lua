--// Simple Beginner UI Library with Dragging + Loading Screen
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- // Loading Screen
local gui = Instance.new("ScreenGui")
gui.Name = "UiLibrary"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loading = Instance.new("Frame")
loading.Parent = gui
loading.Size = UDim2.new(1,0,1,0)
loading.BackgroundColor3 = Color3.fromRGB(15,15,15)

local loadText = Instance.new("TextLabel")
loadText.Parent = loading
loadText.AnchorPoint = Vector2.new(0.5,0.5)
loadText.Position = UDim2.new(0.5,0,0.5,0)
loadText.Size = UDim2.new(0,300,0,50)
loadText.Text = "Loading UI..."
loadText.TextColor3 = Color3.new(1,1,1)
loadText.Font = Enum.Font.GothamBold
loadText.TextSize = 28
loadText.BackgroundTransparency = 1

task.wait(1)
TweenService:Create(loading, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(loadText, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
task.wait(0.6)
loading:Destroy()

-- // Create Window
function Library:CreateWindow(title)
	local Window = {}
	Window.__index = Window

	local main = Instance.new("Frame")
	main.Name = "Window"
	main.Parent = gui
	main.Size = UDim2.new(0,450,0,300)
	main.Position = UDim2.new(0.5,-225,0.5,-150)
	main.BackgroundColor3 = Color3.fromRGB(25,25,25)
	main.BorderSizePixel = 0
	main.Active = true

	-- Dragging system
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local titleBar = Instance.new("TextLabel")
	titleBar.Parent = main
	titleBar.Size = UDim2.new(1,0,0,30)
	titleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
	titleBar.Text = title or "Untitled UI"
	titleBar.TextColor3 = Color3.fromRGB(255,255,255)
	titleBar.Font = Enum.Font.GothamBold
	titleBar.TextSize = 16

	local tabs = Instance.new("Frame")
	tabs.Parent = main
	tabs.Size = UDim2.new(0,100,1,-30)
	tabs.Position = UDim2.new(0,0,0,30)
	tabs.BackgroundColor3 = Color3.fromRGB(35,35,35)
	tabs.BorderSizePixel = 0

	local container = Instance.new("Frame")
	container.Parent = main
	container.Size = UDim2.new(1,-100,1,-30)
	container.Position = UDim2.new(0,100,0,30)
	container.BackgroundColor3 = Color3.fromRGB(45,45,45)
	container.BorderSizePixel = 0

	function Window:CreateTab(name)
		local tab = {}
		tab.__index = tab

		local btn = Instance.new("TextButton")
		btn.Parent = tabs
		btn.Size = UDim2.new(1,0,0,30)
		btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
		btn.Text = name
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14

		local page = Instance.new("ScrollingFrame")
		page.Parent = container
		page.Size = UDim2.new(1,0,1,0)
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 4
		page.Visible = false

		btn.MouseButton1Click:Connect(function()
			for _,v in pairs(container:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			page.Visible = true
		end)

		if #container:GetChildren() == 1 then
			page.Visible = true
		end

		function tab:CreateButton(text, callback)
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

		function tab:CreateToggle(text, callback)
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

		function tab:CreateSlider(name, min, max, start, callback)
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Parent = page
			sliderFrame.Size = UDim2.new(0,200,0,50)
			sliderFrame.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			sliderFrame.BackgroundTransparency = 1

			local title = Instance.new("TextLabel")
			title.Parent = sliderFrame
			title.Size = UDim2.new(1,0,0,20)
			title.Text = name.." ("..start..")"
			title.TextColor3 = Color3.new(1,1,1)
			title.Font = Enum.Font.Gotham
			title.TextSize = 14
			title.BackgroundTransparency = 1

			local bar = Instance.new("Frame")
			bar.Parent = sliderFrame
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

		function tab:CreateDropdown(name, list, callback)
			local drop = Instance.new("TextButton")
			drop.Parent = page
			drop.Size = UDim2.new(0,200,0,30)
			drop.Position = UDim2.new(0,10,0,#page:GetChildren()*35)
			drop.BackgroundColor3 = Color3.fromRGB(60,60,60)
			drop.Text = name
			drop.TextColor3 = Color3.new(1,1,1)
			drop.Font = Enum.Font.Gotham
			drop.TextSize = 14

			local open = false
			local listFrame = Instance.new("Frame")
			listFrame.Parent = page
			listFrame.Size = UDim2.new(0,200,0,#list*25)
			listFrame.Position = drop.Position + UDim2.new(0,0,0,30)
			listFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
			listFrame.Visible = false

			for _,v in ipairs(list) do
				local opt = Instance.new("TextButton")
				opt.Parent = listFrame
				opt.Size = UDim2.new(1,0,0,25)
				opt.Position = UDim2.new(0,0,0,(_-1)*25)
				opt.BackgroundColor3 = Color3.fromRGB(50,50,50)
				opt.TextColor3 = Color3.new(1,1,1)
				opt.Font = Enum.Font.Gotham
				opt.TextSize = 13
				opt.Text = v
				opt.MouseButton1Click:Connect(function()
					drop.Text = name..": "..v
					listFrame.Visible = false
					open = false
					if callback then callback(v) end
				end)
			end

			drop.MouseButton1Click:Connect(function()
				open = not open
				listFrame.Visible = open
			end)
		end

		function tab:CreateTextbox(name, callback)
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
				if enter and callback then
					callback(box.Text)
				end
			end)
		end

		return tab
	end

	return setmetatable(Window, Window)
end

return setmetatable(Library, Library)
