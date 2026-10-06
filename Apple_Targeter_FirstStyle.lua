local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("StableTargetGui")
if old then old:Destroy() end

local TargetName = ""
local RotationSpeed = 6
local RotationDistance = 5

local states = {
	Stick = false,
	Spin = false,
	Orbit = false,
	Float = false,
	AntiSit = false,
	Jitter = false
}

local DARK = Color3.fromRGB(12, 13, 18)
local PANEL = Color3.fromRGB(18, 18, 23)
local INNER = Color3.fromRGB(24, 25, 31)
local BUTTON = Color3.fromRGB(28, 29, 36)
local TEXT = Color3.fromRGB(245, 245, 250)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StableTargetGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = obj
	return c
end

local function rgbStroke(obj, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1.5
	stroke.Transparency = 0
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 70)),
		ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 140, 0)),
		ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 235, 0)),
		ColorSequenceKeypoint.new(0.48, Color3.fromRGB(0, 255, 140)),
		ColorSequenceKeypoint.new(0.64, Color3.fromRGB(0, 190, 255)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(150, 60, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 70))
	})
	gradient.Parent = stroke
	stroke.Parent = obj
	return stroke
end

local function makeDraggable(obj)
	local dragging = false
	local dragStart
	local startPos
	local dragInput

	obj.Active = true

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
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 0.4, -160)
MainFrame.BackgroundColor3 = DARK
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 12)
rgbStroke(MainFrame, 1.6)
makeDraggable(MainFrame)

local TopAccent = Instance.new("Frame")
TopAccent.Size = UDim2.new(1, 0, 0, 2)
TopAccent.BorderSizePixel = 0
TopAccent.Parent = MainFrame

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 70)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 210, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 160)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 180, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 255))
})
AccentGradient.Parent = TopAccent

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 32)
Title.Position = UDim2.new(0, 16, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "APPLE TARGETER"
Title.TextColor3 = TEXT
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -100, 0, 20)
SubTitle.Position = UDim2.new(0, 16, 0, 29)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "TARGET CONTROL"
SubTitle.TextColor3 = Color3.fromRGB(125, 130, 145)
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 8
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = MainFrame

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 27, 0, 27)
MinButton.Position = UDim2.new(1, -68, 0, 10)
MinButton.BackgroundColor3 = BUTTON
MinButton.Text = "–"
MinButton.TextColor3 = Color3.fromRGB(220, 220, 225)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 18
MinButton.BorderSizePixel = 0
MinButton.Parent = MainFrame
corner(MinButton, 7)
rgbStroke(MinButton, 1)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 27, 0, 27)
CloseButton.Position = UDim2.new(1, -36, 0, 10)
CloseButton.BackgroundColor3 = BUTTON
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(235, 80, 100)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame
corner(CloseButton, 7)
rgbStroke(CloseButton, 1)

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0, 440, 0, 58)
SettingsFrame.Position = UDim2.new(0, 0, 0, -66)
SettingsFrame.BackgroundColor3 = PANEL
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Parent = MainFrame
corner(SettingsFrame, 10)
rgbStroke(SettingsFrame, 1.5)

local function createSetting(title, x, value)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 180, 0, 17)
	label.Position = UDim2.new(0, x, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = title
	label.TextColor3 = Color3.fromRGB(185, 188, 198)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 9
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = SettingsFrame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 180, 0, 27)
	box.Position = UDim2.new(0, x, 0, 25)
	box.BackgroundColor3 = INNER
	box.TextColor3 = TEXT
	box.Text = tostring(value)
	box.PlaceholderText = tostring(value)
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.BorderSizePixel = 0
	box.Parent = SettingsFrame
	corner(box, 7)
	rgbStroke(box, 1)

	return box
end

local SpeedBox = createSetting("СКОРОСТЬ", 10, RotationSpeed)
local DistanceBox = createSetting("ДАЛЬНОСТЬ", 230, RotationDistance)

local NameInput = Instance.new("TextBox")
NameInput.Size = UDim2.new(1, -32, 0, 36)
NameInput.Position = UDim2.new(0, 16, 0, 50)
NameInput.BackgroundColor3 = INNER
NameInput.TextColor3 = TEXT
NameInput.PlaceholderText = "ТЕКУЩАЯ ЦЕЛЬ..."
NameInput.ClearTextOnFocus = false
NameInput.Font = Enum.Font.GothamBold
NameInput.TextSize = 11
NameInput.BorderSizePixel = 0
NameInput.Parent = MainFrame
corner(NameInput, 8)
rgbStroke(NameInput, 1)

NameInput.FocusLost:Connect(function()
	TargetName = NameInput.Text
end)

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Size = UDim2.new(1, -32, 0, 165)
ButtonsContainer.Position = UDim2.new(0, 16, 0, 94)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = MainFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 200, 0, 43)
Grid.CellPadding = UDim2.new(0, 8, 0, 7)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ButtonsContainer

