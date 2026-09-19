-- Astra Main Script (main.lua) — Enhanced
local Library     = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/lib.lua"))()
local ESPModule   = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/esp.lua"))()
local AimModule   = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/aimbot.lua"))()
local SilentAim   = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/silentaim.lua"))()
local Triggerbot  = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/triggerbot.lua"))()
local ChamsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/chams.lua"))()
local HitboxMod   = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/hitbox.lua"))()

-- Инициализация интерфейса
local Window = Library.New()

-- Вкладки
local AimbotTab   = Window:CreateTab("Aimbot",   1)
local CombatTab   = Window:CreateTab("Combat",   2)
local VisualsTab  = Window:CreateTab("Visuals",  3)
local SettingsTab = Window:CreateTab("Settings", 4)
local InfoTab     = Window:CreateTab("Info",     5)

-- Модули
local esp       = ESPModule.Init()
local aim       = AimModule.Init()
local silentaim = SilentAim.Init()
local trigger   = Triggerbot.Init()
local chams     = ChamsModule.Init()
local hitbox    = HitboxMod.Init()

esp.SetMaxDistance(500)

-- Сервисы
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ──────────────────────────────────────────
-- Утилита: панель настроек поверх меню
-- ──────────────────────────────────────────
local function CreateSettingsPanel(title, buildCallback)
    local ScreenGui = CoreGui:FindFirstChild("AstraStyleMenu")
    if not ScreenGui then return end

    local Overlay = Instance.new("Frame")
    Overlay.Name = "SettingsOverlay"
    Overlay.Parent = ScreenGui
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.ZIndex = 20

    local Panel = Instance.new("Frame")
    Panel.Parent = Overlay
    Panel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Panel.BorderSizePixel = 0
    Panel.AnchorPoint = Vector2.new(0.5, 0.5)
    Panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Panel.Size = UDim2.new(0, 240, 0, 0)
    Panel.AutomaticSize = Enum.AutomaticSize.Y
    Panel.ZIndex = 21
    Panel.ClipsDescendants = true

    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 6)
    PanelCorner.Parent = Panel

    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = Color3.fromRGB(35, 35, 45)
    PanelStroke.Thickness = 1
    PanelStroke.Parent = Panel

    local PanelPadding = Instance.new("UIPadding")
    PanelPadding.PaddingTop    = UDim.new(0, 12)
    PanelPadding.PaddingBottom = UDim.new(0, 14)
    PanelPadding.PaddingLeft   = UDim.new(0, 14)
    PanelPadding.PaddingRight  = UDim.new(0, 14)
    PanelPadding.Parent = Panel

    local PanelList = Instance.new("UIListLayout")
    PanelList.SortOrder = Enum.SortOrder.LayoutOrder
    PanelList.Padding = UDim.new(0, 10)
    PanelList.Parent = Panel

    local TitleRow = Instance.new("Frame")
    TitleRow.BackgroundTransparency = 1
    TitleRow.Size = UDim2.new(1, 0, 0, 22)
    TitleRow.LayoutOrder = 0
    TitleRow.Parent = Panel

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleRow
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -26, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 22

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleRow
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, 0, 0.5, 0)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(120, 120, 130)
    CloseBtn.TextSize = 12
    CloseBtn.ZIndex = 22
    CloseBtn.MouseButton1Click:Connect(function() Overlay:Destroy() end)
    Overlay.MouseButton1Click:Connect(function() Overlay:Destroy() end)

    local Divider = Instance.new("Frame")
    Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Divider.BorderSizePixel = 0
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.LayoutOrder = 1
    Divider.Parent = Panel

    local ContentFrame = Instance.new("Frame")
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
    ContentFrame.LayoutOrder = 2
    ContentFrame.Parent = Panel

    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = ContentFrame

    buildCallback(ContentFrame, Panel)
end

-- ──────────────────────────────────────────
-- Утилита: слайдер для панелей
-- ──────────────────────────────────────────
local function CreateSlider(parent, labelText, minVal, maxVal, defaultVal, layoutOrder, onChange)
    local currentVal = defaultVal

    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 42)
    Container.LayoutOrder = layoutOrder
    Container.ZIndex = 22

    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = labelText .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Color3.fromRGB(150, 150, 160)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 22

    local Track = Instance.new("Frame")
    Track.Parent = Container
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Track.BorderSizePixel = 0
    Track.Position = UDim2.new(0, 0, 0, 24)
    Track.Size = UDim2.new(1, 0, 0, 8)
    Track.ZIndex = 22

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Parent = Track
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.ZIndex = 22

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Parent = Track
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.ZIndex = 23

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(45, 45, 55)
    KnobStroke.Thickness = 1
    KnobStroke.Parent = Knob

    local dragging = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            currentVal = math.floor(minVal + (maxVal - minVal) * relX)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
            Label.Text = labelText .. ": " .. tostring(currentVal)
            onChange(currentVal)
        end
    end)
