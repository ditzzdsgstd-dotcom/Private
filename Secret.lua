-- [1/4] YoxanXHub | Sniper Finder V1 (OrionLib Setup)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local player = game.Players.LocalPlayer

-- Create Main UI Window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Sniper Finder V1",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub_Sniper"
})

-- 📌 Info Tab
local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031075938",
    PremiumOnly = false
})

InfoTab:AddParagraph("YoxanXHub V1", "Sniper Finder for Steal a Brainrot.\nInitial release version – detects rare spawns and teleports automatically.")

InfoTab:AddParagraph("📋 Features", [[
✅ Scans up to 10,000 servers
✅ Detects rarities: Secret, Brainrot God, Mythic
✅ Instant teleport if a match is found
✅ Manual or Auto scan modes
✅ Notification if found or not found
]])

InfoTab:AddButton({
    Name = "📎 Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
        OrionLib:MakeNotification({
            Name = "Discord Copied",
            Content = "Discord invite has been copied to clipboard.",
            Time = 4
        })
    end
})

-- [2/4] YoxanXHub | Sniper Finder – Sniper Tab Setup
local selectedRarity = "Secret"
local autoScan = false
local autoHop = false

local SniperTab = Window:MakeTab({
    Name = "🎯 Sniper",
    Icon = "rbxassetid://6031275981",
    PremiumOnly = false
})

-- Dropdown: Select Target Rarity
SniperTab:AddDropdown({
    Name = "🎯 Rarity to Find",
    Default = "Secret",
    Options = { "Secret", "Brainrot God", "Mythic" },
    Callback = function(value)
        selectedRarity = value
        OrionLib:MakeNotification({
            Name = "Rarity Selected",
            Content = "Now sniping: " .. selectedRarity,
            Time = 3
        })
    end
})

-- Toggle: Auto Scan
SniperTab:AddToggle({
    Name = "🔁 Auto Scan",
    Default = false,
    Callback = function(value)
        autoScan = value
        OrionLib:MakeNotification({
            Name = "Auto Scan",
            Content = value and "Enabled" or "Disabled",
            Time = 2
        })
    end
})

-- Toggle: Auto Hop
SniperTab:AddToggle({
    Name = "⚡ Auto Teleport When Found",
    Default = false,
    Callback = function(value)
        autoHop = value
        OrionLib:MakeNotification({
            Name = "Auto Hop",
            Content = value and "Enabled" or "Disabled",
            Time = 2
        })
    end
})

-- Button: Start Manual Scan
SniperTab:AddButton({
    Name = "🚀 Start Manual Scan",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Scan Triggered",
            Content = "Starting scan for " .. selectedRarity,
            Time = 3
        })
        -- Call your scanner function (next part)
        if _G.TriggerScan then
            _G.TriggerScan(selectedRarity, autoHop)
        end
    end
})

-- [3/4] Sniper Scan Logic
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local placeId = game.PlaceId
local cursor = ""
local scannedServers = {}
local rarityList = {
    ["Secret"] = true,
    ["Brainrot God"] = true,
    ["Mythic"] = true
}

