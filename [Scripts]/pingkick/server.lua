-- CONFIG --

-- Ping Limit
pingLimit = 500

-- CODE --

RegisterServerEvent("checkMyPingBro")
AddEventHandler("checkMyPingBro", function()
	ping = GetPlayerPing(source)
	if ping >= pingLimit then
		DropPlayer(source, "Votre ping est trop élevé (Max: " .. pingLimit .. " Votre ping: " .. ping .. ")")
	end
end)