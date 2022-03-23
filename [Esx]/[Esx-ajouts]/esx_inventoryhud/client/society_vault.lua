local inventory = nil
local money = nil
local dataJs = nil


RegisterNetEvent("esx_inventoryhud:openVaultInventory")
AddEventHandler("esx_inventoryhud:openVaultInventory", function(data, money, inventory)
    setVaultInventoryData(data, money, inventory)
    openVaultInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshVaultInventory")
AddEventHandler("esx_inventoryhud:refreshVaultInventory", function(data, money, inventory)
    setVaultInventoryData(data, money, inventory)
end)

function setVaultInventoryData(data, moneys, inventor)
    dataJs = data
    inventory = inventor
    money = moneys



    SendNUIMessage({
        action = "setInfoText",
        text = data.text,
        textCapacity = data.textCapacity,
        playerTotalWeight = data.playerTotalWeight,
        playerUsedWeight = data.playerUsedWeight
    })

    items = {}
    if money > 0 and data.isPlayerSocietyBoss then
        accountData = {
            label = _U("cash"),
            count = money,
            type = "item_money",
            name = "cash",
            usable = false,
            rare = false,
            weight = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

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

function openVaultInventory()

    loadPlayerInventory("society", dataJs.society, dataJs.isPlayerSocietyBoss)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "vault",
        inventoryName = dataJs.society
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoVault", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        TriggerServerEvent("vault:putItem", dataJs.society,dataJs.label, data.item.type, data.item.name, count, dataJs.max,
         data.item.label, dataJs.playerTotalWeight, dataJs.isPlayerSocietyBoss)
    end

    Wait(250)
    loadPlayerInventory("society", dataJs.society, dataJs.isPlayerSocietyBoss)

    cb("ok")
end)

RegisterNUICallback("TakeFromVault", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        TriggerServerEvent("vault:getItem", dataJs.society,dataJs.label, data.item.type, data.item.name, count, dataJs.max,
        data.item.label, dataJs.playerTotalWeight, dataJs.isPlayerSocietyBoss)
    end
    Wait(250)
    loadPlayerInventory("society", dataJs.society, dataJs.isPlayerSocietyBoss)

    cb("ok")
end)
