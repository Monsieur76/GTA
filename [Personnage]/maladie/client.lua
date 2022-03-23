ESX = nil
--local timergrippe = 9000   --miliseconde
local declanchement = 900000   --miliseconde

local rhume = false
local soleil = false
local herpes = false
local grippe = false  --modif
local timer = 0
local timer2 = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
  data = ESX.PlayerData.maladie
  if data ~= nil then
    for k,v in pairs(data) do
      maladiecontagionorbdd(v)
  end
  end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


Citizen.CreateThread(function()
    while true do
      timer = timer + 500
      local rand = -1

      if timer >= declanchement and herpes == false and soleil == false and grippe == false and rhume == false then
        rand = math.random(0,10000)/100
        randmaladie(rand)
        timer = 0
      end

      Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if herpes or grippe then
      StartScreenEffect("MenuMGIn", 1, true)
    else
      StopScreenEffect("MenuMGIn")
    end
  end
end)


function randmaladie(rand)

  if rand >= 0 and rand <= 2 then
    ESX.ShowNotification('~r~Vous attrapé de l\'herpès')
    TriggerServerEvent('maladie',"herpes")
    TriggerEvent('skinchanger:change', 'blemishes_1',22 )
    TriggerEvent('skinchanger:change', 'blemishes_2',1.0 )
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
      skin.blemishes_1 = 22
      skin.blemishes_2 = 1.0
      TriggerServerEvent('esx_skin:save', skin)
    end)
    StartScreenEffect("MenuMGIn", 0, true)
    herpes = true

    elseif rand >= 15 and rand <= 17 then
      ESX.ShowNotification('~r~Vous avez attrapé un coup de soleil')
      TriggerServerEvent('maladie',"soleil")
      TriggerEvent('skinchanger:change', 'blush_1',4 )
      TriggerEvent('skinchanger:change', 'blush_2',1.0 )
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.blush_1 = 4
        skin.blush_2 = 1.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      SetCamEffect(2)
        soleil = true
      elseif rand >= 40 and rand <= 41 then
        ESX.ShowNotification('~r~Vous avez attrapé la grippe')
        TriggerServerEvent('maladie',"grippe")
        TriggerEvent('skinchanger:change', 'complexion_1',10 )
        TriggerEvent('skinchanger:change', 'complexion_2',1.0 )
        grippe = true
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
          skin.complexion_1 = 10
          skin.complexion_2 = 1.0
          TriggerServerEvent('esx_skin:save', skin)
        end)
        StartScreenEffect("MenuMGIn", 0, true)
      elseif rand >= 20 and rand <= 25 then
        ESX.ShowNotification('~r~Vous avez attrapé le rhume')
        TriggerServerEvent('maladie',"rhume")
        TriggerEvent('skinchanger:change', 'complexion_1',5 )
        TriggerEvent('skinchanger:change', 'complexion_2',1.0 )
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
          skin.complexion_1 = 5
          skin.complexion_2 = 1.0
          TriggerServerEvent('esx_skin:save', skin)
        end)
        SetCamEffect(2)
        rhume = true
    end

end

function maladiecontagionorbdd(maladie)

  if maladie == "herpes" then
    ESX.ShowNotification('~r~Vous attrapé de l\'herpes')
    TriggerEvent('skinchanger:change', 'blemishes_1',22 )
    TriggerEvent('skinchanger:change', 'blemishes_2',1.0 )
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
      skin.blemishes_2 = 22
      skin.blemishes_2 = 1.0
      TriggerServerEvent('esx_skin:save', skin)
    end)
    StartScreenEffect("MenuMGIn", 0, true)
    herpes = true

  elseif maladie == "soleil" then
    ESX.ShowNotification('~r~Vous avez attrapé un coup de soleil')
    TriggerEvent('skinchanger:change', 'blush_1',4 )
      TriggerEvent('skinchanger:change', 'blush_2',1.0 )
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.blush_1 = 4
        skin.blush_2 = 1.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      SetCamEffect(2)
      soleil = true 

    elseif maladie == "grippe" then
      ESX.ShowNotification('~r~Vous avez attrapé la grippe')
      TriggerEvent('skinchanger:change', 'complexion_1',10 )
      TriggerEvent('skinchanger:change', 'complexion_2',1.0 )
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.complexion_2 = 1.0
        skin.complexion_1 = 10
        TriggerServerEvent('esx_skin:save', skin)
      end)
      StartScreenEffect("MenuMGIn", 0, true)

      grippe = true

    elseif maladie == "rhume" then
        ESX.ShowNotification('~r~Vous avez attrapé le rhume')
        TriggerEvent('skinchanger:change', 'complexion_1',5 )
        TriggerEvent('skinchanger:change', 'complexion_2',1.0 )
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
          skin.complexion_2 = 1.0
        skin.complexion_1 = 5
          TriggerServerEvent('esx_skin:save', skin)
        end)
        SetCamEffect(2)
        rhume = true

    end

end


RegisterNetEvent('maladie')
AddEventHandler('maladie', function(maladie)
    maladiecontagionorbdd(maladie)
end)



Citizen.CreateThread(function()
  while true do
    timer2 = timer2 + 500

      if grippe then
        local target, distance = ESX.Game.GetClosestPlayer()
       local target_id = GetPlayerServerId(target)
        if target_id ~= 0 or nil then
          if distance <= 2.0 then 
            if timer2 >= declanchement then
             local rand2 = math.random(0,10000)/100
              timer2 = 0
              if rand2 >= 0 and rand2 <=30 then
                TriggerServerEvent('maladienobdd',"grippe")
              end
            end
          end
        end
      elseif rhume then
        local target, distance = ESX.Game.GetClosestPlayer()
       local target_id = GetPlayerServerId(target)
        if target_id ~= 0 or nil then
          if distance <= 2.0 then 
            if timer2 >= declanchement then
             local rand2 = math.random(0,10000)/100
              timer2 = 0
              if rand2 >= 0 and rand2 <=30 then
                TriggerServerEvent('maladienobdd',"rhume")
              end
            end
          end
        end
      end
      Citizen.Wait(500)
  end
end)

RegisterNetEvent('resetmaladie')
AddEventHandler('resetmaladie', function(maladie)
    if maladie == "rhume" then
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.complexion_2 = 0.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      TriggerEvent('skinchanger:change', 'complexion_2',0.0 )
      SetCamEffect(0)
      rhume =false
    elseif maladie == "grippe" then
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.complexion_2 = 0.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      StopScreenEffect("MenuMGIn")
      TriggerEvent('skinchanger:change', 'complexion_2',0.0 )
      grippe = false
    elseif maladie == "soleil" then
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.blush_2 = 0.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      SetCamEffect(0)
      TriggerEvent('skinchanger:change', 'blush_2',0.0 )

      soleil = false
    elseif maladie == "herpes" then
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        skin.blemishes_2 = 0.0
        TriggerServerEvent('esx_skin:save', skin)
      end)
      StopScreenEffect("MenuMGIn")
      TriggerEvent('skinchanger:change', 'blemishes_2',0.0 )
      herpes = false
    end
end)