local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	local startTime = os.clock()

	repeat
		LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
			task.wait(0.1)
		end
	until LocalPlayer or os.clock() - startTime > 15

	if not LocalPlayer then
		return
	end
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

if not PlayerGui then
	local startTime = os.clock()

	repeat
		PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if not PlayerGui then
			task.wait(0.1)
		end
	until PlayerGui or os.clock() - startTime > 15
end

if not PlayerGui then
	return
end

local oldGui = PlayerGui:FindFirstChild("StableTargetGui")

if oldGui then
	oldGui:Destroy()
	task.wait()
end

local TargetName = ""
local RotationSpeed = 6
local RotationDistance = 5
local CurrentLanguage = "RU"
local InitialMenuClosed = false

local DARK_COLOR = Color3.fromRGB(18, 23, 31)
local PANEL_COLOR = Color3.fromRGB(30, 38, 50)
local INNER_COLOR = Color3.fromRGB(35, 45, 58)
local TEXT_COLOR = Color3.fromRGB(245, 250, 255)
local CYAN = Color3.fromRGB(50, 225, 235)
local PURPLE = Color3.fromRGB(150, 110, 255)
local GREEN = Color3.fromRGB(55, 225, 145)
local RED = Color3.fromRGB(235, 75, 85)
local ACCENT_FONT = Enum.Font.GothamBold

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StableTargetGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.IgnoreGuiInset = false
ScreenGui.Parent = PlayerGui

local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = obj
	return c
end

local function stroke(obj, thickness)
	local s = Instance.new("UIStroke")
	s.Thickness = thickness or 1.5
	s.Transparency = 0.15
	s.Color = CYAN
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

local function gradient(obj, c1, c2, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, c1),
		ColorSequenceKeypoint.new(1, c2)
	})
	g.Rotation = rotation or 0
	g.Parent = obj
	return g
end

local function makeDraggable(obj)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = obj.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	obj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart

			obj.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function pulseColor()
	local t = (math.sin(os.clock() * 1.7) + 1) / 2

	local r = math.floor(50 + (150 - 50) * t)
	local g = math.floor(220 + (110 - 220) * t)
	local b = math.floor(235 + (255 - 235) * t)

	return Color3.fromRGB(r, g, b)
end

local LanguageText = {
	RU = {
		initialTitle = "скрипт сделан сообществом Etraxon",
		telegram = "Телеграм-канал",
		mainMenu = "MENU",
		speed = "СКОРОСТЬ",
		distance = "ДАЛЬНОСТЬ",
		target = "ТЕКУЩАЯ ЦЕЛЬ...",
		stick = "ПРИКЛЕИТЬСЯ",
		spin = "КРУТИТЬСЯ",
		orbit = "ОРБИТА",
		float = "КАЧАНИЕ",
		antisit = "АНТИ-СИТ",
		jitter = "ХАОТИЧНЫЙ РЫВОК",
		selectPlayer = "ВЫБРАТЬ ИГРОКА",
		closeList = "ЗАКРЫТЬ СПИСОК",
		refresh = "ОБНОВИТЬ СПИСОК",
		language = "ЯЗЫК",
		russian = "РУССКИЙ",
		english = "АНГЛИЙСКИЙ",
		copied = "Ссылка скопирована"
	},

	EN = {
		initialTitle = "script made by Etraxon community",
		telegram = "Telegram channel",
		mainMenu = "MENU",
		speed = "SPEED",
		distance = "DISTANCE",
		target = "CURRENT TARGET...",
		stick = "STICK",
		spin = "SPIN",
		orbit = "ORBIT",
		float = "FLOAT",
		antisit = "ANTI-SIT",
		jitter = "CHAOTIC JERK",
		selectPlayer = "SELECT PLAYER",
		closeList = "CLOSE LIST",
		refresh = "REFRESH LIST",
		language = "LANGUAGE",
		russian = "RUSSIAN",
		english = "ENGLISH",
		copied = "Link copied"
	}
}

