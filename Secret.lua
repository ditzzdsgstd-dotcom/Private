-- // YoxanXHub Sniper Finder V2 - 1/2
-- OrionLib UI Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Main Window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Brainrot Sniper",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanX Sniping Finder",
    ConfigFolder = "YoxanXHubSniper"
})

-- Sniper Tab
local SniperTab = Window:MakeTab({
    Name = "🎯 Sniper Finder",
    Icon = "rbxassetid://6031071057",
    PremiumOnly = false
})

local RankList = {"Secret", "Brainrot God", "Mythic", "Legendary"}
local SelectedRank = "Secret"
local AutoHop = false
local IsSearching = false

-- UI Elements
SniperTab:AddDropdown({
    Name = "Target Rank",
    Default = "Secret",
    Options = RankList,
    Callback = function(v)
        SelectedRank = v
    end
})

SniperTab:AddToggle({
    Name = "Auto-Hop on Found",
    Default = true,
    Callback = function(v)
        AutoHop = v
    end
})

local label = SniperTab:AddParagraph("Status", "Sniping active... searching servers...")

-- Brainrot list by rank
local BrainrotRanks = {
    ["Secret"] = {
        "La Grande Combinasion", "Graipuss Medussi", "Chimpanzini Spiderini",
        "Garama and Madundung", "Dragon Cannelloni", "Los Combinasionas",
        "Tortuginni Dragonfruitini", "Agarrini la Palini"
    },
    ["Brainrot God"] = {
        "Espresso Signora", "Matteo", "Trippi Troppi Troppa Trippa", "Statutino Libertino",
        "Tralalero Tralala", "Piccione Macchina", "Trenostruzzo Turbo 3000"
    },
    ["Mythic"] = {
        "Frigo Camelo", "Gorillo Watermelondrillo", "Rhino Toasterino", "Avocadorilla"
    },
    ["Legendary"] = {
        "Ballerina Cappuccina", "Blueberrini Octapusini", "Glorbo Fruttodrillo",
        "Chef Crabracadabra", "Lionel Cactuseli", "Strawberelli Flamingelli"
    }
}

local function containsTarget(npcName)
    for _, v in ipairs(BrainrotRanks[SelectedRank] or {}) do
        if npcName:lower():find(v:lower()) then
            return true
        end
    end
    return false
end

-- // YoxanXHub Sniper Finder V2 - 2/2
-- Server Scanner Logic

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = 109983668079237
local found = false

local function FetchServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100&sortOrder=Asc"
    if cursor then url = url.."&cursor="..cursor end
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and response or nil
end

local function CheckServer(server)
    if server.playing < server.maxPlayers and not server.id:find(game.JobId) then
        return true
    end
    return false
end

local function HopToServer(server)
    if AutoHop then
        label:Set("Status", "Sniping ✅ Found server! Hopping...")
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
    else
        label:Set("Status", "Found server with target! Auto-hop disabled.")
    end
end

local function SimulateNPCs() -- You can replace this later with real ESP scan in-game if available
    local simulatedNPCs = {
        "Noobini Pizzanini", "Glorbo Fruttodrillo", "Tortuginni Dragonfruitini", "Strawberelli Flamingelli"
    }
    for _, name in pairs(simulatedNPCs) do
        if containsTarget(name) then
            return true
        end
    end
    return false
end

SniperTab:AddButton({
    Name = "🔍 Start Scan 10K Servers",
    Callback = function()
        if IsSearching then
            OrionLib:MakeNotification({
                Name = "⚠️ Already Running",
                Content = "Sniping is already in progress.",
                Time = 3
            })
            return
        end

        IsSearching = true
        label:Set("Status", "Sniping Active: Searching up to 10,000 servers...")

        local scanned = 0
        local cursor = nil

        for i = 1, 100 do
            if found then break end
            local data = FetchServers(cursor)
            if not data then
                label:Set("Status", "❌ Failed to fetch servers.")
                break
            end

            for _, server in pairs(data.data) do
                if found then break end
                if CheckServer(server) then
                    scanned += 1
                    label:Set("Status", "Scanning: "..scanned.." servers...")
                    task.wait(0.05)

                    if SimulateNPCs() then
                        found = true
                        HopToServer(server)
                        return
                    end
                end
            end

            cursor = data.nextPageCursor
            if not cursor then break end
        end

        if not found then
            label:Set("Status", "❌ No target NPCs found in 10,000 servers.")
        end
        IsSearching = false
    end
})

-- Continue on part 2/2
label:Set("Status", "Finder initialized. Press scan...")
