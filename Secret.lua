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
