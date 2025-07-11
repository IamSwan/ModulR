--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local StatusService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {}
}

local statusCb = {
    Stunned = function(character, duration)
        character.Humanoid.WalkSpeed = 0
        task.delay(duration, function()
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16 -- Reset to default speed
            end
        end)
    end,
    Slowed = function(character, duration)
        character.Humanoid.WalkSpeed = 8 -- Example slow speed
        task.delay(duration, function()
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16 -- Reset to default speed
            end
        end)
    end,
    Poisoned = function(character, duration)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for i = 1, duration do
                humanoid.Health = humanoid.Health - 2 -- Example poison damage
                task.wait(1) -- Wait 1 second between damage ticks
            end
        else
            warn("[StatusService] - Humanoid not found for", character.Name)
        end
    end,
    Burned = function(character, duration)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.Health - 5 -- Example burn damage
            task.delay(duration, function()
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = 16 -- Reset to default speed
                end
            end)
        else
            warn("[StatusService] - Humanoid not found for", character.Name)
        end
    end
}

local function onCharacterAdded(character)
    for effectName, effectFunc in pairs(statusCb) do
        character:SetAttribute(effectName, false) -- Initialize status effects
        character:GetAttributeChangedSignal(effectName):Connect(function()
            if character:GetAttribute(effectName) then
                print(string.format("[StatusService] - %s applied to %s", effectName, character.Name))
            else
                print(string.format("[StatusService] - %s removed from %s", effectName, character.Name))
            end
        end)
    end
end

function StatusService:Initialize()
    print("[StatusService] - StatusService initialized.")
    ModulR:GetEventBus():Broadcast("StatusServiceInit")
    local player = game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character) -- Handle existing character
        end
    end)
    for _, player in pairs(game.Players:GetPlayers()) do
        onCharacterAdded(player.Character or player.CharacterAdded:Wait())
    end
    return self
end

function StatusService:Destroy()
    print("[StatusService] - StatusService destroyed.")
end

function StatusService.Server:ApplyStatusEffect(player, effectName, duration)
    local character = player.Character or player.CharacterAdded:Wait()
    if character then
        print(string.format("[StatusService] - Applying %s to %s for %d seconds", effectName, player.Name, duration))
        character:SetAttribute(effectName, true)
        if statusCb[effectName] then
            task.spawn(function()
                statusCb[effectName](character, duration)
            end)
        else
            warn("[StatusService] - Unknown status effect:", effectName)
        end
        task.wait(duration)
        character:SetAttribute(effectName, false)
    else
        warn("[StatusService] - Character not found for", player.Name)
    end
end

return StatusService
