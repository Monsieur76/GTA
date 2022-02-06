ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'police', 'alerte police', true, true)

TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {
    type = 'public'
})

RegisterNetEvent('equipementbase')
AddEventHandler('equipementbase', function(name, dispo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM weapon where label=@label', {
        ['@label'] = name
    }, function(result)
        if result[1].dispo > 0 then
            MySQL.Async.execute('UPDATE weapon SET `dispo` = dispo - 1 WHERE `label` = @label', {
                ['@label'] = name
            })
            if xPlayer.canCarryItem(name, 1) then
                xPlayer.addInventoryItem(name, 1)
                TriggerClientEvent('esx:showNotification', _source, "Vous avez reçue votre arme")
            else
                TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "L'arme n'est plus disponible")
        end
    end)
end)

RegisterNetEvent('Updatefourrière')
AddEventHandler('Updatefourrière', function(plate)
    MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate', {
        ['@stored'] = 0,
        ['@plate'] = plate
    })
end)

ESX.RegisterServerCallback('policejob:select', function(source, cb)
    local vehicule = {}

    MySQL.Async.fetchAll('SELECT * FROM car_police', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(vehicule, {
                name = result[i].nom,
                dispo = result[i].dispo
            })
        end

        cb(vehicule)
    end)
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
    MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
        ['@category'] = category
    }, function(fines)
        cb(fines)
    end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)

        local retrivedInfo = {
            plate = plate
        }

        if result[1] then
            MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier', {
                ['@identifier'] = result[1].owner
            }, function(result2)

                if Config.EnableESXIdentity then
                    retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
                else
                    retrivedInfo.owner = result2[1].name
                end

                cb(retrivedInfo)
            end)
        else
            cb(retrivedInfo)
        end
    end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] ~= nil then

            MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier', {
                ['@identifier'] = result[1].owner
            }, function(result2)

                if Config.EnableESXIdentity then
                    cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
                else
                    cb(result2[1].name, true)
                end

            end)
        else
            cb(_U('unknown'), false)
        end
    end)
end)

RegisterServerEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
        Citizen.Wait(5000)
        TriggerClientEvent('esx_policejob:updateBlip', -1)
    end
end)

RegisterServerEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
    TriggerClientEvent('esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(5000)
        TriggerClientEvent('esx_policejob:updateBlip', -1)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('esx_phone:removeNumber', 'police')
    end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
    TriggerClientEvent('esx:showNotification', target, msg)
end)

-- ALERTE LSPD

RegisterServerEvent('TireEntenduServeur')
AddEventHandler('TireEntenduServeur', function(gx, gy, gz)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'police' then
            TriggerClientEvent('TireEntendu', xPlayers[i], gx, gy, gz)
        end
    end
end)

RegisterServerEvent('PriseAppelServeur')
AddEventHandler('PriseAppelServeur', function(gx, gy, gz)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local name = xPlayer.getName(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'police' then
            TriggerClientEvent('PriseAppel', xPlayers[i], name)
        end
    end
end)

RegisterServerEvent('police:PriseEtFinservice')
AddEventHandler('police:PriseEtFinservice', function(PriseOuFin)
    local _source = source
    local _raison = PriseOuFin
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName(_source)

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'police' then
            TriggerClientEvent('police:InfoService', xPlayers[i], _raison, name)
        end
    end
end)

RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords, playerlocation)
    _source = source
    TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords, playerlocation)
    _source = source
    TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:douncuffing', _source)
end)

RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
    local _source = source
    local _raison = raison
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'police' then
            TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
        end
    end
end)

----------------------

------------------------------------------------ Intéraction

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
    TriggerClientEvent('esx_policejob:handcuff', target)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
    local _source = source
    TriggerClientEvent('esx_policejob:drag', target, _source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
    TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

-------------------------------- Fouiller

RegisterNetEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemName, amount, label)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    if sourceXPlayer.canCarryItem(itemName, amount) then
        targetXPlayer.removeInventoryItem(itemName, amount)
        sourceXPlayer.addInventoryItem(itemName, amount)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source,
            'Vous avez confisqué ~g~' .. amount .. " " .. itemName)
        TriggerClientEvent('esx:showNotification', targetXPlayer.source,
            'On vous a saisi ~r~' .. amount .. " " .. itemName)
            if itemName == "radio" then
                TriggerClientEvent('ls-radio:onRadioDrop', targetXPlayer.source)
        end
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Vous n'avez plus de place")
    end

end)

RegisterNetEvent('esx_policejob:confiscatePlayerItemWeapon')
AddEventHandler('esx_policejob:confiscatePlayerItemWeapon', function(target, itemName, name, count)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    local amount = 1
    if sourceXPlayer.hasWeapon(name) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source,
            "~r~Vous ne pouvez pas porter plus d'arme de ce type")
    else
        targetXPlayer.removeWeapon(name)
        sourceXPlayer.addWeapon(name, count)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source,
            'Vous avez confisqué ~g~' .. amount .. " " .. itemName)
        TriggerClientEvent('esx:showNotification', targetXPlayer.source,
            'On vous a saisi ~r~' .. amount .. " " .. itemName)
    end

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)
    local data = {}
    local items = xPlayer.inventory
    weapon = xPlayer.getLoadout()
    if notify then
        xPlayer.showNotification('being_searched')
    end
    for k, v in pairs(items) do
        if items[k].count > 0 then
            table.insert(data, {
                name = items[k].name,
                label = items[k].label,
                count = items[k].count,
                item = "item",
                index = 1
            })
        end
    end
    for k, v in pairs(weapon) do
        table.insert(data, {
            name = weapon[k].name,
            label = weapon[k].label,
            item = "weapon",
            count = weapon[k].ammo
        })
    end
    table.insert(data, {
        item = "money",
        count = xPlayer.getAccount("black_money").money + xPlayer.getAccount("money").money
    })
    cb(data)
