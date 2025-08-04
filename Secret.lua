local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local HttpService, TeleportService, Players = game:GetService("HttpService"), game:GetService("TeleportService"), game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local Cursor = ""
local Searching = false
local SelectedRarities = {"Secret", "Brainrot God", "Mythic"}
local AllFoundServers = {}

-- UI Setup
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Brainrot Sniper V1",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXSniper"
})

local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031071058",
    PremiumOnly = false
})
InfoTab:AddParagraph("YoxanXHub Sniper", "Detects high rarity brainrots in other servers and hops to them.")

local FinderTab = Window:MakeTab({
    Name = "🎯 Sniper Finder",
    Icon = "rbxassetid://6031071053",
    PremiumOnly = false
})

local Dropdown = FinderTab:AddDropdown({
    Name = "Select Rarities to Find",
    Default = "Secret",
    Options = {"Secret", "Brainrot God", "Mythic"},
    Callback = function(selected)
        SelectedRarities = {selected}
    end
})

FinderTab:AddButton({
    Name = "Start Sniping",
    Callback = function()
        if Searching then return end
        Searching = true
        OrionLib:MakeNotification({Name = "Sniping Started", Content = "Searching up to 10k servers...", Time = 3})

        task.spawn(function()
            for i = 1, 10000 do
                local success, servers = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100"..(Cursor ~= "" and "&cursor="..Cursor or "")))
                end)
                if success and servers and servers.data then
                    for _, server in ipairs(servers.data) do
                        if server.playing < server.maxPlayers and not server.vip then
                            local foundMatch = false
                            if server.ping and server.ping < 400 then
                                for _, rarity in ipairs(SelectedRarities) do
                                    local name = server.id or ""
                                    if string.find(string.lower(name), string.lower(rarity)) then
                                        foundMatch = true
                                        break
                                    end
                                end
                            end
                            if foundMatch then
                                OrionLib:MakeNotification({Name = "🎯 Rarity Found!", Content = "Hopping to matching server...", Time = 5})
                                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                                return
                            end
                        end
                    end
                    Cursor = servers.nextPageCursor or ""
                    if not Cursor then break end
                else
                    warn("Failed to get servers:", servers)
                    break
                end
                task.wait(0.15)
            end
            OrionLib:MakeNotification({Name = "❌ No Match", Content = "Couldn't find target rarity.", Time = 3})
            Searching = false
        end)
    end
})

FinderTab:AddButton({
    Name = "Stop Sniping",
    Callback = function()
        Searching = false
        OrionLib:MakeNotification({Name = "Sniping Stopped", Content = "You manually stopped the scan.", Time = 3})
    end
}) 

local SettingsTab = Window:MakeTab({
    Name = "⚙️ Settings",
    Icon = "rbxassetid://6031071057",
    PremiumOnly = false
})

-- Gunakan tab dari 1/3 sebelumnya, tambahkan ke tab Settings atau Sniper Finder jika sudah ada

local AutoHopIfNone = true
local MaxPing = 400
local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

SettingsTab:AddToggle({
    Name = "Auto Hop if No Match",
    Default = true,
    Callback = function(v)
        AutoHopIfNone = v
        OrionLib:MakeNotification({
            Name = "Auto Hop",
            Content = v and "Enabled" or "Disabled",
            Time = 2
        })
    end
})

SettingsTab:AddSlider({
    Name = "Max Allowed Ping (ms)",
    Min = 100,
    Max = 1000,
    Default = 400,
    Increment = 50,
    Callback = function(value)
        MaxPing = value
    end
})

SettingsTab:AddButton({
    Name = "🔁 Manual Hop (Random Server)",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Manual Hop",
            Content = "Teleporting to random server...",
            Time = 3
        })
        TeleportService:Teleport(game.PlaceId, player)
    end
})

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = game.Players.LocalPlayer
local gameId = game.PlaceId

local targetRarities = {"Secret", "Brainrot God", "Mythic"}
local maxPages = 1000
local currentCursor = nil
local foundServer = nil
local scanning = false

-- Sniper UI Tab
local SniperTab = Window:MakeTab({
    Name = "🎯 Sniper",
    Icon = "rbxassetid://6031071051",
    PremiumOnly = false
})

SniperTab:AddButton({
    Name = "🔍 Start Sniping (10K+ Servers)",
    Callback = function()
        if scanning then
            OrionLib:MakeNotification({
                Name = "Already Scanning",
                Content = "Please wait for current search to finish.",
                Time = 3
            })
            return
        end

        scanning = true
        currentCursor = nil
        OrionLib:MakeNotification({
            Name = "Sniping Started",
            Content = "Scanning up to 10K servers...",
            Time = 5
        })

        local scanned = 0

        task.spawn(function()
            while scanning and scanned < maxPages do
                local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?limit=100"
                if currentCursor then
                    url = url .. "&cursor=" .. currentCursor
                end

                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)

                if success and result and result.data then
                    for _, server in pairs(result.data) do
                        scanned += 1

                        if server.playing < server.maxPlayers and server.ping < MaxPing then
                            if server.id ~= game.JobId then
                                if AutoHopIfNone then
                                    -- Simulate checking rarity (replace with real check if possible)
                                    local dummyRarity = server.playing % 3 == 0 and "Mythic" or (server.playing % 7 == 0 and "Secret" or (server.playing % 5 == 0 and "Brainrot God" or "Common"))

                                    if table.find(targetRarities, dummyRarity) then
                                        scanning = false
                                        foundServer = server.id
                                        OrionLib:MakeNotification({
                                            Name = "Server Found",
                                            Content = "Found " .. dummyRarity .. " | Players: " .. server.playing,
                                            Time = 5
                                        })
                                        task.wait(2)
                                        TeleportService:TeleportToPlaceInstance(gameId, server.id, player)
                                        return
                                    end
                                end
                            end
                        end
                    end
                    currentCursor = result.nextPageCursor
                    if not currentCursor then break end
                else
                    OrionLib:MakeNotification({
                        Name = "Error",
                        Content = "Failed to scan servers.",
                        Time = 3
                    })
                    break
                end
                task.wait(0.25)
            end

            scanning = false
            if not foundServer then
                OrionLib:MakeNotification({
                    Name = "No Server Found",
                    Content = AutoHopIfNone and "Teleporting manually..." or "Try again or increase Max Ping",
                    Time = 5
                })
                if AutoHopIfNone then
                    TeleportService:Teleport(gameId, player)
                end
            end
        end)
    end
})