end

-- ──────────────────────────────────────────
-- Колор пикер (обобщённый)
-- ──────────────────────────────────────────
local function OpenColorPicker(title, initialColor, onColorChange)
    local colorH, colorS, colorV = initialColor:ToHSV()

    CreateSettingsPanel(title, function(content, panel)

        local HueBar = Instance.new("Frame")
        HueBar.Parent = content
        HueBar.Size = UDim2.new(1, 0, 0, 14)
        HueBar.LayoutOrder = 0
        HueBar.ZIndex = 22
        HueBar.BorderSizePixel = 0

        local HueCorner = Instance.new("UICorner")
        HueCorner.CornerRadius = UDim.new(0, 4)
        HueCorner.Parent = HueBar

        local HueGradient = Instance.new("UIGradient")
        HueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0/6, Color3.fromRGB(255, 0,   0)),
            ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0,   255, 0)),
            ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0,   255, 255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0,   0,   255)),
            ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0,   255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 0,   0)),
        })
        HueGradient.Parent = HueBar

        local HueCursor = Instance.new("Frame")
        HueCursor.Parent = HueBar
        HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueCursor.BorderSizePixel = 0
        HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        HueCursor.Position = UDim2.new(colorH, 0, 0.5, 0)
        HueCursor.Size = UDim2.new(0, 4, 1, 4)
        HueCursor.ZIndex = 23

        local HueCursorCorner = Instance.new("UICorner")
        HueCursorCorner.CornerRadius = UDim.new(0, 2)
        HueCursorCorner.Parent = HueCursor

        local SVField = Instance.new("Frame")
        SVField.Parent = content
        SVField.Size = UDim2.new(1, 0, 0, 110)
        SVField.LayoutOrder = 1
        SVField.ZIndex = 22
        SVField.BorderSizePixel = 0

        local SVFieldCorner = Instance.new("UICorner")
        SVFieldCorner.CornerRadius = UDim.new(0, 4)
        SVFieldCorner.Parent = SVField

        local SVGradientS = Instance.new("UIGradient")
        SVGradientS.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(colorH, 1, 1)),
        })
        SVGradientS.Parent = SVField

        local SVOverlay = Instance.new("Frame")
        SVOverlay.Parent = SVField
        SVOverlay.Size = UDim2.new(1, 0, 1, 0)
        SVOverlay.BorderSizePixel = 0
        SVOverlay.ZIndex = 22

        local SVOverlayCorner = Instance.new("UICorner")
        SVOverlayCorner.CornerRadius = UDim.new(0, 4)
        SVOverlayCorner.Parent = SVOverlay

        local SVOverlayGradient = Instance.new("UIGradient")
        SVOverlayGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        })
        SVOverlayGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        })
        SVOverlayGradient.Rotation = 90
        SVOverlayGradient.Parent = SVOverlay

        local SVCursor = Instance.new("Frame")
        SVCursor.Parent = SVField
        SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SVCursor.BorderSizePixel = 0
        SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        SVCursor.Position = UDim2.new(colorS, 0, 1 - colorV, 0)
        SVCursor.Size = UDim2.new(0, 10, 0, 10)
        SVCursor.ZIndex = 24

        local SVCursorCorner = Instance.new("UICorner")
        SVCursorCorner.CornerRadius = UDim.new(1, 0)
        SVCursorCorner.Parent = SVCursor

        local SVCursorStroke = Instance.new("UIStroke")
        SVCursorStroke.Color = Color3.fromRGB(20, 20, 25)
        SVCursorStroke.Thickness = 1.5
        SVCursorStroke.Parent = SVCursor

        local PreviewBox = Instance.new("Frame")
        PreviewBox.Parent = content
        PreviewBox.BackgroundColor3 = initialColor
        PreviewBox.BorderSizePixel = 0
        PreviewBox.Size = UDim2.new(1, 0, 0, 28)
        PreviewBox.LayoutOrder = 2
        PreviewBox.ZIndex = 22

        local PreviewCorner = Instance.new("UICorner")
        PreviewCorner.CornerRadius = UDim.new(0, 4)
        PreviewCorner.Parent = PreviewBox

        local function UpdateColor()
            local newColor = Color3.fromHSV(colorH, colorS, colorV)
            PreviewBox.BackgroundColor3 = newColor
            SVGradientS.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(colorH, 1, 1)),
            })
            onColorChange(newColor)
        end

        local hueDragging = false
        HueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true end
        end)

        local svDragging = false
        SVField.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueDragging = false
                svDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

            if hueDragging then
                local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                colorH = relX
                HueCursor.Position = UDim2.new(relX, 0, 0.5, 0)
                UpdateColor()
            elseif svDragging then
                local relX = math.clamp((input.Position.X - SVField.AbsolutePosition.X) / SVField.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - SVField.AbsolutePosition.Y) / SVField.AbsoluteSize.Y, 0, 1)
                colorS = relX
                colorV = 1 - relY
                SVCursor.Position = UDim2.new(relX, 0, relY, 0)
                UpdateColor()
            end
        end)
    end)
