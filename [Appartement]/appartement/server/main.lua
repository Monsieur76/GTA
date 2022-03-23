ESX = nil
local indentifierColocOwner

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('esx_property:getUserProperty', function(source, cb)
    local userProperty = nil
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    for _, v in pairs(Config.Properties) do
        if userProperty == nil and xPlayer ~= nil then
            if v.owner_identifier == xPlayer.identifier then
                userProperty = v
            end
            if v.coloc_name ~= nil then
                for k in pairs(v.coloc_name) do
                    if v.coloc_name[k].identifier == xPlayer.identifier then
                        userProperty = v
                    end
                end
            end
        end
    end
    cb(userProperty)
end)

ESX.RegisterServerCallback('esx_property:getOwnedProperty', function(source, cb)
    local userProperty = nil
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    for _, v in pairs(Config.Properties) do
        if userProperty == nil and xPlayer ~= nil then
            if v.owner_identifier == xPlayer.identifier then
                userProperty = v
            end
        end
    end
    cb(userProperty)
end)

ESX.RegisterServerCallback("upgradeProperty:applyUpgrade", function(source, cb, upgrade, level, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= price then
        for _, v in pairs(Config.Properties) do
            if v.owner_identifier == xPlayer.identifier then
                v[upgrade] = level
                v["level_coloc"]= level
                xPlayer.removeMoney(price)
                TriggerClientEvent("esx:showNotification", xPlayer.source,
                    "Amélioration niveau " .. level .. " achetée pour ~r~" .. price .. "$")
                cb(true)
            end
        end
    else
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous n'avez pas assez d'argent")
        cb(false)
    end
end)

RegisterServerEvent('properties:buyProperties')
AddEventHandler('properties:buyProperties', function(label, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        if getIdentifierOwner(xPlayer.identifier) and getColocIdentifier(xPlayer.identifier) then
            xPlayer.removeMoney(price)
            addProprtie(label, xPlayer)
            TriggerClientEvent("esx:showNotification", xPlayer.source,
                "Vous venez d'acheter un logement pour ~r~" .. price .. " $")
            TriggerClientEvent('esx_property:sendProperties', -1)
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous possédez déjà une propriété")
        end
    else
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous n'avez pas assez d'argent")
    end
end)

RegisterServerEvent('properties:NewColoc')
AddEventHandler('properties:NewColoc', function(label, target_id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target_id)
    if getColoc(label) > 0 then
        if getColocIdentifier(xTarget.identifier) then
            if getIdentifierOwner(xTarget.identifier) then
                addColoc(label, xTarget.identifier, xTarget.getName())
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Un nouveau colocataire vient d'arriver")
                TriggerClientEvent("esx:showNotification", xTarget.source, "Vous êtes colocataire !")
                TriggerClientEvent('esx_property:sendProperties', -1)
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "La personne a déjà une propriété")
                TriggerClientEvent("esx:showNotification", xTarget.source, "Vous avez déja une propriété !")
            end
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "La personne a déjà une colocation")
            TriggerClientEvent("esx:showNotification", xTarget.source, "Vous avez déja une colocation !")
        end
    else
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous n'avez plus de place en colocation")
        TriggerClientEvent("esx:showNotification", xTarget.source, "Plus de place en colocation")
    end
end)

