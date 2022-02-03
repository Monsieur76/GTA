ESX = nil
local playerCars = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

-- AddEventHandler('ddx_vehiclelock:hasEnteredMarker', function(zone)

-- CurrentAction     = 'Serrurier'
-- CurrentActionMsg  = 'Serrurier'
-- CurrentActionData = {zone = zone}

-- end)

-- AddEventHandler('ddx_vehiclelock:hasExitedMarker', function(zone)

-- CurrentAction = nil
-- ESX.UI.Menu.CloseAll()

-- end)

function OpenCloseVehicle()
    local playerPed = PlayerPedId()
    local PedPosition = GetEntityCoords(playerPed)

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = ESX.Game.GetClosestVehicle(PedPosition)
    end
    ESX.TriggerServerCallback('ddx_vehiclelock:mykey', function(gotkey)
        if gotkey then
            local locked = GetVehicleDoorLockStatus(vehicle)
			TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
            if locked == 1 or locked == 0 then -- if unlocked
                SetVehicleDoorsLocked(vehicle, 2)
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                PlayVehicleDoorCloseSound(vehicle, 1)
                ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
            elseif locked == 2 then -- if locked
                SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                PlayVehicleDoorOpenSound(vehicle, 0)
                ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
            end
        else
            ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
        end
    end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
    while true do
        local dict = "anim@mp_player_intmenu@key_fob@"

        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        Wait(0)
        if IsControlJustReleased(0, 303) then -- Touche U
            OpenCloseVehicle()
        end
    end
end)

-- Create Blips
-- Citizen.CreateThread(function()
--		local blip = AddBlipForCoord(Config.Zones.place.Pos.x, Config.Zones.place.Pos.y, Config.Zones.place.Pos.z)
--		SetBlipSprite (blip, 134)
--		SetBlipDisplay(blip, 4)
--		SetBlipScale  (blip, 0.6)
--		SetBlipColour (blip, 3)
--		SetBlipAsShortRange(blip, true)
--		BeginTextCommandSetBlipName("STRING")
--		AddTextComponentString('Serrurier')
--		EndTextCommandSetBlipName(blip)
-- end)

-- RegisterNetEvent('NB:car')
-- AddEventHandler('NB:car', function()
--	OpenCloseVehicle()
-- end)
