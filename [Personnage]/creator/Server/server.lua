ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('CreatVehicle')
AddEventHandler('CreatVehicle', function(plate, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        "INSERT INTO `owned_vehicles` SET `owner` = @owner, `plate` = @plate, `vehicle` = @vehicle,`type` = @type,`model` = @model,`price` = @price,`stored` = @stored",
        {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(vehicle),
            ['@type'] = "car",
            ['@model'] = "Kalahari",
            ['@price'] = 20,
            ['@stored'] = 9
        })
end)
