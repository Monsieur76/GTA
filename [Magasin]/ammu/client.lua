ESX = nil
local ppa

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

ConfAmmu = {
    Posdebz = {{
        x = -3171.70,
        y = 1087.66,
        z = 19.84
    }, {
        x = 2567.6,
        y = 294.3,
        z = 107.7
    }, {
        x = 22.0,
        y = -1107.2,
        z = 28.8
    }, {
        x = 252.3,
        y = -50.0,
        z = 68.9
    }, {
        x = -330.2,
        y = 6083.8,
        z = 30.4
    }, {
        x = 1693.4,
        y = 3759.5,
        z = 33.7
    }, {
        x = -662.1,
        y = -935.3,
        z = 20.8
    }},

    Apunir = {{
        x = 23.17,
        y = -1105.32,
        z = 28.8,
        a = 160.2
    }, {
        x = -3173.81,
        y = 1088.71,
        z = 19.83,
        a = 246.79
    }, {
        x = -331.92,
        y = 6085.38,
        z = 30.45,
        a = 223.21
    }, {
        x = 1692.01,
        y = 3761.31,
        z = 33.70,
        a = 228.42
    }, {
        x = 2567.77,
        y = 292.12,
        z = 107.73,
        a = 357.27
    }, {
        x = 254.20,
        y = -50.88,
        z = 68.94,
        a = 72.29
    }, {
        x = -662.1,
        y = -933.61,
        z = 20.83,
        a = 177.29
    }},

    Type = {

        General = {{
            Label = 'Couteau',
            Value = 'WEAPON_KNIFE',
            Price = 100,
            pa = false
        }, {
            Label = 'Clé anglaise',
            Value = 'WEAPON_WRENCH',
            Price = 120,
            pa = false
        }, {
            Label = 'Club de golf',
            Value = 'WEAPON_GOLFCLUB',
            Price = 120,
            pa = false
        }, {
            Label = 'Batte de baseball',
            Value = 'WEAPON_BAT',
            Price = 250,
            pa = false
        }, {
            Label = 'Tazer',
            Value = 'WEAPON_STUNGUN',
            Price = 300,
            pa = false
        }, {
            Label = 'Pistolet de détresse',
            Value = 'WEAPON_FLAREGUN',
            Price = 350,
            pa = true
        }, {
            Label = 'Pistolet 9mm',
            Value = 'WEAPON_PISTOL',
            Price = 710,
            pa = true
        }, {
            Label = 'Mousquet',
            Value = 'WEAPON_MUSKET',
            Price = 1200,
            pa = true
        }, {
            Label = 'Chargeur pistolet 9mm',
            Value = 'chargeur_pistolet',
            Price = 50,
            pa = true
        }, {
            Label = 'Chargeur mousquet',
            Value = 'chargeur_mousquet',
            Price = 50,
            pa = true
        }, {
            Label = 'Chargeur pistolet de détresse',
            Value = 'chargeur_flaregun',
            Price = 50,
            pa = true
        }, {
            Label = 'Parachute',
            Value = 'parachute',
            Price = 500,
            pa = false
        }},

        outilsPolice = {{
            Label = 'Plot',
            Value = 'plot',
            Price = 100
        }, {
            Label = 'Barriere',
            Value = 'barriere',
            Price = 100
        }, {
            Label = 'Herse',
            Value = 'herse',
            Price = 200
        }, {
            Label = 'Lampe Torche',
            Value = 'WEAPON_FLASHLIGHT',
            Price = 150
        }, {
            Label = 'Radio',
            Value = 'radio',
            Price = 500
        }, {
            Label = 'Matraque',
            Value = 'WEAPON_NIGHTSTICK',
            Price = 300
        }, {
            Label = 'Fusil à pompe',
            Value = 'WEAPON_PUMPSHOTGUN',
            Price = 11500
        }, {
            Label = 'Carabine d\'assaut',
            Value = 'WEAPON_CARBINERIFLE',
            Price = 19500
        }, {
            Label = 'Chargeur carabine d\'assaut',
            Value = 'chargeur_carabine',
            Price = 50
        }, {
            Label = 'Chargeur fusil à pompe',
            Value = 'chargeur_fap',
            Price = 50
        } -- {Label = 'Fusil à lunette', Value = 'WEAPON_SNIPERRIFLE', Price = 125000},
        },
        outilsBrinks = {{
            Label = 'Lampe Torche',
            Value = 'WEAPON_FLASHLIGHT',
            Price = 150
        }, {
            Label = 'Matraque',
            Value = 'WEAPON_NIGHTSTICK',
            Price = 300
        }, {
            Label = 'Radio',
            Value = 'radio',
            Price = 500
        }, {
            Label = 'Fusil à pompe',
            Value = 'WEAPON_PUMPSHOTGUN',
            Price = 11500
        }, {
            Label = 'Chargeur fusil à pompe',
            Value = 'chargeur_fap',
            Price = 50
        }},

        outilsLSMS = {{
            Label = 'Plot',
            Value = 'plot',
            Price = 100
        }, {
            Label = 'Tazer',
            Value = 'WEAPON_STUNGUN',
            Price = 150
        }, {
            Label = 'Radio',
            Value = 'radio',
            Price = 500
        }},
        Armes = {
            -- {Label = 'Pétoire', Value = 'WEAPON_SNSPISTOL', Price = 450},
            -- {Label = 'Pistolet lourd', Value = 'WEAPON_HEAVYPISTOL', Price = 500},
            -- {Label = 'Revolver', Value = 'WEAPON_DOUBLEACTION', Price = 850},
            -- {Label = 'Pistolet de précision', Value = 'WEAPON_MARKSMANPISTOL', Price = 850},
        }
    }
}
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
Citizen.CreateThread(function()
    for k, v in pairs(ConfAmmu.Posdebz) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite(blip, 110)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, 28)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Armurerie')
        EndTextCommandSetBlipName(blip)
    end
