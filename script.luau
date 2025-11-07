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
local stepDistance = 3 -- Distance per step in studs (1-20)
local waitTime = 0.1 -- Wait time between steps (0.01-1.0)

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

-- Create Main Frame (now taller for controls)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 520)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -260)
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

-- Step Distance Control Frame
local stepFrame = Instance.new("Frame")
stepFrame.Size = UDim2.new(1, -20, 0, 60)
stepFrame.Position = UDim2.new(0, 10, 0, 240)
stepFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
stepFrame.BorderSizePixel = 0
stepFrame.ZIndex = 6
stepFrame.Parent = mainFrame

local stepCorner = Instance.new("UICorner")
stepCorner.CornerRadius = UDim.new(0, 8)
stepCorner.Parent = stepFrame

local stepLabel = Instance.new("TextLabel")
stepLabel.Size = UDim2.new(1, -10, 0, 20)
stepLabel.Position = UDim2.new(0, 5, 0, 5)
stepLabel.BackgroundTransparency = 1
stepLabel.Text = "📏 Step Distance: 3 studs"
stepLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
stepLabel.Font = Enum.Font.GothamBold
stepLabel.TextSize = 14
stepLabel.TextXAlignment = Enum.TextXAlignment.Left
stepLabel.ZIndex = 7
stepLabel.Parent = stepFrame

local stepSlider = Instance.new("Frame")
stepSlider.Size = UDim2.new(1, -20, 0, 6)
stepSlider.Position = UDim2.new(0, 10, 0, 35)
stepSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
stepSlider.BorderSizePixel = 0
stepSlider.ZIndex = 7
stepSlider.Parent = stepFrame

local stepSliderCorner = Instance.new("UICorner")
stepSliderCorner.CornerRadius = UDim.new(1, 0)
stepSliderCorner.Parent = stepSlider

local stepFill = Instance.new("Frame")
stepFill.Size = UDim2.new(0.1, 0, 1, 0)
stepFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
stepFill.BorderSizePixel = 0
stepFill.ZIndex = 8
stepFill.Parent = stepSlider

local stepFillCorner = Instance.new("UICorner")
stepFillCorner.CornerRadius = UDim.new(1, 0)
stepFillCorner.Parent = stepFill

local stepKnob = Instance.new("TextButton")
stepKnob.Size = UDim2.new(0, 20, 0, 20)
stepKnob.Position = UDim2.new(0.1, -10, 0.5, -10)
stepKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
stepKnob.Text = ""
stepKnob.ZIndex = 9
stepKnob.Parent = stepSlider

local stepKnobCorner = Instance.new("UICorner")
stepKnobCorner.CornerRadius = UDim.new(1, 0)
stepKnobCorner.Parent = stepKnob

-- Wait Time Control Frame
local waitFrame = Instance.new("Frame")
waitFrame.Size = UDim2.new(1, -20, 0, 60)
waitFrame.Position = UDim2.new(0, 10, 0, 310)
waitFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
waitFrame.BorderSizePixel = 0
waitFrame.ZIndex = 6
waitFrame.Parent = mainFrame

local waitCorner = Instance.new("UICorner")
waitCorner.CornerRadius = UDim.new(0, 8)
waitCorner.Parent = waitFrame

local waitLabel = Instance.new("TextLabel")
waitLabel.Size = UDim2.new(1, -10, 0, 20)
waitLabel.Position = UDim2.new(0, 5, 0, 5)
waitLabel.BackgroundTransparency = 1
waitLabel.Text = "⏱️ Wait Time: 0.10s"
waitLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
waitLabel.Font = Enum.Font.GothamBold
waitLabel.TextSize = 14
waitLabel.TextXAlignment = Enum.TextXAlignment.Left
waitLabel.ZIndex = 7
waitLabel.Parent = waitFrame

local waitSlider = Instance.new("Frame")
waitSlider.Size = UDim2.new(1, -20, 0, 6)
waitSlider.Position = UDim2.new(0, 10, 0, 35)
waitSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
waitSlider.BorderSizePixel = 0
waitSlider.ZIndex = 7
waitSlider.Parent = waitFrame

local waitSliderCorner = Instance.new("UICorner")
waitSliderCorner.CornerRadius = UDim.new(1, 0)
waitSliderCorner.Parent = waitSlider

local waitFill = Instance.new("Frame")
waitFill.Size = UDim2.new(0.09, 0, 1, 0)
waitFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
waitFill.BorderSizePixel = 0
waitFill.ZIndex = 8
waitFill.Parent = waitSlider

local waitFillCorner = Instance.new("UICorner")
waitFillCorner.CornerRadius = UDim.new(1, 0)
waitFillCorner.Parent = waitFill

