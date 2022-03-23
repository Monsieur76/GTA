Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        for k, v in pairs(Config.ClearPedsVehicles) do
            ClearAreaOfPeds(v.x, v.y, v.z, v.r, 1)
            if k ~= "lost" and k ~= "lsms_parking_haut" then
                ClearAreaOfVehicles(v.x, v.y, v.z, v.r, false, false, false, false, false)
                RemoveVehiclesFromGeneratorsInArea(v.x - 0.0, v.y - 0.0, v.z - 0.0, v.x + 0.0, v.y + 0.0, v.z + 0.0);
            end
        end
    end
end)
