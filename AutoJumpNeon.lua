-- Auto Jump Neon GUI
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Botão
local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 160, 0, 55)
button.Position = UDim2.new(0.4, 0, 0.5, 0)
button.Text = "AUTO JUMP OFF"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(0, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
button.Active = true
button.Draggable = true
button.AutoButtonColor = false

-- Neon borda
local stroke = Instance.new("UIStroke")
stroke.Parent = button
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 255, 255)

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

-- Variáveis
local autoJump = false
local connection

-- Glow pulsante
local function neonPulse(color)
	local tween1 = TweenService:Create(
		stroke,
		TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{Thickness = 6, Color = color}
	)
	local tween2 = TweenService:Create(
		stroke,
		TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Thickness = 3, Color = color}
	)
	tween1:Play()
	tween1.Completed:Wait()
	tween2:Play()
end

-- Loop neon
task.spawn(function()
	while true do
		if autoJump then
			neonPulse(Color3.fromRGB(0, 255, 0))
		else
			neonPulse(Color3.fromRGB(0, 255, 255))
		end
		task.wait(0.1)
	end
end)

-- Auto Jump
local function startJump()
	connection = RunService.RenderStepped:Connect(function()
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
end

local function stopJump()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

-- Clique
button.MouseButton1Click:Connect(function()
	autoJump = not autoJump
	
	if autoJump then
		button.Text = "AUTO JUMP ON"
		button.TextColor3 = Color3.fromRGB(0, 255, 0)
		stroke.Color = Color3.fromRGB(0, 255, 0)
		startJump()
	else
		button.Text = "AUTO JUMP OFF"
		button.TextColor3 = Color3.fromRGB(0, 255, 255)
		stroke.Color = Color3.fromRGB(0, 255, 255)
		stopJump()
	end
end)
