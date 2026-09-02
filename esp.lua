-- Astra ESP Module (esp.lua)
local ESPModule = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

function ESPModule.Init()
    local ESPEnabled = false
    local espCache = {}
    local renderConnection = nil

    local function CreateCornerLine()
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(255, 255, 255)
        return line
    end

    local function CreatePlayerESP(player)
        if espCache[player] then return end
        espCache[player] = {
            TL1 = CreateCornerLine(), TL2 = CreateCornerLine(),
            TR1 = CreateCornerLine(), TR2 = CreateCornerLine(),
            BL1 = CreateCornerLine(), BL2 = CreateCornerLine(),
            BR1 = CreateCornerLine(), BR2 = CreateCornerLine()
        }
    end

    local function RemovePlayerESP(player)
        if espCache[player] then
            for _, line in pairs(espCache[player]) do
                pcall(function() line:Remove() end)
            end
            espCache[player] = nil
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then CreatePlayerESP(player) end
    end

    local addedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then CreatePlayerESP(player) end
    end)

    local removingConn = Players.PlayerRemoving:Connect(function(player)
        RemovePlayerESP(player)
    end)

    renderConnection = RunService.RenderStepped:Connect(function()
        if not ESPEnabled then
            for _, lines in pairs(espCache) do
                for _, line in pairs(lines) do
                    line.Visible = false
                end
            end
            return
        end

        for player, lines in pairs(espCache) do
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")

            local visible = false
            if character and rootPart and humanoid and humanoid.Health > 0 then
                -- Используем ModelCFrame или Pivot для точного охвата персонажа, включая объемную одежду
                local cf, size = character:GetBoundingBox()
                local topPoint = (cf + Vector3.new(0, size.Y / 2, 0)).Position
                local bottomPoint = (cf - Vector3.new(0, size.Y / 2, 0)).Position

                local topVector, topOnScreen = Camera:WorldToViewportPoint(topPoint)
                local bottomVector, bottomOnScreen = Camera:WorldToViewportPoint(bottomPoint)

                if topOnScreen or bottomOnScreen then
                    local height = math.abs(topVector.Y - bottomVector.Y)
                    local width = height * 0.65
                    local x = topVector.X - width / 2
                    local y = topVector.Y
                    
                    -- Длина линий уголков (адаптивная)
                    local length = math.clamp(width / 4, 6, 15)

                    -- Top Left
                    lines.TL1.From = Vector2.new(x, y)
                    lines.TL1.To = Vector2.new(x + length, y)
                    lines.TL2.From = Vector2.new(x, y)
                    lines.TL2.To = Vector2.new(x, y + length)

                    -- Top Right
                    lines.TR1.From = Vector2.new(x + width, y)
                    lines.TR1.To = Vector2.new(x + width - length, y)
                    lines.TR2.From = Vector2.new(x + width, y)
                    lines.TR2.To = Vector2.new(x + width, y + length)

                    -- Bottom Left
                    lines.BL1.From = Vector2.new(x, y + height)
                    lines.BL1.To = Vector2.new(x + length, y + height)
                    lines.BL2.From = Vector2.new(x, y + height)
                    lines.BL2.To = Vector2.new(x, y + height - length)

                    -- Bottom Right
                    lines.BR1.From = Vector2.new(x + width, y + height)
                    lines.BR1.To = Vector2.new(x + width - length, y + height)
                    lines.BR2.From = Vector2.new(x + width, y + height)
                    lines.BR2.To = Vector2.new(x + width, y + height - length)

                    for _, line in pairs(lines) do
                        line.Visible = true
                    end
                    visible = true
                end
            end

            if not visible then
                for _, line in pairs(lines) do
                    line.Visible = false
                end
            end
        end
    end)

    return {
        SetEnabled = function(state)
            ESPEnabled = state
        end,
        Destroy = function()
            ESPEnabled = false
            if renderConnection then renderConnection:Disconnect() end
            if addedConn then addedConn:Disconnect() end
            if removingConn then removingConn:Disconnect() end
            for player, _ in pairs(espCache) do
                RemovePlayerESP(player)
            end
        end
    }
end

return ESPModule
