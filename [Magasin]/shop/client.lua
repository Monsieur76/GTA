ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

ConfShopp = {}

ConfShopp.Shop = {
    Posdeouf = {{
        x = 374.25,
        y = 327.94,
        z = 102.57
    }, {
        x = 2555.49,
        y = 382.16,
        z = 107.62
    }, {
        x = -3041.11,
        y = 585.19,
        z = 6.91
    }, {
        x = -3244.05,
        y = 1001.42,
        z = 11.83
    }, {
        x = 548.03,
        y = 2669.38,
        z = 41.16
    }, {
        x = 1960.32,
        y = 3742.17,
        z = 31.343
    }, {
        x = 2676.97,
        y = 3281.46,
        z = 54.241
    }, {
        x = 1729.81,
        y = 6416.29,
        z = 34.04
    }, {
        x = 1135.808,
        y = -982.281,
        z = 46.415
    }, {
        x = -1222.915,
        y = -906.983,
        z = 12.326
    }, {
        x = -1487.553,
        y = -379.107,
        z = 40.163
    }, {
        x = -2968.243,
        y = 390.910,
        z = 15.043
    }, {
        x = 1166.024,
        y = 2708.930,
        z = 38.157
    }, {
        x = 1392.562,
        y = 3604.684,
        z = 34.980
    }, {
        x = -48.519,
        y = -1757.514,
        z = 29.421
    }, {
        x = 1163.373,
        y = -323.801,
        z = 69.205
    }, {
        x = -707.501,
        y = -914.260,
        z = 19.215
    }, {
        x = -1820.523,
        y = 792.518,
        z = 138.118
    }, {
        x = 1698.388,
        y = 4924.404,
        z = 42.063
    }, {
        x = 25.82,
        y = -1345.22,
        z = 29.5
    },
},

    nord = {{
        x = -865.03,
        y = -2408.89,
        z = 13.03,
        a = 237.50
    }, {
        x = 967.78,
        y = -1867.07,
        z = 30.45,
        a = 171.09
    }, {
        x = -1222.4,
        y = -909.09,
        z = 11.33,
        a = 31.91
    }},

    sud = {{}},

    Items = {{
        Label = 'Pain',
        Value = 'pain',
        Price = 10
    }, {
        Label = 'Eau',
        Value = 'eau',
        Price = 10
    },{
        Label = 'Crème solaire',
        Value = 'creme_solaire',
        Price = 10
    },{
        Label = 'Médicament',
        Value = 'medicament',
        Price = 20
    },{
        Label = 'Pommade',
        Value = 'pommade',
        Price = 20
    },{
        Label = 'Mouchoir',
        Value = 'mouchoir',
        Price = 20
    }, {
        Label = 'Canne à pêche',
        Value = 'fishingrod',
        Price = 50
    }, {
        Label = 'Appât à poisson',
        Value = 'fishbait',
        Price = 15
    }, {
        Label = 'Appât à tortue',
        Value = 'turtlebait',
        Price = 25
    }, {
        Label = 'Tenue de plongée',
        Value = 'dive',
        Price = 1000
    }, {
        Label = 'Téléphone',
        Value = 'phone',
        Price = 150
    }}
}

Citizen.CreateThread(function()
    for k, v in pairs(ConfShopp.Shop.Posdeouf) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 52)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 27)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Supérette')
        EndTextCommandSetBlipName(blip)
    end
end)

local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- spawn de Apu

-- Citizen.CreateThread(function()
--   local hash = GetHashKey("a_f_m_fatwhite_01")
--   while not HasModelLoaded(hash) do
--       RequestModel(hash)
--       Wait(20)
--   end
--   for k, v in pairs(ConfShopp.Shop.nord) do
--      ped = CreatePed("PED_TYPE_CIVFEMALE", "a_f_m_fatwhite_01", v.x, v.y, v.z, v.a, false, true)
--      SetBlockingOfNonTemporaryEvents(ped, true)
---      FreezeEntityPosition(ped, true)
--      SetEntityInvincible(ped, true)
--  end
-- end)

