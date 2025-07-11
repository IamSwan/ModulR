--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local CombatService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {},
}

function CombatService:Initialize()
    print("[CombatService] - CombatService initialized.")
    ModulR:GetEventBus():Broadcast("CombatServiceInit")
    return self
end

function CombatService:Destroy()
    print("[CombatService] - CombatService destroyed.")
end

function CombatService.Server:Attack(source: Instance, damage: number)
    print("[CombatService] - Player", source.Name, "is attacking with damage:", damage)
end

function CombatService.Client:Attack()
    print("[CombatService] - Starting combat animation.")
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("Attack", 10)
end

function CombatService.Server:Block(source: Instance)
    print("[CombatService] - Entity", source.Name, "is blocking.")
end

function CombatService.Server:BlockEnd(source: Instance)
    print("[CombatService] - Entity", source.Name, "has ended blocking.")
end

function CombatService.Client:Block()
    print("[CombatService] - Starting block animation.")
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("Block")
end

function CombatService.Client:BlockEnd()
    print("[CombatService] - Ending block animation.")
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("BlockEnd")
end

return CombatService
