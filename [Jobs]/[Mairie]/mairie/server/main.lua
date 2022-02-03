ESX = nil
local acceptSell
local acceptBuy
local sourcedeleteKey
local sourceregisterKey

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'mairie', 'mairie', true, true)

TriggerEvent('esx_society:registerSociety', 'mairie', 'mairie', 'society_mairie', 'society_mairie', 'society_mairie', {
    type = 'private'
})



RegisterServerEvent('mairie:debutvente')
AddEventHandler('mairie:debutvente', function(identifierSell,plate,identifierBuy,nameSell,nameBuy,model)
    local xPlayers = ESX.GetPlayers()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local mairie = xPlayer.source
    local notif = "Signature de la carte grise"
    acceptSell = "pas signer"
    acceptBuy = "pas signer"
    Citizen.Wait(2000)
    for i = 1, #xPlayers do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
            if xTarget.identifier == identifierSell then
                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, model.." "..plate, '~b~' .. notif,
                    'Appuyez sur ~g~Y ~s~pour signer ou sur ~r~N ~s~pour refuser de signer', 'CHAR_BLANK_ENTRY', nil)
                    TriggerClientEvent("mairie:ventevehicleowner",xTarget.source,identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
                    sourcedeleteKey = xTarget.source
            elseif xTarget.identifier == identifierBuy then
                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, model.." "..plate, '~b~' .. notif,
                'Appuyez sur ~g~Y ~s~pour signer ou sur ~r~N ~s~pour refuser de signer', 'CHAR_BLANK_ENTRY', nil)
                TriggerClientEvent("mairie:ventevehiclebuyer",xTarget.source,identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
                sourceregisterKey= xTarget.source
            end
    end
end)


ESX.RegisterServerCallback('mairie:retrivename', function(source, cb,name)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
            if xTarget.getName() == name then
                return cb(xTarget.identifier)
            end
    end
    return cb(false)
end)


ESX.RegisterServerCallback('mairie:retriveplate', function(source, cb,identifier,plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate=@plate and owner=@owner', {
        ["@plate"]= plate,
        ["@owner"]= identifier,
    }, function(result)
        if result[1]~= nil then
            if tonumber(result[1].stored) >= 2 and tonumber(result[1].stored) <= 8 then
                cb(result[1].model)
            else
                TriggerClientEvent('esx:showNotification', source, "La voiture n'est pas rangé dans un garage privé")
            end
        else
            cb(false)
        end
    end)
end)


RegisterServerEvent('mairie:acceptSell')
AddEventHandler('mairie:acceptSell', function(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
    acceptSell = true
    vehicleSell(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
end)

RegisterServerEvent('mairie:refuseSell')
AddEventHandler('mairie:refuseSell', function(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
    acceptSell = false
    vehicleSell(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
end)

RegisterServerEvent('mairie:acceptBuy')
AddEventHandler('mairie:acceptBuy', function(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
    acceptBuy = true
    vehicleSell(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
end)

RegisterServerEvent('mairie:refuseBuy')
AddEventHandler('mairie:refuseBuy', function(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
    acceptBuy = false
    vehicleSell(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
end)


function vehicleSell(identifierSell,plate,identifierBuy,nameSell,nameBuy,model,mairie)
    if acceptSell == true and acceptBuy == "pas signer" then
        TriggerClientEvent('esx:showNotification', mairie, "Il manque la signature de "..nameBuy)
    elseif acceptBuy == true and acceptSell == "pas signer" then
        TriggerClientEvent('esx:showNotification', mairie, "Il manque la signature de "..nameSell)
    elseif acceptBuy == true and acceptSell == true then
        MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @owner WHERE `plate` = @plate', {
            ['@owner'] = identifierBuy,
            ['@plate'] = plate,
        })
        TriggerClientEvent('esx:showNotification', mairie, "Le contrat a bien été signé par les 2 partie. La vente a été effectué")
    elseif acceptBuy == false and acceptSell == false then
        TriggerClientEvent('esx:showNotification', mairie, nameBuy.." et "..nameSell.." ont refusé de signé. Annulation de la vente")
    elseif acceptBuy == false then
        TriggerClientEvent('esx:showNotification', mairie, nameBuy.." a refusé de signé. Annulation de la vente")
    elseif acceptSell == false then
        TriggerClientEvent('esx:showNotification', mairie, nameSell.." a refusé de signé. Annulation de la vente")
    end
end