--[[
    ═══════════════════════════════════════════════════════════════════════════
    FLOW RIVALS // MAIN PRESENTATION MODULE (GITHUB DISTRIBUTION)
    Repository Core: main.lua
    Matches the Flow Rivals UI layout, styling, and visual elements 1:1.
    Pure presentation & entity overlay research mockup.
    ═══════════════════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local UserHandle = "@" .. (LocalPlayer.Name or "theultimate587")

-- Safe Parent Detection
local parentGui = nil
pcall(function()
    if gethui then
        parentGui = gethui()
    elseif syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = CoreGui
        parentGui = sg
    else
        parentGui = CoreGui
    end
end)

if not parentGui or not pcall(function() return parentGui.Name end) then
    parentGui = LocalPlayer:WaitForChild("PlayerGui")
end

-- Cleanup prior instance
local existing = parentGui:FindFirstChild("FlowRivalsInterface")
if existing then
    existing:Destroy()
end

-- Master ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlowRivalsInterface"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = parentGui

-- Colors & Styling Tokens
local Colors = {
    MainBg = Color3.fromRGB(11, 11, 15),
    MainStroke = Color3.fromRGB(26, 26, 34),
    
    CardBg = Color3.fromRGB(18, 18, 23),
    CardStroke = Color3.fromRGB(30, 30, 40),
    CardBgSubtle = Color3.fromRGB(24, 24, 31),
    
    ActivePurple = Color3.fromRGB(155, 45, 255),
    ActivePurpleGlow = Color3.fromRGB(180, 80, 255),
    AccentBlue = Color3.fromRGB(0, 140, 255),
    AccentCyan = Color3.fromRGB(75, 163, 255),
    
    TextWhite = Color3.fromRGB(245, 245, 250),
    TextTitle = Color3.fromRGB(75, 163, 255),
    TextMuted = Color3.fromRGB(120, 125, 145),
    TextSubtle = Color3.fromRGB(85, 90, 110),
    
    ToggleOff = Color3.fromRGB(42, 42, 52),
    ToggleOffKnob = Color3.fromRGB(85, 85, 105),
    ToggleOn = Color3.fromRGB(55, 55, 72),
    ToggleOnKnob = Color3.fromRGB(230, 230, 245),
    
    SliderTrack = Color3.fromRGB(28, 28, 36),
    SliderFill = Color3.fromRGB(0, 145, 255),
    
    BadgeBg = Color3.fromRGB(26, 26, 35),
    BadgeStroke = Color3.fromRGB(40, 40, 54),
    BadgeText = Color3.fromRGB(160, 165, 185)
}

local PreviewState = {
    ESP = true,
    BoxESP = true,
    SkeletonESP = true,
    HealthBar = true,
    NameESP = true,
    DistanceESP = true,
    TracerLines = true,
    FOVCircle = true,
    Chams = true
}

local PreviewElements = {}

local MasterAnchor = Instance.new("Frame")
MasterAnchor.Name = "MasterAnchor"
MasterAnchor.Size = UDim2.new(0, 1040, 0, 510)
MasterAnchor.Position = UDim2.new(0.5, -520, 0.5, -255)
MasterAnchor.BackgroundTransparency = 1
MasterAnchor.Parent = ScreenGui

--[[
    ── 1. FLOATING CARD: ESP PREVIEW (LEFT) ──
]]
local PreviewCard = Instance.new("Frame")
PreviewCard.Name = "ESPPreviewCard"
PreviewCard.Size = UDim2.new(0, 230, 1, 0)
PreviewCard.Position = UDim2.new(0, 0, 0, 0)
PreviewCard.BackgroundColor3 = Colors.MainBg
PreviewCard.BorderSizePixel = 0
PreviewCard.Parent = MasterAnchor

local PreviewCardCorner = Instance.new("UICorner")
PreviewCardCorner.CornerRadius = UDim.new(0, 16)
PreviewCardCorner.Parent = PreviewCard

local PreviewCardStroke = Instance.new("UIStroke")
PreviewCardStroke.Thickness = 1.2
PreviewCardStroke.Color = Colors.MainStroke
PreviewCardStroke.Parent = PreviewCard

local PreviewHeader = Instance.new("Frame")
PreviewHeader.Name = "Header"
PreviewHeader.Size = UDim2.new(1, -24, 0, 36)
PreviewHeader.Position = UDim2.new(0, 14, 0, 10)
PreviewHeader.BackgroundTransparency = 1
PreviewHeader.Parent = PreviewCard

local PreviewTitle = Instance.new("TextLabel")
PreviewTitle.Name = "Title"
PreviewTitle.Size = UDim2.new(0.5, 0, 1, 0)
PreviewTitle.BackgroundTransparency = 1
PreviewTitle.Font = Enum.Font.GothamBold
PreviewTitle.Text = "ESP Preview"
PreviewTitle.TextColor3 = Colors.TextWhite
PreviewTitle.TextSize = 13
PreviewTitle.TextXAlignment = Enum.TextXAlignment.Left
PreviewTitle.Parent = PreviewHeader

local PreviewUser = Instance.new("TextLabel")
PreviewUser.Name = "UserHandle"
PreviewUser.Size = UDim2.new(0.5, 0, 1, 0)
PreviewUser.Position = UDim2.new(0.5, 0, 0, 0)
PreviewUser.BackgroundTransparency = 1
PreviewUser.Font = Enum.Font.Gotham
PreviewUser.Text = UserHandle
PreviewUser.TextColor3 = Colors.TextMuted
PreviewUser.TextSize = 11
PreviewUser.TextXAlignment = Enum.TextXAlignment.Right
PreviewUser.Parent = PreviewHeader

local ViewportContainer = Instance.new("Frame")
ViewportContainer.Name = "ViewportContainer"
ViewportContainer.Size = UDim2.new(1, -20, 1, -56)
ViewportContainer.Position = UDim2.new(0, 10, 0, 46)
ViewportContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ViewportContainer.BorderSizePixel = 0
ViewportContainer.ClipsDescendants = true
ViewportContainer.Parent = PreviewCard

local VPCorner = Instance.new("UICorner")
VPCorner.CornerRadius = UDim.new(0, 12)
VPCorner.Parent = ViewportContainer

local VPStroke = Instance.new("UIStroke")
VPStroke.Thickness = 1
VPStroke.Color = Color3.fromRGB(24, 24, 32)
VPStroke.Parent = ViewportContainer

local Viewport = Instance.new("ViewportFrame")
Viewport.Name = "AvatarViewport"
Viewport.Size = UDim2.new(1, 0, 1, 0)
Viewport.BackgroundTransparency = 1
Viewport.LightColor = Color3.fromRGB(240, 240, 255)
Viewport.LightDirection = Vector3.new(-1, -1, -2)
Viewport.Ambient = Color3.fromRGB(140, 135, 160)
Viewport.Parent = ViewportContainer

local CharacterModel = Instance.new("Model")
CharacterModel.Name = "RivalCharacter"

local function makeLimb(name, size, cf, color, mat)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color or Color3.fromRGB(210, 140, 95)
    p.Material = mat or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.Parent = CharacterModel
    return p
end

local cTorso = makeLimb("Torso", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0), Color3.fromRGB(65, 145, 230))
local cHead = makeLimb("Head", Vector3.new(1.2, 1.2, 1.2), CFrame.new(0, 1.6, 0), Color3.fromRGB(210, 140, 95))
local cLeftArm = makeLimb("LeftArm", Vector3.new(1, 2, 1), CFrame.new(-1.55, 0, 0), Color3.fromRGB(210, 140, 95))
local cRightArm = makeLimb("RightArm", Vector3.new(1, 2, 1), CFrame.new(1.55, 0, 0), Color3.fromRGB(210, 140, 95))
local cLeftLeg = makeLimb("LeftLeg", Vector3.new(1, 2, 1), CFrame.new(-0.55, -2, 0), Color3.fromRGB(180, 185, 195))
local cRightLeg = makeLimb("RightLeg", Vector3.new(1, 2, 1), CFrame.new(0.55, -2, 0), Color3.fromRGB(180, 185, 195))
local cHair = makeLimb("Hair", Vector3.new(1.3, 0.6, 1.3), CFrame.new(0, 2.1, 0), Color3.fromRGB(90, 55, 35))
local cGlasses = makeLimb("Glasses", Vector3.new(1.1, 0.35, 0.3), CFrame.new(0, 1.7, -0.6), Color3.fromRGB(255, 90, 140), Enum.Material.Neon)

CharacterModel.PrimaryPart = cTorso
CharacterModel.Parent = Viewport

local Camera = Instance.new("Camera")
Camera.CFrame = CFrame.new(Vector3.new(0, -0.2, 7.2), Vector3.new(0, -0.3, 0))
Viewport.CurrentCamera = Camera
Camera.Parent = Viewport

local OverlayLayer = Instance.new("Frame")
OverlayLayer.Name = "OverlayLayer"
OverlayLayer.Size = UDim2.new(1, 0, 1, 0)
OverlayLayer.BackgroundTransparency = 1
OverlayLayer.Parent = ViewportContainer

local BoxFrame = Instance.new("Frame")
BoxFrame.Name = "BoxESP"
BoxFrame.Size = UDim2.new(0, 130, 0, 280)
BoxFrame.Position = UDim2.new(0.5, -65, 0.5, -145)
BoxFrame.BackgroundTransparency = 1
BoxFrame.Parent = OverlayLayer
PreviewElements.BoxESP = BoxFrame

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Colors.AccentBlue
BoxStroke.Thickness = 1.5
BoxStroke.Parent = BoxFrame

local HealthBar = Instance.new("Frame")
HealthBar.Name = "HealthBar"
HealthBar.Size = UDim2.new(0, 4, 0, 280)
HealthBar.Position = UDim2.new(0.5, -74, 0.5, -145)
HealthBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
HealthBar.BorderSizePixel = 0
HealthBar.Parent = OverlayLayer
PreviewElements.HealthBar = HealthBar

local HealthFill = Instance.new("Frame")
HealthFill.Size = UDim2.new(1, 0, 0.9, 0)
HealthFill.Position = UDim2.new(0, 0, 0.1, 0)
HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 135)
HealthFill.BorderSizePixel = 0
HealthFill.Parent = HealthBar

