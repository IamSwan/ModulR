local RunService = game:GetService("RunService")
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

    if type(module) ~= "table" or not module.Initialize or not module.Destroy then
        error("Invalid service module. Must be a table with Initialize and Destroy methods.")
    end

    module.Name = serviceName
    module.Initialize = module.Initialize or function() end
    module.Destroy = module.Destroy or function() end

    if not module.Client then
        module.Client = {}
    end

    if not module.Server then
        module.Server = {}
    end

    if RunService:IsServer() then
        services[serviceName] = module.Server
    elseif RunService:IsClient() then
        services[serviceName] = module.Client
    end
    for _, method in pairs(module.Shared) do
        if type(method) == "function" then
            services[serviceName][method] = method
        else
            error("Shared methods must be functions.")
        end
    end
end

function ModulRCore:GetEventBus()
    if not eventBus then
        error("Event bus is not initialized. Call Initialize() first.")
    end
    return eventBus
end

--|| Return ||--
return ModulRCore