local function T(key)
	return LanguageText[CurrentLanguage][key]
end

local InitialFrame = Instance.new("Frame")
InitialFrame.Name = "InitialFrame"
InitialFrame.Size = UDim2.new(0, 390, 0, 255)
InitialFrame.Position = UDim2.new(0.5, -195, 0.42, -128)
InitialFrame.BackgroundColor3 = DARK_COLOR
InitialFrame.BackgroundTransparency = 0.08
InitialFrame.BorderSizePixel = 0
InitialFrame.Parent = ScreenGui
corner(InitialFrame, 18)
gradient(
	InitialFrame,
	Color3.fromRGB(28, 45, 58),
	Color3.fromRGB(45, 35, 65),
	25
)

local InitialStroke = stroke(InitialFrame, 2)

local InitialGlow = Instance.new("Frame")
InitialGlow.Size = UDim2.new(1, -10, 1, -10)
InitialGlow.Position = UDim2.new(0, 5, 0, 5)
InitialGlow.BackgroundTransparency = 1
InitialGlow.BorderSizePixel = 0
InitialGlow.ZIndex = 0
InitialGlow.Parent = InitialFrame
corner(InitialGlow, 15)

local InitialTitle = Instance.new("TextLabel")
InitialTitle.Size = UDim2.new(1, -35, 0, 55)
InitialTitle.Position = UDim2.new(0, 17, 0, 32)
InitialTitle.BackgroundTransparency = 1
InitialTitle.TextColor3 = TEXT_COLOR
InitialTitle.Text = T("initialTitle")
InitialTitle.Font = Enum.Font.GothamBold
InitialTitle.TextSize = 17
InitialTitle.TextWrapped = true
InitialTitle.Parent = InitialFrame

local TelegramButton = Instance.new("TextButton")
TelegramButton.Size = UDim2.new(0, 245, 0, 43)
TelegramButton.Position = UDim2.new(0.5, -122, 0, 105)
TelegramButton.BackgroundColor3 = INNER_COLOR
TelegramButton.BackgroundTransparency = 0.05
TelegramButton.TextColor3 = TEXT_COLOR
TelegramButton.Text = T("telegram")
TelegramButton.Font = ACCENT_FONT
TelegramButton.TextSize = 14
TelegramButton.BorderSizePixel = 0
TelegramButton.Parent = InitialFrame
corner(TelegramButton, 12)
gradient(
	TelegramButton,
	Color3.fromRGB(40, 80, 95),
	Color3.fromRGB(65, 55, 95),
	0
)
stroke(TelegramButton, 1)

local InitialClose = Instance.new("TextButton")
InitialClose.Size = UDim2.new(0, 60, 0, 48)
InitialClose.Position = UDim2.new(0.5, -30, 1, -62)
InitialClose.BackgroundColor3 = Color3.fromRGB(45, 38, 48)
InitialClose.BackgroundTransparency = 0.1
InitialClose.TextColor3 = Color3.fromRGB(255, 100, 115)
InitialClose.Text = "×"
InitialClose.Font = Enum.Font.GothamBold
InitialClose.TextSize = 36
InitialClose.BorderSizePixel = 0
InitialClose.Parent = InitialFrame
corner(InitialClose, 12)
stroke(InitialClose, 1)

local InitialMenuButton = Instance.new("TextButton")
InitialMenuButton.Name = "InitialMenuButton"
InitialMenuButton.Size = UDim2.new(0, 100, 0, 55)
InitialMenuButton.Position = UDim2.new(0.5, -345, 0.42, -28)
InitialMenuButton.BackgroundColor3 = PANEL_COLOR
InitialMenuButton.BackgroundTransparency = 0.05
InitialMenuButton.TextColor3 = TEXT_COLOR
InitialMenuButton.Text = T("mainMenu")
InitialMenuButton.Font = ACCENT_FONT
InitialMenuButton.TextSize = 15
InitialMenuButton.BorderSizePixel = 0
InitialMenuButton.Parent = ScreenGui
corner(InitialMenuButton, 15)
gradient(
	InitialMenuButton,
	Color3.fromRGB(40, 85, 100),
	Color3.fromRGB(75, 55, 105),
	45
)