local NameTag = Instance.new("TextLabel")
NameTag.Name = "NameESP"
NameTag.Size = UDim2.new(1, 0, 0, 16)
NameTag.Position = UDim2.new(0, 0, 0.5, -168)
NameTag.BackgroundTransparency = 1
NameTag.Font = Enum.Font.GothamBold
NameTag.Text = "Target_Rival"
NameTag.TextColor3 = Colors.TextWhite
NameTag.TextSize = 11
NameTag.Parent = OverlayLayer
PreviewElements.NameESP = NameTag

local DistTag = Instance.new("TextLabel")
DistTag.Name = "DistanceESP"
DistTag.Size = UDim2.new(1, 0, 0, 14)
DistTag.Position = UDim2.new(0, 0, 0.5, 140)
DistTag.BackgroundTransparency = 1
DistTag.Font = Enum.Font.GothamMedium
DistTag.Text = "24m"
DistTag.TextColor3 = Colors.AccentCyan
DistTag.TextSize = 10
DistTag.Parent = OverlayLayer
PreviewElements.DistanceESP = DistTag

local TracerLine = Instance.new("Frame")
TracerLine.Name = "TracerLines"
TracerLine.Size = UDim2.new(0, 1.5, 0, 145)
TracerLine.Position = UDim2.new(0.5, -0.75, 1, -145)
TracerLine.BackgroundColor3 = Colors.ActivePurple
TracerLine.BorderSizePixel = 0
TracerLine.Parent = OverlayLayer
PreviewElements.TracerLines = TracerLine

