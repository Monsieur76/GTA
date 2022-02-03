ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('weaponshops:giveWeapon')
AddEventHandler('weaponshops:giveWeapon', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    if playerMoney >= (item.Price) then
            if not xPlayer.hasWeapon(item.Value) then
                xPlayer.addWeapon(item.Value, 20)
                xPlayer.removeMoney(item.Price)
                TriggerClientEvent('esx:showNotification', source, 'Vous avez acheté ~g~1x ' .. item.Label)
            else
                TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà cette arme sur vous')
            end
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end
end)

RegisterNetEvent('item:acheter')
AddEventHandler('item:acheter', function(item, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= item.Price * quantity then
            xPlayer.addInventoryItem(item.Value, quantity)
            xPlayer.removeMoney(item.Price * quantity)
            TriggerClientEvent('esx:showNotification', source, 'Vous avez acheté ~g~' .. quantity .. 'x ' .. item.Label)
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end
end)

