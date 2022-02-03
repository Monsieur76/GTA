ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local restrictSwitching = false
        
        if IsPedInAnyVehicle(ped, false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                restrictSwitching = true
            end
        end
        
        SetPedConfigFlag(ped, 184, restrictSwitching)
        Wait(150)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId();
        
        local pco = GetEntityCoords(ped);
        local veh = ESX.Game.GetClosestVehicle(pco)
    
        if DoesEntityExist(veh) then

            for i = 1, GetNumberOfVehicleDoors(veh), 1 do
                local coord = GetEntryPositionOfDoor(veh, i);

                if Vdist2(pco.x, pco.y, pco.z, coord.x, coord.y, coord.z) < 0.75 and
                    not DoesEntityExist(GetPedInVehicleSeat(veh, i)) and GetVehicleDoorLockStatus(veh) ~= 2 then
                    if not IsThisModelABike(GetEntityModel(veh)) and not IsThisModelABoat(GetEntityModel(veh)) and IsControlJustPressed(1, 23) then
                        TaskEnterVehicle(ped, veh, 10000, i-1, 1.0, 1, 0);
                    end
                end
            end
        end
    end
end)
