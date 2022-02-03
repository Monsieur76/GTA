ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx_radars:sendBill')
AddEventHandler('esx_radars:sendBill', function(rue, point, plate, price, vehicleClass, speeding)
    local _source = source
    local xPlayers = ESX.GetPlayerFromId(_source)
    local xPlayersAll = ESX.GetPlayers()
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1].owner:find('police') or result[1].owner == "ambulance" or result[1].owner:find('mairie') or result[1].owner:find('fbi') then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH", (plate or ""),
                "~g~Véhicule autorisé.", 'CHAR_MP_PROF_BOSS', nil)
        else
            if vehicleClass == 8 or vehicleClass == 13 then
                MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive', {
                    ['@identifier'] = xPlayers.identifier,
                    ['@drive'] = "bike"
                }, function(result)
                    local found = false
                    if result[1] ~= nil then
                        if xPlayers.identifier == result[1].owner then
                            found = true
                        end
                    end
                    if found then
                        MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive',
                            {
                                ['@identifier'] = xPlayers.identifier,
                                ['@drive'] = "bike"
                            }, function(result)
                                if result[1].point <= point then
                                    xPlayers.removeAccountMoney("bank", price)
                                    RemoveDriveLicense(xPlayers.identifier, "bike")
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""), "Vous avez été flashé à " .. math.ceil(speeding) ..
                                            "km/h. Vous perdez ~r~" .. price .. "$~w~ et ~r~votre permis.",
                                        'CHAR_MP_PROF_BOSS', nil)
                                        for i = 1, #xPlayersAll, 1 do
                                            local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                            if xPlayer.job.name:find('police') then
                                                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                            end
                                        end
                                else
                                    local points = result[1].point - point
                                    MySQL.Async.execute(
                                        'UPDATE user_licenses SET `point` = @point WHERE owner = @owner and type = @drive',
                                        {
                                            ['@point'] = points,
                                            ['@drive'] = "bike",
                                            ['@owner'] = xPlayers.identifier
                                        })
                                    xPlayers.removeAccountMoney("bank", price)
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""),
                                        "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" ..
                                            price .. "$~w~ et " .. point .. " points.", 'CHAR_MP_PROF_BOSS', nil)
                                            for i = 1, #xPlayersAll, 1 do
                                                local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                                if xPlayer.job.name:find('police') then
                                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                        rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                                end
                                            end
                                end
                            end)
                    else
                        local xTarget = ESX.GetPlayers()
                        xPlayers.removeAccountMoney("bank", price)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH", (plate or ""),
                            "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" .. price ..
                                "$", 'CHAR_MP_PROF_BOSS', nil)
                        for i = 1, #xTarget, 1 do
                            local xTarget = ESX.GetPlayerFromId(xTarget[i])
                            if xTarget.job.name:find('police') then
                                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, "FLASH", "",
                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H .", 'CHAR_MP_PROF_BOSS', nil)
                            end
                        end
                    end
                end)
            elseif vehicleClass == 10 or vehicleClass == 20 then
                MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive', {
                    ['@identifier'] = xPlayers.identifier,
                    ['@drive'] = "truck"
                }, function(result)
                    local found = false
                    if result[1] ~= nil then
                        if xPlayers.identifier == result[1].owner then
                            found = true
                        end
                    end
                    if found then
                        MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive',
                            {
                                ['@identifier'] = xPlayers.identifier,
                                ['@drive'] = "truck"
                            }, function(result)
                                if result[1].point <= point then
                                    xPlayers.removeAccountMoney("bank", price)
                                    RemoveDriveLicense(xPlayers.identifier, "truck")
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""), "Vous avez été flashé à " .. math.ceil(speeding) ..
                                            "km/h. Vous perdez ~r~" .. price .. "$~w~ et ~r~votre permis.",
                                        'CHAR_MP_PROF_BOSS', nil)
                                        for i = 1, #xPlayersAll, 1 do
                                            local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                            if xPlayer.job.name:find('police') then
                                                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                            end
                                        end
                                else
                                    local points = result[1].point - point
                                    MySQL.Async.execute(
                                        'UPDATE user_licenses SET `point` = @point WHERE owner = @owner and type = @drive',
                                        {
                                            ['@point'] = points,
                                            ['@drive'] = "truck",
                                            ['@owner'] = xPlayers.identifier
                                        })
                                    xPlayers.removeAccountMoney("bank", price)
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""),
                                        "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" ..
                                            price .. "$~w~ et " .. point .. " points.", 'CHAR_MP_PROF_BOSS', nil)
                                            for i = 1, #xPlayersAll, 1 do
                                                local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                                if xPlayer.job.name:find('police') then
                                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                        rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                                end
                                            end
                                end
                            end)
                    else
                        local xTarget = ESX.GetPlayers()
                        xPlayers.removeAccountMoney("bank", price)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH", (plate or ""),
                            "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" .. price ..
                                "$", 'CHAR_MP_PROF_BOSS', nil)
                        for i = 1, #xTarget, 1 do
                            local xTarget = ESX.GetPlayerFromId(xTarget[i])
                            if xTarget.job.name:find('police') then
                                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, "FLASH", "",
                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H .", 'CHAR_MP_PROF_BOSS', nil)
                            end
                        end
                    end
                end)

            else
                MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive', {
                    ['@identifier'] = xPlayers.identifier,
                    ['@drive'] = "drive"
                }, function(result)
                    local found = false
                    if result[1] ~= nil then
                        if xPlayers.identifier == result[1].owner then
                            found = true
                        end
                    end
                    if found then
                        MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive',
                            {
                                ['@identifier'] = xPlayers.identifier,
                                ['@drive'] = "drive"
                            }, function(result)
                                if result[1].point <= point then
                                    xPlayers.removeAccountMoney("bank", price)
                                    RemoveDriveLicense(xPlayers.identifier, "drive")
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""), "Vous avez été flashé à " .. math.ceil(speeding) ..
                                            "km/h. Vous perdez ~r~" .. price .. "$~w~ et ~r~votre permis.",
                                        'CHAR_MP_PROF_BOSS', nil)
                                        for i = 1, #xPlayersAll, 1 do
                                            local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                            if xPlayer.job.name:find('police') then
                                                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                            end
                                        end
                                else
                                    local points = result[1].point - point
                                    MySQL.Async.execute(
                                        'UPDATE user_licenses SET `point` = @point WHERE owner = @owner and type = @drive',
                                        {
                                            ['@point'] = points,
                                            ['@drive'] = "drive",
                                            ['@owner'] = xPlayers.identifier
                                        })
                                    xPlayers.removeAccountMoney("bank", price)
                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH",
                                        (plate or ""),
                                        "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" ..
                                            price .. "$~w~ et " .. point .. " points.", 'CHAR_MP_PROF_BOSS', nil)
                                            for i = 1, #xPlayersAll, 1 do
                                                local xPlayer = ESX.GetPlayerFromId(xPlayersAll[i])
                                                if xPlayer.job.name:find('police') then
                                                    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                                                        rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H", 'CHAR_MP_PROF_BOSS', nil)
                                                end
                                            end
                                end
                            end)
                    else
                        local xTarget = ESX.GetPlayers()
                        xPlayers.removeAccountMoney("bank", price)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayers.source, "FLASH", (plate or ""),
                            "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h. Vous perdez ~r~" .. price ..
                                "$", 'CHAR_MP_PROF_BOSS', nil)

                        for i = 1, #xTarget, 1 do
                            local xTarget = ESX.GetPlayerFromId(xTarget[i])
                            if xTarget.job.name:find('police') then
                                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, "FLASH", "",
                                    rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H .", 'CHAR_MP_PROF_BOSS', nil)

                            end
                        end
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent('vehicleVole')
AddEventHandler('vehicleVole', function(rue, point, plate, price, vehicleClass, speeding)
    local _source = source
    local xTarget = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local stringPlate = ""
    TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, "FLASH", (plate or "") .. "~r~(volé)",
        "Vous avez été flashé à " .. math.ceil(speeding) .. "km/h.", 'CHAR_MP_PROF_BOSS', nil)
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name:find('police') then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "FLASH", "",
                rue .. ". ~g~(" .. plate .. ")~b~ " .. math.ceil(speeding) .. "KM/H ~r~(volé)", 'CHAR_MP_PROF_BOSS', nil)
        end
    end
end)

ESX.RegisterServerCallback('plateFound', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate,
    }, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)


function RemoveDriveLicense(identifier, permis)
    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner and type = @drive', {
        ['@owner'] = identifier,
        ['@drive'] = permis
    })
end
