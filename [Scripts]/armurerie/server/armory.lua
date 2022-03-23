ESX = nil
Items = {}
local SharedDataStores = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM society_armory_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local society = nil
            local weapon = nil

            if result[i].society ~= nil then
                society = result[i].society
            end
            if result[i].weapon ~= nil then
                weapon = json.decode(result[i].weapon)
            end

            Citizen.Wait(500)

            SharedDataStores[society] = CreateDataStore(society, weapon)
        end
    end)
end)

function addStore(society)
    local weapon = {}
    MySQL.Async.execute('INSERT INTO society_armory_inventory (society,weapon) VALUES (@society,"{}")', {
        ['@society'] = society
    })
    SharedDataStores[society] = CreateDataStore(society, weapon)
    return SharedDataStores[society].getInventoryWeight(), SharedDataStores[society],
        SharedDataStores[society].getWeapon()
end

function GetSharedDataStore(society)
    if SharedDataStores[society] == nil then
        addStore(society)
    end
    return SharedDataStores[society].getInventoryWeight(), SharedDataStores[society],
        SharedDataStores[society].getWeapon()
end

ESX.RegisterServerCallback('armurie:getWeight', function(source, cb, society)
    cb(GetSharedDataStore(society))
end)

RegisterServerEvent("armurerie:getItem")
AddEventHandler("armurerie:getItem",
    function(society, type, item, label, count, armurerieMax, playerMax, etiquette, labelSociety)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if type == "item_weapon" then
            if xPlayer.hasWeapon(item) then
                TriggerClientEvent('esx:showNotification', _source, _U("already_have_weapon"))
            else
                if SharedDataStores[society].searchItemWeapon(item, etiquette) then
                    xPlayer.addWeapon(item, SharedDataStores[society].getAmmo(item, etiquette))
                    SharedDataStores[society].removeItemWeapon(item, etiquette)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
                end

                text = _U("armurerie_info", labelSociety)
                textCapacity = _U("trunk_capacity", SharedDataStores[society].getInventoryWeight(), armurerieMax)
                data = {
                    label = labelSociety,
                    society = society,
                    max = armurerieMax,
                    text = text,
                    textCapacity = textCapacity,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight()
                }
                TriggerClientEvent("esx_inventoryhud:refreshArmurerieInventory", _source, data,
                    SharedDataStores[society].getWeapon())
            end
        end
    end)

RegisterServerEvent("armurerie:putItem")
AddEventHandler("armurerie:putItem",
    function(society, type, item, label, count, armurerieMax, playerMax, etiquette, labelSociety)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.hasWeapon(item) then
            if type == "item_weapon" then
                if (SharedDataStores[society].getInventoryWeight() + Config.DefaultWeight) > armurerieMax then
                    TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
                else
                    SharedDataStores[society].addItemWeapon(item, count, label, etiquette)
                    xPlayer.removeWeapon(item)
                end
            end
            text = _U("armurerie_info", labelSociety)
            textCapacity = _U("trunk_capacity", SharedDataStores[society].getInventoryWeight(), armurerieMax)
            data = {
                label = labelSociety,
                society = society,
                max = armurerieMax,
                textCapacity = textCapacity,
                text = text,
                playerTotalWeight = playerMax,
                playerUsedWeight = xPlayer.getWeight()
            }
            TriggerClientEvent("esx_inventoryhud:refreshArmurerieInventory", _source, data,
                SharedDataStores[society].getWeapon())
        end
    end)
