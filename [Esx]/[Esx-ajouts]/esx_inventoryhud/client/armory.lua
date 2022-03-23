local armoryData = nil
local weapons = nil

RegisterNetEvent("esx_inventoryhud:openArmurerieInventory")
AddEventHandler("esx_inventoryhud:openArmurerieInventory", function(data, weapons)
    setArmoryInventoryData(data, weapons)
    openArmoryInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshArmurerieInventory")
AddEventHandler("esx_inventoryhud:refreshArmurerieInventory", function(data, weapons)
    setArmoryInventoryData(data, weapons)
end)

function setArmoryInventoryData(data, weapo)
    armoryData = data
    weapons = weapo

    SendNUIMessage({
        action = "setInfoText",
        text = data.text,
        textCapacity = data.textCapacity,
        playerTotalWeight = data.playerTotalWeight,
        playerUsedWeight = data.playerUsedWeight
    })

    items = {}

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

function openArmoryInventory()
    loadPlayerInventory("armory", armoryData.society)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "armory",
        inventoryName = armoryData.society
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoArmory", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end

        TriggerServerEvent("armurerie:putItem", armoryData.society, data.item.type, data.item.name,data.item.label, count,
            armoryData.max, armoryData.playerTotalWeight, data.etiquette,armoryData.label)
    end

    Wait(250)
    loadPlayerInventory("armory", armoryData.society)

    cb("ok")
end)

RegisterNUICallback("TakeFromArmory", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        print(data.etiquette)
        TriggerServerEvent("armurerie:getItem", armoryData.society, data.item.type, data.item.name,data.item.label, count,
        armoryData.max, armoryData.playerTotalWeight, data.item.etiquette,armoryData.label)
    end

    Wait(250)
    loadPlayerInventory("armory", armoryData.society)

    cb("ok")
end)
