-- YoxanXHub | Sniper Finder V1 - 1/3 (UI Setup)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V1",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanXSniper",
    IntroText = "YoxanXHub | Brainrot Sniping",
    IntroEnabled = true
})

-- Global Settings
_G.SniperSettings = {
    AutoHop = true,
    TargetTypes = {"Secret"}
}

-- 🎯 Sniper Tab
local SniperTab = Window:MakeTab({
    Name = "🎯 Sniper",
    Icon = "rbxassetid://6031071050",
    PremiumOnly = false
})

SniperTab:AddParagraph("Sniping Target", "Automatically hops if target is found.")

SniperTab:AddDropdown({
    Name = "🎯 Select Target Rarity",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Brainrot God"},
    Callback = function(Value)
        _G.SniperSettings.TargetTypes = {Value}
        OrionLib:MakeNotification({
            Name = "Target Set",
            Content = "Now sniping: " .. Value,
            Time = 3
        })
    end
})

SniperTab:AddToggle({
    Name = "🔁 Auto Hop (if no target)",
    Default = true,
    Callback = function(Value)
        _G.SniperSettings.AutoHop = Value
    end
})

SniperTab:AddButton({
    Name = "📋 Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/yourserver") -- Replace with your actual Discord invite
        OrionLib:MakeNotification({
            Name = "Discord",
            Content = "Discord link copied!",
            Time = 3
        })
    end
})

-- ℹ️ Info Tab
local InfoTab = Window:MakeTab({
    Name = "ℹ️ Info",
    Icon = "rbxassetid://6031280882",
    PremiumOnly = false
})

InfoTab:AddParagraph("Script Version", "YoxanXHub - Sniper Finder V1")
InfoTab:AddParagraph("Features", "- Server sniper UI\n- Auto hop toggle\n- Target rarity selector\n- Fully mobile-pasteable\n- OrionLib UI")

-- YoxanXHub | Sniper Finder V1 - 2/3 (Sniper Logic)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GameId = game.GameId

-- Internal: Converts characters in NPC name for comparison
local function normalize(str)
    return string.lower(str):gsub("%s+", "")
end

-- Masterlist (normalized)
local BrainrotList = {
    Secret = {
        "lavaccasaturnosaturnita", "chimpanzinispiderini", "lostralaleirtos", "lastralaleritas",
        "graipussmedussi", "lagrandecombinasion", "nuclearodinossauro", "garamaandmadundung",
        "tortuginnidragonfruitini", "pothotspot", "lasvaquitassaturnitas", "chicleteirabicicleteira",
        "agarrinilapalini", "dragoncannelloni", "loscombinasionas"
    },
    Mythic = {
        "frigocamelo", "orangutiniananassini", "rhinotoasterino", "bombardirocrocodilo", "bombombinigusini",
        "cavallovirtuso", "gorillowatermelondrillo", "avocadorilla", "spionirogolubiro", "zibrazubrazibralini",
        "tigriliniwatermelini"
    },
    ["Brainrot God"] = {
        "cocoelefanto", "girafacelestre", "gattatinonyanino", "matteo", "tralalerotralala", "espressosignora",
        "odindindindun", "statutinolibertino", "trenostruzzoturbo3000", "ballerinolololo", "trigoligrefrutonni",
        "orcaleroorcala", "loscrocodilitos", "piccionemacchina", "trippitroppitroppatrippa"
    }
}

-- Scan server for target
local function hasTarget()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name and npc:FindFirstChildOfClass("Humanoid") then
            local name = normalize(npc.Name)
            for _, rarity in ipairs(_G.SniperSettings.TargetTypes) do
                for _, match in ipairs(BrainrotList[rarity] or {}) do
                    if name:find(match) then
                        return true, rarity, npc.Name
                    end
                end
            end
        end
    end
    return false
end

-- Sniper core
task.spawn(function()
    local cursor = ""
    local hopSuccess = false
    local checked = 0
    while not hopSuccess and checked < 10000 do
        local url = "https://games.roblox.com/v1/games/"..GameId.."/servers/Public?sortOrder=Desc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and not server.vipServerId then
                    local teleportFunc = function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    end

                    local joined = pcall(teleportFunc)
                    if joined then
                        task.wait(3)
                        local found, rarity, npcName = hasTarget()
                        if found then
                            OrionLib:MakeNotification({
                                Name = "🎯 Target Found!",
                                Content = npcName .. " (" .. rarity .. ") found. Sniping...",
                                Time = 5
                            })
                            hopSuccess = true
                            break
                        elseif _G.SniperSettings.AutoHop then
                            -- not found, continue hopping
                        end
                    end
                end
                checked += 1
                if checked >= 10000 then break end
            end
            cursor = result.nextPageCursor or ""
            if cursor == nil then break end
        else
            break
        end
    end

    if not hopSuccess then
        OrionLib:MakeNotification({
            Name = "Sniping Result",
            Content = "Finished checking 10k servers. No target found.",
            Time = 5
        })
    end
end)

_G.SniperSettings = {
    Enabled = false,
    AutoHop = true,
    TargetTypes = {"Secret", "Mythic", "Brainrot God"},
}

local OrionLib = OrionLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V1",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Sniping Active: Searching...",
    ConfigFolder = "YoxanXHubSniper"
})

local Tab = Window:MakeTab({
    Name = "🎯 Sniper Finder",
    Icon = "rbxassetid://6035047409",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "🔎 Enable Sniper",
    Default = false,
    Callback = function(v)
        _G.SniperSettings.Enabled = v
        if v then
            OrionLib:MakeNotification({
                Name = "Sniper Running",
                Content = "Now searching up to 10,000 servers...",
                Time = 5
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YoxanXHub/Brainrot.sniper/main/logic.lua"))()
        else
            OrionLib:MakeNotification({
                Name = "Sniper Stopped",
                Content = "Sniper disabled manually.",
                Time = 3
            })
        end
    end
})

Tab:AddToggle({
    Name = "⚡ Auto Hop If Not Found",
    Default = true,
    Callback = function(v)
        _G.SniperSettings.AutoHop = v
    end
})

Tab:AddLabel("Target Rarity (always ON):")
Tab:AddParagraph("✅ Scans for:", "Secret\nMythic\nBrainrot God")

OrionLib:MakeNotification({
    Name = "YoxanXHub Loaded",
    Content = "Sniper Finder V1 is ready.",
    Time = 4
})

OrionLib:MakeNotification({
    Name = "YoxanXHub Loaded",
    Content = "Sniper Finder UI initialized successfully.",
    Time = 4
})
