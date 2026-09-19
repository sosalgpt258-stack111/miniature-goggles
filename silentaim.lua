-- Astra Silent Aim Module (silentaim.lua)
local SilentAimModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

function SilentAimModule.Init()
    local enabled = false
    local teamCheck = true
    local fov = 80
    local hitChance = 100
    local targetPart = "Head"
    local activated = false

    -- Метод хука: "MouseHit" или "Namecall"
    local hookMethod = "MouseHit"

    local function IsSameTeam(player)
        return player.Team ~= nil and player.Team == localPlayer.Team
    end

    local function GetClosestTarget()
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local closestDist = math.huge
        local closestPart = nil

        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end
            if teamCheck and IsSameTeam(player) then continue end

            local character = player.Character
            if not character then continue end

            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end

            local part = character:FindFirstChild(targetPart)
            if not part then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local screenVec = Vector2.new(screenPos.X, screenPos.Y)
            local dist = (screenVec - center).Magnitude

            if dist < fov and dist < closestDist then
                closestDist = dist
                closestPart = part
            end
        end

        return closestPart
    end

    -- Mouse.Hit hook
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if enabled and hookMethod == "MouseHit" and key == "Hit" and self == localPlayer:GetMouse() then
            if activated and math.random(1, 100) <= hitChance then
                local target = GetClosestTarget()
                if target then
                    return target.CFrame
                end
            end
        end
        return oldIndex(self, key)
    end))

    -- Namecall hook для FireServer (Rivals и большинство FPS)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if enabled and hookMethod == "Namecall" and method == "FireServer" then
            if activated and math.random(1, 100) <= hitChance then
                local target = GetClosestTarget()
                if target then
                    -- Подменяем направление/позицию на таргет
                    if typeof(args[1]) == "Vector3" then
                        args[1] = target.Position
                    elseif typeof(args[2]) == "Vector3" then
                        args[2] = (target.Position - Camera.CFrame.Position).Unit * 1000
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        return oldNamecall(self, ...)
    end))

    -- Активация (по умолчанию всегда, но можно на кнопку)
    RunService.RenderStepped:Connect(function()
        activated = enabled
    end)

    return {
        SetEnabled    = function(state) enabled = state end,
        SetTeamCheck  = function(state) teamCheck = state end,
        SetFOV        = function(value) fov = value end,
        SetHitChance  = function(value) hitChance = value end,
        SetTargetPart = function(part) targetPart = part end,
        SetHookMethod = function(method) hookMethod = method end,
        Destroy = function()
            enabled = false
        end
    }
end

return SilentAimModule
