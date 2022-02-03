Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) 
		SetPedDensityMultiplierThisFrame(1.0) 
		SetRandomVehicleDensityMultiplierThisFrame(1.0) 
		SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0) 
		SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
        SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
        SetVehicleModelIsSuppressed(GetHashKey("biff"), true)
		SetGarbageTrucks(false) 
		SetRandomBoats(true) 
		SetCreateRandomCops(false) 
		SetCreateRandomCopsNotOnScenarios(false) 
		SetCreateRandomCopsOnScenarios(false) 
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 0, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 0.0, y - 0.0, z - 0.0, x + 0.0, y + 0.0, z + 0.0);

        if IsPedSittingInAnyVehicle(PlayerPedId()) then

            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(),false),-1) == PlayerPedId() then
                SetVehicleDensityMultiplierThisFrame(1.0)
                SetParkedVehicleDensityMultiplierThisFrame(1.0)
            else
                SetVehicleDensityMultiplierThisFrame(1.0)
                SetParkedVehicleDensityMultiplierThisFrame(1.0)
            end
        else
          SetParkedVehicleDensityMultiplierThisFrame(1.0)
          SetVehicleDensityMultiplierThisFrame(1.0)
        end
	end
end)