local buttonObjects = {}

local names = {
	Stick = "ПРИКЛЕИТЬСЯ",
	Spin = "КРУТИТЬСЯ",
	Orbit = "ОРБИТА",
	Float = "КАЧАНИЕ",
	AntiSit = "АНТИ-СИТ",
	Jitter = "ХАОТИЧНЫЙ РЫВОК"
}

local function createToggle(key)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = BUTTON
	button.Text = ""
	button.BorderSizePixel = 0
	button.Parent = ButtonsContainer
	corner(button, 8)
	rgbStroke(button, 1)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -62, 1, 0)
	title.Position = UDim2.new(0, 12, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = names[key]
	title.TextColor3 = TEXT
	title.Font = Enum.Font.GothamBold
	title.TextSize = 9
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = button

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0, 44, 0, 22)
	toggle.Position = UDim2.new(1, -54, 0.5, -11)
	toggle.BackgroundColor3 = Color3.fromRGB(55, 56, 63)
	toggle.BorderSizePixel = 0
	toggle.Parent = button
	corner(toggle, 20)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 16, 0, 16)
	dot.Position = UDim2.new(0, 3, 0.5, -8)
	dot.BackgroundColor3 = Color3.fromRGB(180, 182, 188)
	dot.BorderSizePixel = 0
	dot.Parent = toggle
	corner(dot, 20)

	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1, 0, 1, 0)
	status.BackgroundTransparency = 1
	status.Text = "ВЫКЛ"
	status.TextColor3 = Color3.fromRGB(210, 210, 215)
	status.Font = Enum.Font.GothamBold
	status.TextSize = 6
	status.Parent = toggle

	local function update()
		if states[key] then
			toggle.BackgroundColor3 = Color3.fromRGB(0, 205, 135)
			dot.Position = UDim2.new(1, -19, 0.5, -8)
			dot.BackgroundColor3 = Color3.fromRGB(245, 255, 250)
			status.Text = "ВКЛ"
			status.TextColor3 = Color3.fromRGB(15, 55, 40)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(55, 56, 63)
			dot.Position = UDim2.new(0, 3, 0.5, -8)
			dot.BackgroundColor3 = Color3.fromRGB(180, 182, 188)
			status.Text = "ВЫКЛ"
			status.TextColor3 = Color3.fromRGB(210, 210, 215)
		end
	end

	button.MouseButton1Click:Connect(function()
		states[key] = not states[key]

		if key ~= "AntiSit" and states[key] then
			for other in pairs(states) do
				if other ~= key and other ~= "AntiSit" then
					states[other] = false
				end
			end
		end

		for _, data in pairs(buttonObjects) do
			data.update()
		end
	end)

	buttonObjects[key] = {update = update}
	update()
end

createToggle("Stick")
createToggle("Spin")
createToggle("Orbit")
createToggle("Float")
createToggle("AntiSit")
createToggle("Jitter")

local ListToggleBtn = Instance.new("TextButton")
ListToggleBtn.Size = UDim2.new(1, -32, 0, 34)
ListToggleBtn.Position = UDim2.new(0, 16, 1, -45)
ListToggleBtn.BackgroundColor3 = PANEL
ListToggleBtn.Text = "ВЫБРАТЬ ИГРОКА"
ListToggleBtn.TextColor3 = TEXT
ListToggleBtn.Font = Enum.Font.GothamBold
ListToggleBtn.TextSize = 9
ListToggleBtn.BorderSizePixel = 0
ListToggleBtn.Parent = MainFrame
corner(ListToggleBtn, 8)
rgbStroke(ListToggleBtn, 1)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -32, 0, 170)
PlayerListFrame.Position = UDim2.new(0, 16, 0, 92)
PlayerListFrame.BackgroundColor3 = PANEL
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 20
PlayerListFrame.Parent = MainFrame
corner(PlayerListFrame, 9)
rgbStroke(PlayerListFrame, 1.4)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ZIndex = 21
ScrollFrame.Parent = PlayerListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Parent = ScrollFrame

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(1, -10, 0, 28)
RefreshButton.Position = UDim2.new(0, 5, 1, -33)
RefreshButton.BackgroundColor3 = BUTTON
RefreshButton.Text = "ОБНОВИТЬ СПИСОК"
RefreshButton.TextColor3 = TEXT
RefreshButton.Font = Enum.Font.GothamBold
RefreshButton.TextSize = 8
RefreshButton.BorderSizePixel = 0
RefreshButton.ZIndex = 22
RefreshButton.Parent = PlayerListFrame
corner(RefreshButton, 7)
rgbStroke(RefreshButton, 1)