local waitKnob = Instance.new("TextButton")
waitKnob.Size = UDim2.new(0, 20, 0, 20)
waitKnob.Position = UDim2.new(0.09, -10, 0.5, -10)
waitKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
waitKnob.Text = ""
waitKnob.ZIndex = 9
waitKnob.Parent = waitSlider

local waitKnobCorner = Instance.new("UICorner")
waitKnobCorner.CornerRadius = UDim.new(1, 0)
waitKnobCorner.Parent = waitKnob

-- Step slider functionality
local draggingStepSlider = false
stepKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingStepSlider = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingStepSlider = false
		draggingWaitSlider = false
	end
end)

-- Wait slider functionality
local draggingWaitSlider = false
waitKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingWaitSlider = true
	end
end)

RunService.RenderStepped:Connect(function()
	if draggingStepSlider then
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = stepSlider.AbsolutePosition
		local sliderSize = stepSlider.AbsoluteSize
		
		local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		
		stepDistance = math.floor(percentage * 19) + 1 -- 1 to 20 studs
		
		stepKnob.Position = UDim2.new(percentage, -10, 0.5, -10)
		stepFill.Size = UDim2.new(percentage, 0, 1, 0)
		stepLabel.Text = "📏 Step Distance: " .. stepDistance .. " studs"
	end
	
	if draggingWaitSlider then
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = waitSlider.AbsolutePosition
		local sliderSize = waitSlider.AbsoluteSize
		
		local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		
		-- 0.01 to 1.0 seconds
		waitTime = 0.01 + (percentage * 0.99)
		
		waitKnob.Position = UDim2.new(percentage, -10, 0.5, -10)
		waitFill.Size = UDim2.new(percentage, 0, 1, 0)
		waitLabel.Text = string.format("⏱️ Wait Time: %.2fs", waitTime)
	end
end)

-- Set Position Button
local setButton = Instance.new("TextButton")
setButton.Name = "SetButton"
setButton.Size = UDim2.new(1, -20, 0, 45)
setButton.Position = UDim2.new(0, 10, 0, 380)
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
teleportButton.Position = UDim2.new(0, 10, 0, 435)
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

-- Teleport functionality with stronger anti-cheat bypass
local isTeleporting = false
teleportButton.MouseButton1Click:Connect(function()
	if isTeleporting then
		return -- Prevent multiple teleports at once
	end
	
	if savedPosition then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
			local hrp = character.HumanoidRootPart
			local humanoid = character.Humanoid
			
			isTeleporting = true
			
			local startPos = hrp.Position
			local endPos = savedPosition
			local totalDistance = (endPos - startPos).Magnitude
			
			-- Visual feedback
			teleportButton.BackgroundColor3 = Color3.fromRGB(200, 120, 255)
			teleportButton.Text = "⚡ Teleporting..."
			
			-- Advanced anti-cheat bypass
			task.spawn(function()
				-- Store original properties
				local originalWalkSpeed = humanoid.WalkSpeed
				local originalJumpPower = humanoid.JumpPower
				
				-- Modify humanoid properties to simulate "walking"
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
				humanoid.AutoRotate = false
				
				-- Disable all body movers
				for _, v in pairs(hrp:GetChildren()) do
					if v:IsA("BodyMover") then
						v:Destroy()
					end
				end
				
				local stepsTaken = 0
				local maxSteps = math.ceil(totalDistance / stepDistance)
				
				for i = 1, maxSteps do
					if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") or humanoid.Health <= 0 then
						break
					end
					
					local currentPos = hrp.Position
					local direction = (endPos - currentPos).Unit
					local remainingDistance = (endPos - currentPos).Magnitude
					
					-- If we're close enough, snap to final position
					if remainingDistance <= stepDistance then
						hrp.CFrame = CFrame.new(endPos, endPos + direction)
						break
					end
					
					-- Calculate new position
					local newPos = currentPos + direction * stepDistance
					
					-- Set CFrame with orientation preserved
					hrp.CFrame = CFrame.new(newPos, newPos + direction)
					
					-- Aggressively reset all velocity
					hrp.Velocity = Vector3.new(0, 0, 0)
					hrp.RotVelocity = Vector3.new(0, 0, 0)
					if hrp.AssemblyLinearVelocity then
						hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					end
					if hrp.AssemblyAngularVelocity then
						hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					end
					
					stepsTaken = stepsTaken + 1
					
					-- Wait between steps
					task.wait(waitTime)
				end
				
				-- Restore original properties
				task.wait(0.1)
				humanoid.WalkSpeed = originalWalkSpeed
				humanoid.JumpPower = originalJumpPower
				humanoid.AutoRotate = true
				
				-- Reset velocity one final time
				hrp.Velocity = Vector3.new(0, 0, 0)
				hrp.RotVelocity = Vector3.new(0, 0, 0)
				
				-- Reset visuals
				teleportButton.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
				teleportButton.Text = "⚡ Teleport"
				isTeleporting = false
			end)
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
