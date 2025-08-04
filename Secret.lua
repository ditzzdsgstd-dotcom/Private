local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local searching = false
local preferredTiers = {"Secret", "Mythic", "Brainrot God"}

local function matchTargetTier(npcName)
	for _, tier in ipairs(preferredTiers) do
		if string.find(string.lower(npcName), string.lower(tier)) then
			return true
		end
	end
	return false
end

local function hopToServer(id)
	TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
end

local Window = OrionLib:MakeWindow({
	Name = "YoxanXHub | Sniper Finder V2",
	HidePremium = false,
	SaveConfig = false,
	IntroText = "Sniping Active • Searching...",
	ConfigFolder = "YoxanXHub_Sniper"
})

local SniperTab = Window:MakeTab({
	Name = "🎯 Sniper",
	Icon = "rbxassetid://6035198848",
	PremiumOnly = false
})

SniperTab:AddParagraph("Sniping Brainrot", "Auto hop if target found")

SniperTab:AddButton({
	Name = "📋 Copy Discord",
	Callback = function()
		setclipboard("https://discord.gg/Az8Cm2F6")
		OrionLib:MakeNotification({
			Name = "Copied",
			Content = "Discord invite copied!",
			Time = 2
		})
	end
})

local function getServerList(cursor)
	local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
	if cursor then
		url = url.."&cursor="..cursor
	end
	local response = game:HttpGet(url)
	local data = HttpService:JSONDecode(response)
	return data
end

local function findNpcInServer(serverId)
	local success, result = pcall(function()
		local jobUrl = "https://www.roblox.com/servers/"..game.PlaceId.."/server/"..serverId
		local html = game:HttpGet(jobUrl)
		for _, tier in ipairs(preferredTiers) do
			if string.find(string.lower(html), string.lower(tier)) then
				return tier
			end
		end
		return nil
	end)
	return success and result or nil
end

local function searchAndHop()
	if searching then return end
	searching = true
	local checked = 0
	local cursor = nil

	while checked < 10000 and searching do
		local data = getServerList(cursor)
		cursor = data.nextPageCursor

		for _, server in ipairs(data.data) do
			if server.playing < server.maxPlayers then
				local tierFound = findNpcInServer(server.id)
				if tierFound then
					OrionLib:MakeNotification({
						Name = "🎯 Target Found!",
						Content = "Found "..tierFound..", hopping now...",
						Time = 4
					})
					task.wait(1)
					hopToServer(server.id)
					return
				end
				checked += 1
				task.wait(0.2)
			end
		end

		if not cursor then
			break
		end
	end

	OrionLib:MakeNotification({
		Name = "❌ Not Found",
		Content = "No target NPC found in 10k servers.",
		Time = 4
	})
	searching = false
end

SniperTab:AddToggle({
	Name = "🔍 Auto Hop (Secret/Mythic/Brainrot God)",
	Default = true,
	Callback = function(val)
		if val and not searching then
			task.spawn(function()
				while val do
					searchAndHop()
					task.wait(3)
				end
			end)
		end
	end
})
