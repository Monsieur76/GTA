local coffreData = nil

RegisterNetEvent("esx_inventoryhud:openCoffreFortAppartementInventory")
AddEventHandler("esx_inventoryhud:openCoffreFortAppartementInventory", function(data, blackMoney)
    setCoffreFortAppartementInventoryData(data, blackMoney)
    openCoffreFortAppartementInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshCoffreFortAppartementInventory")
AddEventHandler("esx_inventoryhud:refreshCoffreFortAppartementInventory", function(data, blackMoney)
    setCoffreFortAppartementInventoryData(data, blackMoney)
end)

function setCoffreFortAppartementInventoryData(data, blackMoney)
    coffreData = data

    SendNUIMessage({
        action = "setInfoText",
        text = data.text,
        textCapacity = data.textCapacity,
        playerTotalWeight = data.playerTotalWeight,
        playerUsedWeight = data.playerUsedWeight
    })

    items = {}

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end
    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

function openCoffreFortAppartementInventory()
    loadPlayerInventory("coffreFort_appartement", coffreData.address)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "coffreFort_appartement"
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoCoffreFortAppartement", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
print(coffreData.playerTotalWeight, coffreData.level)
        TriggerServerEvent("coffreFortAppartement:putItem", coffreData.address, data.item.type, data.item.name, count,
            coffreData.max, data.item.label, coffreData.playerTotalWeight, coffreData.level)
    end

    Wait(250)
    loadPlayerInventory("coffreFort_appartement", coffreData.address)

    cb("ok")
end)

RegisterNUICallback("TakeFromCoffreFortAppartement", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        print(coffreData.playerTotalWeight, coffreData.level)
        TriggerServerEvent("coffreFortAppartement:getItem", coffreData.address, data.item.type, data.item.name, count,
        coffreData.max, data.item.label, coffreData.playerTotalWeight, coffreData.level)
    end

    Wait(250)
    loadPlayerInventory("coffreFort_appartement", coffreData.address)

    cb("ok")
end)
