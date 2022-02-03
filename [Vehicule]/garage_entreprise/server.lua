ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)


-- liste véhicule
ESX.RegisterServerCallback('h4ci_garage:listevoitureentrepris', function(source, cb, name, job)
    local ownedCars = {}
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = @stored', { -- job = NULL
        ['@stored'] = name
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedCars, {
                vehicle = vehicle,
                stored = v.stored,
                plate = v.plate,
                model = v.model
            })
        end
        cb(ownedCars)
    end)
end)


-- état sortie véhicule
RegisterServerEvent('h4ci_garage:etatvehiculesortieentreprise')
AddEventHandler('h4ci_garage:etatvehiculesortieentreprise', function(vehicleProps, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        'UPDATE owned_vehicles SET `stored` = @stored, dateranged =NOW(),vehicle = @vehicle WHERE plate = @plate', {
            ['@stored'] = state,
            ['@plate'] = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps)
        }, function(rowsChanged)
            if rowsChanged == 0 then
                print(('esx_advancedgarage: %s exploited the society garage!'):format(xPlayer.identifier))
            end
        end)
end)

-- ranger véhicule
--ESX.RegisterServerCallback('h4ci_garage:rangervoitureentrepris', function(source, cb, vehicleProps)
 --   local vehiclemodel = vehicleProps.model
 --   local xPlayer = ESX.GetPlayerFromId(source)
 --   MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
--       ['@plate'] = vehicleProps.plate
 --   }, function(result)
 --       if result[1] ~= nil then
 --           if result[1].owner == xPlayer.identifier or result[1].owner == xPlayer.getJob().name then
  --              cb(true)
  --          else
 --               print(('h4ci_garage : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
  --              cb(false)
 --           end+
 --       else
 --           cb(false)
 --       end
 --   end)
--end)
