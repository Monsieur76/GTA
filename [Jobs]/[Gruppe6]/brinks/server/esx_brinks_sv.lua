ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
TriggerEvent('esx_phone:registerNumber', Config.jobName, 'Client ' .. Config.companyName, false, false)
TriggerEvent('esx_society:registerSociety', Config.jobName, Config.companyName, Config.companyLabel,
    Config.companyLabel, Config.companyLabel, {
        type = 'private'
    })

-- depo

RegisterServerEvent('poseDeSacCoffre')
AddEventHandler('poseDeSacCoffre', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(item).count
    xPlayer.removeInventoryItem(item, count)
    prix = count * Config.price
    -- mairie = prix * 0.2
    moneys = prix
    TriggerEvent('society:getObject', "brinks", function(weightSociety,store, money, inventory)
        store.addMoney(moneys)
    end)
    -- TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
    --     store.addMoney(mairie)
    -- end)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous avez déposé " .. count .. " sac")
end)

-- Sac banque market

RegisterServerEvent('MettreSacDeBankInventaire')
AddEventHandler('MettreSacDeBankInventaire', function(number, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(name, number) then
        xPlayer.addInventoryItem(name, number)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez reçue " .. number .. " sac")
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous ête trop lourd")
    end
end)

-- Argent sale

RegisterServerEvent('destructionArgentSale')
AddEventHandler('destructionArgentSale', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = xPlayer.getAccount("black_money").money
    if amount > 0 then
        xPlayer.removeAccountMoney("black_money", amount)
        TriggerClientEvent('esx:showNotification', xPlayer.source,
            "~r~Vous avez détruit " .. amount .. "$ d'argents sale")
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas d'argents sale")
    end
end)