end)

local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_ammucity_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    for k, v in pairs(ConfAmmu.Apunir) do
        ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_ammucity_01", v.x, v.y, v.z, v.a, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)

        for k, v in pairs(ConfAmmu.Posdebz) do
            local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z, true)

            if distance < 10.0 then
                actualZone = v

                zoneDistance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z, true)

                DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95,
                    100, 0, nil, nil, 0)

            end

            if distance <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Acheter")
                if IsControlJustPressed(1, 51) and not RageUI.Visible(RMenu:Get('enos_ammu', 'main')) and
                    not RageUI.Visible(RMenu:Get('enos_ammu', 'brinks')) and
                    not RageUI.Visible(RMenu:Get('enos_ammu', 'lspd')) and
                    not RageUI.Visible(RMenu:Get('enos_ammu', 'lsms')) then
                    ESX.TriggerServerCallback('esx_license:checkLicenseCurrentUser', function(haveLicense)
                        if haveLicense then
                            ppa = true
                        else
                            ppa = false
                        end
                    end, "PPA")
                    RageUI.Visible(RMenu:Get('enos_ammu', 'main'), not RageUI.Visible(RMenu:Get('enos_ammu', 'main')))
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

RMenu.Add('enos_ammu', 'main', RageUI.CreateMenu("Ammunation", "Armurerie"))
RMenu.Add('enos_ammu', 'brinks',
    RageUI.CreateSubMenu(RMenu:Get('enos_ammu', 'main'), "Armurerie", "Voici notre matos pour l'UDST."))
RMenu.Add('enos_ammu', 'lspd',
    RageUI.CreateSubMenu(RMenu:Get('enos_ammu', 'main'), "Armurerie", "Voici notre matos pour le LSPD."))