end)

RegisterServerEvent('retraitpoint')
AddEventHandler('retraitpoint', function(point, target, permis, del)
    local __source = source
    local xPlayers = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier and type = @drive', {
        ['@identifier'] = xPlayers.identifier,
        ['@drive'] = permis
    }, function(result)
        local found = false
        if result[1] ~= nil then
            if xPlayers.identifier == result[1].owner then
                found = true
            end
        end
        if found then
            if del then
                MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner and  type = @drive', {
                    ['@owner'] = xPlayers.identifier,
                    ['@drive'] = permis
                })
                TriggerClientEvent('esx:showNotification', __source, "Vous avez confisquez le permis " .. permis)
            else
                if result[1].point > point then
                    local points = result[1].point - point
                    MySQL.Async.execute(
                        'UPDATE user_licenses SET `point` = @point WHERE owner = @owner and type = @drive', {
                            ['@point'] = points,
                            ['@drive'] = permis,
                            ['@owner'] = xPlayers.identifier
                        })
                    TriggerClientEvent('esx:showNotification', __source, "Vous avez retirez " .. point .. " point(s)")
                else
                    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner and  type = @drive', {
                        ['@owner'] = xPlayers.identifier,
                        ['@drive'] = permis
                    })
                    TriggerClientEvent('esx:showNotification', __source,
                        "Vous avez confisquez le permis " .. permis .. " car il n'y avais plus de point")
                end
            end
        else
            TriggerClientEvent('esx:showNotification', __source,
                "La personne n'a pas de permis de conduire, vous devriez lui mettre 1h de cellule")
        end
    end)
end)

RegisterServerEvent('barrierMettre')
AddEventHandler('barrierMettre', function()
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' and xPlayer.getInventoryItem("barriere").count > 0 then
        xPlayer.removeInventoryItem('barriere', 1)
        TriggerClientEvent('barrier', source)
    elseif xPlayer.job.name == 'policeNorth' and xPlayer.getInventoryItem("barriere").count > 0 then
        xPlayer.removeInventoryItem('barriere', 1)
        TriggerClientEvent('barrier', source)
    else
        TriggerClientEvent('esx:showNotification', __source, "Vous n'avez pas de barrière")
    end
end)

RegisterServerEvent('plotMettre')
AddEventHandler('plotMettre', function()
        local __source = source
        local xPlayer = ESX.GetPlayerFromId(__source)
        if xPlayer.job.name == 'police' and xPlayer.getInventoryItem("plot").count > 0 then
            xPlayer.removeInventoryItem('plot', 1)
            TriggerClientEvent('plot', __source)
        elseif xPlayer.job.name == 'ambulance' and xPlayer.getInventoryItem("plot").count > 0 then
            xPlayer.removeInventoryItem('plot', 1)
            TriggerClientEvent('plot', __source)
        elseif xPlayer.job.name == 'policeNorth' and xPlayer.getInventoryItem("plot").count > 0 then
            xPlayer.removeInventoryItem('plot', 1)
            TriggerClientEvent('plot', __source)
        else
            TriggerClientEvent('esx:showNotification', __source, "Vous n'avez pas de plot")
        end
end)

RegisterServerEvent('herseMettre')
AddEventHandler('herseMettre', function()
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' and xPlayer.getInventoryItem("herse").count > 0 then
        xPlayer.removeInventoryItem('herse', 1)
        TriggerClientEvent('herse', source)
    elseif xPlayer.job.name == 'policeNorth' and xPlayer.getInventoryItem("plot").count > 0 then
        xPlayer.removeInventoryItem('herse', 1)
        TriggerClientEvent('herse', source)
    else
        TriggerClientEvent('esx:showNotification', __source, "Vous n'avez pas de herse")
    end
end)

RegisterServerEvent('hersedeployer')
AddEventHandler('hersedeployer', function(x, y, z, deploy)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('hersedeployere', xPlayers[i], x, y, z)
    end
end)

RegisterServerEvent('retireherse')
AddEventHandler('retireherse', function(deploy)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('retirehersee', xPlayers[i], deploy)
    end
end)

RegisterServerEvent('verifFauxBillet')
AddEventHandler('verifFauxBillet', function(target_id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target_id)
    if xTarget.getAccount("black_money").money >= 0 then
        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Laboratoire",
            '~b~' .. xTarget.getAccount("black_money").money .. "$ de sale",
            'Appuyer sur ~g~Y ~s~pour prendre l\'argent et sur ~r~N ~s~pour ne pas prendre l\'argent', 'CHAR_ABIGAIL', 9)
        TriggerClientEvent("prendre_faux_billet", xPlayer.source, source, target_id,
            xTarget.getAccount("black_money").money)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "La personne n'a pas d'argent sale sur elle")
    end
end)

RegisterServerEvent('Prendre_billet_faux')
AddEventHandler('Prendre_billet_faux', function(source, target_id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target_id)
    amount = xTarget.getAccount("black_money").money
    if amount >= 0 then
        xTarget.removeAccountMoney("black_money", amount)
        xPlayer.addAccountMoney("black_money", amount)
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez perdu " .. amount .. "$ d'argent sale")
        TriggerClientEvent('esx:showNotification', xPlayer.source,
            "Vous avez récupéré " .. amount .. "$ d'argent sale.")
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "La personne n'a pas d'argent sale sur elle")
    end
end)

RegisterServerEvent('refus_billet_faux')
AddEventHandler('refus_billet_faux', function(target_id)
    local xTarget = ESX.GetPlayerFromId(target_id)
    TriggerClientEvent('esx:showNotification', xTarget.source, "L'agent n'a rien pris c'est votre jour de chance !")
end)
