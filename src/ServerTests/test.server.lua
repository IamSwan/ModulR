local ModulR = require(game.ReplicatedStorage.ModulR)


ModulR:AddService("LoggerService", require(game.ReplicatedStorage.ModulR.Services.LoggerService))
ModulR:Initialize()
ModulR:GetEventBus():Broadcast("Info1")