local InitialMenuStroke = stroke(InitialMenuButton, 2)

makeDraggable(InitialFrame)
makeDraggable(InitialMenuButton)

InitialMenuButton.MouseButton1Click:Connect(function()
	InitialFrame.Visible = not InitialFrame.Visible
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 285)
MainFrame.Position = UDim2.new(0.5, -210, 0.4, -142)
MainFrame.BackgroundColor3 = DARK_COLOR
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
corner(MainFrame, 18)
gradient(
	MainFrame,
	Color3.fromRGB(27, 43, 55),
	Color3.fromRGB(43, 34, 61),
	25
)

local MainStroke = stroke(MainFrame, 2)

local MainInner = Instance.new("Frame")
MainInner.Size = UDim2.new(1, -12, 1, -12)
MainInner.Position = UDim2.new(0, 6, 0, 6)
MainInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainInner.BackgroundTransparency = 0.96
MainInner.BorderSizePixel = 0
MainInner.Parent = MainFrame
corner(MainInner, 14)

makeDraggable(MainFrame)

local SettingsHolder = Instance.new("Frame")
SettingsHolder.Name = "SettingsHolder"
SettingsHolder.Size = UDim2.new(0, 500, 0, 63)
SettingsHolder.Position = UDim2.new(0, 0, 0, -72)
SettingsHolder.BackgroundTransparency = 1
SettingsHolder.Parent = MainFrame

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0, 420, 0, 58)
SettingsFrame.Position = UDim2.new(0, 0, 0, 0)
SettingsFrame.BackgroundColor3 = PANEL_COLOR
SettingsFrame.BackgroundTransparency = 0.08
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Parent = SettingsHolder
corner(SettingsFrame, 17)
gradient(
	SettingsFrame,
	Color3.fromRGB(37, 72, 82),
	Color3.fromRGB(62, 52, 91),
	0
)

local SettingsStroke = stroke(SettingsFrame, 2)

local function createSetting(labelText, x, value)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 150, 0, 20)
	Label.Position = UDim2.new(0, x, 0, 5)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = TEXT_COLOR
	Label.Text = labelText
	Label.Font = ACCENT_FONT
	Label.TextSize = 13
	Label.Parent = SettingsFrame

	local Box = Instance.new("TextBox")
	Box.Size = UDim2.new(0, 150, 0, 27)
	Box.Position = UDim2.new(0, x, 0, 27)
	Box.BackgroundColor3 = Color3.fromRGB(42, 53, 67)
	Box.BackgroundTransparency = 0.05
	Box.TextColor3 = TEXT_COLOR
	Box.Text = tostring(value)
	Box.PlaceholderText = tostring(value)
	Box.ClearTextOnFocus = false
	Box.Font = ACCENT_FONT
	Box.TextSize = 12
	Box.BorderSizePixel = 0
	Box.Parent = SettingsFrame
	corner(Box, 10)

	local boxStroke = stroke(Box, 1)
	boxStroke.Color = Color3.fromRGB(100, 210, 225)

	return Label, Box
end

local SpeedLabel, SpeedBox = createSetting(
	T("speed"),
	10,
	RotationSpeed
)

local DistanceLabel, DistanceBox = createSetting(
	T("distance"),
	210,
	RotationDistance
)

local GearButton = Instance.new("TextButton")
GearButton.Size = UDim2.new(0, 62, 0, 58)
GearButton.Position = UDim2.new(0, 430, 0, 0)
GearButton.BackgroundColor3 = PANEL_COLOR
GearButton.BackgroundTransparency = 0.05
GearButton.TextColor3 = TEXT_COLOR
GearButton.Text = "⚙"
GearButton.Font = Enum.Font.GothamBold
GearButton.TextSize = 27
GearButton.BorderSizePixel = 0
GearButton.Parent = SettingsHolder
corner(GearButton, 17)
gradient(
	GearButton,
	Color3.fromRGB(48, 65, 77),
	Color3.fromRGB(67, 55, 87),
	45
)

