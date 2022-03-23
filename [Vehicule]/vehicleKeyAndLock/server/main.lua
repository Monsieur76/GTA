ESX = nil
local cars = {}
local plateIdentifier = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

-- utiliser
-- Enregistrement d'une nouvelle paire de clés
RegisterServerEvent('ddx_vehiclelock:registerkey')
AddEventHandler('ddx_vehiclelock:registerkey', function(plate,model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifierKey = {}
    cars[plate] = CreateDataStore(xPlayer.identifier, identifierKey,plate)
    plateIdentifier[xPlayer.identifier] = CreateSearchIdentifier({})
    plateIdentifier[xPlayer.identifier].addPlate(plate,model)
end)

---------------------------------------------------------------------------------------------
--------------------------------- Menu pour donner / preter clé -----------------------------
---------------------------------------------------------------------------------------------

------- Préter clé
RegisterServerEvent('ddx_vehiclelock:duplicateKey')
AddEventHandler('ddx_vehiclelock:duplicateKey', function(target, plate,model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayertarget = ESX.GetPlayerFromId(target)
    if cars[plate] ~= nil then
        if cars[plate].getIdentifier() == xPlayer.identifier or cars[plate].searcheIdentifierKey(xPlayer.identifier) then
            cars[plate].addIdentifierKey(xPlayertarget.identifier)
            if plateIdentifier[xPlayertarget.identifier] == nil then
                plateIdentifier[xPlayertarget.identifier] = CreateSearchIdentifier({})
                plateIdentifier[xPlayertarget.identifier].addPlate(plate,model)
                TriggerClientEvent('esx:showNotification', xPlayertarget.source, "~g~ vous avez reçue les clefs "..plate)
            else
                plateIdentifier[xPlayertarget.identifier].addPlate(plate,model)
                TriggerClientEvent('esx:showNotification', xPlayertarget.source, "~g~ vous avez reçue les clefs "..plate)
            end
        end
    end
end)

RegisterServerEvent('ddx_vehiclelock:deleteKey')
AddEventHandler('ddx_vehiclelock:deleteKey', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if cars[plate] ~= nil then
        if cars[plate].getIdentifier() == xPlayer.identifier or cars[plate].searcheIdentifierKey(xPlayer.identifier) then
            cars[plate]= nil
            plateIdentifier[xPlayer.identifier].removePlate(plate)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Clef rendue")
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez pas les clefs")
    end
end)

RegisterServerEvent('ddx_vehiclelock:deleteDuplicateKey')
AddEventHandler('ddx_vehiclelock:deleteDuplicateKey', function(plate)
    if cars[plate] ~= nil then
        cars[plate]= nil
    end
end)

ESX.RegisterServerCallback('getPlayerVehiclesKeys', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if plateIdentifier[xPlayer.identifier] ~= nil then
        cb(plateIdentifier[xPlayer.identifier].getPlate())
    end
end)

ESX.RegisterServerCallback('ddx_vehiclelock:mykey', function(source, cb, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if cars[plate].getIdentifier() == xPlayer.identifier or cars[plate].searcheIdentifierKey(xPlayer.identifier) then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('ddx_vehiclelock:MKeyGarageApart', function(source, cb, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if cars[plate].getIdentifier() == xPlayer.identifier or cars[plate].searcheIdentifierKey(xPlayer.identifier) then
        cb(true)
    else
        cb(false)
    end
end)
