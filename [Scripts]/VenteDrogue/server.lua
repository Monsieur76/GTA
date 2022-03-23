ESX = nil
local vente = false
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function drug(drugToSell, xPlayer)

    item = xPlayer.getInventoryItem(drugToSell.label)

    if item == nil then
        return
    end

    count = item.count

    if count ~= 0 then
        TriggerClientEvent('stasiek_selldrugsv2:findClient', xPlayer.source, drugToSell, vente, count)
    end

end

ESX.RegisterSellItem('weed_pooch', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(__source)
    if not vente then
        vente = true
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous commencez à vendre")
    else
        vente = false
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous arrêtez de vendre")
    end
    drugToSell = {
        type = Config.drugs[1].type,
        label = Config.drugs[1].name,
        count = 0,
        price = Config.drugs[1].price,
        alert = Config.drugs[1].alert
    }
    drug(drugToSell, xPlayer)
end)

ESX.RegisterSellItem('opium_pooch', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not vente then
        vente = true
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous commencez à vendre")
    else
        vente = false
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous arrêtez de vendre")
    end
    drugToSell = {
        type = Config.drugs[2].type,
        label = Config.drugs[2].name,
        count = 0,
        price = Config.drugs[2].price,
        alert = Config.drugs[2].alert
    }
    drug(drugToSell, xPlayer)
end)

ESX.RegisterSellItem('meth_pooch', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not vente then
        vente = true
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous commencez à vendre")
    else
        vente = false
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous arrêtez de vendre")
    end
    drugToSell = {
        type = Config.drugs[4].type,
        label = Config.drugs[4].name,
        count = 0,
        price = Config.drugs[4].price,
        alert = Config.drugs[4].alert
    }
    drug(drugToSell, xPlayer)
end)

ESX.RegisterSellItem('coke_pooch', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not vente then
        vente = true
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous commencez à vendre")
    else
        vente = false
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous arrêtez de vendre")
    end
    drugToSell = {
        type = Config.drugs[3].type,
        label = Config.drugs[3].name,
        count = 0,
        price = Config.drugs[3].price,
        alert = Config.drugs[3].alert
    }
    drug(drugToSell, xPlayer)

end)

RegisterServerEvent('stasiek_selldrugsv2:pay')
AddEventHandler('stasiek_selldrugsv2:pay', function(drugToSell)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(drugToSell.label, drugToSell.count)
    if Config.account == 'money' then
        xPlayer.addMoney(drugToSell.price)
    else
        xPlayer.addAccountMoney(Config.account, drugToSell.price)
    end
end)

ESX.RegisterServerCallback('stasiek_selldrugsv2:getPoliceCount', function(source, cb)
    count = 0
    local currentPlayerCoords = (ESX.GetPlayerFromId(source)).getCoords()
    if currentPlayerCoords.x < -224.12 then
        for _, playerId in pairs(ESX.GetPlayers()) do
            xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer.job.name == 'policeNorth' then
                count = count + 1
            end
        end
    else
        for _, playerId in pairs(ESX.GetPlayers()) do
            xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer.job.name == 'police' then
                count = count + 1
            end
        end
    end

    cb(count)
end)
