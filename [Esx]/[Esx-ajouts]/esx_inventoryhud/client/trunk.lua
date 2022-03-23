local inventory = nil
local weapons = nil
local store = nil
local dataJs = nil

RegisterNetEvent("esx_inventoryhud:openTrunkInventory")
AddEventHandler("esx_inventoryhud:openTrunkInventory", function(data, inventory, weapons, stor)
    store = stor
    setTrunkInventoryData(data, inventory, weapons)
    openTrunkInventory(stor)
end)

RegisterNetEvent("esx_inventoryhud:refreshTrunkInventory")
AddEventHandler("esx_inventoryhud:refreshTrunkInventory", function(data, inventory, weapons)
    setTrunkInventoryData(data, inventory, weapons)
end)

function setTrunkInventoryData(data, inventor, weapon)
    dataJs = data
    inventory = inventor
    weapons = weapon

    SendNUIMessage({
        action = "setInfoText",
        text = data.text,
        textCapacity = data.textCapacity,
        playerTotalWeight = data.playerTotalWeight,
        playerUsedWeight = data.playerUsedWeight
    })

    items = {}


    if inventory ~= nil then
        for key, value in pairs(inventory) do
                if inventory[key].count <= 0 then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    inventory[key].usable = false
                    inventory[key].rare = false
                    inventory[key].limit = -1
                    inventory[key].canRemove = false
                    table.insert(items, inventory[key])
                end
        end
    end

    if weapons ~= nil then
        for i = 1, #weapons, 1 do
            local weapon = weapons[i]

            if weapons[i].name ~= "WEAPON_UNARMED" then
                table.insert(items, {
                    label = ESX.GetWeaponLabel(weapon.name),
                    etiquette = weapon.etiquette,
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false,
                    id = weapon.id
                })
            end
        end
    end

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

function openTrunkInventory(stor)

    loadPlayerInventory("trunk", stor.plate)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "trunk",
        inventoryName = stor
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end
        TriggerServerEvent("esx_trunk:putItem", store.plate, data.item.type, data.item.name, count, dataJs.max,
            dataJs.myVeh, data.item.label, dataJs.playerTotalWeight, data.etiquette)
    end

    Wait(250)
    loadPlayerInventory("trunk", store.plate)

    cb("ok")
end)

RegisterNUICallback("TakeFromTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        TriggerServerEvent("esx_trunk:getItem", store.plate, data.item.type, data.item.name, count, dataJs.max,
            dataJs.myVeh, data.item.label, dataJs.playerTotalWeight, data.item.etiquette)

    end

    Wait(250)
    loadPlayerInventory("trunk", store.plate)

    cb("ok")
end)
