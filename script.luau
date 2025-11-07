-- LocalScript - Place in StarterPlayer > StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Variables
local savedPosition = nil
local teleportSpeed = 5 -- Default speed (1-10, higher = faster)

-- Function to make frames draggable (only from header)
local function makeDraggableFromHeader(frame, dragArea)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

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

	dragArea.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, 
				startPos.X.Offset + delta.X, 
				startPos.Y.Scale, 
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Simple draggable for toggle button
local function makeDraggable(frame)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	frame.InputBegan:Connect(function(input)
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

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, 
				startPos.X.Offset + delta.X, 
				startPos.Y.Scale, 
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 85, 255)
toggleButton.Text = "Hide UI"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.ZIndex = 10
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Create Main Frame (now taller for speed controls)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 85, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Header (This is the drag area)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(45, 85, 255)
header.BorderSizePixel = 0
header.ZIndex = 6
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(45, 85, 255)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 6
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Teleporter"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 7
title.Parent = header

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.ZIndex = 8
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Current Position Display
local currentPosFrame = Instance.new("Frame")
currentPosFrame.Size = UDim2.new(1, -20, 0, 80)
currentPosFrame.Position = UDim2.new(0, 10, 0, 60)
currentPosFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
currentPosFrame.BorderSizePixel = 0
currentPosFrame.ZIndex = 6
currentPosFrame.Parent = mainFrame

local currentPosCorner = Instance.new("UICorner")
currentPosCorner.CornerRadius = UDim.new(0, 8)
currentPosCorner.Parent = currentPosFrame

local currentPosLabel = Instance.new("TextLabel")
currentPosLabel.Size = UDim2.new(1, -10, 0, 25)
currentPosLabel.Position = UDim2.new(0, 5, 0, 5)
currentPosLabel.BackgroundTransparency = 1
currentPosLabel.Text = "📍 Current Position"
currentPosLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
currentPosLabel.Font = Enum.Font.GothamBold
currentPosLabel.TextSize = 14
currentPosLabel.TextXAlignment = Enum.TextXAlignment.Left
currentPosLabel.ZIndex = 7
currentPosLabel.Parent = currentPosFrame

local currentPosText = Instance.new("TextLabel")
currentPosText.Size = UDim2.new(1, -10, 0, 45)
currentPosText.Position = UDim2.new(0, 5, 0, 30)
currentPosText.BackgroundTransparency = 1
currentPosText.Text = "X: 0\nY: 0\nZ: 0"
currentPosText.TextColor3 = Color3.new(1, 1, 1)
currentPosText.Font = Enum.Font.Code
currentPosText.TextSize = 12
currentPosText.TextXAlignment = Enum.TextXAlignment.Left
currentPosText.TextYAlignment = Enum.TextYAlignment.Top
currentPosText.ZIndex = 7
currentPosText.Parent = currentPosFrame

-- Saved Position Display
local savedPosFrame = Instance.new("Frame")
savedPosFrame.Size = UDim2.new(1, -20, 0, 80)
savedPosFrame.Position = UDim2.new(0, 10, 0, 150)
savedPosFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
savedPosFrame.BorderSizePixel = 0
savedPosFrame.ZIndex = 6
savedPosFrame.Parent = mainFrame

local savedPosCorner = Instance.new("UICorner")
savedPosCorner.CornerRadius = UDim.new(0, 8)
savedPosCorner.Parent = savedPosFrame

local savedPosLabel = Instance.new("TextLabel")
savedPosLabel.Size = UDim2.new(1, -10, 0, 25)
savedPosLabel.Position = UDim2.new(0, 5, 0, 5)
savedPosLabel.BackgroundTransparency = 1
savedPosLabel.Text = "💾 Saved Position"
savedPosLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
savedPosLabel.Font = Enum.Font.GothamBold
savedPosLabel.TextSize = 14
savedPosLabel.TextXAlignment = Enum.TextXAlignment.Left
savedPosLabel.ZIndex = 7
savedPosLabel.Parent = savedPosFrame

local savedPosText = Instance.new("TextLabel")
savedPosText.Size = UDim2.new(1, -10, 0, 45)
savedPosText.Position = UDim2.new(0, 5, 0, 30)
savedPosText.BackgroundTransparency = 1
savedPosText.Text = "No position saved"
savedPosText.TextColor3 = Color3.fromRGB(150, 150, 150)
savedPosText.Font = Enum.Font.Code
savedPosText.TextSize = 12
savedPosText.TextXAlignment = Enum.TextXAlignment.Left
savedPosText.TextYAlignment = Enum.TextYAlignment.Top
savedPosText.ZIndex = 7
savedPosText.Parent = savedPosFrame

