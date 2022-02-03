
RegisterNetEvent('hudDisablereticule')
AddEventHandler('hudDisablereticule', function()  
    SendNUIMessage({
        hud = false,
    })
end)

RegisterNetEvent('hudEnablereticule')
AddEventHandler('hudEnablereticule', function()  
    SendNUIMessage({
        hud = true,
    })
end)