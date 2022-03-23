ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('enos_shop:giveItem')
AddEventHandler('enos_shop:giveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    if playerMoney >= item.Price * count then
        if xPlayer.canCarryItem(item.Value, count) then
            xPlayer.addInventoryItem(item.Value, count)
            xPlayer.removeMoney(item.Price * count)
            TriggerClientEvent('esx:showNotification', source, 'Vous avez acheté ~g~' .. count .. 'x ' .. item.Label ..
                '~s~ pour ~g~' .. item.Price * count .. "$")
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez de place !")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent")
    end
end)


RegisterServerEvent('enos_shop:DelItem')
AddEventHandler('enos_shop:DelItem', function(name, label, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, count)
    xPlayer.addMoney(1 * count)
    if name == "radio" then
        TriggerClientEvent('ls-radio:onRadioDrop', xPlayer.source)
    end

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu ~r~" .. count .. " " .. label)

end)