task.spawn(function()
    local t = 0
    while CharacterModel and CharacterModel.Parent do
        t = t + 0.03
        if CharacterModel.PrimaryPart then
            CharacterModel:SetPrimaryPartCFrame(CFrame.new(0, -0.1 + math.sin(t) * 0.04, 0))
        end
        task.wait(0.03)
    end
end)

local function SyncPreview(key, val)
    PreviewState[key] = val
    if PreviewElements[key] then
        PreviewElements[key].Visible = val
    end
end

--[[
    ── 2. MAIN MENU WINDOW (RIGHT) ──
]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 790, 1, 0)
MainFrame.Position = UDim2.new(0, 245, 0, 0)
MainFrame.BackgroundColor3 = Colors.MainBg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = MasterAnchor

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = Colors.MainStroke
MainStroke.Parent = MainFrame

local isDragging = false
local dragStart = Vector2.zero
local startPos = UDim2.new()

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MasterAnchor.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MasterAnchor.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and (input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert) then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Top Header
local TopHeader = Instance.new("Frame")
TopHeader.Name = "TopHeader"
TopHeader.Size = UDim2.new(1, -32, 0, 52)
TopHeader.Position = UDim2.new(0, 16, 0, 14)
TopHeader.BackgroundTransparency = 1
TopHeader.Parent = MainFrame

local BrandTitle = Instance.new("TextLabel")
BrandTitle.Name = "BrandTitle"
BrandTitle.Size = UDim2.new(0, 130, 0, 20)
BrandTitle.Position = UDim2.new(0, 0, 0, 2)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.Text = "Flow Rivals"
BrandTitle.TextColor3 = Colors.TextTitle
BrandTitle.TextSize = 17
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
BrandTitle.Parent = TopHeader

local BrandUser = Instance.new("TextLabel")
BrandUser.Name = "BrandUser"
BrandUser.Size = UDim2.new(0, 110, 0, 16)
BrandUser.Position = UDim2.new(0, 0, 0, 24)
BrandUser.BackgroundTransparency = 1
BrandUser.Font = Enum.Font.Gotham
BrandUser.Text = UserHandle
BrandUser.TextColor3 = Colors.TextMuted
BrandUser.TextSize = 12
BrandUser.TextXAlignment = Enum.TextXAlignment.Left
BrandUser.Parent = TopHeader

