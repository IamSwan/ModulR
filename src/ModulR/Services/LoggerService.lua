--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local LoggerService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {}
}

-- Init (qui va être supprimé lors de l'init du core)
function LoggerService:Initialize()
    ModulR:GetEventBus():Subscribe("LoggerServiceInit", self, function()
        print("[LoggerService] - LoggerServiceInit event received.")
    end)
    ModulR:GetEventBus():Subscribe("TestServiceInit", self, function()
        print("[LoggerService] - TestServiceInit event received.")
    end)
    ModulR:GetEventBus():Subscribe("LevelServiceInit", self, function()
        print("[LoggerService] - LevelServiceInit event received.")
    end)
    ModulR:GetEventBus():Broadcast("LoggerServiceInit")
    return self
end

function LoggerService:Destroy()
    ModulR:GetEventBus():Unsubscribe("LoggerServiceInit", self)
    ModulR:GetEventBus():Unsubscribe("TestServiceInit", self)
    ModulR:GetEventBus():Unsubscribe("LevelServiceInit", self)
    print("[LoggerService] - LoggerService destroyed.")
end

-- Methode Shared (donc peut importe ou tu add ton service, elle sera accessible)
function LoggerService.Shared:ForceLog(message: string)
    print("[LoggerService] - " .. message)
end

-- Methode Server (donc uniquement sur le serveur)
function LoggerService.Server:ForceLogServer(message: string)
    print("[LoggerService Server] - " .. message)
end

-- Methode Client (donc uniquement sur le client)
function LoggerService.Client:ForceLogClient(message: string)
    print("[LoggerService Client] - " .. message)
end

return LoggerService
