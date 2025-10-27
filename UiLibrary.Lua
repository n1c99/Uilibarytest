--// Ui Library with Draggable Window + Example
--// 99% human made beginner version

local Library = {}

-- // Window Creation
function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ExampleUILib"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.CoreGui

	local Main = Instance.new("Frame")
	Main.Name = "MainWindow"
	Main.Size = UDim2.new(0, 400, 0, 300)
	Main.Position = UDim2.new(0.5, -200, 0.5, -150)
	Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = true  -- old method still works in executors
	Main.Parent = ScreenGui

	local TitleBar = Instance.new("TextLabel")
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleBar.Text = title or "Window"
	TitleBar.Font = Enum.Font.GothamBold
	TitleBar.TextSize = 16
	TitleBar.Parent = Main

	local Container = Instance.new("Frame")
	Container.BackgroundTransparency = 1
	Container.Size = UDim2.new(1, 0, 1, -30)
	Container.Position = UDim2.new(0, 0, 0, 30)
	Container.Parent = Main

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = Container

	local Tab = {}

	function Tab:CreateButton(text, callback)
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.new(1, -10, 0, 30)
		Btn.Position = UDim2.new(0, 5, 0, 0)
		Btn.Text = text
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 14
		Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.Parent = Container
		Btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
	end

	function Tab:CreateToggle(text, callback)
		local Toggle = Instance.new("TextButton")
		Toggle.Size = UDim2.new(1, -10, 0, 30)
		Toggle.Position = UDim2.new(0, 5, 0, 0)
		Toggle.Text = text .. ": OFF"
		Toggle.Font = Enum.Font.Gotham
		Toggle.TextSize = 14
		Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		Toggle.Parent = Container

		local state = false
		Toggle.MouseButton1Click:Connect(function()
			state = not state
			Toggle.Text = text .. (state and ": ON" or ": OFF")
			pcall(callback, state)
		end)
	end

	function Tab:CreateSlider(text, min, max, default, callback)
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.new(1, -10, 0, 50)
		Frame.Position = UDim2.new(0, 5, 0, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Frame.Parent = Container

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.new(1, 0, 0, 20)
		Label.BackgroundTransparency = 1
		Label.Text = text .. ": " .. tostring(default)
		Label.TextColor3 = Color3.new(1, 1, 1)
		Label.Font = Enum.Font.Gotham
		Label.TextSize = 14
		Label.Parent = Frame

		local Slider = Instance.new("TextButton")
		Slider.Size = UDim2.new(1, -10, 0, 20)
		Slider.Position = UDim2.new(0, 5, 0, 25)
		Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		Slider.Text = ""
		Slider.AutoButtonColor = false
		Slider.Parent = Frame

		local Fill = Instance.new("Frame")
		Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
		Fill.Parent = Slider

		local dragging = false

		Slider.InputBegan:Connect(function(input)
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
				local rel = math.clamp((input.Position.X - Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X, 0, 1)
				local val = math.floor(min + (max - min)*rel)
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				Label.Text = text .. ": " .. tostring(val)
				pcall(callback, val)
			end
		end)
	end

	return Tab
end

return Library
