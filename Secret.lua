-- YoxanXHub | Sniper Finder V1 (1/5)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V0",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub_Sniper"
})

-- Setup Variables
getgenv().TargetRarities = {"Secret", "Brainrot God", "Mythic"}
getgenv().BrainrotList = {
    ["Chimpanzini Spiderini"] = "Secret",
    ["Los Tralaleritos"] = "Secret",
    ["Las Tralaleritas"] = "Secret",
    ["Graipuss Medussi"] = "Secret",
    ["La Grande Combinasion"] = "Secret",
    ["Nuclearo Dinossauro"] = "Secret",
    ["Garama and Madundung"] = "Secret",
    ["Tortuginni Dragonfruitini"] = "Secret",
    ["Las Vaquitas Saturnitas"] = "Secret",
    ["Chicleteira Bicicleteira"] = "Secret",
    ["Agarrini la Palini"] = "Secret",
    ["Dragon Cannelloni"] = "Secret",
    ["Los Combinasionas"] = "Secret",
    ["Coco Elefanto"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God",
    ["Gattatino Nyanino"] = "Brainrot God",
    ["Matteo"] = "Brainrot God",
    ["Tralalero Tralala"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God",
    ["Odin Din Din Dun"] = "Brainrot God",
    ["Statutino Libertino"] = "Brainrot God",
    ["Trenostruzzo Turbo 3000"] = "Brainrot God",
    ["Ballerino Lololo"] = "Brainrot God",
    ["Trigoligre Frutonni"] = "Brainrot God",
    ["Orcalero Orcala"] = "Brainrot God",
    ["Los Crocodillitos"] = "Brainrot God",
    ["Piccione Macchina"] = "Brainrot God",
    ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Frigo Camelo"] = "Mythic",
    ["Orangutini Ananassini"] = "Mythic",
    ["Rhino Toasterino"] = "Mythic",
    ["Bombardiro Crocodilo"] = "Mythic",
    ["Bombombini Gusini"] = "Mythic",
    ["Cavallo Virtuso"] = "Mythic",
    ["Gorillo Watermelondrillo"] = "Mythic",
    ["Avocadorilla"] = "Mythic",
    ["Spioniro Golubiro"] = "Mythic",
    ["Zibra Zubra Zibralini"] = "Mythic",
    ["Tigrilini Watermelini"] = "Mythic"
}

-- Info Tab
local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031094678",
    PremiumOnly = false
})
InfoTab:AddParagraph("YoxanXHub - Sniper Finder V1", "Snipes servers with target rarities")
InfoTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/brainrot")
        OrionLib:MakeNotification({
            Name = "Discord Copied",
            Content = "Invite copied to clipboard!",
            Time = 3
        })
    end
})

-- YoxanXHub Sniper Finder V1 | 2/5
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local TargetRarities = getgenv().TargetRarities or {"Secret", "Brainrot God", "Mythic"}
local BrainrotList = getgenv().BrainrotList or {}

local function GetServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor then url = url .. "&cursor=" .. cursor end
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function ContainsTarget(playerList)
    for _, player in ipairs(playerList) do
        if BrainrotList[player] and table.find(TargetRarities, BrainrotList[player]) then
            return true, player, BrainrotList[player]
        end
    end
    return false
end

local function ScanAndHop()
    OrionLib:MakeNotification({
        Name = "Sniper Finder",
        Content = "🔍 Scanning up to 100,000 servers...",
        Time = 5
    })

    local cursor = nil
    local scanned = 0
    local max = 100000
    local found = false

    while not found and scanned < max do
        local data = GetServers(cursor)
        if not data then break end
        for _, server in ipairs(data.data) do
            scanned += 1
            cursor = data.nextPageCursor
            if server.playing > 0 and server.id and not server.vipServer then
                local playersList = {}
                for _, p in ipairs(server.playerIds or {}) do
                    table.insert(playersList, tostring(p))
                end
                local detected, targetName, rarity = ContainsTarget(playersList)
                if detected then
                    OrionLib:MakeNotification({
                        Name = "🎯 Target Found!",
                        Content = rarity .. ": " .. targetName,
                        Time = 4
                    })
                    task.wait(1)
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                    return
                end
            end
            if scanned >= max then break end
        end
        if not data.nextPageCursor then break end
    end

    OrionLib:MakeNotification({
        Name = "❌ Not Found",
        Content = "No target rarity found after scanning " .. scanned .. " servers.",
        Time = 5
    })