end

-- ──────────────────────────────────────────
-- Выбор шрифта для name esp
-- ──────────────────────────────────────────
local fontOptions = {
    {name = "UI",        font = Drawing.Fonts.UI},
    {name = "System",    font = Drawing.Fonts.System},
    {name = "Plex",      font = Drawing.Fonts.Plex},
    {name = "Monospace", font = Drawing.Fonts.Monospace},
}
local currentFontIndex = 3

local function OpenNameFontPicker()
    CreateSettingsPanel("name esp font", function(content, panel)
        for i, option in ipairs(fontOptions) do
            local isSelected = (i == currentFontIndex)

            local FontBtn = Instance.new("TextButton")
            FontBtn.Parent = content
            FontBtn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(22, 22, 28)
            FontBtn.Size = UDim2.new(1, 0, 0, 30)
            FontBtn.AutoButtonColor = false
            FontBtn.Font = Enum.Font.GothamMedium
            FontBtn.Text = option.name
            FontBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            FontBtn.TextSize = 12
            FontBtn.LayoutOrder = i
            FontBtn.ZIndex = 22

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = FontBtn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = isSelected and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(35, 35, 45)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = FontBtn

            FontBtn.MouseButton1Click:Connect(function()
                currentFontIndex = i
                esp.SetNameFont(option.font)
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                        child.TextColor3 = Color3.fromRGB(160, 160, 170)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(35, 35, 45) end
                    end
                end
                FontBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                FontBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                BtnStroke.Color = Color3.fromRGB(80, 80, 100)
            end)
        end
    end)
end

-- ──────────────────────────────────────────
-- Настройки aimbot
-- ──────────────────────────────────────────
local aimKeyCode = Enum.KeyCode.E
local isBindingKey = false