local function updatePlayerList()
	for _, child in ipairs(ScrollFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local pButton = Instance.new("TextButton")
			pButton.Size = UDim2.new(1, -4, 0, 28)
			pButton.BackgroundColor3 = BUTTON
			pButton.Text = player.Name
			pButton.TextColor3 = TEXT
			pButton.Font = Enum.Font.GothamBold
			pButton.TextSize = 9
			pButton.BorderSizePixel = 0
			pButton.ZIndex = 22
			pButton.Parent = ScrollFrame
			corner(pButton, 6)
			rgbStroke(pButton, 0.8)

			pButton.MouseButton1Click:Connect(function()
				TargetName = player.Name
				NameInput.Text = player.Name
				PlayerListFrame.Visible = false
				ListToggleBtn.Text = "ВЫБРАТЬ ИГРОКА"
			end)
		end
	end

	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end

ListToggleBtn.MouseButton1Click:Connect(function()
	PlayerListFrame.Visible = not PlayerListFrame.Visible
	if PlayerListFrame.Visible then
		ListToggleBtn.Text = "ЗАКРЫТЬ СПИСОК"
		updatePlayerList()
	else
		ListToggleBtn.Text = "ВЫБРАТЬ ИГРОКА"
	end
end)

RefreshButton.MouseButton1Click:Connect(updatePlayerList)

Players.PlayerAdded:Connect(function()
	if PlayerListFrame.Visible then task.defer(updatePlayerList) end
end)

Players.PlayerRemoving:Connect(function(player)
	if TargetName == player.Name then
		TargetName = ""
		NameInput.Text = ""
	end
	if PlayerListFrame.Visible then task.defer(updatePlayerList) end
end)

SpeedBox.FocusLost:Connect(function()
	local value = tonumber(SpeedBox.Text)
	if value then
		RotationSpeed = math.clamp(value, 0.1, 100)
		SpeedBox.Text = tostring(RotationSpeed)
	else
		SpeedBox.Text = tostring(RotationSpeed)
	end
end)

DistanceBox.FocusLost:Connect(function()
	local value = tonumber(DistanceBox.Text)
	if value then
		RotationDistance = math.clamp(value, 0, 200)
		DistanceBox.Text = tostring(RotationDistance)
	else
		DistanceBox.Text = tostring(RotationDistance)
	end
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 35)
ToggleButton.Position = UDim2.new(0.5, -50, 0.05, 0)
ToggleButton.BackgroundColor3 = PANEL
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = TEXT
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.BorderSizePixel = 0
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui
corner(ToggleButton, 8)
rgbStroke(ToggleButton, 1.5)
makeDraggable(ToggleButton)

MinButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	ToggleButton.Visible = false
end)

local angle = 0
local waveTime = 0
local lastJitter = 0

RunService.Heartbeat:Connect(function(dt)
	if not ScreenGui.Parent then return end

	local character = LocalPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local targetPlayer = TargetName ~= "" and Players:FindFirstChild(TargetName)
	local targetHrp = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

	if humanoid and states.AntiSit then humanoid.Sit = false end

	if targetHrp and hrp then
		if states.Stick then
			hrp.CFrame = targetHrp.CFrame * CFrame.new(0, RotationDistance, 0)

		elseif states.Spin then
			angle += dt * RotationSpeed
			local position = targetHrp.Position + Vector3.new(
				math.cos(angle) * RotationDistance,
				0,
				math.sin(angle) * RotationDistance
			)
			hrp.CFrame = CFrame.new(position, targetHrp.Position)

		elseif states.Orbit then
			angle += dt * RotationSpeed
			local position = targetHrp.Position + Vector3.new(
				math.cos(angle) * RotationDistance,
				RotationDistance * 0.3 + math.sin(angle * 0.5) * (RotationDistance * 0.5),
				math.sin(angle) * RotationDistance
			)
			hrp.CFrame = CFrame.new(position, targetHrp.Position)

		elseif states.Float then
			waveTime += dt
			local vertical = RotationDistance + math.sin(waveTime * 2) * math.max(RotationDistance * 0.35, 0.5)
			hrp.CFrame = (targetHrp.CFrame * CFrame.new(0, vertical, 2)) *
				CFrame.Angles(math.sin(waveTime * 2) * 0.25, 0, math.cos(waveTime * 2) * 0.25)

		elseif states.Jitter then
			local delayTime = math.clamp(0.15 / math.max(RotationSpeed / 6, 0.1), 0.015, 0.2)
			if os.clock() - lastJitter > delayTime then
				lastJitter = os.clock()
				local d = math.max(RotationDistance, 1)
				local randomPos = Vector3.new(
					math.random(-100, 100) / 100 * d,
					math.random(-50, 100) / 100 * d,
					math.random(-100, 100) / 100 * d
				)
				hrp.CFrame = CFrame.new(targetHrp.Position + randomPos, targetHrp.Position)
			end
		end
	end
end)