end

-- Call when ready
ScanAndHop()

-- YoxanXHub Sniper Finder V1 | 3/5
local OrionLib = OrionLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Setup Window
local FinderTab = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V1",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub"
}):MakeTab({
    Name = "🎯 Finder",
    Icon = "rbxassetid://6031071050",
    PremiumOnly = false
})

-- Dropdown rarity
local SelectedRarity = "Secret"
FinderTab:AddDropdown({
    Name = "🎯 Select Rarity",
    Default = "Secret",
    Options = {"Secret", "Brainrot God", "Mythic"},
    Callback = function(Value)
        SelectedRarity = Value
    end
})

-- Mocked Brainrot List (fill dynamically if needed)
local BrainrotList = getgenv().BrainrotList or {
    ["Player1"] = "Secret",
    ["Player2"] = "Brainrot God",
    ["Player3"] = "Mythic"
}

-- Server Scanning Logic
local function GetServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor then url = url .. "&cursor=" .. cursor end
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

local function ContainsTarget(playerList)
    for _, player in ipairs(playerList) do
        if BrainrotList[player] == SelectedRarity then
            return true, player
        end
    end
    return false
end

local function ScanServers(maxCount)
    local cursor = nil
    local scanned = 0
    local found = false

    OrionLib:MakeNotification({
        Name = "Sniper Finder",
        Content = "🔍 Scanning for " .. SelectedRarity .. "...",
        Time = 5
    })

    while not found and scanned < maxCount do
        local data = GetServers(cursor)
        if not data then break end

        for _, server in ipairs(data.data) do
            scanned += 1
            cursor = data.nextPageCursor
            if server.playing > 0 and server.id and not server.vipServer then
                local playersList = server.playerIds or {}
                local detected, playerName = ContainsTarget(playersList)
                if detected then
                    OrionLib:MakeNotification({
                        Name = "🎯 Found!",
                        Content = SelectedRarity .. ": " .. playerName,
                        Time = 4
                    })
                    task.wait(1)
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                    return
                end
            end
            if scanned >= maxCount then break end
        end

        if not data.nextPageCursor then break end
    end

    OrionLib:MakeNotification({
        Name = "❌ Not Found",
        Content = "Scanned " .. scanned .. " servers, no match found.",
        Time = 5
    })
end

-- Manual Scan Button
FinderTab:AddButton({
    Name = "🔎 Manual Scan (100k Servers)",
    Callback = function()
        task.spawn(function()
            ScanServers(100000)
        end)
    end
})

-- Auto Scan Button
FinderTab:AddButton({
    Name = "♻️ Auto Scan Every 30s",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Auto Mode",
            Content = "Auto scanning every 30s...",
            Time = 4
        })
        while true do
            task.spawn(function()
                ScanServers(100000)
            end)
            task.wait(30)
        end
    end
})