local function OpenAimbotSettings()
    CreateSettingsPanel("aimbot settings", function(content, panel)

        CreateSlider(content, "fov", 10, 400, 120, 0, function(val)
            aim.SetFOV(val)
        end)

        CreateSlider(content, "smoothing", 1, 30, 15, 1, function(val)
            aim.SetSmoothing(val / 100)
        end)

        local partLabel = Instance.new("TextLabel")
        partLabel.Parent = content
        partLabel.BackgroundTransparency = 1
        partLabel.Size = UDim2.new(1, 0, 0, 14)
        partLabel.Font = Enum.Font.GothamMedium
        partLabel.Text = "target part"
        partLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        partLabel.TextSize = 11
        partLabel.TextXAlignment = Enum.TextXAlignment.Left
        partLabel.LayoutOrder = 2
        partLabel.ZIndex = 22

        local partOptions = {"Head", "HumanoidRootPart"}
        local selectedPart = 1

        for i, partName in ipairs(partOptions) do
            local isSelected = (i == selectedPart)

            local PartBtn = Instance.new("TextButton")
            PartBtn.Parent = content
            PartBtn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(22, 22, 28)
            PartBtn.Size = UDim2.new(1, 0, 0, 30)
            PartBtn.AutoButtonColor = false
            PartBtn.Font = Enum.Font.GothamMedium
            PartBtn.Text = partName == "HumanoidRootPart" and "torso" or "head"
            PartBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            PartBtn.TextSize = 12
            PartBtn.LayoutOrder = 3 + i
            PartBtn.ZIndex = 22

            local PartCorner = Instance.new("UICorner")
            PartCorner.CornerRadius = UDim.new(0, 4)
            PartCorner.Parent = PartBtn

            local PartStroke = Instance.new("UIStroke")
            PartStroke.Color = isSelected and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(35, 35, 45)
            PartStroke.Thickness = 1
            PartStroke.Parent = PartBtn

            PartBtn.MouseButton1Click:Connect(function()
                selectedPart = i
                aim.SetTargetPart(partName)
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                        child.TextColor3 = Color3.fromRGB(160, 160, 170)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(35, 35, 45) end
                    end
                end
                PartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                PartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                PartStroke.Color = Color3.fromRGB(80, 80, 100)
            end)
        end

        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = content
        keyLabel.BackgroundTransparency = 1
        keyLabel.Size = UDim2.new(1, 0, 0, 14)
        keyLabel.Font = Enum.Font.GothamMedium
        keyLabel.Text = "keybind"
        keyLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        keyLabel.TextSize = 11
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.LayoutOrder = 6
        keyLabel.ZIndex = 22

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Parent = content
        KeyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        KeyBtn.Size = UDim2.new(1, 0, 0, 30)
        KeyBtn.AutoButtonColor = false
        KeyBtn.Font = Enum.Font.GothamMedium
        KeyBtn.Text = "[" .. tostring(aimKeyCode.Name) .. "]"
        KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
        KeyBtn.TextSize = 12
        KeyBtn.LayoutOrder = 7
        KeyBtn.ZIndex = 22

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 4)
        KeyCorner.Parent = KeyBtn

        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Color = Color3.fromRGB(45, 45, 55)
        KeyStroke.Thickness = 1
        KeyStroke.Parent = KeyBtn

        KeyBtn.MouseButton1Click:Connect(function()
            if isBindingKey then return end
            isBindingKey = true
            KeyBtn.Text = "press any key..."
            KeyBtn.TextColor3 = Color3.fromRGB(255, 220, 100)

            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    aimKeyCode = input.KeyCode
                    aim.SetAimKey(aimKeyCode)
                    KeyBtn.Text = "[" .. tostring(aimKeyCode.Name) .. "]"
                    KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
                    isBindingKey = false
                    conn:Disconnect()
                end
            end)
        end)
    end)
end