local UserIcon = Instance.new("ImageLabel")
UserIcon.Name = "UserIcon"
UserIcon.Size = UDim2.new(0, 26, 0, 26)
UserIcon.Position = UDim2.new(0, 136, 0, 10)
UserIcon.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
UserIcon.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) or ""
UserIcon.Parent = TopHeader

local UserIconCorner = Instance.new("UICorner")
UserIconCorner.CornerRadius = UDim.new(1, 0)
UserIconCorner.Parent = UserIcon

local CurrentTabTitle = Instance.new("TextLabel")
CurrentTabTitle.Name = "CurrentTabTitle"
CurrentTabTitle.Size = UDim2.new(0, 220, 0, 20)
CurrentTabTitle.Position = UDim2.new(0, 190, 0, 2)
CurrentTabTitle.BackgroundTransparency = 1
CurrentTabTitle.Font = Enum.Font.GothamBold
CurrentTabTitle.Text = "Combat"
CurrentTabTitle.TextColor3 = Colors.TextTitle
CurrentTabTitle.TextSize = 17
CurrentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabTitle.Parent = TopHeader

local CurrentTabSubtitle = Instance.new("TextLabel")
CurrentTabSubtitle.Name = "CurrentTabSubtitle"
CurrentTabSubtitle.Size = UDim2.new(0, 220, 0, 16)
CurrentTabSubtitle.Position = UDim2.new(0, 190, 0, 24)
CurrentTabSubtitle.BackgroundTransparency = 1
CurrentTabSubtitle.Font = Enum.Font.Gotham
CurrentTabSubtitle.Text = "Aimbot and combat features"
CurrentTabSubtitle.TextColor3 = Colors.TextSubtle
CurrentTabSubtitle.TextSize = 12
CurrentTabSubtitle.TextXAlignment = Enum.TextXAlignment.Left
CurrentTabSubtitle.Parent = TopHeader

local SearchBar = Instance.new("Frame")
SearchBar.Name = "SearchBar"
SearchBar.Size = UDim2.new(0, 215, 0, 34)
SearchBar.Position = UDim2.new(1, -215, 0, 6)
SearchBar.BackgroundColor3 = Colors.CardBg
SearchBar.BorderSizePixel = 0
SearchBar.Parent = TopHeader

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(1, 0)
SearchCorner.Parent = SearchBar

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Thickness = 1
SearchStroke.Color = Colors.CardStroke
SearchStroke.Parent = SearchBar

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Name = "SearchIcon"
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 12, 0.5, -8)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://10734886648"
SearchIcon.ImageColor3 = Colors.TextSubtle
SearchIcon.Parent = SearchBar

local SearchInput = Instance.new("TextBox")
SearchInput.Name = "SearchInput"
SearchInput.Size = UDim2.new(1, -38, 1, 0)
SearchInput.Position = UDim2.new(0, 34, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.Font = Enum.Font.Gotham
SearchInput.PlaceholderText = "Search tabs/groups..."
SearchInput.PlaceholderColor3 = Colors.TextSubtle
SearchInput.Text = ""
SearchInput.TextColor3 = Colors.TextWhite
SearchInput.TextSize = 12
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.Parent = SearchBar

-- Left Tree Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -78)
Sidebar.Position = UDim2.new(0, 16, 0, 68)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SelectorPill = Instance.new("Frame")
SelectorPill.Name = "SelectorPill"
SelectorPill.Size = UDim2.new(1, 0, 0, 36)
SelectorPill.BackgroundColor3 = Colors.CardBg
SelectorPill.BorderSizePixel = 0
SelectorPill.Parent = Sidebar

local SelCorner = Instance.new("UICorner")
SelCorner.CornerRadius = UDim.new(0, 8)
SelCorner.Parent = SelectorPill

local SelStroke = Instance.new("UIStroke")
SelStroke.Thickness = 1
SelStroke.Color = Colors.CardStroke
SelStroke.Parent = SelectorPill

local SelIcon = Instance.new("ImageLabel")
SelIcon.Name = "Icon"
SelIcon.Size = UDim2.new(0, 16, 0, 16)
SelIcon.Position = UDim2.new(0, 10, 0.5, -8)
SelIcon.BackgroundTransparency = 1
SelIcon.Image = "rbxassetid://10734898144"
SelIcon.ImageColor3 = Colors.AccentCyan
SelIcon.Parent = SelectorPill

local SelText = Instance.new("TextLabel")
SelText.Size = UDim2.new(1, -54, 1, 0)
SelText.Position = UDim2.new(0, 32, 0, 0)
SelText.BackgroundTransparency = 1
SelText.Font = Enum.Font.GothamMedium
SelText.Text = "Flow Rivals"
SelText.TextColor3 = Colors.TextWhite
SelText.TextSize = 12
SelText.TextXAlignment = Enum.TextXAlignment.Left
SelText.Parent = SelectorPill