-- Speed Control Frame
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 60)
speedFrame.Position = UDim2.new(0, 10, 0, 240)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedFrame.BorderSizePixel = 0
speedFrame.ZIndex = 6
speedFrame.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Speed: 5"
speedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 7
speedLabel.Parent = speedFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(1, -20, 0, 6)
speedSlider.Position = UDim2.new(0, 10, 0, 35)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedSlider.BorderSizePixel = 0
speedSlider.ZIndex = 7
speedSlider.Parent = speedFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = speedSlider

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
speedFill.BorderSizePixel = 0
speedFill.ZIndex = 8
speedFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = speedFill

local speedKnob = Instance.new("TextButton")
speedKnob.Size = UDim2.new(0, 20, 0, 20)
speedKnob.Position = UDim2.new(0.5, -10, 0.5, -10)
speedKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedKnob.Text = ""
speedKnob.ZIndex = 9
speedKnob.Parent = speedSlider

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = speedKnob

-- Speed slider functionality
local draggingSlider = false
speedKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

RunService.RenderStepped:Connect(function()
	if draggingSlider then
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = speedSlider.AbsolutePosition
		local sliderSize = speedSlider.AbsoluteSize
		
		local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		
		teleportSpeed = math.floor(percentage * 10) + 1 -- 1 to 11
		if teleportSpeed > 10 then teleportSpeed = 10 end
		
		speedKnob.Position = UDim2.new(percentage, -10, 0.5, -10)
		speedFill.Size = UDim2.new(percentage, 0, 1, 0)
		speedLabel.Text = "⚡ Speed: " .. teleportSpeed
	end
end)

-- Set Position Button
local setButton = Instance.new("TextButton")
setButton.Name = "SetButton"
setButton.Size = UDim2.new(1, -20, 0, 45)
setButton.Position = UDim2.new(0, 10, 0, 310)
setButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
setButton.Text = "📍 Set Position"
setButton.TextColor3 = Color3.new(1, 1, 1)
setButton.Font = Enum.Font.GothamBold
setButton.TextSize = 16
setButton.ZIndex = 7
setButton.AutoButtonColor = true
setButton.Parent = mainFrame

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0, 8)
setCorner.Parent = setButton

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -20, 0, 45)
teleportButton.Position = UDim2.new(0, 10, 0, 365)
teleportButton.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
teleportButton.Text = "⚡ Teleport"
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 16
teleportButton.ZIndex = 7
teleportButton.AutoButtonColor = true
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

-- Make toggle button draggable
makeDraggable(toggleButton)

-- Make main frame draggable from header only
makeDraggableFromHeader(mainFrame, header)

-- Update current position display
local function updateCurrentPosition()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local pos = character.HumanoidRootPart.Position
		currentPosText.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z)
	end
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggleButton.Text = mainFrame.Visible and "Hide UI" or "Show UI"
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	toggleButton.Text = "Show UI"
end)

-- Set position functionality
setButton.MouseButton1Click:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		savedPosition = character.HumanoidRootPart.Position
		savedPosText.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", savedPosition.X, savedPosition.Y, savedPosition.Z)
		savedPosText.TextColor3 = Color3.new(1, 1, 1)
		
		-- Visual feedback
		setButton.BackgroundColor3 = Color3.fromRGB(70, 255, 120)
		task.wait(0.1)
		setButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
	end
end)

-- Teleport functionality with bypass method
teleportButton.MouseButton1Click:Connect(function()
	if savedPosition then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
			local hrp = character.HumanoidRootPart
			local humanoid = character.Humanoid
			
			-- Calculate steps based on speed (1=slowest, 10=fastest)
			local maxSteps = 20
			local steps = math.max(2, maxSteps - (teleportSpeed * 2))
			local delay = math.max(0.001, 0.03 - (teleportSpeed * 0.002))
			
			local startPos = hrp.Position
			local endPos = savedPosition
			
			-- Anti-detection methods
			hrp.Anchored = true -- Prevent physics interference
			
			-- Move in steps with RunService for smoother movement
			local connection
			local currentStep = 0
			
			connection = RunService.Heartbeat:Connect(function()
				currentStep = currentStep + 1
				if currentStep >= steps then
					connection:Disconnect()
					hrp.CFrame = CFrame.new(endPos)
					hrp.Anchored = false
					hrp.Velocity = Vector3.new(0, 0, 0)
					hrp.RotVelocity = Vector3.new(0, 0, 0)
				else
					local alpha = currentStep / steps
					local newPos = startPos:Lerp(endPos, alpha)
					hrp.CFrame = CFrame.new(newPos)
				end
			end)
			
			-- Visual feedback
			teleportButton.BackgroundColor3 = Color3.fromRGB(200, 120, 255)
			task.wait(0.1)
			teleportButton.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
		end
	else
		-- No position saved feedback
		local originalText = teleportButton.Text
		teleportButton.Text = "❌ No Position!"
		task.wait(1)
		teleportButton.Text = originalText
	end
end)

-- Update position every frame
RunService.RenderStepped:Connect(updateCurrentPosition)

print("Teleport GUI Loaded Successfully!")