-- ──────────────────────────────────────────
-- Настройки silent aim
-- ──────────────────────────────────────────
local function OpenSilentAimSettings()
    CreateSettingsPanel("silent aim settings", function(content, panel)

        CreateSlider(content, "fov", 10, 300, 80, 0, function(val)
            silentaim.SetFOV(val)
        end)

        CreateSlider(content, "hit chance %", 1, 100, 100, 1, function(val)
            silentaim.SetHitChance(val)
        end)

        -- Target part
        local partLabel = Instance.new("TextLabel")
        partLabel.Parent = content
        partLabel.BackgroundTransparency = 1
        partLabel.Size = UDim2.new(1, 0, 0, 14)
        partLabel.Font = Enum.Font.GothamMedium
        partLabel.Text = "target part"
        partLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        partLabel.TextSize = 11
        partLabel.TextXAlignment = Enum.TextXAlignment.Left
        partLabel.LayoutOrder = 2
        partLabel.ZIndex = 22

        local partOptions = {"Head", "HumanoidRootPart"}
        local selectedPart = 1

        for i, partName in ipairs(partOptions) do
            local isSelected = (i == selectedPart)

            local PartBtn = Instance.new("TextButton")
            PartBtn.Parent = content
            PartBtn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(22, 22, 28)
            PartBtn.Size = UDim2.new(1, 0, 0, 30)
            PartBtn.AutoButtonColor = false
            PartBtn.Font = Enum.Font.GothamMedium
            PartBtn.Text = partName == "HumanoidRootPart" and "torso" or "head"
            PartBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            PartBtn.TextSize = 12
            PartBtn.LayoutOrder = 3 + i
            PartBtn.ZIndex = 22

            local PartCorner = Instance.new("UICorner")
            PartCorner.CornerRadius = UDim.new(0, 4)
            PartCorner.Parent = PartBtn

            local PartStroke = Instance.new("UIStroke")
            PartStroke.Color = isSelected and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(35, 35, 45)
            PartStroke.Thickness = 1
            PartStroke.Parent = PartBtn

            PartBtn.MouseButton1Click:Connect(function()
                selectedPart = i
                silentaim.SetTargetPart(partName)
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                        child.TextColor3 = Color3.fromRGB(160, 160, 170)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(35, 35, 45) end
                    end
                end
                PartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                PartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                PartStroke.Color = Color3.fromRGB(80, 80, 100)
            end)
        end

        -- Hook method
        local hookLabel = Instance.new("TextLabel")
        hookLabel.Parent = content
        hookLabel.BackgroundTransparency = 1
        hookLabel.Size = UDim2.new(1, 0, 0, 14)
        hookLabel.Font = Enum.Font.GothamMedium
        hookLabel.Text = "hook method"
        hookLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        hookLabel.TextSize = 11
        hookLabel.TextXAlignment = Enum.TextXAlignment.Left
        hookLabel.LayoutOrder = 6
        hookLabel.ZIndex = 22

        local hookOptions = {"MouseHit", "Namecall"}
        local selectedHook = 1

        for i, hookName in ipairs(hookOptions) do
            local isSelected = (i == selectedHook)

            local HookBtn = Instance.new("TextButton")
            HookBtn.Parent = content
            HookBtn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(22, 22, 28)
            HookBtn.Size = UDim2.new(1, 0, 0, 30)
            HookBtn.AutoButtonColor = false
            HookBtn.Font = Enum.Font.GothamMedium
            HookBtn.Text = hookName
            HookBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            HookBtn.TextSize = 12
            HookBtn.LayoutOrder = 7 + i
            HookBtn.ZIndex = 22

            local HookCorner = Instance.new("UICorner")
            HookCorner.CornerRadius = UDim.new(0, 4)
            HookCorner.Parent = HookBtn

            local HookStroke = Instance.new("UIStroke")
            HookStroke.Color = isSelected and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(35, 35, 45)
            HookStroke.Thickness = 1
            HookStroke.Parent = HookBtn

            HookBtn.MouseButton1Click:Connect(function()
                selectedHook = i
                silentaim.SetHookMethod(hookName)
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                        child.TextColor3 = Color3.fromRGB(160, 160, 170)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(35, 35, 45) end
                    end
                end
                HookBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                HookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                HookStroke.Color = Color3.fromRGB(80, 80, 100)
            end)
        end
    end)
end

-- ──────────────────────────────────────────
-- Настройки triggerbot
-- ──────────────────────────────────────────
local function OpenTriggerbotSettings()
    CreateSettingsPanel("triggerbot settings", function(content, panel)

        CreateSlider(content, "delay (ms)", 0, 500, 50, 0, function(val)
            trigger.SetDelay(val / 1000)
        end)
    end)
end

-- ──────────────────────────────────────────
-- Настройки hitbox
-- ──────────────────────────────────────────
local function OpenHitboxSettings()
    CreateSettingsPanel("hitbox expander", function(content, panel)

        CreateSlider(content, "size", 4, 30, 10, 0, function(val)
            hitbox.SetSize(val)
        end)

        local partLabel = Instance.new("TextLabel")
        partLabel.Parent = content
        partLabel.BackgroundTransparency = 1
        partLabel.Size = UDim2.new(1, 0, 0, 14)
        partLabel.Font = Enum.Font.GothamMedium
        partLabel.Text = "target part"
        partLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        partLabel.TextSize = 11
        partLabel.TextXAlignment = Enum.TextXAlignment.Left
        partLabel.LayoutOrder = 1
        partLabel.ZIndex = 22

        local partOptions = {"HumanoidRootPart", "Head"}
        local selectedPart = 1

        for i, partName in ipairs(partOptions) do
            local isSelected = (i == selectedPart)

            local PartBtn = Instance.new("TextButton")
            PartBtn.Parent = content
            PartBtn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(22, 22, 28)
            PartBtn.Size = UDim2.new(1, 0, 0, 30)
            PartBtn.AutoButtonColor = false
            PartBtn.Font = Enum.Font.GothamMedium
            PartBtn.Text = partName == "HumanoidRootPart" and "torso" or "head"
            PartBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            PartBtn.TextSize = 12
            PartBtn.LayoutOrder = 2 + i
            PartBtn.ZIndex = 22

            local PartCorner = Instance.new("UICorner")
            PartCorner.CornerRadius = UDim.new(0, 4)
            PartCorner.Parent = PartBtn

            local PartStroke = Instance.new("UIStroke")
            PartStroke.Color = isSelected and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(35, 35, 45)
            PartStroke.Thickness = 1
            PartStroke.Parent = PartBtn

            PartBtn.MouseButton1Click:Connect(function()
                selectedPart = i
                hitbox.SetTargetPart(partName)
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                        child.TextColor3 = Color3.fromRGB(160, 160, 170)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(35, 35, 45) end
                    end
                end
                PartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                PartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                PartStroke.Color = Color3.fromRGB(80, 80, 100)
            end)
        end
    end)