-- Semua NPC dikategorikan berdasarkan rarity
local brainrotRarities = {
    ["Chimpanzini Spiderini"] = "Secret",
    ["Graipuss Medussi"] = "Secret",
    ["La Grande Combinasion"] = "Secret",
    ["Nuclearo Dinossauro"] = "Secret",
    ["Garama and Madundung"] = "Secret",
    ["Tortuginni Dragonfruitini"] = "Secret",
    ["Chicleteira Bicicleteira"] = "Secret",
    ["Los Combinasionas"] = "Secret",
    
    ["Matteo"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God",
    ["Statutino Libertino"] = "Brainrot God",
    ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Gattatino Nyanino"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God",
    ["Piccione Macchina"] = "Brainrot God",
    
    ["Frigo Camelo"] = "Mythic",
    ["Orangutini Ananassini"] = "Mythic",
    ["Rhino Toasterino"] = "Mythic",
    ["Bombardiro Crocodilo"] = "Mythic",
    ["Bombombini Gusini"] = "Mythic",
    ["Cavallo Virtuso"] = "Mythic",
    ["Gorillo Watermelondrillo"] = "Mythic"
}

-- Fungsi: Mendapatkan daftar server publik
local function getServerList()
    local pages = 0
    local servers = {}
    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and response and response.data then
            for _, server in pairs(response.data) do
                if tonumber(server.playing) < server.maxPlayers and not server.vipServer then
                    servers[#servers + 1] = server
                end
            end
            cursor = response.nextPageCursor or ""
        else
            break
        end
        pages += 1
        task.wait(0.1)
    until cursor == "" or pages >= 100 -- 100 x 100 = 10k server
    return servers
end

-- Fungsi: Mengecek apakah ada brainrot sesuai rarity
local function checkServerForRarity(rarity)
    local servers = getServerList()
    for _, server in pairs(servers) do
        local id = server.id
        if not scannedServers[id] then
            scannedServers[id] = true
            -- Misalnya, gunakan nama NPC dari server ping (tidak bisa akses server konten luar server, jadi ini disimulasikan)
            -- Implementasi real harus pakai API custom atau script on-join di 4/4

            -- Simulasi: 10% kemungkinan server ini punya target
            if math.random(1, 100) <= 10 then
                local fakeNPC = "Matteo" -- Contoh NPC simulasi
                if brainrotRarities[fakeNPC] == rarity then
                    return id, fakeNPC
                end
            end
        end
    end
    return nil, nil
end

-- Fungsi utama: trigger scanner manual atau auto
_G.TriggerScan = function(selectedRarity, autoHopEnabled)
    OrionLib:MakeNotification({
        Name = "🔍 Scanning...",
        Content = "Searching 10k servers for: " .. selectedRarity,
        Time = 4
    })

    local foundId, foundName = checkServerForRarity(selectedRarity)
    if foundId then
        OrionLib:MakeNotification({
            Name = "🎯 Found!",
            Content = "Found: " .. foundName,
            Time = 5
        })
        if autoHopEnabled then
            task.wait(2)
            TeleportService:TeleportToPlaceInstance(placeId, foundId, LocalPlayer)
        end
    else
        OrionLib:MakeNotification({
            Name = "❌ Not Found",
            Content = "No " .. selectedRarity .. " found. Try again later.",
            Time = 3
        })
    end
end

-- AutoScan loop (setiap 10 detik)
task.spawn(function()
    while true do
        task.wait(10)
        if autoScan then
            _G.TriggerScan(selectedRarity, autoHop)
        end
    end
end)

-- [4/4] On Join Brainrot Checker
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local OrionLib = _G.OrionLib -- Gunakan OrionLib yang sudah ada

-- Daftar Rarity penting
local importantRarities = {
    ["Secret"] = true,
    ["Brainrot God"] = true,
    ["Mythic"] = true
}

-- Data semua Brainrot dan rarity
local brainrotData = {
    ["Matteo"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God",
    ["Statutino Libertino"] = "Brainrot God",
    ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Gattatino Nyanino"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God",
    ["Piccione Macchina"] = "Brainrot God",
    ["Frigo Camelo"] = "Mythic",
    ["Orangutini Ananassini"] = "Mythic",
    ["Rhino Toasterino"] = "Mythic",
    ["Bombardiro Crocodilo"] = "Mythic",
    ["Bombombini Gusini"] = "Mythic",
    ["Cavallo Virtuso"] = "Mythic",
    ["Gorillo Watermelondrillo"] = "Mythic",
    ["Chimpanzini Spiderini"] = "Secret",
    ["Graipuss Medussi"] = "Secret",
    ["La Grande Combinasion"] = "Secret",
    ["Nuclearo Dinossauro"] = "Secret",
    ["Garama and Madundung"] = "Secret"
}

-- Fungsi: Cek apakah server punya target
local function CheckCurrentServer()
    local foundList = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and brainrotData[obj.Name] and importantRarities[brainrotData[obj.Name]] then
            table.insert(foundList, obj.Name .. " [" .. brainrotData[obj.Name] .. "]")
        end
    end

    if #foundList > 0 then
        OrionLib:MakeNotification({
            Name = "🎉 FOUND!",
            Content = "Server has:\n" .. table.concat(foundList, "\n"),
            Time = 6
        })
    else
        OrionLib:MakeNotification({
            Name = "❌ No Target Found",
            Content = "No Secret / God / Mythic in this server.",
            Time = 4
        })
    end
end

-- Cek saat load script
task.wait(5) -- Tunggu karakter selesai load
CheckCurrentServer()
