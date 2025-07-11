local Players = game:GetService("Players")
local datastoreservice = game:GetService("DataStoreService")

--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local InventoryService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local inventoryStore = datastoreservice:GetDataStore("inventoryStore")

local testItem = {
	Name = "fish",
	Description = "this is a fish",
	Quantity = 27,
}

Inventory = {}

-- Local functions

-- Init (qui va être supprimé lors de l'init du core)
function InventoryService:Initialize()
	Players.PlayerAdded:Connect(function(player)
		local items = {
			fish = testItem,
		}
		local data = inventoryStore:GetAsync(player.UserId)
		if data then
            print("[InventoryService] - Loaded inventory for player:", player.Name)
			Inventory[player.UserId] = data
		else
            print("[InventoryService] - No inventory found for player:", player.Name, "Creating new inventory.")
			Inventory[player.UserId] = {
				items = items,
			}
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
        local success, errorMessage = pcall(function()
            inventoryStore:SetAsync(player.UserId, Inventory[player.UserId])
        end)
		Inventory[player.UserId] = nil -- Clean up inventory when player leaves
	end)
	game.Close:Connect(function()
		for _, inventory in pairs(Inventory) do
			inventory.items = {}
		end
	end)
	ModulR:GetEventBus():Broadcast("InventoryServiceInit")
	return self
end

function InventoryService:Destroy()
	print("[InventoryService] - InventoryService destroyed.")
end

function InventoryService.Server:PrintInventory(player)
	for id, inventory in pairs(Inventory) do
		if id ~= player.UserId then
			continue
		end
		print("Inventory for player:", player.Name)
		for itemName, itemData in pairs(inventory.items) do
			print(" - " .. itemName .. ": " .. itemData.Quantity)
		end
		return inventory
	end
	return nil
end

function InventoryService.Server:AddItem(player, itemName, quantity, description)
	if not description then
		description = "No description provided."
	end
	if not quantity then
		quantity = 1
	end

	if not Inventory[player.UserId] then
		Inventory[player.UserId] = { items = {} }
	end

	local items = Inventory[player.UserId].items
	if not items[itemName] then
		items[itemName] = { Name = itemName, Description = description, Quantity = quantity }
		return
	end

	items[itemName].Quantity += quantity
end

function InventoryService.Server:RemoveItem(player, itemName, quantity)
	if not quantity then
		quantity = 1
	end

	if not Inventory[player.UserId] or not Inventory[player.UserId].items[itemName] then
		print("Item not found in inventory.")
		return
	end

	local item = Inventory[player.UserId].items[itemName]
	if item.Quantity < quantity then
		print("Not enough items to remove.")
		return
	end

	item.Quantity -= quantity
	if item.Quantity <= 0 then
		Inventory[player.UserId].items[itemName] = nil -- Remove item if quantity is zero
	end
end

function InventoryService.Client:RequestInventory(player)
    print("Client requested inventory for " .. player.Name)
    return table.clone(Inventory[player.UserId] and Inventory[player.UserId].items or {})
end

return InventoryService
