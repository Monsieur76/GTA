local inventory = nil
local store = nil
local dataJs = nil

RegisterNetEvent("esx_inventoryhud:openFrigoInventory")
AddEventHandler("esx_inventoryhud:openFrigoInventory", function(data, inventory,stor)
    store = stor
    setFrigoInventoryData(data, inventory)
    openFrigoInventory(store)
end)

RegisterNetEvent("esx_inventoryhud:refreshFrigoInventory")
AddEventHandler("esx_inventoryhud:refreshFrigoInventory", function(data, inventory)
    setFrigoInventoryData(data, inventory)
end)

function setFrigoInventoryData(data, inventor)
    inventory = inventor
    dataJs=data

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

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

function openFrigoInventory(store)
    loadPlayerInventory("frigo", store.owner)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "frigo",
        inventoryName = store
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoFrigo", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        TriggerServerEvent("frigo:putItem", dataJs.owner, data.item.type,data.item.label, data.item.name, count, dataJs.max, dataJs.playerTotalWeight, dataJs.label)
    end

    Wait(250)
    loadPlayerInventory("frigo", dataJs.owner)

    cb("ok")
end)

RegisterNUICallback("TakeFromFrigo", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("frigo:getItem", dataJs.owner, data.item.type,data.item.label, data.item.name, tonumber(data.number),
        dataJs.max, dataJs.playerTotalWeight, dataJs.label)
    end

    Wait(250)
    loadPlayerInventory("frigo", dataJs.owner)

    cb("ok")
end)