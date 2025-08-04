-- ✅ Setup only once
if not getgenv().OrionLib then
    getgenv().OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
    getgenv().Window = getgenv().OrionLib:MakeWindow({
        Name = "YoxanXHub | Sniper Finder V1",
        HidePremium = false,
        SaveConfig = false,
        IntroText = "YoxanX Sniping Online...",
        ConfigFolder = "YoxanXFinder"
    })
end

local OrionLib = getgenv().OrionLib
local Window = getgenv().Window

-- 📌 Info Tab
local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031094678",
    PremiumOnly = false
})

InfoTab:AddParagraph("YoxanXHub V1", "Sniper Finder for Steal a Brainrot")
InfoTab:AddButton({
    Name = "📎 Discord Copy",
    Callback = function()
        setclipboard("https://discord.gg/YoxanXHub")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Discord invite copied to clipboard.",
            Time = 3
        })
    end
})
