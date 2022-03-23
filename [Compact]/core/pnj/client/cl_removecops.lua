Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local playerPed = PlayerPedId()
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)

    end
end)

-- SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
-- SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
-- SetVehicleModelIsSuppressed(GetHashKey("biff"), true)