RegisterServerEvent('properties:removeColoc')
AddEventHandler('properties:removeColoc', function(name, label, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    removeColoc(label, identifier, name)
    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez expulsé " .. name)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        if xTarget.identifier == identifier then
            TriggerClientEvent("esx:showNotification", xTarget.source, "Vous avez été ~r~expulsé")
        end
    end
    TriggerClientEvent('esx_property:sendProperties', -1)
end)

RegisterServerEvent('properties:sellProperties')
AddEventHandler('properties:sellProperties', function(label, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    xPlayer.addMoney(price)
    MySQL.Async.execute(
        'UPDATE properties SET owner = @owner,owner_identifier = @owner_identifier,name_owner = @name_owner,number_coloc = @number_coloc,level_garage = @level_garage,level_coffre = @level_coffre,level_coffre_fort = @level_coffre_fort, level_coloc=@level_coloc, coloc_name = @coloc_name WHERE label = @label',
        {
            ['@owner'] = false,
            ['@owner_identifier'] = "",
            ['@name_owner'] = "",
            ['@number_coloc'] = 1,
            ['@level_garage'] = 0,
            ['@level_coffre_fort'] = 0,
            ['@level_coffre'] = 0,
            ['@level_coloc'] = 0,
            ['@coloc_name'] = "",
            ['@label'] = label
        })
    removeProprtie(label)
    TriggerEvent("coffreFortAppartement:delete", label)
    TriggerEvent("coffreAppartement:delete", label)
    TriggerEvent("frigo:delete", label)
    TriggerEvent("garageAppartement:setToFourriere", label)
    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu votre logement pour ~g~" .. price .. "$")
    TriggerClientEvent('esx_property:sendProperties', -1)
end)

AddEventHandler("garageAppartement:setToFourriere", function(label)
    local garageName = nil
    for k, v in pairs(Config.Properties) do
        if v.label == label then
            garageName = v.garage
        end
    end
    if garageName ~= nil then
        MySQL.Async.execute('UPDATE owned_vehicles SET stored = @stored WHERE stored = @from', {
            ['@stored'] = "0",
            ['@from'] = garageName
        })
    end
end)

RegisterServerEvent('properties:phone')
AddEventHandler('properties:phone', function(label, identifier, x, y, z, h)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local notif = "Une personne sonne "
    getindentifierColocOwner(label, identifier)
    Citizen.Wait(2000)
    local own = false
    for i = 1, #xPlayers do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        if xTarget.identifier == getOwner(label) then
            TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, label, '~b~' .. notif,
                'Appuyez sur ~g~Y ~s~pour accepter ou sur ~r~N ~s~pour refuser', 'CHAR_BLANK_ENTRY', nil)
            TriggerClientEvent("properties:sonnette", xTarget.source, xPlayer.source, x, y, z, h)
            own = true
        end
    end
    if not own then
        for i = 1, #xPlayers do
            local xTarget = ESX.GetPlayerFromId(xPlayers[i])
            for k, v in ipairs(indentifierColocOwner) do
                if xTarget.identifier == v then
                    TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, label, '~b~' .. notif,
                        'Appuyez sur ~g~Y ~s~pour accepter ou sur ~r~N ~s~pour refuser', 'CHAR_BLANK_ENTRY', nil)
                    TriggerClientEvent("properties:sonnette", xTarget.source, xPlayer.source, x, y, z, h)
                end
            end
        end
    end
end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

        for i = 1, #properties, 1 do
            local name = nil
            local label = nil
            local price = nil
            local enter = nil
            local exit = nil
            local garage = nil
            local owner = nil
            local owner_identifier = nil
            local name_owner = nil
            local number_coloc = nil
            local coloc_name = nil

            if properties[i].name ~= nil then
                name = properties[i].name
            end

            if properties[i].label ~= nil then
                label = properties[i].label
            end

            if properties[i].price ~= nil then
                price = properties[i].price
            end

            if properties[i].enter ~= nil then
                enter = json.decode(properties[i].enter)
            end

            if properties[i].exit_properties ~= nil then
                exit = json.decode(properties[i].exit_properties)
            end

            garage = properties[i].garage_name

            if properties[i].owner == false then
                owner = false
            else
                owner = true
            end

            if properties[i].owner_identifier ~= nil then
                owner_identifier = properties[i].owner_identifier
            end

            if properties[i].name_owner ~= nil then
                name_owner = properties[i].name_owner
            end

            if properties[i].number_coloc ~= nil then
                number_coloc = properties[i].number_coloc
            end

            if properties[i].coloc_name ~= nil then
                coloc_name = json.decode(properties[i].coloc_name)

            end
            Citizen.Wait(500)
            table.insert(Config.Properties, {
                name = name,
                label = label,
                price = price,
                enter = enter,
                exit = exit,
                garage = garage,
                owner = owner,
                owner_identifier = owner_identifier,
                name_owner = name_owner,
                number_coloc = number_coloc,
                coloc_name = coloc_name,
                level_garage = properties[i].level_garage,
                level_coffre_fort = properties[i].level_coffre_fort,
                level_coffre = properties[i].level_coffre,
                level_coloc = properties[i].level_coloc
            })
        end

        TriggerEvent('esx_property:sendProperties')
    end)
end)

ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
    cb(Config.Properties)
end)

-- function check

RegisterServerEvent('properties:notify')
AddEventHandler('properties:notify', function(playerid, response, x, y, z, h)
    local xPlayer = ESX.GetPlayerFromId(playerid)
    if response then
        TriggerClientEvent("esx:showNotification", playerid, "~g~Vous avez été autorisé à entrer")
        SetEntityCoords(xPlayer.source, x, y, z, true, true, true, true)
        SetEntityHeading(xPlayer.source, h)
    else
        TriggerClientEvent("esx:showNotification", playerid, "~r~Vous avez été refusé à entrer")
    end
end)

function addProprtie(label, xPlayer)
    for k, v in pairs(Config.Properties) do
        if label == v.label then
            v.owner = true
            v.owner_identifier = xPlayer.identifier
            v.name_owner = xPlayer.getName()
        end
    end
    return Config.Properties