local GearStroke = stroke(GearButton, 2)

local LanguageFrame = Instance.new("Frame")
LanguageFrame.Name = "LanguageFrame"
LanguageFrame.Size = UDim2.new(0, 210, 0, 140)
LanguageFrame.Position = UDim2.new(0, 205, 0, 65)
LanguageFrame.BackgroundColor3 = PANEL_COLOR
LanguageFrame.BackgroundTransparency = 0.04
LanguageFrame.BorderSizePixel = 0
LanguageFrame.Visible = false
LanguageFrame.ZIndex = 50
LanguageFrame.Parent = SettingsHolder
corner(LanguageFrame, 15)
gradient(
	LanguageFrame,
	Color3.fromRGB(35, 60, 70),
	Color3.fromRGB(55, 45, 78),
	20
)

local LanguageStroke = stroke(LanguageFrame, 2)

local LanguageTitle = Instance.new("TextLabel")
LanguageTitle.Size = UDim2.new(1, -16, 0, 25)
LanguageTitle.Position = UDim2.new(0, 8, 0, 5)
LanguageTitle.BackgroundTransparency = 1
LanguageTitle.TextColor3 = TEXT_COLOR
LanguageTitle.Text = T("language")
LanguageTitle.Font = ACCENT_FONT
LanguageTitle.TextSize = 12
LanguageTitle.ZIndex = 51
LanguageTitle.Parent = LanguageFrame

local RussianButton = Instance.new("TextButton")
RussianButton.Size = UDim2.new(1, -16, 0, 39)
RussianButton.Position = UDim2.new(0, 8, 0, 35)
RussianButton.BackgroundColor3 = INNER_COLOR
RussianButton.TextColor3 = TEXT_COLOR
RussianButton.Text = T("russian")
RussianButton.Font = ACCENT_FONT
RussianButton.TextSize = 11
RussianButton.BorderSizePixel = 0
RussianButton.ZIndex = 51
RussianButton.Parent = LanguageFrame
corner(RussianButton, 9)
stroke(RussianButton, 1)

local EnglishButton = Instance.new("TextButton")
EnglishButton.Size = UDim2.new(1, -16, 0, 39)
EnglishButton.Position = UDim2.new(0, 8, 0, 82)
EnglishButton.BackgroundColor3 = INNER_COLOR
EnglishButton.TextColor3 = TEXT_COLOR
EnglishButton.Text = T("english")
EnglishButton.Font = ACCENT_FONT
EnglishButton.TextSize = 11
EnglishButton.BorderSizePixel = 0
EnglishButton.ZIndex = 51
EnglishButton.Parent = LanguageFrame
corner(EnglishButton, 9)
stroke(EnglishButton, 1)

local NameInput = Instance.new("TextBox")
NameInput.Size = UDim2.new(0, 390, 0, 38)
NameInput.Position = UDim2.new(0.5, -195, 0, 13)
NameInput.BackgroundColor3 = Color3.fromRGB(20, 30, 39)
NameInput.BackgroundTransparency = 0.03
NameInput.TextColor3 = TEXT_COLOR
NameInput.Text = ""
NameInput.PlaceholderText = T("target")
NameInput.Font = ACCENT_FONT
NameInput.TextSize = 12
NameInput.BorderSizePixel = 0
NameInput.Parent = MainFrame
corner(NameInput, 12)

local NameStroke = stroke(NameInput, 1)
NameStroke.Color = Color3.fromRGB(55, 210, 220)

NameInput.FocusLost:Connect(function()
	TargetName = NameInput.Text
end)

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Size = UDim2.new(1, -20, 0, 165)
ButtonsContainer.Position = UDim2.new(0, 10, 0, 58)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = MainFrame

