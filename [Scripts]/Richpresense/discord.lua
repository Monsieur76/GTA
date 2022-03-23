ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj)
          ESX = obj
      end)
      Citizen.Wait(0)
  end
end)


Citizen.CreateThread(function()
  while true do
      
      Citizen.Wait(30*1000) -- Checkea cada 5 segundos
      
      SetDiscordAppId(933923829074526279) -- ID Del BOT

      local player = PlayerId()
      local name = GetPlayerName(player)
		  local id = GetPlayerServerId(player)

      ESX.TriggerServerCallback('presencePlayer', function(playerNumber)
		    SetRichPresence(name ..  " | " .. playerNumber .. "/128 | ID: " .. id)
      end)

      SetDiscordRichPresenceAsset("logo_tales") -- nombre logo grande
      SetDiscordRichPresenceAssetText(name) -- Nombre en el logo grande

      SetDiscordRichPresenceAssetSmall("logo_tales") -- nombre logo pequeño
      SetDiscordRichPresenceAssetSmallText("ID: ".. id) -- logo pequeño

      SetDiscordRichPresenceAction(0, "💻 Discord!", "https://discord.gg/7NY83kv5")
      SetDiscordRichPresenceAction(1, "🕹️ Jouer!", "fivem://connect/147.189.171.46:30112")

  end
end)