end

ESX.RegisterServerCallback('esx_property:getowned', function(source, cb, name)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if getColocIdentifierLabel(xPlayer.identifier, name) ~= true then
        return cb('coloc',getColocIdentifierLabel(xPlayer.identifier, name))
    elseif getIdentifierOwnerLabel(xPlayer.identifier, name) ~= true then
        return cb('owned',getIdentifierOwnerLabel(xPlayer.identifier, name))
    else
        cb('no')
    end

end)

ESX.RegisterServerCallback('esx_property:getownedpropertyorcoloc', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not getColocIdentifier(xPlayer.identifier) or not getIdentifierOwner(xPlayer.identifier) then
        return cb(true)
    else
        return cb(false)
    end

end)

function removeProprtie(label)
    for k, v in pairs(Config.Properties) do
        if v.label == label then
            v.owner = false
            v.owner_identifier = ""
            v.name_owner = ""
            v.number_coloc = 1
            v.level_garage = 0
            v.level_coffre_fort = 0
            v.level_coffre = 0
            v.level_coloc = 0
            v.coloc_name = {}
        end
    end
    return Config.Properties
end

function getindentifierColocOwner(label, identifier)
    indentifierColocOwner = {}
    for k, v in ipairs(Config.Properties) do
        if v.label == label then
            if v.owner_identifier == identifier then
                table.insert(indentifierColocOwner, v.owner_identifier)
            end
            if v.coloc_name ~= nil and #v.coloc_name > 0 then
                for i = 1, 5, 1 do
                    if v.coloc_name[i] ~= nil then
                        table.insert(indentifierColocOwner, v.coloc_name[i].identifier)
                    end
                end
            end
        end
    end
    return indentifierColocOwner
end

function getOwner(label)
    for k, v in ipairs(Config.Properties) do
        if v.label == label then
            if v.owner_identifier == identifier then
                return v.owner_identifier
            end
        end
    end
    return false
end

function getColoc(label)
    local coloc
    for k, v in pairs(Config.Properties) do
        if v.label == label then
            coloc = v.number_coloc
        end
    end
    return coloc
end

function addColoc(label, identifier, name)
    for k, v in pairs(Config.Properties) do
        if v.label == label then
            v.number_coloc = v.number_coloc - 1
            if v.coloc_name == nil then
                v.coloc_name = {{
                    name = name,
                    identifier = identifier
                }}
            else
                table.insert(v.coloc_name, {
                    name = name,
                    identifier = identifier
                })
            end
        end
    end
    return Config.Properties
end

function removeColoc(label, identifier, name)
    for k, v in pairs(Config.Properties) do
        if v.label == label then
            for a, b in pairs(v.coloc_name) do
                if b.name == name then
                    table.remove(v.coloc_name, a)
                end
            end
            v.number_coloc = v.number_coloc + 1
        end
    end
    return Config.Properties
end

function getColocIdentifier(identifier)
    for k, v in pairs(Config.Properties) do
        if v.coloc_name == nil or v.coloc_name == {} then
        else
            for a, b in pairs(v.coloc_name) do
                if b.identifier == identifier then
                    return false
                end
            end
        end
    end
    return true
end

function getIdentifierOwner(identifier)
    for k, v in pairs(Config.Properties) do
        if identifier == v.owner_identifier then
            return false
        end
    end
    return true
end

function getColocIdentifierLabel(identifier, name)
    for k, v in pairs(Config.Properties) do
        if name == v.name then
            if v.coloc_name == nil or v.coloc_name == {} then
            else
                for a, b in pairs(v.coloc_name) do
                    if b.identifier == identifier then
                        return v.label
                    end
                end
            end
        end
    end
    return true
end

function getIdentifierOwnerLabel(identifier, name)
    for k, v in pairs(Config.Properties) do
        if name == v.name then
            if identifier == v.owner_identifier then
                return v.label
            end
        end
    end
    return true
end

SaveApart = function(cb)
    -- local time = os.time()
    selectList = " SELECT '%s', '%s', '%s' , %s, '%s', '%s' "
    updateCommand = "UPDATE properties u JOIN ("
    for k, v in pairs(Config.Properties) do
        local propertys = Config.Properties[k]
        updateCommand = updateCommand .. " UNION "
        updateCommand = updateCommand ..
                            string.format(selectList, propertys.label, propertys.owner, propertys.owner_identifier,
                propertys.name_owner, propertys.number_coloc, json.encode(propertys.coloc_name))
    end
    updateCommand = updateCommand ..
                        ' ) vals ON u.label = vals.label SET owner = new_owner, owner_identifier = new_owner_identifier, name_owner = new_name_owner, `number_coloc` = new_number_coloc, coloc_name = new_coloc_name'
    MySQL.Async.fetchAll(updateCommand, {}, function(result)
        if result then
            if cb then
                cb()
            else
                print("Appartement save")
            end
        end
    end)
