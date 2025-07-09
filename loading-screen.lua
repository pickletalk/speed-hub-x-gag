-- Speed Hub X Loading Screen
-- Creates a fullscreen loading overlay that progresses 5% per second

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHubXLoading"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create black background frame
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.ZIndex = 10
backgroundFrame.Parent = screenGui

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 400, 0, 60)
titleLabel.Position = UDim2.new(0.5, -200, 0.3, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Speed Hub X"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.ZIndex = 11
titleLabel.Parent = backgroundFrame

-- Create description label
local descriptionLabel = Instance.new("TextLabel")
descriptionLabel.Name = "Description"
descriptionLabel.Size = UDim2.new(0, 600, 0, 100)
descriptionLabel.Position = UDim2.new(0.5, -300, 0.4, 0)
descriptionLabel.BackgroundTransparency = 1
descriptionLabel.Text = "Note: Thank you for using our scripts, quick alert don't use random scripts it may steal your pets but don't worry we don't code pet stealers. Thank you for using our script again!"
descriptionLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
descriptionLabel.TextScaled = true
descriptionLabel.TextWrapped = true
descriptionLabel.Font = Enum.Font.SourceSans
descriptionLabel.ZIndex = 11
descriptionLabel.Parent = backgroundFrame

-- Create loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Name = "LoadingBarBackground"
loadingBarBg.Size = UDim2.new(0, 400, 0, 20)
loadingBarBg.Position = UDim2.new(0.5, -200, 0.6, 0)
loadingBarBg.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 11
loadingBarBg.Parent = backgroundFrame

-- Create loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Name = "LoadingBarFill"
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.new(0, 0.7, 1)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 12
loadingBarFill.Parent = loadingBarBg

-- Create percentage label
local percentageLabel = Instance.new("TextLabel")
percentageLabel.Name = "Percentage"
percentageLabel.Size = UDim2.new(0, 100, 0, 30)
percentageLabel.Position = UDim2.new(0.5, -50, 0.65, 0)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Text = "0%"
percentageLabel.TextColor3 = Color3.new(1, 1, 1)
percentageLabel.TextScaled = true
percentageLabel.Font = Enum.Font.SourceSansBold
percentageLabel.ZIndex = 11
percentageLabel.Parent = backgroundFrame

-- Loading animation variables
local currentProgress = 0
local targetProgress = 0
local startTime = tick()

-- Function to update loading progress
local function updateLoadingProgress()
    local elapsedTime = tick() - startTime
    targetProgress = math.min(elapsedTime * 5, 100) -- 5% per second
    
    -- Smooth interpolation
    currentProgress = currentProgress + (targetProgress - currentProgress) * 0.1
    
    -- Update UI elements
    local progressRatio = currentProgress / 100
    loadingBarFill.Size = UDim2.new(progressRatio, 0, 1, 0)
    percentageLabel.Text = math.floor(currentProgress) .. "%"
    
    -- Check if loading is complete
    if currentProgress >= 99.5 then
        -- Close loading screen
        local fadeOutTween = TweenService:Create(
            backgroundFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local fadeOutTitleTween = TweenService:Create(
            titleLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        
        local fadeOutDescTween = TweenService:Create(
            descriptionLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        
        local fadeOutPercentTween = TweenService:Create(
            percentageLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        
        local fadeOutBarBgTween = TweenService:Create(
            loadingBarBg,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local fadeOutBarFillTween = TweenService:Create(
            loadingBarFill,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        -- Play all fade out tweens
        fadeOutTween:Play()
        fadeOutTitleTween:Play()
        fadeOutDescTween:Play()
        fadeOutPercentTween:Play()
        fadeOutBarBgTween:Play()
        fadeOutBarFillTween:Play()
        
        -- Destroy the GUI after fade out completes
        fadeOutTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        
        return true -- Signal to disconnect the connection
    end
    
    return false
end

-- Connect the update function to RenderStepped
local connection
connection = RunService.RenderStepped:Connect(function()
    if updateLoadingProgress() then
        connection:Disconnect()
    end
end)
