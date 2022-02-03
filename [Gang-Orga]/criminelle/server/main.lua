ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('illegal:vente')
AddEventHandler('illegal:vente', function(name, label, count, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, count)
    xPlayer.addAccountMoney("black_money", prix)
    
    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu ~r~" .. count .. " " .. label)
end)