local ButtonsGrid = Instance.new("UIGridLayout")
ButtonsGrid.CellSize = UDim2.new(0, 185, 0, 42)
ButtonsGrid.CellPadding = UDim2.new(0, 10, 0, 8)
ButtonsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonsGrid.Parent = ButtonsContainer

local states = {
	Stick = false,
	Spin = false,
	Orbit = false,
	Float = false,
	AntiSit = false,
	Jitter = false
}

local buttonObjects = {}

local function getButtonName(key)
	if key == "Stick" then
		return T("stick")
	elseif key == "Spin" then
		return T("spin")
	elseif key == "Orbit" then
		return T("orbit")
	elseif key == "Float" then
		return T("float")
	elseif key == "AntiSit" then
		return T("antisit")
	elseif key == "Jitter" then
		return T("jitter")
	end

	return key
end

local function createButton(key)
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = INNER_COLOR
	btn.BackgroundTransparency = 0.02
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.Parent = ButtonsContainer
	corner(btn, 14)

	local btnGradient = gradient(
		btn,
		Color3.fromRGB(55, 72, 84),
		Color3.fromRGB(48, 55, 73),
		0
	)

	local btnStroke = stroke(btn, 1)
	btnStroke.Color = Color3.fromRGB(125, 205, 220)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -65, 1, 0)
	title.Position = UDim2.new(0, 13, 0, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = TEXT_COLOR
	title.Text = getButtonName(key)
	title.Font = ACCENT_FONT
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = btn

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0, 48, 0, 25)
	toggle.Position = UDim2.new(1, -58, 0.5, -12)
	toggle.BackgroundColor3 = Color3.fromRGB(75, 82, 90)
	toggle.BorderSizePixel = 0
	toggle.Parent = btn
	corner(toggle, 20)

	local toggleStroke = stroke(toggle, 1)
	toggleStroke.Transparency = 0.5
	toggleStroke.Color = Color3.fromRGB(170, 180, 190)

	local toggleDot = Instance.new("Frame")
	toggleDot.Size = UDim2.new(0, 19, 0, 19)
	toggleDot.Position = UDim2.new(0, 3, 0.5, -9)
	toggleDot.BackgroundColor3 = Color3.fromRGB(175, 185, 190)
	toggleDot.BorderSizePixel = 0
	toggleDot.Parent = toggle
	corner(toggleDot, 20)

	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1, 0, 1, 0)
	status.BackgroundTransparency = 1
	status.TextColor3 = Color3.fromRGB(235, 235, 235)
	status.Text = "OFF"
	status.Font = ACCENT_FONT
	status.TextSize = 7
	status.Parent = toggle

	local function updateVisual()
		title.Text = getButtonName(key)

		if states[key] then
			toggle.BackgroundColor3 = GREEN
			toggleDot.Position = UDim2.new(1, -22, 0.5, -9)
			toggleDot.BackgroundColor3 = Color3.fromRGB(240, 255, 250)
			status.Text = CurrentLanguage == "RU" and "ВКЛ" or "ON"
			status.TextColor3 = Color3.fromRGB(20, 55, 40)
			btnGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 105, 105)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 70, 82))
			})
		else
			toggle.BackgroundColor3 = Color3.fromRGB(82, 87, 92)
			toggleDot.Position = UDim2.new(0, 3, 0.5, -9)
			toggleDot.BackgroundColor3 = Color3.fromRGB(180, 185, 190)
			status.Text = CurrentLanguage == "RU" and "ВЫКЛ" or "OFF"
			status.TextColor3 = Color3.fromRGB(235, 235, 235)
			btnGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 72, 84)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 55, 73))
			})
		end
	end

	btn.MouseButton1Click:Connect(function()
		states[key] = not states[key]

		if key ~= "AntiSit" and states[key] then
			for otherKey in pairs(states) do
				if otherKey ~= key and otherKey ~= "AntiSit" then
					states[otherKey] = false
				end
			end
      end

      buttonObjects[key] = {
		button = btn,
		title = title,
		update = updateVisual
	}

	updateVisual()
end

createButton("Stick")
createButton("Spin")
createButton("Orbit")
createButton("Float")
createButton("AntiSit")
createButton("Jitter")

local ListToggleBtn = Instance.new("TextButton")
ListToggleBtn.Size = UDim2.new(0, 390, 0, 38)
ListToggleBtn.Position = UDim2.new(0.5, -195, 1, -48)
ListToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 44, 53)
ListToggleBtn.BackgroundTransparency = 0.03
ListToggleBtn.Text = T("selectPlayer")
ListToggleBtn.TextColor3 = TEXT_COLOR
ListToggleBtn.Font = ACCENT_FONT
ListToggleBtn.TextSize = 11
ListToggleBtn.BorderSizePixel = 0
ListToggleBtn.Parent = MainFrame
corner(ListToggleBtn, 12)
gradient(
	ListToggleBtn,
	Color3.fromRGB(48, 72, 82),
	Color3.fromRGB(57, 55, 76),
	0
)

