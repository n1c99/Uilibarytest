local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.Theme = "Light"

local Themes = {
	Dark = {
		Main = Color3.fromRGB(30, 30, 30),
		Secondary = Color3.fromRGB(45, 45, 45),
		Text = Color3.fromRGB(255, 255, 255),
		Accent = Color3.fromRGB(0, 170, 255)
	},
	Light = {
		Main = Color3.fromRGB(240, 240, 240),
		Secondary = Color3.fromRGB(220, 220, 220),
		Text = Color3.fromRGB(0, 0, 0),
		Accent = Color3.fromRGB(0, 120, 255)
	}
}

function Library:SetTheme(theme)
	if Themes[theme] then
		self.Theme = theme
	end
end

function Library:CreateWindow(name)
	local Gui = Instance.new("ScreenGui")
	Gui.Name = name or "Window"
	Gui.ResetOnSpawn = false
	Gui.Parent = game.CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.BackgroundColor3 = Themes[self.Theme].Main
	Main.Active = true
	Main.Draggable = true
	Main.Parent = Gui

	local Topbar = Instance.new("TextLabel")
	Topbar.Size = UDim2.new(1, 0, 0, 35)
	Topbar.BackgroundColor3 = Themes[self.Theme].Secondary
	Topbar.TextColor3 = Themes[self.Theme].Text
	Topbar.Font = Enum.Font.GothamBold
	Topbar.TextSize = 16
	Topbar.Text = name or "Window"
	Topbar.Parent = Main

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(0, 130, 1, -35)
	TabHolder.Position = UDim2.new(0, 0, 0, 35)
	TabHolder.BackgroundColor3 = Themes[self.Theme].Secondary
	TabHolder.Parent = Main

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(1, -130, 1, -35)
	ContentHolder.Position = UDim2.new(0, 130, 0, 35)
	ContentHolder.BackgroundTransparency = 1
	ContentHolder.Parent = Main

	local Tabs = {}

	function Tabs:CreateTab(tabName)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.BackgroundTransparency = 1
		TabButton.TextColor3 = Themes[Library.Theme].Text
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14
		TabButton.Text = tabName
		TabButton.Parent = TabHolder

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.ScrollBarThickness = 4
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.Parent = ContentHolder

		local layout = Instance.new("UIListLayout", Page)
		layout.Padding = UDim.new(0, 6)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		TabButton.MouseButton1Click:Connect(function()
			for _, other in pairs(ContentHolder:GetChildren()) do
				if other:IsA("ScrollingFrame") then
					other.Visible = false
				end
			end
			Page.Visible = true
		end)

		local Section = {}

		function Section:CreateButton(text, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Themes[Library.Theme].Secondary
			btn.TextColor3 = Themes[Library.Theme].Text
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Text = text
			btn.Parent = Page
			btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function Section:CreateToggle(text, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -10, 0, 30)
			Frame.BackgroundColor3 = Themes[Library.Theme].Secondary
			Frame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -40, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Themes[Library.Theme].Text
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Text = text
			Label.Parent = Frame

			local ToggleBtn = Instance.new("Frame")
			ToggleBtn.Size = UDim2.new(0, 24, 0, 24)
			ToggleBtn.Position = UDim2.new(1, -30, 0.5, -12)
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			ToggleBtn.Parent = Frame

			local on = false
			Frame.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					on = not on
					local goal = on and Themes[Library.Theme].Accent or Color3.fromRGB(80, 80, 80)
					TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goal}):Play()
					pcall(callback, on)
				end
			end)
		end

		function Section:CreateSlider(text, min, max, default, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -10, 0, 40)
			Frame.BackgroundColor3 = Themes[Library.Theme].Secondary
			Frame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -10, 0, 20)
			Label.Position = UDim2.new(0, 5, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Themes[Library.Theme].Text
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.Text = text .. ": " .. default
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new(1, -10, 0, 6)
			Bar.Position = UDim2.new(0, 5, 1, -12)
			Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Bar.Parent = Frame

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = Themes[Library.Theme].Accent
			Fill.Parent = Bar

			local dragging = false
			Bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UIS.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					local value = math.floor(min + (max - min) * pos)
					Label.Text = text .. ": " .. value
					pcall(callback, value)
				end
			end)
		end

		function Section:CreateDropdown(text, list, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -10, 0, 30)
			Frame.BackgroundColor3 = Themes[Library.Theme].Secondary
			Frame.Parent = Page

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -40, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Themes[Library.Theme].Text
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.Text = text
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Frame

			local DropBtn = Instance.new("TextButton")
			DropBtn.Size = UDim2.new(0, 60, 1, 0)
			DropBtn.Position = UDim2.new(1, -70, 0, 0)
			DropBtn.BackgroundColor3 = Themes[Library.Theme].Accent
			DropBtn.TextColor3 = Color3.new(1,1,1)
			DropBtn.Font = Enum.Font.Gotham
			DropBtn.TextSize = 14
			DropBtn.Text = "▼"
			DropBtn.Parent = Frame

			local open = false
			local ListFrame = Instance.new("Frame")
			ListFrame.Size = UDim2.new(1, -10, 0, #list * 25)
			ListFrame.Position = UDim2.new(0, 5, 1, 5)
			ListFrame.BackgroundColor3 = Themes[Library.Theme].Secondary
			ListFrame.Visible = false
			ListFrame.Parent = Frame

			local layout = Instance.new("UIListLayout", ListFrame)
			layout.Padding = UDim.new(0, 2)

			for _, opt in ipairs(list) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Size = UDim2.new(1, 0, 0, 25)
				OptBtn.BackgroundTransparency = 1
				OptBtn.TextColor3 = Themes[Library.Theme].Text
				OptBtn.Font = Enum.Font.Gotham
				OptBtn.TextSize = 14
				OptBtn.Text = opt
				OptBtn.Parent = ListFrame
				OptBtn.MouseButton1Click:Connect(function()
					ListFrame.Visible = false
					open = false
					Label.Text = text .. ": " .. opt
					pcall(callback, opt)
				end)
			end

			DropBtn.MouseButton1Click:Connect(function()
				open = not open
				ListFrame.Visible = open
			end)
		end

		function Section:CreateTextbox(placeholder, callback)
			local Box = Instance.new("TextBox")
			Box.Size = UDim2.new(1, -10, 0, 30)
			Box.BackgroundColor3 = Themes[Library.Theme].Secondary
			Box.Text = ""
			Box.PlaceholderText = placeholder or "Enter text..."
			Box.TextColor3 = Themes[Library.Theme].Text
			Box.Font = Enum.Font.Gotham
			Box.TextSize = 14
			Box.ClearTextOnFocus = false
			Box.Parent = Page

			Box.FocusLost:Connect(function()
				pcall(callback, Box.Text)
			end)
		end

		Page.Visible = (#ContentHolder:GetChildren() == 1)
		return Section
	end

	return Tabs
end

return Library
