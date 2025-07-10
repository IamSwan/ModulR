--|| ModulR ||--

--|| Dependencies ||--
local EventBus = require(script.EventBus)

--|| Main module ||--
local ModulRCore = {}
ModulRCore.__index = ModulRCore

--|| Interfaces ||--
type Service = {
    Name: string,
    Initialize: () -> any,
    Destroy: () -> any,
    Server: {}?,
    Client: {}?
}

--|| Private Attributes ||--
local Services = {}
local Locked = false

--|| Constructor ||--
function ModulRCore.new()
    local self = setmetatable({}, ModulRCore)
    return self
end

--|| Destructor ||--
function ModulRCore:Destroy()
    for _, service in pairs(Services) do
        if not service.Destroy then continue end
        service:Destroy()
    end
    Services = {}
end

--|| Public Methods ||--
function ModulRCore:Initialize()
    Locked = true -- Prevent further edits after init
    self.EventBus = EventBus.new()
    return self
end

function ModulRCore:GetService(serviceName: string): Service
    if not Services[serviceName] then
        error("Service '" .. serviceName .. "' does not exist.")
    end

    return Services[serviceName]
end

function ModulRCore:AddService(serviceName: string)
    if Locked then
        error("Cannot add services after initialization.")
    end

    if Services[serviceName] then
        error("Service '" .. serviceName .. "' already exists.")
    end

    local modulePath = script.Services[serviceName]

    if not modulePath then
        error("Service '" .. serviceName .. "' not found in script.Services.")
    end

    local serviceModule = require(modulePath)
    if type(serviceModule) ~= "table" or not serviceModule.Initialize then
        error("Service '" .. serviceName .. "' must be a table with an Initialize method.")
    end

    Services[serviceName] = serviceModule:Initialize()
end

--|| Return ||--
return ModulRCore
