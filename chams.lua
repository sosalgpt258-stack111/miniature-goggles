-- Astra Chams Module (chams.lua)
local ChamsModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

function ChamsModule.Init()
    local enabled = false
    local teamCheck = false
    local fillColor = Color3.fromRGB(255, 60, 90)
    local outlineColor = Color3.fromRGB(255, 255, 255)
    local fillTransparency = 0.6
    local chamsCache = {}

    local function IsSameTeam(player)
        return player.Team ~= nil and player.Team == localPlayer.Team
    end

    local function CreateChams(player)
        if chamsCache[player] then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "AstraChams"
        highlight.FillColor = fillColor
        highlight.OutlineColor = outlineColor
        highlight.FillTransparency = fillTransparency
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = false

        chamsCache[player] = highlight
    end

    local function RemoveChams(player)
        if chamsCache[player] then
            pcall(function() chamsCache[player]:Destroy() end)
            chamsCache[player] = nil
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then CreateChams(player) end
    end

    local addedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then CreateChams(player) end
    end)

    local removingConn = Players.PlayerRemoving:Connect(function(player)
        RemoveChams(player)
    end)

    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        for player, highlight in pairs(chamsCache) do
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")

            if enabled and character and humanoid and humanoid.Health > 0 then
                if teamCheck and IsSameTeam(player) then
                    highlight.Enabled = false
                else
                    highlight.Adornee = character
                    highlight.Enabled = true
                end
            else
                highlight.Enabled = false
            end
        end
    end)

    return {
        SetEnabled           = function(state) enabled = state end,
        SetTeamCheck         = function(state) teamCheck = state end,
        SetFillColor         = function(color) fillColor = color end,
        SetOutlineColor      = function(color) outlineColor = color end,
        SetFillTransparency  = function(value) fillTransparency = value end,
        Destroy = function()
            enabled = false
            if renderConn then renderConn:Disconnect() end
            if addedConn then addedConn:Disconnect() end
            if removingConn then removingConn:Disconnect() end
            for player, _ in pairs(chamsCache) do
                RemoveChams(player)
            end
        end
    }
end

return ChamsModule
