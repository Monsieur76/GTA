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

ESX.RegisterServerCallback('payement', function(source, cb, quantity)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local black = xPlayer.getAccount("black_money").money
    local money = xPlayer.getAccount("money").money

    if quantity > 0 and black + money >= quantity or money >= quantity then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('give:money')
AddEventHandler('give:money', function(target_id, price)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xTarget = ESX.GetPlayerFromId(target_id)
    local black = xPlayer.getAccount("black_money").money

    if black >= price then
        print('ici')
        xPlayer.removeAccountMoney('black_money', price)
        xTarget.addAccountMoney('black_money', price)
        TriggerClientEvent("esx:showNotification",xPlayer.source,'Vous avez donné ~r~' .. ESX.Math.GroupDigits(price) .. "$")
        TriggerClientEvent("esx:showNotification",xTarget.source,'Vous avez reçue ~g~' .. ESX.Math.GroupDigits(price) .. "$")
    elseif black ~= 0 and black < price then
        print('la')
        totalrestepayer = price - black
        print(black)
        print(totalrestepayer)
        xPlayer.removeAccountMoney('black_money', black)
        xTarget.addAccountMoney('black_money', black)
        TriggerClientEvent("esx:showNotification",xPlayer.source,'Vous avez donné ~r~' .. ESX.Math.GroupDigits(black) .. "$")
        xPlayer.removeAccountMoney('money', totalrestepayer)
        xTarget.addAccountMoney('money', totalrestepayer)
        TriggerClientEvent("esx:showNotification",xPlayer.source,'Vous avez donné ~g~' .. ESX.Math.GroupDigits(totalrestepayer) .. "$")
        TriggerClientEvent("esx:showNotification",xTarget.source,'Vous avez reçue ~g~' .. ESX.Math.GroupDigits(price) .. "$")
    else
        print('par cic')
        xPlayer.removeAccountMoney('money', price)
        xTarget.addAccountMoney('money', price)
        TriggerClientEvent("esx:showNotification",xPlayer.source,'Vous avez donné ~g~' .. ESX.Math.GroupDigits(price) .. "$")
        TriggerClientEvent("esx:showNotification",xTarget.source,'Vous avez reçue ~g~' .. ESX.Math.GroupDigits(price) .. "$")
    end
end)