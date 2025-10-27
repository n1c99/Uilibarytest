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
	Gui.ResetOnSpawn = false
	Gui.Parent = game.CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 484, 0, 270)
	Main.Position = UDim2.new(0, 144, 0, 4)
	Main.BackgroundColor3 = Themes[self.Theme].Main
	Main.Active = true
	Main.Draggable = true
	Main.Parent = Gui

	local Topbar = Instance.new("TextLabel")
	Topbar.Size = UDim2.new(0, 484, 0, 22)
	Topbar.BackgroundColor3 = Themes[self.Theme].Secondary
	Topbar.TextColor3 = Themes[self.Theme].Text
	Topbar.Font = Enum.Font.GothamBold
	Topbar.TextSize = 16
	Topbar.Text = name or "Window"
	Topbar.Parent = Main

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(0, 482, 0, 30)
	TabHolder.Position = UDim2.new(0, 2, 0, 26)
	TabHolder.BackgroundColor3 = Themes[self.Theme].Secondary
	TabHolder.Parent = Main

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(0, 482, 0, 210)
	ContentHolder.Position = UDim2.new(0, 2, 0, 60)
	ContentHolder.BackgroundColor3 = Themes[self.Theme].Main
	ContentHolder.Parent = Main

	local Tabs = {}

	function Tabs:CreateTab(tabName)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(0, 70, 0, 30)
		TabButton.BackgroundColor3 = Themes[self.Theme].Secondary
		TabButton.TextColor3 = Themes[self.Theme].Text
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
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local padding = Instance.new("UIPadding", Page)
		padding.PaddingLeft = UDim.new(0, 6)
		padding.PaddingTop = UDim.new(0, 6)

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

		return Section
	end

	return Tabs
end

return Library
