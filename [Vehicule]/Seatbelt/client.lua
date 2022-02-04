--- "Ramsus" ---

local isUiOpen = false 
local speedBuffer = {}
local velBuffer = {}
local SeatbeltON = false
local InVehicle = false
local vehData = {
  hasBelt = false,
  engineRunning = false,
  hasCruise = false,

  currSpd = 0.0,
  cruiseSpd = 0.0,
  prevVelocity = {x = 0.0, y = 0.0, z = 0.0}, 
};

local wasInCar = false
local oldBodyDamage = 0.0
local oldSpeed = 0.0
local currentDamage = 0.0
local currentSpeed = 0.0
local vehicle

function Notify(string)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(string)
  DrawNotification(false, true)
end

AddEventHandler('seatbelt:sounds', function(soundFile, soundVolume)
  SendNUIMessage({
    transactionType = 'playSound',
    transactionFile = soundFile,
    transactionVolume = soundVolume
  })
end)

function IsCar(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

function Fwv(entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end
 





Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
  
    local ped = PlayerPedId()
    local car = GetVehiclePedIsIn(ped)

    if car ~= 0 and (InVehicle or IsCar(car)) then
      InVehicle = true
          if isUiOpen == false and not IsPlayerDead(PlayerId()) then
            if Config.Blinker then
              SendNUIMessage({displayWindow = 'true'})
            end
              isUiOpen = true
          end

      if SeatbeltON then 
        DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
        DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
	    end


      local playerPed = PlayerPedId();
      local position = GetEntityCoords(playerPed);
      local veh = GetVehiclePedIsIn(playerPed, false);
      SetPlayerVehicleDamageModifier(playerPed,3.0)
      local prevSpeed = 0
      prevSpeed = vehData['currSpd'];
      vehData['currSpd'] = GetEntitySpeed(veh);
      local vehIsMovingFwd = 0
      vehIsMovingFwd = GetEntitySpeedVector(veh, true).y > 5.0;
      local vehAcc = 0
      vehAcc = (prevSpeed - vehData['currSpd']) / GetFrameTime();

      if (not SeatbeltON and vehIsMovingFwd and (prevSpeed > (Config['seatbeltEjectSpeed']/1)) and (vehAcc > (Config['seatbeltEjectAccel']*9.81))) then
                    SetEntityCoords(playerPed, position.x, position.y, position.z - 0.47, true, true, true);
                    SetEntityVelocity(playerPed, vehData['prevVelocity'].x, vehData['prevVelocity'].y, vehData['prevVelocity'].z);
                    Citizen.Wait(1);
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0);
      else
        vehData['prevVelocity'] = GetEntityVelocity(veh);
      end

      velBuffer[2] = velBuffer[1]
      velBuffer[1] = GetEntityVelocity(car)
        
      if IsControlJustReleased(0, Config.Control) and GetLastInputMethod(0) then
          SeatbeltON = not SeatbeltON 
          if SeatbeltON then
          Citizen.Wait(1)
            if Config.Notification then
            Notify(Config.Strings.seatbelt_on)
            end
            isUiOpen = true 
          else 
            if Config.Notification then
            Notify(Config.Strings.seatbelt_off)
            end
            isUiOpen = true  
          end
    end
    elseif InVehicle then
      InVehicle = false
      SeatbeltON = false
      speedBuffer[1], speedBuffer[2] = 0.0, 0.0
          if isUiOpen == true and not IsPlayerDead(PlayerId()) then
            if Config.Blinker then
              SendNUIMessage({displayWindow = 'false'})
            end
            isUiOpen = false 
          end
    end
  end
end)





Citizen.CreateThread(function()
  while true do
    Citizen.Wait(50)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local VehSpeed = GetEntitySpeed(Vehicle) * 3.6

    if Config.AlarmOnlySpeed and VehSpeed > Config.AlarmSpeed then
      ShowWindow = true
    else
      ShowWindow = false
      SendNUIMessage({displayWindow = 'false'})
    end

      if IsPlayerDead(PlayerId()) or IsPauseMenuActive() then
        if isUiOpen == true then
          SendNUIMessage({displayWindow = 'false'})
        end
        elseif not SeatbeltON and InVehicle and not IsPauseMenuActive() and not IsPlayerDead(PlayerId()) and Config.Blinker then
          if Config.AlarmOnlySpeed and ShowWindow and VehSpeed > Config.AlarmSpeed then
            SendNUIMessage({displayWindow = 'true'})
          end
      end
  end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3500)
    if not SeatbeltON and InVehicle and not IsPauseMenuActive() and Config.LoopSound and ShowWindow then
      TriggerEvent("seatbelt:sounds", "seatbelt", Config.Volume)
		end    
	end
