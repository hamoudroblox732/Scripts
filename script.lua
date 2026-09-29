local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local PASSWORD = "HAMOUDY"
local TRIGGER_TIME = 4
local DETECTION_DISTANCE = 25
local SPIN_SPEED = math.rad(10000000)

local unlocked = false
local autoEnabled = false
local noClipEnabled = false
local spinning = false
local spinConnection = nil
local rainbowTime = 0

local gui = Instance.new("ScreenGui")
gui.Name = "BombPanel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function makeDraggable(frame, handle)
	local dragging = false
	local dragStart
	local startPosition

	handle = handle or frame

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local login = Instance.new("Frame")
login.Size = UDim2.fromOffset(205, 145)
login.Position = UDim2.new(0, 18, 0.5, -72)
login.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
login.BorderSizePixel = 0
login.Active = true
login.Parent = gui

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 12)
loginCorner.Parent = login

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "BOMB PANEL"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = login

local loginRights = Instance.new("TextLabel")
loginRights.Size = UDim2.new(1, -20, 0, 28)
loginRights.Position = UDim2.fromOffset(10, 29)
loginRights.BackgroundTransparency = 1
loginRights.Text = "HAMOUD"
loginRights.TextColor3 = Color3.new(1, 1, 1)
loginRights.TextSize = 21
loginRights.Font = Enum.Font.GothamBlack
loginRights.Parent = login

local password = Instance.new("TextBox")
password.Size = UDim2.new(1, -20, 0, 32)
password.Position = UDim2.fromOffset(10, 60)
password.PlaceholderText = "Password"
password.Text = ""
password.TextColor3 = Color3.new(1, 1, 1)
password.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
password.BorderSizePixel = 0
password.ClearTextOnFocus = false
password.Parent = login

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 8)
passwordCorner.Parent = password

local unlock = Instance.new("TextButton")
unlock.Size = UDim2.new(1, -20, 0, 32)
unlock.Position = UDim2.fromOffset(10, 98)
unlock.Text = "UNLOCK"
unlock.TextColor3 = Color3.new(1, 1, 1)
unlock.TextSize = 13
unlock.Font = Enum.Font.GothamBold
unlock.BackgroundColor3 = Color3.fromRGB(55, 105, 210)
unlock.BorderSizePixel = 0
unlock.Parent = login

local unlockCorner = Instance.new("UICorner")
unlockCorner.CornerRadius = UDim.new(0, 8)
unlockCorner.Parent = unlock

local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1, -20, 0, 16)
errorText.Position = UDim2.fromOffset(10, 132)
errorText.BackgroundTransparency = 1
errorText.Text = ""
errorText.TextColor3 = Color3.fromRGB(255, 75, 75)
errorText.TextSize = 10
errorText.Parent = login

makeDraggable(login, title)

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(190, 195)
panel.Position = UDim2.new(0, 18, 0.5, 75)
panel.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
panel.BorderSizePixel = 0
panel.Active = true
panel.Visible = false
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, -45, 0, 28)
panelTitle.Position = UDim2.fromOffset(8, 3)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "BOMB PANEL"
panelTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
panelTitle.TextSize = 14
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Parent = panel

local panelRights = Instance.new("TextLabel")
panelRights.Size = UDim2.new(1, -45, 0, 28)
panelRights.Position = UDim2.fromOffset(8, 29)
panelRights.BackgroundTransparency = 1
panelRights.Text = "HAMOUD"
panelRights.TextColor3 = Color3.new(1, 1, 1)
panelRights.TextSize = 20
panelRights.Font = Enum.Font.GothamBlack
panelRights.TextXAlignment = Enum.TextXAlignment.Left
panelRights.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -37, 0, 6)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.BackgroundColor3 = Color3.fromRGB(150, 42, 48)
close.BorderSizePixel = 0
close.Parent = panel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, -12, 0, 55)
autoButton.Position = UDim2.fromOffset(6, 65)
autoButton.Text = "AUTO  •  OFF"
autoButton.TextColor3 = Color3.fromRGB(245, 245, 245)
autoButton.TextSize = 14
autoButton.Font = Enum.Font.GothamBold
autoButton.BackgroundColor3 = Color3.fromRGB(150, 42, 48)
autoButton.BorderSizePixel = 0
autoButton.Parent = panel

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 9)
autoCorner.Parent = autoButton

local noClipButton = Instance.new("TextButton")
noClipButton.Size = UDim2.new(1, -12, 0, 55)
noClipButton.Position = UDim2.fromOffset(6, 123)
noClipButton.Text = "NOCLIP  •  OFF"
noClipButton.TextColor3 = Color3.fromRGB(245, 245, 245)
noClipButton.TextSize = 14
noClipButton.Font = Enum.Font.GothamBold
noClipButton.BackgroundColor3 = Color3.fromRGB(150, 42, 48)
noClipButton.BorderSizePixel = 0
noClipButton.Parent = panel

local noClipCorner = Instance.new("UICorner")
noClipCorner.CornerRadius = UDim.new(0, 9)
noClipCorner.Parent = noClipButton

makeDraggable(panel, panelTitle)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(70, 70)
reopen.Position = UDim2.new(0, 18, 0.5, 75)
reopen.Text = "💣"
reopen.TextSize = 28
reopen.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.BorderSizePixel = 0
reopen.Visible = false
reopen.Parent = gui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 12)
reopenCorner.Parent = reopen

