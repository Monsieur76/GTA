IsInInventory = {} -- format : {{["from"] = 322, ["whoIn"] = prenomnom},{["from"] = 322, ["whoIn"] = prenomnom} }
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback("NUIFocusOff", function(data, cb)
    local isTrunk = from == "trunk"
    local isFrigo = from == "frigo"
    local isSocietyVault = from == "vault"
    local isArmory = from == "armory"
    local isConfiscation = from == "confiscation"
    local isCoffreAppartement = from == "coffre_appartement"
    local isCoffreFortAppartement = from == "coffreFort_appartement"
    print('ici')
    SendNUIMessage({
        action = "hide"
    })
    if isConfiscation then
    elseif isArmory then
    elseif isFrigo then
    elseif isSocietyVault then
    elseif isTrunk then
        local vehicle, dist = ESX.Game.GetClosestVehicle(coords)
        SetVehicleDoorShut(vehicle, 5, false, false)
        SetNuiFocus(false, false)    
    elseif isCoffreAppartement then
    elseif isCoffreFortAppartement then
    end
    SetNuiFocus(false, false)
end)

function loadPlayerInventory(from, inventoryName, userIsJobBoss)
    ESX.PlayerData = ESX.GetPlayerData()
    items = {}
    inventory = ESX.PlayerData.inventory
    accounts = ESX.PlayerData.accounts
    --money = ESX.PlayerData.money
    weapons = ESX.PlayerData.loadout
    local isTrunk = from == "trunk"
    local isFrigo = from == "frigo"
    local isSocietyVault = from == "society"
    local isArmory = from == "armory"
    local isConfiscation = from == "confiscation"
    local isCoffreAppartement = from == "coffre_appartement"
    local isCoffreFortAppartement = from == "coffreFort_appartement"

    if accounts ~= nil and not isFrigo and (isSocietyVault and userIsJobBoss) and not isTrunk and
        not isArmory and not isConfiscation and not isCoffreAppartement and not isCoffreFortAppartement then
        for i = 1, #accounts, 1 do
            if accounts[i].name == 'money' then
                money = accounts[i].money

                moneyData = {
                    label = _U("cash"),
                    name = "cash",
                    type = "item_money",
                    count = money,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }

                table.insert(items, moneyData)
            end
        end
    end

    if accounts ~= nil and not isFrigo and not isSocietyVault and not isTrunk and not isArmory and
        not isCoffreAppartement then
        for key, value in pairs(accounts) do
                local canDrop = accounts[key].name ~= "bank"
                if accounts[key].name == 'black_money' then
                    accountData = {
                        label = accounts[key].label,
                        count = accounts[key].money,
                        type = "item_account",
                        name = accounts[key].name,
                        usable = false,
                        rare = false,
                        limit = -1,
                        canRemove = canDrop
                    }
                    table.insert(items, accountData)
                end
        end
    end

    if inventory ~= nil and not isArmory and not isCoffreFortAppartement then
        for key, value in pairs(inventory) do
            if inventory[key].count ~= false then
                if inventory[key].count <= 0 or (isFrigo and inventory[key].legal ~= "manger") or
                    ((isCoffreAppartement or isSocietyVault) and inventory[key].legal == "manger") or
                    (isSocietyVault and inventory[key].legal == "illégal") or
                    (isConfiscation and inventory[key].legal ~= "illégal") then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    table.insert(items, inventory[key])
                end
            end
        end
    end
    if weapons ~= nil and not isFrigo and not isSocietyVault and not isCoffreFortAppartement then
        for key, value in pairs(weapons) do
            local weaponHash = GetHashKey(weapons[key].name)
            local playerPed = PlayerPedId()
            if weapons[key].name ~= "WEAPON_UNARMED" then
                ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                table.insert(items, {
                    label = weapons[key].label,
                    count = ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapons[key].name,
                    usable = false,
                    rare = false,
                    canRemove = true
                })
            end
        end
    end

    SendNUIMessage({
        action = "setItems",
        itemList = items
    })

end
