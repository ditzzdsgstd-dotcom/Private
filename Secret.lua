-- ✅ OrionLib Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V1.5",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanX Sniping Initialized",
    ConfigFolder = "YoxanXFinder"
})

-- 📌 Info Tab
local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031094678",
    PremiumOnly = false
})

InfoTab:AddParagraph("YoxanXHub V1.5", "Sniper Finder for Steal a Brainrot")

InfoTab:AddButton({
    Name = "📎 Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
        OrionLib:MakeNotification({
            Name = "Link Copied",
            Content = "Discord invite copied to clipboard.",
            Time = 3
        })
    end
})

--// Pastikan ini disambung dari 1/5, OrionLib dan Window sudah ada
local targetRarities = {"Secret", "Brainrot God", "Mythic"}
local autoHopEnabled = false
local selectedRarity = "Secret"

local SniperTab = Window:MakeTab({
	Name = "🎯 Sniper Settings",
	Icon = "rbxassetid://6031071058",
	PremiumOnly = false
})

SniperTab:AddDropdown({
	Name = "🎯 Target Rarity",
	Default = "Secret",
	Options = targetRarities,
	Callback = function(v)
		selectedRarity = v
		OrionLib:MakeNotification({
			Name = "Target Rarity",
			Content = "Now scanning for: " .. v,
			Time = 3
		})
	end
})

SniperTab:AddToggle({
	Name = "♻️ AutoHop if Not Found",
	Default = false,
	Callback = function(v)
		autoHopEnabled = v
	end
})

SniperTab:AddButton({
	Name = "📡 Scan 100K Servers",
	Callback = function()
		if _G.SniperScanRunning then
			OrionLib:MakeNotification({
				Name = "Already Scanning",
				Content = "Please wait, still scanning.",
				Time = 3
			})
			return
		end
		_G.SniperScanRunning = true
		loadstring("scan_server_target = '" .. selectedRarity .. "'; scan_auto_hop = " .. tostring(autoHopEnabled) .. "; found_teleport = false")()
		loadstring([[-- 3/5 logic will run here]])() -- Placeholder: real logic in 3/5
	end
})

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local SelectedRarities = {"Secret", "Brainrot God", "Mythic"}

-- List brainrot name & rarity
local BrainrotList = {
    ["Tortuginni Dragonfruitini"] = "Secret", ["Matteo"] = "Brainrot God", ["Frigo Camelo"] = "Mythic",
    ["Chimpanzini Spiderini"] = "Secret", ["La Vacca Saturno Saturnita"] = "Secret", ["Coco Elefanto"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God", ["Garama and Madundung"] = "Secret", ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God", ["Trigoligre Frutonni"] = "Brainrot God Lucky", ["Zibra Zubra Zibralini"] = "Mythic Lucky",
    ["Bombombini Gusini"] = "Mythic", ["Cavallo Virtuso"] = "Mythic", ["Blueberrini Octapusini"] = "Legendary",
    ["Odin Din Din Dun"] = "Brainrot God", ["Los Tralaleirtos"] = "Secret", ["Tralalero Tralala"] = "Brainrot God",
    ["Orcalero Orcala"] = "Brainrot God Lucky", ["Nuclearo Dinossauro"] = "Secret"
}

-- UI Log Function (Requires OrionLib loaded in 1/5)
function LogStatus(text)
    OrionLib:MakeNotification({
        Name = "Sniper Log",
        Content = tostring(text),
        Time = 3
    })
end

-- Core Search Function
local Cursor = ""
local MaxServers = 100000
local HopCooldown = 0.5
local Searched = 0
local Found = false

LogStatus("Sniping active... searching 100k servers")

local function SearchServerBatch()
    if Found then return end
    local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?limit=100&sortOrder=Desc&cursor=%s", PlaceId, Cursor)
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.maxPlayers > 1 and server.playing < server.maxPlayers and server.id ~= game.JobId then
                Searched += 1

                -- Check each server's brainrot name (simulate detection here)
                local serverName = server.name or ""
                for name, rarity in pairs(BrainrotList) do
                    if table.find(SelectedRarities, rarity) and string.find(serverName:lower(), name:lower()) then
                        LogStatus("✅ Found: "..name.." ("..rarity..")")
                        Found = true
                        TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                        return
                    end
                end
            end
        end
        Cursor = result.nextPageCursor or ""
    else
        LogStatus("❌ Error fetching servers")
    end
end

-- Loop search fast
task.spawn(function()
    while not Found and Searched < MaxServers and Cursor do
        SearchServerBatch()
        task.wait(HopCooldown)
    end
    if not Found then
        LogStatus("❌ No suitable server found.")
    end
end)

-- PASTIKAN OrionLib DAN Window sudah dibuat di 1/5
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Fallback default
_G.FoundServerId = _G.FoundServerId or nil
_G.ScanStatus = _G.ScanStatus or "Idle"
_G.ScannedCount = _G.ScannedCount or 0

-- Fungsi Manual Hop
local function ManualHop()
    if _G.FoundServerId then
        OrionLib:MakeNotification({
            Name = "Manual Hop",
            Content = "Teleporting to found server...",
            Time = 3
        })
        TeleportService:TeleportToPlaceInstance(PlaceId, _G.FoundServerId, LocalPlayer)
    else
        OrionLib:MakeNotification({
            Name = "No Server Found",
            Content = "Scanner hasn't found a valid server yet.",
            Time = 3
        })
    end
end

-- Tambah Tab ke window utama dari 1/5
local StatusTab = Window:MakeTab({
    Name = "📊 Status",
    Icon = "rbxassetid://6031280882",
    PremiumOnly = false
})

-- Status Viewer
StatusTab:AddParagraph("Scan Status", function()
    return "🔄 " .. (_G.ScanStatus or "Unknown")
end)

StatusTab:AddParagraph("Servers Scanned", function()
    return tostring(_G.ScannedCount or 0)
end)

StatusTab:AddParagraph("Found Server ID", function()
    return _G.FoundServerId or "None"
end)

StatusTab:AddButton({
    Name = "🔁 Teleport to Found Server",
    Callback = ManualHop
})

StatusTab:AddParagraph("🔍 Scanner Log", "")

local LogBox = StatusTab:AddTextbox({
    Name = "Live Log",
    Default = "",
    TextDisappear = false,
    Callback = function() end
})

-- Auto update logs
task.spawn(function()
    while task.wait(0.2) do
        if not _G.ScanLog then _G.ScanLog = {} end
        local latestLogs = table.concat(_G.ScanLog, "\n")
        LogBox:Set(latestLogs:sub(-500)) -- Batasi 500 char agar tidak berat
    end
end)