local reopenRights = Instance.new("TextLabel")
reopenRights.Size = UDim2.new(1, 0, 0, 18)
reopenRights.Position = UDim2.new(0, 0, 1, -19)
reopenRights.BackgroundTransparency = 1
reopenRights.Text = "HAMOUD"
reopenRights.TextSize = 10
reopenRights.Font = Enum.Font.GothamBlack
reopenRights.Parent = reopen

makeDraggable(reopen, reopen)

local function updateButtons()
	if autoEnabled then
		autoButton.Text = "AUTO  •  ON"
		autoButton.BackgroundColor3 = Color3.fromRGB(40, 175, 85)
	else
		autoButton.Text = "AUTO  •  OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(150, 42, 48)
	end

	if noClipEnabled then
		noClipButton.Text = "NOCLIP  •  ON"
		noClipButton.BackgroundColor3 = Color3.fromRGB(40, 175, 85)
	else
		noClipButton.Text = "NOCLIP  •  OFF"
		noClipButton.BackgroundColor3 = Color3.fromRGB(150, 42, 48)
	end
end

local function getCharacter()
	return player.Character
end

local function getRoot(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getHeldTool()
	local character = getCharacter()

	if not character then
		return nil
	end

	for _, object in ipairs(character:GetChildren()) do
		if object:IsA("Tool") then
			return object
		end
	end

	return nil
end

local function getNearestPlayer()
	local character = getCharacter()
	local root = getRoot(character)

	if not root then
		return nil
	end

	local nearest = nil
	local nearestDistance = DETECTION_DISTANCE

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local otherCharacter = otherPlayer.Character
			local otherRoot = getRoot(otherCharacter)
			local humanoid = getHumanoid(otherCharacter)

			if otherRoot and humanoid and humanoid.Health > 0 then
				local distance = (otherRoot.Position - root.Position).Magnitude

				if distance <= nearestDistance then
					nearestDistance = distance
					nearest = otherPlayer
				end
			end
		end
	end

	return nearest
end

local function getNumberFromText(text)
	if typeof(text) ~= "string" then
		return nil
	end

	local number = string.match(text, "%d+%.?%d*")

	if number then
		return tonumber(number)
	end

	return nil
end

local function findTimer(tool)
	for _, object in ipairs(tool:GetDescendants()) do
		if object:IsA("IntValue") or object:IsA("NumberValue") then
			local value = tonumber(object.Value)

			if value and value >= 0 and value <= 10 then
				return value
			end
		end

		if object:IsA("TextLabel")
			or object:IsA("TextButton")
			or object:IsA("TextBox") then

			local value = getNumberFromText(object.Text)

			if value and value >= 0 and value <= 10 then
				return value
			end
		end
	end

	for _, value in pairs(tool:GetAttributes()) do
		if typeof(value) == "number"
			and value >= 0
			and value <= 10 then
			return value
		end
	end

	return nil
end

local function stopSpin()
	spinning = false

	if spinConnection then
		spinConnection:Disconnect()
		spinConnection = nil
	end
end

local function startSpin()
	if spinning then
		return
	end

	spinning = true

	spinConnection = RunService.Heartbeat:Connect(function(deltaTime)
		local character = getCharacter()
		local root = getRoot(character)
		local humanoid = getHumanoid(character)
		local tool = getHeldTool()
		local target = getNearestPlayer()

		if not root or not humanoid or humanoid.Health <= 0 or not tool or not target then
			stopSpin()
			return
		end

		local targetRoot = getRoot(target.Character)

		if not targetRoot then
			stopSpin()
			return
		end

		humanoid:MoveTo(targetRoot.Position)

		root.CFrame =
			root.CFrame *
			CFrame.Angles(0, SPIN_SPEED * deltaTime, 0)
	end)
end

unlock.MouseButton1Click:Connect(function()
	if password.Text == PASSWORD then
		unlocked = true
		login.Visible = false
		panel.Visible = true
	else
		errorText.Text = "WRONG PASSWORD"
		password.Text = ""
	end
end)

autoButton.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled

	if not autoEnabled then
		stopSpin()
	end

	updateButtons()
end)

noClipButton.MouseButton1Click:Connect(function()
	noClipEnabled = not noClipEnabled
	updateButtons()
end)

close.MouseButton1Click:Connect(function()
	panel.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	panel.Visible = true
	reopen.Visible = false
end)

RunService.Stepped:Connect(function()
	if not noClipEnabled then
		return
	end

	local character = getCharacter()

	if character then
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CanCollide = false
			end
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if not unlocked or not autoEnabled then
		return
	end

	local character = getCharacter()
	local humanoid = getHumanoid(character)
	local tool = getHeldTool()
	local target = getNearestPlayer()

	if not humanoid or humanoid.Health <= 0 or not tool or not target then
		stopSpin()
		return
	end

	local targetRoot = getRoot(target.Character)

	if not targetRoot then
		stopSpin()
		return
	end

	humanoid:MoveTo(targetRoot.Position)

	local timer = findTimer(tool)

	if timer and timer <= TRIGGER_TIME and timer > 0 then
		startSpin()
	else
		stopSpin()
	end
end)

player.CharacterAdded:Connect(function()
	stopSpin()
end)

task.spawn(function()
	while true do
		task.wait(0.03)

		rainbowTime = rainbowTime + 0.02

		local rainbow = Color3.fromHSV((rainbowTime * 0.15) % 1, 1, 1)

		loginRights.TextColor3 = rainbow
		panelRights.TextColor3 = rainbow
		reopenRights.TextColor3 = rainbow
	end
end)

updateButtons()