local ListStroke = stroke(ListToggleBtn, 1)
ListStroke.Color = Color3.fromRGB(90, 210, 220)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(0, 390, 0, 170)
PlayerListFrame.Position = UDim2.new(0.5, -195, 0, 58)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(25, 34, 43)
PlayerListFrame.BackgroundTransparency = 0.02
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 20
PlayerListFrame.Parent = MainFrame
corner(PlayerListFrame, 14)
gradient(
	PlayerListFrame,
	Color3.fromRGB(40, 65, 74),
	Color3.fromRGB(53, 45, 70),
	20
)

stroke(PlayerListFrame, 1.5)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -8, 1, -38)
ScrollFrame.Position = UDim2.new(0, 4, 0, 4)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = CYAN
ScrollFrame.ZIndex = 21
ScrollFrame.Parent = PlayerListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Parent = ScrollFrame

local ManualRefreshBtn = Instance.new("TextButton")
ManualRefreshBtn.Size = UDim2.new(1, -8, 0, 29)
ManualRefreshBtn.Position = UDim2.new(0, 4, 1, -33)
ManualRefreshBtn.BackgroundColor3 = Color3.fromRGB(44, 56, 66)
ManualRefreshBtn.Text = T("refresh")
ManualRefreshBtn.TextColor3 = TEXT_COLOR
ManualRefreshBtn.Font = ACCENT_FONT
ManualRefreshBtn.TextSize = 9
ManualRefreshBtn.ZIndex = 22
ManualRefreshBtn.BorderSizePixel = 0
ManualRefreshBtn.Parent = PlayerListFrame
corner(ManualRefreshBtn, 9)
stroke(ManualRefreshBtn, 1)