-- Citizen.CreateThread(function()
-- local hash = GetHashKey("a_m_y_downtown_01")
-- while not HasModelLoaded(hash) do
--     RequestModel(hash)
--      Wait(20)
-- end
--  for k, v in pairs(ConfShopp.Shop.sud) do
--     ped = CreatePed("PED_TYPE_CIVMALE", "a_m_y_downtown_01", v.x, v.y, v.z, v.a, false, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
--     FreezeEntityPosition(ped, true)
--     SetEntityInvincible(ped, true)
--  end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(ConfShopp.Shop.Posdeouf) do
            local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 5.0 then
                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

                DrawMarker(29, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 16, 192, 37, 100, false,
                    true, 2, false, nil, nil, false)
            end

            if distance <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Acheter quelque chose")
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('enos_shop', 'main'), not RageUI.Visible(RMenu:Get('enos_shop', 'main')))
                end
            end

            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    RageUI.CloseAll()
                end
            end
        end
    end
end)

RMenu.Add('enos_shop', 'main', RageUI.CreateMenu("Supérette", "Supérette"))
RMenu.Add('enos_shop', 'achat', RageUI.CreateSubMenu(RMenu:Get('enos_shop', 'main'), "Acheter", "Intéractions"))
RMenu.Add('enos_shop', 'vente', RageUI.CreateSubMenu(RMenu:Get('enos_shop', 'main'), "Vendre", "Intéractions"))

itemVendable = {
    "pain",
    "eau",
    "canne",
    "coffee",
    "dive",
    "fishingrod",
    "journal",
    "jumelles",
    "leather",
    "mouchoir",
    "phone",
    "whool"
}

-- in some helper module
function utils_Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('enos_shop', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Acheter", nil, {
                RightLabel = ""
            }, true, function()
            end, RMenu:Get('enos_shop', 'achat'))

            RageUI.ButtonWithStyle("Vendre", nil, {
                RightLabel = ""
            }, true, function()
            end, RMenu:Get('enos_shop', 'vente'))
        end)

        RageUI.IsVisible(RMenu:Get('enos_shop', 'achat'), true, true, true, function()

            for _, v in pairs(ConfShopp.Shop.Items) do

                RageUI.ButtonWithStyle(v.Label, nil, {
                    RightLabel = "~g~" .. v.Price .. "$"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                        if not valid then
                            ESX.ShowNotification("Quantité invalide")
                        else
                            TriggerServerEvent('enos_shop:giveItem', v, quantity)
                        end
                    end
                end)

            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos_shop', 'vente'), true, true, true, function()
            ESX.PlayerData = ESX.GetPlayerData()
            -- Parcourir l'inventaire OK
            -- Trouver les items vendable
            -- Afficher les items vendable
            -- Vendre l'item (et le retirer de l'inventaire)

            for i = 1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].count ~= false then
                    if ESX.PlayerData.inventory[i].count > 0 then
                        _set = utils_Set(itemVendable)
                        if _set[ESX.PlayerData.inventory[i].name] then
                            invCount = {}
                            for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                                table.insert(invCount, i)
                            end
                            RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', nil, { RightLabel = "~g~ 1 $"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    print("Vente")
                                    local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                                    if not valid then
                                        ESX.ShowNotification("Quantité invalide")
                                    else
                                        if quantity <= ESX.PlayerData.inventory[i].count then
                                            TriggerServerEvent('enos_shop:DelItem', ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, quantity)
                                        else
                                            ESX.ShowNotification("Quantité invalide")
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end


            -- for _, v in pairs(ConfShopp.Shop.Items) do

            --     RageUI.ButtonWithStyle(v.Label, nil, {
            --         RightLabel = "~g~" .. v.Price .. "$"
            --     }, true, function(Hovered, Active, Selected)
            --         if Selected then
            --             local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
            --             if not valid then
            --                 ESX.ShowNotification("Quantité invalide")
            --             else
            --                 TriggerServerEvent('enos_shop:giveItem', v, quantity)
            --             end
            --         end
            --     end)

            -- end

        end, function()
        end)


        Citizen.Wait(0)
    end
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("SHOP_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "SHOP_INPUT", '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == 'number' then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end