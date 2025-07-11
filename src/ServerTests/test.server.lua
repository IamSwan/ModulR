local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LoggerService", require(game.ReplicatedStorage.ModulR.Services.LoggerService))
ModulR:AddService("TestService", require(game.ReplicatedStorage.ModulR.Services.TestService))
ModulR:Initialize()


local loggerService = ModulR:GetService("LoggerService")