local function updatePlayerList()
	for _, child in ipairs(ScrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local pBtn = Instance.new("TextButton")
			pBtn.Size = UDim2.new(0, 370, 0, 28)
			pBtn.BackgroundColor3 = Color3.fromRGB(39, 51, 62)
			pBtn.Text = player.Name
			pBtn.TextColor3 = TEXT_COLOR
			pBtn.Font = Enum.Font.GothamBold
			pBtn.TextSize = 11
			pBtn.BorderSizePixel = 0
			pBtn.ZIndex = 22
			pBtn.Parent = ScrollFrame
			corner(pBtn, 8)

			pBtn.MouseButton1Click:Connect(function()
				TargetName = player.Name
				NameInput.Text = player.Name
				PlayerListFrame.Visible = false
				ListToggleBtn.Text = T("selectPlayer")
			end)
		end
	end

	ScrollFrame.CanvasSize = UDim2.new(
		0,
		0,
		0,
		ListLayout.AbsoluteContentSize.Y + 5
	)
end

ListToggleBtn.MouseButton1Click:Connect(function()
	PlayerListFrame.Visible = not PlayerListFrame.Visible

	if PlayerListFrame.Visible then
		ListToggleBtn.Text = T("closeList")
		updatePlayerList()
	else
		ListToggleBtn.Text = T("selectPlayer")
	end
end)

ManualRefreshBtn.MouseButton1Click:Connect(updatePlayerList)

Players.PlayerAdded:Connect(function()
	if PlayerListFrame.Visible then
		task.defer(updatePlayerList)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if TargetName == player.Name then
		TargetName = ""
		NameInput.Text = ""
	end

	if PlayerListFrame.Visible then
		task.defer(updatePlayerList)
	end
end)

local MainToggleButton = Instance.new("TextButton")
MainToggleButton.Name = "MainToggleButton"
MainToggleButton.Size = UDim2.new(0, 100, 0, 55)
MainToggleButton.Position = UDim2.new(0.5, -345, 0.4, -28)
MainToggleButton.BackgroundColor3 = PANEL_COLOR
MainToggleButton.BackgroundTransparency = 0.05
MainToggleButton.TextColor3 = TEXT_COLOR
MainToggleButton.Text = T("mainMenu")
MainToggleButton.Font = ACCENT_FONT
MainToggleButton.TextSize = 15
MainToggleButton.BorderSizePixel = 0
MainToggleButton.Visible = false
MainToggleButton.Parent = ScreenGui
corner(MainToggleButton, 15)
gradient(
	MainToggleButton,
	Color3.fromRGB(40, 85, 100),
	Color3.fromRGB(75, 55, 105),
	45
)

local MainToggleStroke = stroke(MainToggleButton, 2)

makeDraggable(MainToggleButton)

MainToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible

	if MainFrame.Visible then
		LanguageFrame.Visible = false
	else
		PlayerListFrame.Visible = false
	end
end)

GearButton.MouseButton1Click:Connect(function()
	LanguageFrame.Visible = not LanguageFrame.Visible
end)

local function updateLanguage()
	InitialTitle.Text = T("initialTitle")
	TelegramButton.Text = T("telegram")

	if InitialMenuButton and InitialMenuButton.Parent then
		InitialMenuButton.Text = T("mainMenu")
	end

	if MainToggleButton and MainToggleButton.Parent then
		MainToggleButton.Text = T("mainMenu")
	end

	SpeedLabel.Text = T("speed")
	DistanceLabel.Text = T("distance")
	NameInput.PlaceholderText = T("target")

	if PlayerListFrame.Visible then
		ListToggleBtn.Text = T("closeList")
	else
		ListToggleBtn.Text = T("selectPlayer")
	end

	ManualRefreshBtn.Text = T("refresh")
	LanguageTitle.Text = T("language")
	RussianButton.Text = T("russian")
	EnglishButton.Text = T("english")

	for _, data in pairs(buttonObjects) do
		if data and data.update then
			data.update()
		end
	end
end

RussianButton.MouseButton1Click:Connect(function()
	CurrentLanguage = "RU"
	LanguageFrame.Visible = false
	updateLanguage()
end)

EnglishButton.MouseButton1Click:Connect(function()
	CurrentLanguage = "EN"
	LanguageFrame.Visible = false
	updateLanguage()
end)

SpeedBox.FocusLost:Connect(function()
	local value = tonumber(SpeedBox.Text)

	if value then
		RotationSpeed = math.clamp(value, 0.1, 100)
	else
		SpeedBox.Text = tostring(RotationSpeed)
		return
	end

	SpeedBox.Text = tostring(RotationSpeed)
end)

DistanceBox.FocusLost:Connect(function()
	local value = tonumber(DistanceBox.Text)

	if value then
		RotationDistance = math.clamp(value, 0, 200)
	else
		DistanceBox.Text = tostring(RotationDistance)
		return
	end

	DistanceBox.Text = tostring(RotationDistance)
end)