local SelArrows = Instance.new("TextLabel")
SelArrows.Size = UDim2.new(0, 20, 1, 0)
SelArrows.Position = UDim2.new(1, -24, 0, 0)
SelArrows.BackgroundTransparency = 1
SelArrows.Font = Enum.Font.GothamMedium
SelArrows.Text = "⇅"
SelArrows.TextColor3 = Colors.TextMuted
SelArrows.TextSize = 14
SelArrows.Parent = SelectorPill

local NavTree = Instance.new("Frame")
NavTree.Name = "NavTree"
NavTree.Size = UDim2.new(1, 0, 1, -85)
NavTree.Position = UDim2.new(0, 0, 0, 46)
NavTree.BackgroundTransparency = 1
NavTree.Parent = Sidebar

local TreeLayout = Instance.new("UIListLayout")
TreeLayout.Padding = UDim.new(0, 4)
TreeLayout.Parent = NavTree

local UISettingsBtn = Instance.new("TextButton")
UISettingsBtn.Name = "UISettingsBtn"
UISettingsBtn.Size = UDim2.new(0, 108, 0, 28)
UISettingsBtn.Position = UDim2.new(0, 0, 1, -28)
UISettingsBtn.BackgroundColor3 = Colors.CardBg
UISettingsBtn.BorderSizePixel = 0
UISettingsBtn.Text = ""
UISettingsBtn.Parent = Sidebar

local UISetCorner = Instance.new("UICorner")
UISetCorner.CornerRadius = UDim.new(1, 0)
UISetCorner.Parent = UISettingsBtn

local UISetStroke = Instance.new("UIStroke")
UISetStroke.Thickness = 1
UISetStroke.Color = Colors.CardStroke
UISetStroke.Parent = UISettingsBtn

local GearIcon = Instance.new("ImageLabel")
GearIcon.Size = UDim2.new(0, 14, 0, 14)
GearIcon.Position = UDim2.new(0, 10, 0.5, -7)
GearIcon.BackgroundTransparency = 1
GearIcon.Image = "rbxassetid://10734950020"
GearIcon.ImageColor3 = Colors.TextMuted
GearIcon.Parent = UISettingsBtn

local GearText = Instance.new("TextLabel")
GearText.Size = UDim2.new(1, -30, 1, 0)
GearText.Position = UDim2.new(0, 28, 0, 0)
GearText.BackgroundTransparency = 1
GearText.Font = Enum.Font.GothamMedium
GearText.Text = "UI Settings"
GearText.TextColor3 = Colors.TextMuted
GearText.TextSize = 11
GearText.TextXAlignment = Enum.TextXAlignment.Left
GearText.Parent = UISettingsBtn

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -196, 1, -78)
ContentArea.Position = UDim2.new(0, 186, 0, 68)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TabPages = {}
local NavButtons = {}
local ActiveTabName = nil

local function createTabPage(name)
    local page = Instance.new("Frame")
    page.Name = "Page_" .. name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentArea
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 14)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    
    TabPages[name] = page
    return page
end

