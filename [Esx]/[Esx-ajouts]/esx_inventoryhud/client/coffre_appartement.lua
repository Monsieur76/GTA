local coffreData = nil
local inventory = nil
local weapons = nil

RegisterNetEvent("esx_inventoryhud:openCoffreAppartementInventory")
AddEventHandler("esx_inventoryhud:openCoffreAppartementInventory", function(data, inventory, weapons)
    setCoffreAppartementInventoryData(data, inventory, weapons)
    openCoffreAppartementInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshCoffreAppartementInventory")
AddEventHandler("esx_inventoryhud:refreshCoffreAppartementInventory", function(data, inventory, weapons)
    setCoffreAppartementInventoryData(data, inventory, weapons)
end)

function setCoffreAppartementInventoryData(data, inventor, weapon)
    coffreData = data
    inventory = inventor
    weapons = weapon

    items = {}

    SendNUIMessage({
        action = "setInfoText",
        text = data.text,
        textCapacity = data.textCapacity,
        playerTotalWeight = data.playerTotalWeight,
        playerUsedWeight = data.playerUsedWeight
    })

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

function openCoffreAppartementInventory()
    loadPlayerInventory("coffre_appartement", coffreData.address)
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "coffre_appartement"
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoCoffreAppartement", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end

        TriggerServerEvent("coffreAppartement:putItem", coffreData.address, data.item.type, data.item.name, tonumber(data.number),
        coffreData.max,data.item.label, coffreData.playerTotalWeight, coffreData.level,data.etiquette,data.item.count)

    end

    Wait(250)
    loadPlayerInventory("coffre_appartement", coffreData.address)

    cb("ok")
end)

RegisterNUICallback("TakeFromCoffreAppartement", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then

        TriggerServerEvent("coffreAppartement:getItem", coffreData.address, data.item.type, data.item.name, tonumber(data.number),
        coffreData.max,data.item.label, coffreData.playerTotalWeight, coffreData.level,data.item.etiquette,data.item.count)
    end
    
    Wait(250)
    loadPlayerInventory("coffre_appartement", coffreData.address)

    cb("ok")
end)