TelegramButton.MouseButton1Click:Connect(function()
	local success = pcall(function()
		if setclipboard then
			setclipboard("https://t.me/Etraxon")
		elseif toclipboard then
			toclipboard("https://t.me/Etraxon")
		else
			error("Clipboard unavailable")
		end
	end)

	if success then
		TelegramButton.Text = T("copied")

		task.delay(1.5, function()
			if TelegramButton and TelegramButton.Parent then
				TelegramButton.Text = T("telegram")
			end
		end)
	end
end)

InitialClose.MouseButton1Click:Connect(function()
	if InitialMenuClosed then
		return
	end

	InitialMenuClosed = true

	if InitialFrame and InitialFrame.Parent then
		InitialFrame:Destroy()
	end

	if InitialMenuButton and InitialMenuButton.Parent then
		InitialMenuButton:Destroy()
	end

	MainFrame.Visible = true
	MainToggleButton.Visible = true
end)

local angle = 0
local waveTime = 0
local lastJitter = 0

RunService.Heartbeat:Connect(function(dt)
	if not ScreenGui or not ScreenGui.Parent then
		return
	end

	local color = pulseColor()

	if MainStroke and MainStroke.Parent then
		MainStroke.Color = color
	end

	if MainToggleStroke and MainToggleStroke.Parent then
		MainToggleStroke.Color = color
	end

	if InitialFrame and InitialFrame.Parent then
		InitialStroke.Color = color
	end

	if InitialMenuButton and InitialMenuButton.Parent then
		InitialMenuStroke.Color = color
	end

	if SettingsFrame and SettingsFrame.Parent then
		SettingsStroke.Color = color
	end

	if GearButton and GearButton.Parent then
		GearStroke.Color = color
	end

	if LanguageFrame and LanguageFrame.Parent then
		LanguageStroke.Color = color
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	local targetPlayer =
		TargetName ~= "" and Players:FindFirstChild(TargetName)

	local targetHrp =
		targetPlayer
		and targetPlayer.Character
		and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

	if hum and states.AntiSit then
		hum.Sit = false
	end

	if targetHrp and hrp then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero

		if states.Stick then
			hrp.CFrame =
				targetHrp.CFrame
				* CFrame.new(0, RotationDistance, 0)

		elseif states.Spin then
			angle = angle + (dt * RotationSpeed)

			local position =
				targetHrp.Position
				+ Vector3.new(
					math.cos(angle) * RotationDistance,
					0,
					math.sin(angle) * RotationDistance
				)

			hrp.CFrame =
				CFrame.new(position, targetHrp.Position)

		elseif states.Orbit then
			angle = angle + (dt * RotationSpeed)

			local position =
				targetHrp.Position
				+ Vector3.new(
					math.cos(angle) * RotationDistance,
					RotationDistance * 0.3
						+ math.sin(angle * 0.5)
						* (RotationDistance * 0.5),
					math.sin(angle) * RotationDistance
				)

			hrp.CFrame =
				CFrame.new(position, targetHrp.Position)

		elseif states.Float then
			waveTime = waveTime + dt

			local vertical =
				RotationDistance
				+ math.sin(waveTime * 2)
				* math.max(RotationDistance * 0.35, 0.5)

			hrp.CFrame =
				(targetHrp.CFrame * CFrame.new(0, vertical, 2))
				* CFrame.Angles(
					math.sin(waveTime * 2) * 0.25,
					0,
					math.cos(waveTime * 2) * 0.25
				)

		elseif states.Jitter then
			local jitterDelay =
				math.clamp(
					0.15 / math.max(RotationSpeed / 6, 0.1),
					0.015,
					0.2
				)

			if os.clock() - lastJitter > jitterDelay then
				lastJitter = os.clock()

				local distance =
					math.max(RotationDistance, 1)

				local randomPos =
					Vector3.new(
						math.random(-100, 100) / 100 * distance,
						math.random(-50, 100) / 100 * distance,
						math.random(-100, 100) / 100 * distance
					)

				hrp.CFrame =
					CFrame.new(
						targetHrp.Position + randomPos,
						targetHrp.Position
					)
			end
		end
	end
end)

updateLanguage()
