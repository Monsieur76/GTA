ESX = nil
PlayersHarvesting = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting = {}
PlayersCrafting2 = {}
PlayersCrafting3 = {}
local PlayersSelling = {}
local recolte = false
local traitement = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'vigne', 'vigne', true, true)

TriggerEvent('esx_society:registerSociety', 'vigne', 'vigne', 'society_vigne', 'society_vigne', 'society_vigne', {
    type = 'private'
})



-- Récolte--
RegisterServerEvent('recolteadd')
AddEventHandler('recolteadd', function(recolt,item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.canCarryItem(item, recolt) then
        xPlayer.addInventoryItem(item, recolt)
        TriggerClientEvent("showNotifFabrik", xPlayer.source,item,recolt)
    else
        TriggerClientEvent("stopRecolte", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
    end
end)






-- fabrication

RegisterServerEvent('traitementAdd')
AddEventHandler('traitementAdd', function(numberAdd,itemRemoove,numberRemoove,itemAdd)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem(itemRemoove).count >= numberRemoove then
        if xPlayer.canCarryItem(itemAdd, numberAdd) then
            xPlayer.removeInventoryItem(itemRemoove, numberRemoove)
            xPlayer.addInventoryItem(itemAdd, numberAdd)
            TriggerClientEvent("showNotifFabrik", xPlayer.source,itemAdd,numberAdd)
        else
            TriggerClientEvent("stopTraitement", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    else
        TriggerClientEvent("stopTraitement", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Pas assez de raisin')
    end
end)



-- Vente


RegisterServerEvent('vigne:vente')
AddEventHandler('vigne:vente', function(name, label, count, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, count)
    -- xPlayer.addMoney(1 * count)
    vigne = count * prix
	mairie = vigne * 0.2
	moneys = vigne - mairie
    TriggerEvent('society:getObject', "vigne", function(weightSociety,store, money, inventory)
        store.addMoney(moneys)
    end)
    TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
        store.addMoney(mairie)
    end)
    if name == "radio" then
        TriggerClientEvent('ls-radio:onRadioDrop', xPlayer.source)
    end

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu ~r~" .. count .. " " .. label)

end)