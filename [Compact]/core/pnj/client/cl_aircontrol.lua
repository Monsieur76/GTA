-- Vehicles to enable/disable air control
local vehicleClassDisableControl = {
    [0] = false,     --compacts
    [1] = false,     --sedans
    [2] = false,     --SUV's
    [3] = false,     --coupes
    [4] = false,     --muscle
    [5] = false,     --sport classic
    [6] = false,     --sport
    [7] = false,     --super
    [8] = false,    --motorcycle
    [9] = false,     --offroad
    [10] = false,    --industrial
    [11] = false,    --utility
    [12] = false,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = false,    --service
    [18] = false,    --emergency
    [19] = false    --military
}

-- Main thread
Citizen.CreateThread(function()
    while true do
        -- Loop forever and update every frame
        Citizen.Wait(0)

        -- Get player, vehicle and vehicle class
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)

        -- Disable control if player is in the driver seat and vehicle class matches array
        if ((GetPedInVehicleSeat(vehicle, -1) == player) and vehicleClassDisableControl[vehicleClass]) then
            -- Check if vehicle is in the air and disable L/R and UP/DN controls
            if IsEntityInAir(vehicle) then
                DisableControlAction(2, 59)
                DisableControlAction(2, 60)
            end
        end
    end
end)
