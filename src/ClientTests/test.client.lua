local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("DialogueService", require(game.ReplicatedStorage.ModulR.Services.DialogueService))
ModulR:AddService("NpcService", require(game.ReplicatedStorage.ModulR.Services.NpcService))
ModulR:AddService("LevelService", require(game.ReplicatedStorage.ModulR.Services.LevelService))
ModulR:AddService("CombatService", require(game.ReplicatedStorage.ModulR.Services.CombatService))
ModulR:AddService("MovementService", require(game.ReplicatedStorage.ModulR.Services.MovementService))
ModulR:Initialize()

local CombatService = ModulR:GetService("CombatService")
local MovementService = ModulR:GetService("MovementService")

-- Example usage of CombatService
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        CombatService:Attack()
    end
    if input.KeyCode == Enum.KeyCode.F then
        CombatService:Block()
    end
    if input.KeyCode == Enum.KeyCode.Space then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if humanoid.FloorMaterial == Enum.Material.Air then
                MovementService:DoubleJump()
            end
        end
    end
    if input.KeyCode == Enum.KeyCode.Q then
        MovementService:Dash()
    end
end)

uis.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then
        CombatService:BlockEnd()
    end
end)