-- YoxanXHub | Sniper Finder V1 | 4/5
-- 🧠 Brainrot Data Table for Finder Detection
getgenv().BrainrotList = {
    -- 🟣 Secret
    ["Chimpanzini Spiderini"] = "Secret",
    ["Los Tralaleritos"] = "Secret",
    ["Las Tralaleritas"] = "Secret",
    ["Graipuss Medussi"] = "Secret",
    ["La Grande Combinasion"] = "Secret",
    ["Nuclearo Dinossauro"] = "Secret",
    ["Garama and Madundung"] = "Secret",
    ["Tortuginni Dragonfruitini"] = "Secret",
    ["Pot Hotspot"] = "Secret",
    ["Las Vaquitas Saturnitas"] = "Secret",
    ["Chicleteira Bicicleteira"] = "Secret",
    ["Agarrini la Palini"] = "Secret",
    ["Dragon Cannelloni"] = "Secret",
    ["Los Combinasionas"] = "Secret",

    -- 🔴 Brainrot God
    ["Piccione Macchina"] = "Brainrot God",
    ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Matteo"] = "Brainrot God",
    ["Tralalero Tralala"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God",
    ["Ballerino Lololo"] = "Brainrot God",
    ["Odin Din Din Dun"] = "Brainrot God",
    ["Statutino Libertino"] = "Brainrot God",
    ["Trenostruzzo Turbo 3000"] = "Brainrot God",
    ["Los Crocodillitos"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God",
    ["Gattatino Nyanino"] = "Brainrot God",
    ["Trigoligre Frutonni"] = "Brainrot God",
    ["Orcalero Orcala"] = "Brainrot God",

    -- 🔵 Mythic
    ["Frigo Camelo"] = "Mythic",
    ["Orangutini Ananassini"] = "Mythic",
    ["Rhino Toasterino"] = "Mythic",
    ["Bombardiro Crocodilo"] = "Mythic",
    ["Bombombini Gusini"] = "Mythic",
    ["Cavallo Virtuso"] = "Mythic",
    ["Gorillo Watermelondrillo"] = "Mythic",
    ["Avocadorilla"] = "Mythic",
    ["Spioniro Golubiro"] = "Mythic",
    ["Zibra Zubra Zibralini"] = "Mythic",
    ["Tigrilini Watermelini"] = "Mythic"
}

-- YoxanXHub | Sniper Finder V1 | 5/5 (Viewer, Status, Logs)

local OrionLib = getgenv().OrionLib
local foundMatches = {}
local logHistory = {}
local statusLabel

local FinderTab = OrionLib:MakeTab({
	Name = "🎯 Sniper Finder",
	Icon = "rbxassetid://6031280882",
	PremiumOnly = false
})

-- Status section
FinderTab:AddParagraph("🛰 Status", "Status shown below in real-time.")
statusLabel = FinderTab:AddLabel("🔄 Scanning 0/0 servers...")

-- Found matches
FinderTab:AddButton({
	Name = "📋 View Found Targets",
	Callback = function()
		if #foundMatches == 0 then
			OrionLib:MakeNotification({
				Name = "No Matches",
				Content = "No targets were found.",
				Time = 3
			})
			return
		end
		local msg = ""
		for _, match in pairs(foundMatches) do
			msg ..= `[{match.rarity}] {match.name} | Server: {match.serverId}\n`
		end
		setclipboard(msg)
		OrionLib:MakeNotification({
			Name = "Copied",
			Content = "Target list copied to clipboard.",
			Time = 3
		})
	end
})

-- Full log viewer
FinderTab:AddButton({
	Name = "🗂 View Server Log",
	Callback = function()
		if #logHistory == 0 then
			OrionLib:MakeNotification({
				Name = "Log Empty",
				Content = "No scan data yet.",
				Time = 3
			})
			return
		end
		local msg = ""
		for _, entry in ipairs(logHistory) do
			msg ..= `{entry.serverId} = {entry.result}\n`
		end
		setclipboard(msg)
		OrionLib:MakeNotification({
			Name = "Copied Log",
			Content = "Server log copied to clipboard.",
			Time = 3
		})
	end
})

-- Export function (used by 3/5)
getgenv().SniperLogger = function(currentIndex, totalServers, result, serverId, matchedNPC)
	statusLabel:Set("🔄 Scanning " .. currentIndex .. "/" .. totalServers .. " servers...")

	table.insert(logHistory, {
		serverId = serverId,
		result = matchedNPC and ("FOUND: " .. matchedNPC.name) or "No Match"
	})

	if matchedNPC then
		table.insert(foundMatches, {
			name = matchedNPC.name,
			rarity = matchedNPC.rarity,
			serverId = serverId
		})
		statusLabel:Set("✅ Match found in server " .. serverId)
	end
end