RMenu.Add('enos_ammu', 'lsms',
    RageUI.CreateSubMenu(RMenu:Get('enos_ammu', 'main'), "Armurerie", "Voici notre matos pour le LSMS."))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('enos_ammu', 'main'), true, true, true, function()

            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'brinks' and ESX.PlayerData.job.grade > 2 then
                RageUI.ButtonWithStyle("Matériel UDST", nil, {
                    RigtLabel = "→"
                }, true, function()
                end, RMenu:Get('enos_ammu', 'brinks'))
            end
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') and ESX.PlayerData.job.grade > 2 then
                RageUI.ButtonWithStyle("Matériel LSPD", nil, {
                    RigtLabel = "→"
                }, true, function()
                end, RMenu:Get('enos_ammu', 'lspd'))
            end

            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade > 2 then
                RageUI.ButtonWithStyle("Matériel LSMS", nil, {
                    RigtLabel = "→"
                }, true, function()
                end, RMenu:Get('enos_ammu', 'lsms'))
            end

            for _, v in pairs(ConfAmmu.Type.General) do
                if ppa then
                    RageUI.ButtonWithStyle(v.Label, nil, {
                        RightLabel = "~g~" .. v.Price .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if v.Value:find('WEAPON') then
                                if v.Value == "WEAPON_MUSKET" then
                                    ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                                        if haveLicense then
                                            TriggerServerEvent('weaponshops:giveWeapon', v)
                                        else
                                            ESX.ShowNotification(
                                                "Vous ne pouvez pas acheter de mousquet sans permis de chasse !")
                                        end

                                    end, GetPlayerServerId(PlayerId()), "hunting")
                                else
                                    TriggerServerEvent('weaponshops:giveWeapon', v)
                                end

                            else
                                if v.Value == "chargeur_mousquet" then
                                    ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                                        if haveLicense then
                                            local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                                            if not valid then
                                                ESX.ShowNotification("Quantité invalide")
                                            else
                                                TriggerServerEvent('item:acheter', v, quantity)
                                            end
                                        else
                                            ESX.ShowNotification(
                                                "Vous ne pouvez pas acheter de munitions de mousquet sans permis de chasse !")
                                        end

                                    end, GetPlayerServerId(PlayerId()), "hunting")
                                else
                                    local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                                    if not valid then
                                        ESX.ShowNotification("Quantité invalide")
                                    else
                                        TriggerServerEvent('item:acheter', v, quantity)
                                    end
                                end

                            end

                        end
                    end)
                else
                    if v.pa == false then
                        RageUI.ButtonWithStyle(v.Label, nil, {
                            RightLabel = "~g~" .. v.Price .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if v.Value:find('WEAPON') then
                                    if v.Value == "WEAPON_MUSKET" then
                                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                                            if haveLicense then
                                                TriggerServerEvent('weaponshops:giveWeapon', v)
                                            else
                                                ESX.ShowNotification(
                                                    "Vous ne pouvez pas acheter de mousquet sans permis de chasse !")
                                            end

                                        end, GetPlayerServerId(PlayerId()), "hunting")
                                    else
                                        TriggerServerEvent('weaponshops:giveWeapon', v)
                                    end

                                else
                                    if v.Value == "chargeur_mousquet" then
                                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                                            if haveLicense then
                                                local valid, quantity =
                                                    CheckQuantity(KeyboardInput("Quantité", "", 10))
                                                if not valid then
                                                    ESX.ShowNotification("Quantité invalide")
                                                else
                                                    TriggerServerEvent('item:acheter', v, quantity)
                                                end
                                            else
                                                ESX.ShowNotification(
                                                    "Vous ne pouvez pas acheter de munitions de mousquet sans permis de chasse !")
                                            end

                                        end, GetPlayerServerId(PlayerId()), "hunting")
                                    else
                                        local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                                        if not valid then
                                            ESX.ShowNotification("Quantité invalide")
                                        else
                                            TriggerServerEvent('item:acheter', v, quantity)
                                        end
                                    end

                                end

                            end
                        end)
                    end
                end
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos_ammu', 'armurerie'), true, true, true, function()
            for k, v in pairs(ConfAmmu.Type.Blanche) do
                RageUI.ButtonWithStyle(v.Label, nil, {
                    RightLabel = "~g~" .. v.Price
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('weaponshops:giveWeapon', v)
                    end
                end)
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos_ammu', 'lspd'), true, true, true, function()
            for k, v in pairs(ConfAmmu.Type.outilsPolice) do
                RageUI.ButtonWithStyle(v.Label, nil, {
                    RightLabel = "~g~" .. v.Price .. "$"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if v.Value:find('WEAPON') then
                            TriggerServerEvent('weaponshops:giveWeapon', v)
                        else
                            local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                            if not valid then
                                ESX.ShowNotification("Quantité invalide")
                            else
                                TriggerServerEvent('item:acheter', v, quantity)
                            end
                        end
                    end
                end)
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos_ammu', 'brinks'), true, true, true, function()
            for k, v in pairs(ConfAmmu.Type.outilsBrinks) do
                RageUI.ButtonWithStyle(v.Label, nil, {
                    RightLabel = "~g~" .. v.Price .. "$"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if v.Value:find('WEAPON') then
                            TriggerServerEvent('weaponshops:giveWeapon', v)
                        else
                            local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                            if not valid then
                                ESX.ShowNotification("Quantité invalide")
                            else
                                TriggerServerEvent('item:acheter', v, quantity)
                            end
                        end
                    end
                end)
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos_ammu', 'lsms'), true, true, true, function()
            for k, v in pairs(ConfAmmu.Type.outilsLSMS) do
                RageUI.ButtonWithStyle(v.Label, nil, {
                    RightLabel = "~g~" .. v.Price .. "$"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if v.Value:find('WEAPON') then
                            TriggerServerEvent('weaponshops:giveWeapon', v)
                        else
                            local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
                            if not valid then
                                ESX.ShowNotification("Quantité invalide")
                            else
                                TriggerServerEvent('item:acheter', v, quantity)
                            end
                        end
                    end
                end)
            end

        end, function()
        end)

        Citizen.Wait(0)
    end
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("AMMU_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "AMMU_INPUT", '', inputText, '', '', '', maxLength)
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
