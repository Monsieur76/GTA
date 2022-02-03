ESX = nil
local recolte = false
local fabrication = false
local fabricationmenu = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'burgershot', 'burgershot', true, true)

TriggerEvent('esx_society:registerSociety', 'burgershot', 'burgershot', 'society_burgershot', 'society_burgershot',
    'society_burgershot', {
        type = 'private'
    })

--recolte

RegisterServerEvent('recolteaddItem')
AddEventHandler('recolteaddItem', function(recolt, item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.canCarryItem(item, recolt) then
        xPlayer.addInventoryItem(item, recolt)
        TriggerClientEvent("showFabrik", xPlayer.source,item,recolt)
    else
        TriggerClientEvent("stopRecolteBurger", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
    end
end)

-- fabrication Burger

RegisterServerEvent('traitementAddBurger')
AddEventHandler('traitementAddBurger', function(itemAdd)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if itemAdd == "veget_burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and
        xPlayer.getInventoryItem("oignon").count > 0 and xPlayer.getInventoryItem("oignon").count > 0 and
        xPlayer.getInventoryItem("tomate").count > 0 and xPlayer.getInventoryItem("salade").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("oignon", 1)
            xPlayer.removeInventoryItem("tomate", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end    
    elseif itemAdd == "pain_de_mie" and xPlayer.getInventoryItem("pain").count >= 1 then
    if xPlayer.canCarryItem(itemAdd, 1) then
        xPlayer.removeInventoryItem("pain", 1)
        rand = math.random(1, 6)
        xPlayer.addInventoryItem(itemAdd, rand)
        TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,rand)
    else
        TriggerClientEvent("stopTraitementBurger", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
    end
    elseif itemAdd == "cannibale_burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and
        xPlayer.getInventoryItem("meat").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("meat", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "fish_burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and xPlayer.getInventoryItem("fish").count >
        0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("fish", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "Better_Burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and xPlayer.getInventoryItem("meat").count > 0 and
        xPlayer.getInventoryItem("salade").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("meat", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "Hamburger_Plaza" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and xPlayer.getInventoryItem("fish").count > 0 and
        xPlayer.getInventoryItem("salade").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("fish", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "Burger_Enervé" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and xPlayer.getInventoryItem("meat").count >
        0 and xPlayer.getInventoryItem("salade").count > 0 and xPlayer.getInventoryItem("tomate").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("meat", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.removeInventoryItem("tomate", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "Baby_Burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and xPlayer.getInventoryItem("fish").count >
        0 and xPlayer.getInventoryItem("salade").count > 0 and xPlayer.getInventoryItem("tomate").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("fish", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.removeInventoryItem("tomate", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "terminator_burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and
        xPlayer.getInventoryItem("meat").count > 0 and xPlayer.getInventoryItem("salade").count > 0 and
        xPlayer.getInventoryItem("tomate").count > 0 and xPlayer.getInventoryItem("oignon").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("meat", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.removeInventoryItem("tomate", 1)
            xPlayer.removeInventoryItem("oignon", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    elseif itemAdd == "ex_burger" and xPlayer.getInventoryItem("pain_de_mie").count >= 2 and
        xPlayer.getInventoryItem("fish").count > 0 and xPlayer.getInventoryItem("salade").count > 0 and
        xPlayer.getInventoryItem("tomate").count > 0 and xPlayer.getInventoryItem("oignon").count > 0 then
        if xPlayer.canCarryItem(itemAdd, 1) then
            xPlayer.removeInventoryItem("pain_de_mie", 2)
            xPlayer.removeInventoryItem("fish", 1)
            xPlayer.removeInventoryItem("salade", 1)
            xPlayer.removeInventoryItem("oignon", 1)
            xPlayer.addInventoryItem(itemAdd, 1)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementBurger", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    else
        TriggerClientEvent("stopTraitementBurger", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Pas assez d\'ingrédient')
    end
end)


-- fabrication Menu

RegisterServerEvent('traitementAddMenu')
AddEventHandler('traitementAddMenu', function(itemRemoove,itemAdd)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local numberRemoove = 1
    local numberAdd = 1
    if xPlayer.getInventoryItem(itemRemoove).count >= numberRemoove and xPlayer.getInventoryItem("jus_raisin").count > 0  then
        if xPlayer.canCarryItem(itemAdd, numberAdd) then
            xPlayer.removeInventoryItem("jus_raisin", 1)
            xPlayer.removeInventoryItem(itemRemoove, numberRemoove)
            xPlayer.addInventoryItem(itemAdd, numberAdd)
            TriggerClientEvent("showFabrik", xPlayer.source,itemAdd,1)
        else
            TriggerClientEvent("stopTraitementMenu", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
    else
        TriggerClientEvent("stopTraitementMenu", xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Pas assez d\'ingrédient')
    end
end)


-------------- Vente



RegisterServerEvent('burger:vente')
AddEventHandler('burger:vente', function(name, label, count, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, count)
    -- xPlayer.addMoney(1 * count)
    burgershot = count * prix
	mairie = burgershot * 0.2
	moneys = burgershot - mairie
    TriggerEvent('society:getObject', "burgershot", function(weightSociety,store, money, inventory)
        store.addMoney(moneys)
    end)
    TriggerEvent('society:getObject', "burgershot", function(weightSociety,store, money, inventory)
        store.addMoney(mairie)
    end)
    if name == "radio" then
        TriggerClientEvent('ls-radio:onRadioDrop', xPlayer.source)
    end

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu ~r~" .. count .. " " .. label)

end)