--|| ModulR ||--

--|| Dependencies ||--
local eventBus = require(script.EventBus)
local ModulRInterfaces = require(script.Interfaces)

--|| Main module ||--
local ModulRCore = {}
ModulRCore.__index = ModulRCore

--|| Private Attributes ||--
local services = {}
local locked = false

--|| Constructor ||--
function ModulRCore.new()
    local self = setmetatable({}, ModulRCore)
    return self
end

--|| Destructor ||--
function ModulRCore:Destroy()
    for _, service in pairs(services) do
        if not service.Destroy then continue end
        service:Destroy()
    end
    services = {}
end

--|| Public Methods ||--
function ModulRCore:Initialize()
    locked = true -- Prevent further edits after init
    for index, value in pairs(services) do
        if not value.Initialize then
            error("Service '" .. index .. "' does not have an Initialize method.")
        end

        local success, err = pcall(value.Initialize, value)
        if not success then
            warn("Failed to initialize service '" .. index .. "': " .. tostring(err))
        end
    end
    return self
end

function ModulRCore:GetService(serviceName: string): ModulRInterfaces.Service
    if not services[serviceName] then
        error("Service '" .. serviceName .. "' does not exist.")
    end
    return services[serviceName]
end

function ModulRCore:AddService(serviceName: string, module: ModulRInterfaces.Service)
    if locked then
        error("Cannot add services after initialization.")
    end

    if services[serviceName] then
        error("Service '" .. serviceName .. "' already exists.")
    end

    local modulePath = script.Services[serviceName]

    if not modulePath then
        error("Service '" .. serviceName .. "' not found in script.services.")
    end

    local serviceModule = require(modulePath)
    if type(serviceModule) ~= "table" or not serviceModule.Initialize then
        error("Service '" .. serviceName .. "' must be a table with an Initialize method.")
    end

    serviceModule.Name = serviceName
    serviceModule.Initialize = serviceModule.Initialize or function() end
    serviceModule.Destroy = serviceModule.Destroy or function() end
    services[serviceName] = serviceModule
end

function ModulRCore:GetEventBus()
    if not eventBus then
        error("Event bus is not initialized. Call Initialize() first.")
    end
    return eventBus
end

--|| Return ||--
return ModulRCore