end

-- ──────────────────────────────────────────
-- AIMBOT TAB
-- ──────────────────────────────────────────
local aimbotCol = AimbotTab:CreateColumn("aim settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

aimbotCol:CreateToggle("enable aimbot", function(state)
    aim.SetEnabled(state)
end, function()
    OpenAimbotSettings()
end)

aimbotCol:CreateToggle("team check", function(state)
    aim.SetTeamCheck(state)
end)

-- ──────────────────────────────────────────
-- COMBAT TAB
-- ──────────────────────────────────────────
local combatCol = CombatTab:CreateColumn("silent aim", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

combatCol:CreateToggle("enable silent aim", function(state)
    silentaim.SetEnabled(state)
end, function()
    OpenSilentAimSettings()
end)

combatCol:CreateToggle("silent team check", function(state)
    silentaim.SetTeamCheck(state)
end)

-- Triggerbot
local triggerCol = CombatTab:CreateColumn("triggerbot", UDim2.new(0, 220, 0, 10), UDim2.new(0, 195, 0, 355))

triggerCol:CreateToggle("enable triggerbot", function(state)
    trigger.SetEnabled(state)
end, function()
    OpenTriggerbotSettings()
end)

triggerCol:CreateToggle("trigger team check", function(state)
    trigger.SetTeamCheck(state)
end)

-- Hitbox
triggerCol:CreateToggle("hitbox expander", function(state)
    hitbox.SetEnabled(state)
end, function()
    OpenHitboxSettings()
end)

triggerCol:CreateToggle("hitbox team check", function(state)
    hitbox.SetTeamCheck(state)
end)

-- ──────────────────────────────────────────
-- VISUALS TAB
-- ──────────────────────────────────────────
local visualsCol = VisualsTab:CreateColumn("esp settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

visualsCol:CreateToggle("box corners", function(state)
    esp.SetEnabled(state)
end, function()
    OpenColorPicker("box corners color", Color3.fromRGB(255, 255, 255), function(color)
        esp.SetBoxColor(color)
    end)
end)

visualsCol:CreateToggle("box team check", function(state)
    esp.SetBoxTeamCheck(state)
end)

visualsCol:CreateToggle("health bar", function(state)
    esp.SetHealthBarEnabled(state)
end)

visualsCol:CreateToggle("health team check", function(state)
    esp.SetHealthTeamCheck(state)
end)

visualsCol:CreateToggle("name esp", function(state)
    esp.SetNameEnabled(state)
end, function()
    OpenNameFontPicker()
end)

visualsCol:CreateToggle("distance esp", function(state)
    esp.SetDistanceEnabled(state)
end)

-- Chams
local chamsCol = VisualsTab:CreateColumn("chams", UDim2.new(0, 220, 0, 10), UDim2.new(0, 195, 0, 355))

chamsCol:CreateToggle("enable chams", function(state)
    chams.SetEnabled(state)
end, function()
    OpenColorPicker("chams fill color", Color3.fromRGB(255, 60, 90), function(color)
        chams.SetFillColor(color)
    end)
end)

chamsCol:CreateToggle("chams team check", function(state)
    chams.SetTeamCheck(state)
end)

-- ──────────────────────────────────────────
-- SETTINGS TAB
-- ──────────────────────────────────────────
local settingsCol = SettingsTab:CreateColumn("management", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

settingsCol:CreateButton("unload script", function()
    esp.Destroy()
    aim.Destroy()
    silentaim.Destroy()
    trigger.Destroy()
    chams.Destroy()
    hitbox.Destroy()
    Window:Unload()
end)

-- ──────────────────────────────────────────
-- INFO TAB
-- ──────────────────────────────────────────
local infoCol = InfoTab:CreateColumn("about", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

infoCol:CreateButton("Astra v2.0 | Rivals Edition", function() end)
infoCol:CreateButton("Insert — открыть/закрыть меню", function() end)