local function CreateCard(parent, title, iconId)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. title
    card.Size = UDim2.new(0.485, 0, 1, 0)
    card.BackgroundColor3 = Colors.CardBg
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent = card
    
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Thickness = 1
    cardStroke.Color = Colors.CardStroke
    cardStroke.Parent = card
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -24, 0, 36)
    header.Position = UDim2.new(0, 14, 0, 8)
    header.BackgroundTransparency = 1
    header.Parent = card
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 0, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or "rbxassetid://10723415766"
    icon.ImageColor3 = Colors.TextWhite
    icon.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -26, 1, 0)
    titleLabel.Position = UDim2.new(0, 24, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.TextWhite
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "List"
    scroll.Size = UDim2.new(1, -20, 1, -48)
    scroll.Position = UDim2.new(0, 10, 0, 44)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = Colors.CardStroke
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = card
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scroll
    
    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = scroll
    
    return scroll
end

local function AddToggleRow(parent, labelText, defaultVal, keybindText, callback)
    local state = defaultVal or false
    
    local row = Instance.new("Frame")
    row.Name = "Row_" .. labelText
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -95, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = labelText
    label.TextColor3 = Colors.TextWhite
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = row
    
    local rightContainer = Instance.new("Frame")
    rightContainer.Size = UDim2.new(0, 90, 1, 0)
    rightContainer.Position = UDim2.new(1, -90, 0, 0)
    rightContainer.BackgroundTransparency = 1
    rightContainer.Parent = row
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.FillDirection = Enum.FillDirection.Horizontal
    rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rightLayout.Padding = UDim.new(0, 6)
    rightLayout.Parent = rightContainer
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 32, 0, 17)
    toggleBtn.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = rightContainer
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.Position = state and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5)
    knob.BackgroundColor3 = state and Colors.ToggleOnKnob or Colors.ToggleOffKnob
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob
    
    if keybindText then
        local badge = Instance.new("TextButton")
        badge.Name = "KeybindBadge"
        badge.Size = UDim2.new(0, 24, 0, 18)
        badge.BackgroundColor3 = Colors.BadgeBg
        badge.BorderSizePixel = 0
        badge.Font = Enum.Font.GothamMedium
        badge.Text = keybindText
        badge.TextColor3 = Colors.BadgeText
        badge.TextSize = 10
        badge.Parent = rightContainer
        
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = badge
        
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 1
        bStroke.Color = Colors.BadgeStroke
        bStroke.Parent = badge
        
        local miniIcon = Instance.new("Frame")
        miniIcon.Size = UDim2.new(0, 18, 0, 18)
        miniIcon.BackgroundColor3 = Colors.BadgeBg
        miniIcon.BorderSizePixel = 0
        miniIcon.Parent = rightContainer
        
        local mCorner = Instance.new("UICorner")
        mCorner.CornerRadius = UDim.new(0, 4)
        mCorner.Parent = miniIcon
        
        local mStroke = Instance.new("UIStroke")
        mStroke.Thickness = 1
        mStroke.Color = Colors.BadgeStroke
        mStroke.Parent = miniIcon
        
        local mGlyph = Instance.new("ImageLabel")
        mGlyph.Size = UDim2.new(0, 10, 0, 10)
        mGlyph.Position = UDim2.new(0.5, -5, 0.5, -5)
        mGlyph.BackgroundTransparency = 1
        mGlyph.Image = "rbxassetid://10734950020"
        mGlyph.ImageColor3 = Colors.TextSubtle
        mGlyph.Parent = miniIcon
    end
    
    local function setToggle(newVal)
        state = newVal
        local targetKnobPos = state and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5)
        local targetKnobCol = state and Colors.ToggleOnKnob or Colors.ToggleOffKnob
        local targetTrackCol = state and Colors.ToggleOn or Colors.ToggleOff
        
        TweenService:Create(knob, TweenInfo.new(0.2), { Position = targetKnobPos, BackgroundColor3 = targetKnobCol }):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = targetTrackCol }):Play()
        
        if callback then
            callback(state)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        setToggle(not state)
    end)
    
    return { Set = setToggle }
end