end)




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3500)
    if not SeatbeltON and InVehicle and not IsPauseMenuActive() and Config.LoopSound and ShowWindow then
      TriggerEvent("seatbelt:sounds", "seatbelt", Config.Volume)
		end    
	end
end)

--local removeHelmet = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local vehicleClass = GetVehicleClass(Vehicle)
    if IsPedSittingInAnyVehicle(PlayerPedId()) and vehicleClass == 8 or vehicleClass == 13 then
      SetPedConfigFlag(PlayerPedId(), 35, false)
        --RemovePedHelmet(PlayerPedId(), true)
		end    
	end
end)


























function GetVehHealthPercent()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        
            -- If the damage changed, see if it went over the threshold and blackout if necesary
            vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)
            if DoesEntityExist(vehicle) and (wasInCar or IsCar(vehicle)) then
                wasInCar = true
                oldSpeed = currentSpeed
                oldBodyDamage = currentDamage
                currentDamage = GetVehicleBodyHealth(vehicle)
                currentSpeed = GetEntitySpeed(vehicle) * 2.23
                local damage = GetVehHealthPercent(vehicle)

                if currentDamage ~= oldBodyDamage then
                    if  currentDamage < oldBodyDamage then
                        if (oldBodyDamage - currentDamage) >= 40 
                        then
                          Undriveable(vehicle,6000)
                            oldBodyDamage = currentDamage
 
                        elseif (oldBodyDamage - currentDamage) >= 35 and (oldBodyDamage - currentDamage) <= 40
                        then   
                          Undriveable(vehicle,4000)
                            oldBodyDamage = currentDamage
                            
                        

                        elseif (oldBodyDamage - currentDamage) >= 25 and (oldBodyDamage - currentDamage) <= 35
                        then
                          Undriveable(vehicle,2000)
                            oldBodyDamage = currentDamage


                        elseif (oldBodyDamage - currentDamage) >= 10 and (oldBodyDamage - currentDamage) <= 25
                        then
                            oldBodyDamage = currentDamage
                            Undriveable(vehicle,1000)


                        elseif damage < 90 then
                              SetVehicleUndriveable(vehicle, true)
                            end
                        end
                    end
            elseif wasInCar then
                wasInCar = false
                beltOn = false
                currentDamage = 0
                oldBodyDamage = 0
                currentSpeed = 0
                oldSpeed = 0
            end
    end
end)


function Undriveable (vehicle,time)
  SetVehicleUndriveable(vehicle, true)
  Citizen.Wait(time)
  SetVehicleUndriveable(vehicle, false)
end



local vehicleClassDisableControl = {
  [0] = true,     --compacts
  [1] = true,     --sedans
  [2] = true,     --SUV's
  [3] = true,     --coupes
  [4] = true,     --muscle
  [5] = true,     --sport classic
  [6] = true,     --sport
  [7] = true,     --super
  [8] = false,    --motorcycle
  [9] = true,     --offroad
  [10] = true,    --industrial
  [11] = true,    --utility
  [12] = true,    --vans
  [13] = false,   --bicycles
  [14] = false,   --boats
  [15] = false,   --helicopter
  [16] = false,   --plane
  [17] = true,    --service
  [18] = true,    --emergency
  [19] = false    --military
}

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)

      local player = PlayerPedId()
      local vehicle = GetVehiclePedIsIn(player, false)
      local vehicleClass = GetVehicleClass(vehicle)
      if ((GetPedInVehicleSeat(vehicle, -1) == player) and vehicleClassDisableControl[vehicleClass]) then
          if IsEntityInAir(vehicle) then
              DisableControlAction(2, 59)
              DisableControlAction(2, 60)
          end
      end
  end
end)
