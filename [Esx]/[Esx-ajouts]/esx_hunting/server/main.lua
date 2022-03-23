ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function(leatherAmount, meatAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local leatherLabel = "cuir"
    if leatherAmount > 1 then
        leatherLabel = "cuirs"
    end
    local meatLabel = "viande"
    if meatAmount > 1 then
        meatLabel = "viandes"
    end

    if xPlayer.canCarryItem('leather', leatherAmount) and xPlayer.canCarryItem('meat', meatAmount) then
        xPlayer.addInventoryItem('leather', leatherAmount)
        xPlayer.addInventoryItem('meat', meatAmount)
        TriggerClientEvent("esx:showNotification", source,
            'Vous avez obtenu ~g~x' .. meatAmount .. '~w~ ' .. meatLabel .. ' et ~g~x' .. leatherAmount .. '~w~ ' ..
                leatherLabel)
    else
        TriggerClientEvent("esx:showNotification", source, "~r~Vous êtes trop lourd")
    end

end)