local function AddSliderRow(parent, labelText, minVal, maxVal, defaultVal, isFraction, callback)
    local val = defaultVal or minVal
    
    local row = Instance.new("Frame")
    row.Name = "Row_Slider_" .. labelText
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Position = UDim2.new(0, 4, 0, 2)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = labelText
    label.TextColor3 = Colors.TextWhite
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueLabel"
    valueText.Size = UDim2.new(0.35, 0, 0, 18)
    valueText.Position = UDim2.new(0.65, -4, 0, 2)
    valueText.BackgroundTransparency = 1
    valueText.Font = Enum.Font.Gotham
    valueText.TextColor3 = Colors.TextMuted
    valueText.TextSize = 11
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = row
    
    local function formatVal(v)
        if isFraction then
            return string.format("%.2f / %.1f", v, maxVal)
        else
            return string.format("%d / %d", math.round(v), maxVal)
        end
    end
    valueText.Text = formatVal(val)
    
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.Size = UDim2.new(1, -8, 0, 8)
    track.Position = UDim2.new(0, 4, 0, 26)
    track.BackgroundColor3 = Colors.SliderTrack
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = row
    
    local trkCorner = Instance.new("UICorner")
    trkCorner.CornerRadius = UDim.new(1, 0)
    trkCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    local pct = math.clamp((val - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Colors.SliderFill
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local isSliding = false
    
    local function updateValue(newVal)
        val = math.clamp(newVal, minVal, maxVal)
        local ratio = (val - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        valueText.Text = formatVal(val)
        if callback then
            callback(val)
        end
    end
    
    local function snap(xPos)
        local rel = math.clamp(xPos - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local ratio = rel / track.AbsoluteSize.X
        updateValue(minVal + (maxVal - minVal) * ratio)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            snap(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            snap(input.Position.X)
        end
    end)
    
    return { Set = updateValue }
end

local function AddDropdownRow(parent, labelText, options, defaultVal, callback)
    local selected = defaultVal or options[1]
    
    local row = Instance.new("Frame")
    row.Name = "Row_Dropdown_" .. labelText
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -85, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = labelText
    label.TextColor3 = Colors.TextWhite
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
    
    local pill = Instance.new("TextButton")
    pill.Name = "DropdownPill"
    pill.Size = UDim2.new(0, 75, 0, 22)
    pill.Position = UDim2.new(1, -75, 0.5, -11)
    pill.BackgroundColor3 = Colors.BadgeBg
    pill.BorderSizePixel = 0
    pill.Text = ""
    pill.Parent = row
    
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 5)
    pCorner.Parent = pill
    
    local pStroke = Instance.new("UIStroke")
    pStroke.Thickness = 1
    pStroke.Color = Colors.BadgeStroke
    pStroke.Parent = pill
    
    local pText = Instance.new("TextLabel")
    pText.Size = UDim2.new(1, -16, 1, 0)
    pText.Position = UDim2.new(0, 6, 0, 0)
    pText.BackgroundTransparency = 1
    pText.Font = Enum.Font.GothamMedium
    pText.Text = selected
    pText.TextColor3 = Colors.BadgeText
    pText.TextSize = 11
    pText.TextXAlignment = Enum.TextXAlignment.Left
    pText.Parent = pill
    
    local pArrow = Instance.new("TextLabel")
    pArrow.Size = UDim2.new(0, 14, 1, 0)
    pArrow.Position = UDim2.new(1, -14, 0, 0)
    pArrow.BackgroundTransparency = 1
    pArrow.Font = Enum.Font.GothamMedium
    pArrow.Text = "⇅"
    pArrow.TextColor3 = Colors.TextSubtle
    pArrow.TextSize = 11
    pArrow.Parent = pill
    
    local curIdx = 1
    pill.MouseButton1Click:Connect(function()
        curIdx = curIdx + 1
        if curIdx > #options then curIdx = 1 end
        selected = options[curIdx]
        pText.Text = selected
        if callback then callback(selected) end
    end)
end

-- COMBAT TAB
local CombatPage = createTabPage("Combat")
local AimbotCard = CreateCard(CombatPage, "Aimbot")
AddToggleRow(AimbotCard, "Enable Aimbot (Toggle)", false, nil, function(v) end)
AddToggleRow(AimbotCard, "Enable Aimbot...", false, "F1", function(v) end)
AddDropdownRow(AimbotCard, "Select Hitbox", {"Head", "Torso", "Random"}, "Head", function(v) end)
AddSliderRow(AimbotCard, "FOV", 0, 360, 30, false, function(v) end)
AddSliderRow(AimbotCard, "Smooth", 1, 10, 1, false, function(v) end)
AddToggleRow(AimbotCard, "Hold To Aim", false, "E", function(v) end)
AddToggleRow(AimbotCard, "Show FOV Circle", false, "F", function(v) end)
AddToggleRow(AimbotCard, "Visible Check", false, "V", function(v) end)

local TriggerCard = CreateCard(CombatPage, "Trigger Bot")
AddToggleRow(TriggerCard, "Enable Trigger...", false, "T", function(v) end)
AddSliderRow(TriggerCard, "Trigger Delay", 0.01, 0.3, 0.05, true, function(v) end)

-- VISUALS TAB
local VisualsPage = createTabPage("Visuals")
local VisualsCard1 = CreateCard(VisualsPage, "Player ESP")
AddToggleRow(VisualsCard1, "Master ESP", true, nil, function(v) SyncPreview("ESP", v) end)
AddToggleRow(VisualsCard1, "Box ESP", true, "B", function(v) SyncPreview("BoxESP", v) end)
AddToggleRow(VisualsCard1, "Skeleton ESP", true, nil, function(v) SyncPreview("SkeletonESP", v) end)
AddToggleRow(VisualsCard1, "Health Bar", true, nil, function(v) SyncPreview("HealthBar", v) end)
AddToggleRow(VisualsCard1, "Name ESP", true, nil, function(v) SyncPreview("NameESP", v) end)
AddToggleRow(VisualsCard1, "Distance ESP", true, nil, function(v) SyncPreview("DistanceESP", v) end)
AddToggleRow(VisualsCard1, "Tracer Lines", true, nil, function(v) SyncPreview("TracerLines", v) end)

local VisualsCard2 = CreateCard(VisualsPage, "ESP Customization")
AddDropdownRow(VisualsCard2, "Accent Theme", {"Cyan Blue", "Neon Purple", "Crimson Rage", "Emerald"}, "Cyan Blue", function(v) end)
AddSliderRow(VisualsCard2, "Max Distance", 50, 1000, 350, false, function(v) end)
AddToggleRow(VisualsCard2, "Team Check", true, nil, function(v) end)

-- RAGE TAB
local RagePage = createTabPage("Rage")
local RageCard1 = CreateCard(RagePage, "Rage Automation")
AddToggleRow(RageCard1, "Silent Aim", true, "R", function(v) end)
AddToggleRow(RageCard1, "Auto Shoot", true, nil, function(v) end)
AddToggleRow(RageCard1, "Auto Reload", true, nil, function(v) end)
AddSliderRow(RageCard1, "Velocity Prediction", 0, 100, 45, false, function(v) end)
AddToggleRow(RageCard1, "Target Lock", true, nil, function(v) end)

local RageCard2 = CreateCard(RagePage, "Rage Statistics")
AddSliderRow(RageCard2, "Target Scan Range", 50, 500, 250, false, function(v) end)
AddToggleRow(RageCard2, "Anti-Aim Simulation", false, nil, function(v) end)

-- HOME TAB
local HomePage = createTabPage("Home")
local HomeCard1 = CreateCard(HomePage, "System Status")
AddToggleRow(HomeCard1, "Interface Blur", true, nil, function(v) end)
AddToggleRow(HomeCard1, "Performance Watermark", true, nil, function(v) end)
local HomeCard2 = CreateCard(HomePage, "Changelog")
AddToggleRow(HomeCard2, "Auto-Check Updates", true, nil, function(v) end)

-- WORLD TAB
local WorldPage = createTabPage("World")
local WorldCard1 = CreateCard(WorldPage, "Lighting & Ambience")
AddToggleRow(WorldCard1, "Night Mode", false, nil, function(v) end)
AddSliderRow(WorldCard1, "Ambient Brightness", 0, 100, 50, false, function(v) end)
AddToggleRow(WorldCard1, "No Fog", true, nil, function(v) end)
local WorldCard2 = CreateCard(WorldPage, "Movement")
AddSliderRow(WorldCard2, "Speed Modifier", 16, 250, 16, false, function(v) end)
AddSliderRow(WorldCard2, "Jump Height", 50, 300, 50, false, function(v) end)

-- SETTINGS TAB
local SettingsPage = createTabPage("Settings")
local SetCard1 = CreateCard(SettingsPage, "Preferences")
AddToggleRow(SetCard1, "Menu Sound Effects", true, nil, function(v) end)
AddSliderRow(SetCard1, "Menu Scale", 80, 120, 100, false, function(v) end)
local SetCard2 = CreateCard(SettingsPage, "Config Management")
AddDropdownRow(SetCard2, "Preset Profile", {"Flow_Rage_Default", "Legit_Clean", "Casual_Visuals"}, "Flow_Rage_Default", function(v) end)
AddToggleRow(SetCard2, "Auto Save Config", true, nil, function(v) end)

-- TREE NAVIGATION ITEMS
local navTreeItems = {
    { Name = "Home", Sub = "Overview & System Info" },
    { Name = "Combat", Sub = "Aimbot and combat features" },
    { Name = "Visuals", Sub = "ESP and player overlays" },
    { Name = "Rage", Sub = "High-velocity targeting automation" },
    { Name = "World", Sub = "Environment & lighting modifiers" },
    { Name = "Settings", Sub = "Interface preferences & profiles" }
}

local function SelectTab(name, subtitle)
    if ActiveTabName == name then return end
    ActiveTabName = name
    
    CurrentTabTitle.Text = name
    CurrentTabSubtitle.Text = subtitle or ""
    
    for tabName, page in pairs(TabPages) do
        page.Visible = (tabName == name)
    end
    
    for btnName, btn in pairs(NavButtons) do
        local isActive = (btnName == name)
        local arrow = btn:FindFirstChild("Arrow")
        local text = btn:FindFirstChild("TextLabel")
        
        if isActive then
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Colors.ActivePurple }):Play()
            if text then text.TextColor3 = Colors.TextWhite end
            if arrow then arrow.TextColor3 = Colors.TextWhite end
        else
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(11, 11, 15) }):Play()
            if text then text.TextColor3 = Colors.TextMuted end
            if arrow then arrow.TextColor3 = Colors.TextSubtle end
        end
    end
end

for _, item in ipairs(navTreeItems) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tree_" .. item.Name
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(11, 11, 15)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = NavTree
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 18, 1, 0)
    arrow.Position = UDim2.new(0, 10, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamMedium
    arrow.Text = "↳"
    arrow.TextColor3 = Colors.TextSubtle
    arrow.TextSize = 13
    arrow.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -34, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = item.Name
    label.TextColor3 = Colors.TextMuted
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if ActiveTabName ~= item.Name then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Colors.CardBg }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if ActiveTabName ~= item.Name then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(11, 11, 15) }):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        SelectTab(item.Name, item.Sub)
    end)
    
    NavButtons[item.Name] = btn
end

-- Default active: Combat
SelectTab("Combat", "Aimbot and combat features")

print("[+] Flow Rivals UI initialized from main.lua.")
