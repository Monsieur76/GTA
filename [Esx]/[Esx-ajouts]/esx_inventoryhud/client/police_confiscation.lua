local confiscationData = nil
RegisterNetEvent("esx_inventoryhud:openConfiscationInventory")
AddEventHandler("esx_inventoryhud:openConfiscationInventory", function(data, blackMoney, inventory,weapon)
    setConfiscationInventoryData(data, blackMoney, inventory,weapon)
    openConfiscationInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshConfiscationInventory")
AddEventHandler("esx_inventoryhud:refreshConfiscationInventory", function(data, blackMoney, inventory,weapon)
    setConfiscationInventoryData(data, blackMoney, inventory,weapon)
end)

function setConfiscationInventoryData(data, blackMoney, inventory,weapons)
    confiscationData = data

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
            weight = 0,
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

    if weapons ~= nil then
        for i = 1, #weapons, 1 do
            local weapon = weapons[i]

            if weapons[i].name ~= "WEAPON_UNARMED" then
                table.insert(items, {
                    label = ESX.GetWeaponLabel(weapon.name),
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

function openConfiscationInventory()
    loadPlayerInventory("confiscation", confiscationData.society)
    SendNUIMessage({
        action = "display",
        type = "confiscation",
        inventoryName = confiscationData.society
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoConfiscation", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        TriggerServerEvent("confiscation:putItem", data.item.type, data.item.name , data.item.label, count, confiscationData.max, confiscationData.playerTotalWeight,confiscationData.society,data.item.count)
    end

    Wait(250)
    loadPlayerInventory("confiscation", confiscationData.society)

    cb("ok")
end)

RegisterNUICallback("TakeFromConfiscation", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        TriggerServerEvent("confiscation:getItem", data.item.type, data.item.name , data.item.label, count, confiscationData.max, confiscationData.playerTotalWeight,confiscationData.society,data.item.count)
    end

    Wait(250)
    loadPlayerInventory("confiscation", confiscationData.society)

    cb("ok")
end)