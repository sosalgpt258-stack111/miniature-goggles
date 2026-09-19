-- Astra Hitbox Expander Module (hitbox.lua)
local HitboxModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

function HitboxModule.Init()
    local enabled = false
    local teamCheck = true
    local size = 10
    local targetPart = "HumanoidRootPart"

    local function IsSameTeam(player)
        return player.Team ~= nil and player.Team == localPlayer.Team
    end

    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end

            local character = player.Character
            if not character then continue end

            local part = character:FindFirstChild(targetPart)
            if not part then continue end

            local humanoid = character:FindFirstChild("Humanoid")

            if enabled and humanoid and humanoid.Health > 0 then
                if teamCheck and IsSameTeam(player) then
                    part.Size = Vector3.new(2, 2, 1) -- стандартный размер HRP
                    part.Transparency = 1
                else
                    part.Size = Vector3.new(size, size, size)
                    part.Transparency = 0.8
                    part.Color = Color3.fromRGB(255, 0, 68)
                    part.Material = Enum.Material.ForceField
                    part.CanCollide = false
                end
            else
                -- Восстановить размер
                part.Size = Vector3.new(2, 2, 1)
                part.Transparency = 1
            end
        end
    end)

    return {
        SetEnabled    = function(state) enabled = state end,
        SetTeamCheck  = function(state) teamCheck = state end,
        SetSize       = function(value) size = value end,
        SetTargetPart = function(part) targetPart = part end,
        Destroy = function()
            enabled = false
            -- Восстановить все хитбоксы
            for _, player in ipairs(Players:GetPlayers()) do
                if player == localPlayer then continue end
                local character = player.Character
                if character then
                    local part = character:FindFirstChild(targetPart)
                    if part then
                        part.Size = Vector3.new(2, 2, 1)
                        part.Transparency = 1
                    end
                end
            end
            if renderConn then renderConn:Disconnect() end
        end
    }
end

return HitboxModule
