--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local DialogueService = ModulR:GetService("DialogueService")
local Players = game:GetService("Players")

--|| Module ||--
local NpcService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local npcs = game.Workspace:WaitForChild("Npcs", 10):GetChildren() -- Wait for the NPCs folder to load
local currentDialogue = nil
local connections = {}

-- Local functions

-- Init (qui va être supprimé lors de l'init du core)
function NpcService:Initialize()
	ModulR:GetEventBus():Broadcast("NpcServiceInit")
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		for _, npc in ipairs(npcs) do
			local ChoiceGui: BillboardGui = npc:FindFirstChild("WelcomeNpc"):Clone()
			if not ChoiceGui then
				warn("[NpcService] - ChoiceGui not found for NPC:", npc.Name)
				continue
			end
			local YapGui: BillboardGui = npc:FindFirstChild("YapGui")
			if not YapGui then
				warn("[NpcService] - YapGui not found for NPC:", npc.Name)
				continue
			end

			-- Initialize the NPC's dialogue choice GUI
			local currentDialogue = DialogueService:GetDialogue(npc.Name)
			if not currentDialogue then
				warn("[NpcService] - No dialogue found for NPC:", npc.Name)
				continue
			end

			local choiceIndex = 1
			for choiceName, _ in pairs(currentDialogue) do
				local choiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. choiceIndex)
				if not choiceButton then
					warn(
						"[NpcService] - Choice button not found for NPC:",
						npc.Name,
						"Choice:",
						choiceName,
						"Button" .. choiceIndex
					)
					continue
				end

				choiceButton.Text = choiceName -- Set the text of the choice button
				table.insert(connections, choiceButton.MouseButton1Click:Connect(function()
					currentDialogue = DialogueService:FollowDialogue(currentDialogue, choiceName)

					-- Check if dialogue exists before proceeding
					if not currentDialogue then
						warn("[NpcService] - No dialogue returned, resetting to Welcome for NPC:", npc.Name)
						currentDialogue = DialogueService:GetDialogue(npc.Name)
						local welcomeChoiceIndex = 1
						for welcomeChoiceName, _ in pairs(currentDialogue) do
							local welcomeChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. welcomeChoiceIndex)
							if welcomeChoiceButton then
								welcomeChoiceButton.Text = welcomeChoiceName
								welcomeChoiceButton.Visible = true
								welcomeChoiceIndex += 1
							end
						end
						-- Hide unused buttons
						for i = welcomeChoiceIndex, 3 do
							local welcomeChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. i)
							if welcomeChoiceButton then
								welcomeChoiceButton.Visible = false
							end
						end
						return
					end

					-- Check if dialogue has text before accessing it
					if currentDialogue.Text then
						task.spawn(function()
							local currentText = ""
							local endText = currentDialogue.Text
							while currentText ~= endText do
								currentText = endText:sub(1, #currentText + 1)
								YapGui.TextLabel.Text = currentText
								task.wait(0.015) -- Adjust the speed of text display
							end
						end)
					end

					local choiceSave = {}
					-- Check if dialogue has choices before accessing them
					if currentDialogue.Choices then
						for _, choiceName in pairs(currentDialogue.Choices) do
							choiceSave[choiceName] = DialogueService:GetSubDialogue(npc.Name, choiceName)
						end
					end
					currentDialogue = choiceSave
					local subDialogueIndex = 1
					print("Current Dialogue:", currentDialogue)

					-- Check if there are no choices left, reset to Welcome dialogue
					if next(currentDialogue) == nil then
						print("[NpcService] - No more dialogue options, resetting to Welcome for NPC:", npc.Name)
						currentDialogue = DialogueService:GetDialogue(npc.Name)
						local welcomeChoiceIndex = 1
						for welcomeChoiceName, _ in pairs(currentDialogue) do
							local welcomeChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. welcomeChoiceIndex)
							if welcomeChoiceButton then
								welcomeChoiceButton.Text = welcomeChoiceName
								welcomeChoiceButton.Visible = true
								welcomeChoiceIndex += 1
							end
						end
						-- Hide unused buttons
						for i = welcomeChoiceIndex, 3 do
							local welcomeChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. i)
							if welcomeChoiceButton then
								welcomeChoiceButton.Visible = false
							end
						end
					else
						-- Handle sub-dialogue options normally
						for subChoiceName, _ in pairs(currentDialogue) do
							local subChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. subDialogueIndex)
							if not subChoiceButton then
								warn(
									"[NpcService] - Sub choice button not found for NPC:",
									npc.Name,
									"Sub Choice:",
									subChoiceName,
									"Button" .. subDialogueIndex
								)
								continue
							end

							subChoiceButton.Text = subChoiceName -- Set the text of the sub choice button
							subChoiceButton.Visible = true -- Make the sub choice button visible
							subDialogueIndex += 1
						end
						for i = subDialogueIndex, 3 do
							local subChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. i)
							if subChoiceButton then
								subChoiceButton.Visible = false -- Hide unused buttons
							end
						end
					end
				end))
				choiceIndex += 1
				choiceButton.Visible = true -- Make the choice button visible
			end

			ChoiceGui.Parent = Players.LocalPlayer.PlayerGui
			ChoiceGui.Adornee = npc:WaitForChild("HumanoidRootPart") -- Set the Adornee to the NPC model
			ChoiceGui.Enabled = true -- Enable the GUI
		end
	end)

	return self
end

function NpcService:Destroy()
	print("[NpcService] - NpcService destroyed.")
end

return NpcService
