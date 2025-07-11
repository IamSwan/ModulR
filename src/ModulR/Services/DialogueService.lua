--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local DialogueService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {},
}

local Dialogues = {}

-- Local functions
local function loadDialogues()
    local dialogueFolder = game.ReplicatedStorage.Data.Dialogues
    local dialogues = {}

    for _, dialogue in ipairs(dialogueFolder:GetChildren()) do
        if dialogue:IsA("ModuleScript") then
            local dialogueData = require(dialogue)
            dialogues[dialogue.Name] = dialogueData
        end
    end
    return dialogues
end

-- Init (qui va être supprimé lors de l'init du core)
function DialogueService:Initialize()
    Dialogues = loadDialogues()
    print("[DialogueService] - Dialogues loaded:", Dialogues)
    ModulR:GetEventBus():Broadcast("DialogueServiceInit")
    return self
end

function DialogueService:Destroy()
    print("[DialogueService] - DialogueService destroyed.")
end

function DialogueService.Client:GetDialogue(npcName: string)
    -- This function would start a dialogue with the NPC
    print("[DialogueService] - Getting dialogue for NPC:", npcName)
    local dialogue = Dialogues[npcName]
    print("[DialogueService] - Dialogue found:", dialogue)
end

return DialogueService
