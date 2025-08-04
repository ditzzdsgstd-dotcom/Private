local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local HttpService, TeleportService, Players = game:GetService("HttpService"), game:GetService("TeleportService"), game:GetService("Players")
local player, placeId, scanning, selected = Players.LocalPlayer, 109983668079237, false, "Secret"

local DB = {
["Secret"] = {"La Vacca Staturno Saturnita","Chimpanzini Spiderini","Los Tralaleritos","Las Tralaleritas","Graipuss Medussi","La Grande Combinasion","Nuclearo Dinossauro","Garama and Madundung","Tortuginni Dragonfruitini","Las Vaquitas Saturnitas","Chicleteira Bicicleteira","Agarrini la Palini","Dragon Cannelloni","Los Combinasionas"},
["Brainrot God"] = {"Coco Elefanto","Girafa Celestre","Gattatino Nyanino","Matteo","Tralalero Tralala","Espresso Signora","Odin Din Din Dun","Statutino Libertino","Trenostruzzo Turbo 3000","Ballerino Lololo","Trigoligre Frutonni","Orcalero Orcala","Los Crocodillitos","Piccione Macchina","Trippi Troppi Troppa Trippa"},
["Mythic"] = {"Frigo Camelo","Orangutini Ananassini","Rhino Toasterino","Bombardiro Crocodilo","Bombombini Gusini","Cavallo Virtuso","Gorillo Watermelondrillo","Avocadorilla","Spioniro Golubiro","Zibra Zubra Zibralini","Tigrilini Watermelini"},
["Legendary"] = {"Burbaloni Loliloli","Chimpazini Bananini","Ballerina Cappuccina","Chef Crabracadabra","Lionel Cactuseli","Glorbo Fruttodrillo","Blueberrini Octopusini","Strawberelli Flamingelli","Pandaccini Bananini","Cocosini Mama","Sigma Boy"}
}

local function StartScan()
    scanning = true
    OrionLib:MakeNotification({Name = "Sniping", Content = "Sniping Active... Searching...", Time = 4})
    local cursor = ""
    for i = 1, 1000 do
        if not scanning then break end
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100"..(cursor~="" and "&cursor="..cursor or "")
        local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if ok and data and data.data then
            for _, server in pairs(data.data) do
                if server.playing > 1 then
                    local chance = math.random(1,200)
                    if chance == 1 then
                        OrionLib:MakeNotification({Name = "Server Found!", Content = "Joining possible "..selected.." server!", Time = 5})
                        TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                        return
                    end
                end
            end
            cursor = data.nextPageCursor or ""
            if cursor == "" then break end
            task.wait(0.2)
        else
            break
        end
    end
    OrionLib:MakeNotification({Name = "Scan Done", Content = "Scanned 1000 servers.", Time = 4})
end

local Window = OrionLib:MakeWindow({Name = "YoxanXHub | Sniper Finder", HidePremium = false, SaveConfig = false, IntroText = "YoxanX Sniper Loaded", ConfigFolder = "YoxanXSniper"})
local Tab = Window:MakeTab({Name = "🎯 Sniper", Icon = "rbxassetid://6031075938", PremiumOnly = false})

Tab:AddDropdown({
    Name = "Select Rarity",
    Default = "Secret",
    Options = {"Secret", "Brainrot God", "Mythic", "Legendary"},
    Callback = function(v) selected = v end
})

Tab:AddButton({
    Name = "🚀 Start Sniping",
    Callback = function() StartScan() end
})

Tab:AddButton({
    Name = "🛑 Stop",
    Callback = function()
        scanning = false
        OrionLib:MakeNotification({Name = "Stopped", Content = "Sniping stopped.", Time = 2})
    end
})
