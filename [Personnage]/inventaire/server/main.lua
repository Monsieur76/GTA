ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('giveiventoryitem')
AddEventHandler('giveiventoryitem', function(target_id, name, label, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target_id)
    if targetPlayer.canCarryItem(name, index) then
        targetPlayer.addInventoryItem(name, index)
        xPlayer.removeInventoryItem(name, index)
        if name == "radio" then
            TriggerClientEvent('ls-radio:onRadioDrop', xPlayer.source)
        end
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez donné ~r~" .. index .. " " .. label)
        TriggerClientEvent("esx:showNotification", targetPlayer.source, "Vous avez reçu ~g~" .. index .. " " .. label)
    else
        TriggerClientEvent("esx:showNotification", xPlayer.source, "La personne n'a plus de place")
        TriggerClientEvent("esx:showNotification", targetPlayer.source, "Vous n'avez plus de place")
    end
end)

RegisterServerEvent('inventoryprendre')
AddEventHandler('inventoryprendre', function(target)
    TriggerClientEvent("animationtarget", target)
end)

RegisterServerEvent('Notifymoney')
AddEventHandler('Notifymoney', function(target_id, price)
    local targetPlayer = ESX.GetPlayerFromId(target_id)
    TriggerClientEvent("esx:showNotification", targetPlayer.source,
        'Vous avez reçu ~g~' .. ESX.Math.GroupDigits(price) .. "$")
end)

ESX.RegisterServerCallback('payement', function(source, cb, quantity)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local prix = "rien"
    local black = xPlayer.getAccount("black_money")
    local money = xPlayer.getAccount("money")

    if quantity > 0 and black.money + money.money >= quantity then
        if black.money >= quantity then
            prix = "bon"
            cb(prix, black.money, money.money)
        else
            prix = "double"
            cb(prix, black.money, money.money)
        end
    else
        cb(prix)
    end
end)