end

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local label
    local owner
    local owner_identifier
    local name_owner
    local number_coloc
    local coloc_name = {}
    local level_garage = 0
    local level_coffre_fort = 0
    local level_coffre = 0
    local level_coloc = 0
    local changement = false

    if xPlayer then
        for k, v in pairs(Config.Properties) do
            if v.owner_identifier == xPlayer.identifier then
                label = v.label
                owner = v.owner
                owner_identifier = v.owner_identifier
                name_owner = v.name_owner
                number_coloc = v.number_coloc
                coloc_name = v.coloc_name
                level_coffre_fort = v.level_coffre_fort
                level_coloc = v.level_coloc
                level_garage = v.level_garage
                level_coffre = v.level_coffre
                changement = true
            end
            if v.coloc_name == nil or v.coloc_name == {} then
            else
                for a, b in pairs(v.coloc_name) do
                    if b.identifier == xPlayer.identifier then
                        label = v.label
                        owner = v.owner
                        owner_identifier = v.owner_identifier
                        name_owner = v.name_owner
                        number_coloc = v.number_coloc
                        coloc_name = v.coloc_name
                        level_coffre_fort = v.level_coffre_fort
                        level_coloc = v.level_coloc
                        level_garage = v.level_garage
                        level_coffre = v.level_coffre
                        changement = true
                    end
                end
            end
        end
        if changement then
            SaveSoloAppart(xPlayer, label, owner, owner_identifier, name_owner, number_coloc, coloc_name, level_garage,
                level_coffre, level_coffre_fort, level_coloc)
        end
    end
end)

local appartaSaved = -1
Citizen.CreateThread(function()
    appartaSaved = MySQL.Sync.store(
        "UPDATE properties SET `owner` = ?, `owner_identifier` = ?, `name_owner` = ?, `number_coloc` = ?, `coloc_name` = ?, `level_garage` = ?, `level_coffre` = ?, `level_coffre_fort` = ?, `level_coloc` = ? WHERE `label` = ?")
end)

SaveSoloAppart = function(xPlayer, label, owner, owner_identifier, name_owner, number_coloc, coloc_name, level_garage,
    level_coffre, level_coffre_fort, level_coloc)
    local asyncTasks = {}

    MySQL.Async.execute(appartaSaved,
        {owner, owner_identifier, name_owner, number_coloc, json.encode(coloc_name), level_garage, level_coffre,
         level_coffre_fort, level_coloc, label})
    print(('[^2INFO^7] Saved Appartement de ^5"%s^7"'):format(xPlayer.getName()))
end

ESX.RegisterServerCallback('h4ci_garage:listevoitureAppartement', function(source, cb, name)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = @stored', { -- job = NULL
        ['@stored'] = name
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedCars, {
                vehicle = vehicle,
                stored = v.stored,
                plate = v.plate,
                price = v.price,
                model = v.model
            })
        end
        cb(ownedCars)
    end)
end)

ESX.RegisterServerCallback('h4ci_garage:rangervoitureAppartement', function(source, cb, vehicleProps, name)
    local vehiclemodel = vehicleProps.model
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM open_car WHERE identifier = @identifier AND @value = value', {
        ['@identifier'] = xPlayer.identifier,
        ['@value'] = vehicleProps.plate
    }, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            print(('h4ci_garage : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
            cb(false)
        end
    end)
end)

RegisterServerEvent('h4ci_garage:etatvehiculesortieAppartement')
AddEventHandler('h4ci_garage:etatvehiculesortieAppartement', function(plate, state, ranger)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ranger then
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, dateranged =NOW() WHERE plate = @plate and owner = @owner', {
            ['@stored'] = state,
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate.plate
        }, function(rowsChanged)
            if rowsChanged == 0 then
                print(('esx_advancedgarage: %s exploited the private garage!'):format(xPlayer.identifier))
            end
        end)
    else
        MySQL.Async.execute(
            'UPDATE owned_vehicles SET `stored` = @stored, dateranged =NOW(),vehicle = @vehicle WHERE plate = @plate and owner = @owner',
            {
                ['@stored'] = state,
                ['@plate'] = plate.plate,
                ['@owner'] = xPlayer.identifier,
                ['@vehicle'] = json.encode(plate)
            }, function(rowsChanged)
                if rowsChanged == 0 then
                    print(('esx_advancedgarage: %s exploited the private garage!'):format(xPlayer.identifier))
                end
            end)
    end
end)
