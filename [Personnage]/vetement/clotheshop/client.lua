local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["BACKSPACE"] = 177,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil
local scaleType = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('Mushy:SyncAccess')
AddEventHandler('Mushy:SyncAccess', function()
    ESX.TriggerServerCallback("Mushy:getMask", function(result)
        MaskTab = result
    end)
end)

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CreateMain()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.75, coords.y, coords.z)
    SetCamFov(cam, 50.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateShoes()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.0, coords.y, coords.z)
    SetCamFov(cam, 50.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z - 1.0)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateFutal()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.50, coords.y, coords.z - 0.55)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z - 0.55)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateTop()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.75, coords.y, coords.z + 0.60)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateFace()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 2.0, coords.y - 1.0, coords.z + 0.5)
    SetCamFov(cam, 30.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z + 0.5)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateGant()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.75, coords.y, coords.z - 0.15)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z - 0.15)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateBack()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x + 1.75, coords.y, coords.z + 0.60)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateMontre()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x - 1.50, coords.y - 1.5, coords.z + 0.60)
    SetCamFov(cam, 20.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function Tourner()
    local back = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), back + 180)
end

function Left()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x, coords.y - 1.00, coords.z)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function Angle()
    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
end

function gettxt2(txtt)
    AddTextEntry('FMMC_MPM_NA', "Texte")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", txtt, "", "", "", 100)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if tonumber(result) ~= nil then
            if tonumber(result) >= 1 then

                return tonumber(result)
            else

            end
        else
            return result
        end
    end

end

local sex = nil
local vestes = nil
local pantalon = nil
local shirt = nil
local variationveste = nil
local variationpantalon = nil
local variationchaussure = nil
local variationteeshirt = nil

RMenu.Add('menu', 'main', RageUI.CreateMenu("Magasin", "~b~Actions disponibles"))
RMenu.Add('menu', 'torso', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Vestes", "~b~Actions disponibles"))
RMenu.Add('menu', 'pants', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Pantalons", "~b~Actions disponibles"))
RMenu.Add('menu', 'shoes', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Chaussures", "~b~Actions disponibles"))
RMenu.Add('menu', 'bag', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Sac à dos", "~b~Actions disponibles"))
RMenu.Add('menu', 'gant', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Gants", "~b~Actions disponibles"))
RMenu.Add('menu', 'colortorso',
    RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Variations du Torse", "~b~Actions disponibles"))
RMenu.Add('menu', 'colorpants',
    RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Variations du Pantalon", "~b~Actions disponibles"))
RMenu.Add('menu', 'colorshoes',
    RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Variations des Chaussures", "~b~Actions disponibles"))
RMenu.Add('menu', 'colortshirt',
    RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Variations du T-shirt", "~b~Actions disponibles"))
RMenu.Add('menu', 'shirt', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "T-Shirt", "~b~Actions disponibles"))
RMenu.Add('menu', 'dressing', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Dressing", "~b~Actions disponibles"))
RMenu.Add('menu', 'watodo', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Que faire ?", "~b~Actions disponibles"))
RMenu:Get('menu', 'main').Closed = function()
    RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
end


local tpchange = {{{
    x = 72.73,
    y = -1399.19,
    z = 29.38,
    h = 82.806739807129
}}}

local actionsToDo = {}

MaskTab = {}
local TenueTable = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.listClotheshop) do

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.listClotheshop[k].x,
                Config.listClotheshop[k].y, Config.listClotheshop[k].z)
            if dist <= 20 then
                DrawMarker(1, Config.listClotheshop[k].x, Config.listClotheshop[k].y, Config.listClotheshop[k].z, 0.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)

                if dist <= 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Changer de style")

                    -- DisplayHelpTextThisFrame("HELP", false)
                    attente = 1
                    if IsControlJustPressed(1, 51) then
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                            Citizen.Wait(3000)
                            TriggerEvent('skinchanger:change', 'decals_1', 0)
                            TriggerEvent('skinchanger:change', 'decals_2', 0)
                            sex = skin['sex']
                            vestes = clothe['torso_1']
                            pantalon = clothe['pants_1']
                            shirt = clothe['tshirt_1']
                            variationveste = clothe['torso_2']
                            variationpantalon = clothe['pants_2']
                            shoes = clothe['shoes_1']
                            variationchaussure = clothe['shoes_2']
                            variationteeshirt = clothe['tshirt_2']
                            if skin['sex'] == 1 then
                                TriggerEvent('skinchanger:change', 'glasses_1', 5)
                            end
                        end)

                        ESX.TriggerServerCallback('VmLife:GetTenues', function(skin)
                            TenueTable = skin
                        end)
                        disable = true
                        ClearPedTasks(PlayerPedId())
                        TaskPedSlideToCoord(PlayerPedId(), Config.listClotheshop[k].taskx,
                            Config.listClotheshop[k].tasky, Config.listClotheshop[k].taskz,
                            Config.listClotheshop[k].taskh, 0.0)
                            Citizen.Wait(7000)
                        FreezeEntityPosition(PlayerPedId(), true)
                        CreateMain()
                        DrawAnim()
                        RageUI.Visible(RMenu:Get('menu', 'main'), not RageUI.Visible(RMenu:Get('menu', 'main')))
                        TriggerEvent("refreshTenueList")
                    end
                end
            end
        end
        RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()

            Angle()
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 191) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            RageUI.Button("Mon Dressing", "", {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function()
            end, RMenu:Get('menu', 'dressing'))
            RageUI.Button("Vestes", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'torso'))
            RageUI.Button("Couleur de la Vestes", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'colortorso'))
            RageUI.Button("T-Shirt", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'shirt'))
            RageUI.Button("Gants", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'gant'))
            if shirt == -1 then
            else
                RageUI.Button("Couleur du T-Shirt", "", {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('menu', 'colortshirt'))
            end
            RageUI.Button("Pantalon", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'pants'))
            RageUI.Button("Couleur du Pantalons", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'colorpants'))
            RageUI.Button("Chaussures", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'shoes'))
            RageUI.Button("Couleur des Chaussures", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'colorshoes'))
            RageUI.Button("Sac", "", {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('menu', 'bag'))

        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('menu', 'dressing'), true, true, true, function()
            CreateMain()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            Angle()
                -- TenueTable
                RageUI.Button("Sauvegarder une tenue", nil, {
                    RightLabel = "→"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        k = gettxt2("")
                        if k ~= nil then
                            if tostring(k) ~= nil and tostring(k) ~= "" then
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                    TriggerServerEvent("VmLife:SaveTenueS", k, clothe)
                                    TriggerEvent("refreshTenueList")
                                end)
                                Wait(550)
                            end
                        end
                    end
                end)

                for i = 1, #TenueTable, 1 do
                    RageUI.List(TenueTable[i].Label, actionsToDo[i].listwatodo, actionsToDo[i].indexwatodo, nil, {
                        RightBadge = RageUI.BadgeStyle.Clothes
                    }, true, function(Hovered, Active, Selected, Index)
                        if (Active) then
                            actionsToDo[i].indexwatodo = Index
                        end
                        if (Selected) then
                            local clothes = TenueTable[i]

                            for k, Index in pairs(clothes) do
                                if k == "Clothe" then
                                    clothes = Index
                                    break
                                end
                            end

                            if Index == 1 then
                                DrawAnim()
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    TriggerEvent('skinchanger:loadClothes', skin, json.decode(clothes))
                                    TriggerServerEvent('VmLife:RenameLabelUser', TenueTable[i].Label)
                                end)
                            elseif Index == 2 then
                                kx = gettxt2(TenueTable[i].Label)
                                ESX.TriggerServerCallback('VmLife:Select', function(tenueActuelle)
                                    if TenueTable[i].Label == tenueActuelle then
                                        TriggerServerEvent('VmLife:RenameLabelUser', kx)
                                    end
                                end)
                                if tostring(kx) ~= nil then
                                    TriggerServerEvent('VmLife:RenameTenue', TenueTable[i].Label, kx)
                                    Wait(100)
                                    TriggerEvent("refreshTenueList")
                                end
                            elseif Index == 3 then
                                ESX.TriggerServerCallback('VmLife:Select', function(tenueActuelle)
                                    if TenueTable[i].Label ~= tenueActuelle then
                                        TriggerServerEvent('VmLife:DeleteTenue', TenueTable[i].Label)
                                        Wait(100)
                                        TriggerEvent("refreshTenueList")
                                    else
                                        ESX.ShowNotification("Vous ne pouvez pas supprimer la tenue que vous portez",
                                            false, false, r)
                                    end
                                end)
                            end
                        end

                    end)
                end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'torso'), true, true, true, function()
            CreateTop()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.femme) do

                    RageUI.Button("Vestes #" .. v.veste, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceVeste .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            torso1 = v.veste
                            torso2 = 0
                            SetPedComponentVariation(PlayerPedId(), 11, v.veste, 0, 2)
                            SetPedComponentVariation(PlayerPedId(), 3, v.bras[1])
                            SetPedComponentVariation(PlayerPedId(), 8, -1, 0, 2)
                        end
                        if (Selected) then
                            vestes = v.veste
                            shirt = 14
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['torso_1'] = v.veste
                                        clothe['torso_2'] = 0
                                        clothe['tshirt_1'] = 14
                                        clothe['arms'] = v.bras[1]
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceVeste)
                        end
                    end)
                end
                tops = 289
            else
                for k, v in ipairs(Config.homme) do

                    RageUI.Button("Vestes #" .. v.veste, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceVeste .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            torso1 = v.veste
                            torso2 = 0
                            SetPedComponentVariation(PlayerPedId(), 11, v.veste, 0, 2)
                            SetPedComponentVariation(PlayerPedId(), 3, v.bras[1])
                            SetPedComponentVariation(PlayerPedId(), 8, -1, 0, 2)
                        end
                        if (Selected) then
                            vestes = v.veste
                            shirt = 15
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['torso_1'] = v.veste
                                        clothe['torso_2'] = 0
                                        clothe['tshirt_1'] = 15
                                        clothe['arms'] = v.bras[1]
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceVeste)
                        end
                    end)
                end
            end
            tops = 289
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'colortorso'), true, true, true, function()
            CreateTop()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            Angle()
            if sex == 0 then
                for k, v in ipairs(Config.homme) do
                    if v.veste == vestes then
                        variationveste = v.variation
                    end
                end
                for k, v in ipairs(variationveste) do
                    if v == -1 then
                    else
                        RageUI.Button("Variations #" .. variationveste[k],
                            "Cette tenue est disponible dans notre magasin.", {
                                RightLabel = "~g~" .. Config.priceColorVeste .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    torso2 = variationveste[k]
                                    CreateTop()
                                    if IsControlJustPressed(0, 194) then
                                        RenderScriptCams(0, 1, 1000, 1, 1)
                                        DestroyAllCams(true)
                                        CreateMain()
                                    end
                                    if IsControlJustPressed(0, 22) then
                                        Tourner()
                                    end
                                    SetPedComponentVariation(PlayerPedId(), 11, vestes, torso2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['torso_1'] = vestes
                                                clothe['torso_2'] = torso2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceColorVeste)
                                end
                            end)
                    end
                end
            else
                for k, v in ipairs(Config.femme) do
                    if v.veste == vestes then
                        variationveste = v.variation
                    end
                end
                for k, v in ipairs(variationveste) do
                    if v == -1 then
                    else
                        RageUI.Button("Variations #" .. variationveste[k],
                            "Cette tenue est disponible dans notre magasin.", {
                                RightLabel = "~g~" .. Config.priceColorVeste .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    torso2 = variationveste[k]
                                    CreateTop()
                                    if IsControlJustPressed(0, 194) then
                                        RenderScriptCams(0, 1, 1000, 1, 1)
                                        DestroyAllCams(true)
                                        CreateMain()
                                    end
                                    if IsControlJustPressed(0, 22) then
                                        Tourner()
                                    end
                                    SetPedComponentVariation(PlayerPedId(), 11, vestes, torso2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['torso_1'] = vestes
                                                clothe['torso_2'] = torso2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                TriggerServerEvent('shop:price', 25)

                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceColorVeste)
                                end
                            end)
                    end
                end
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'shirt'), true, true, true, function()
            CreateTop()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.femme) do
                    if v.veste == vestes then
                        tshirt = v.tshirt
                    end
                end
                for k, v in ipairs(tshirt) do
                    if v ~= -1 or v ~= 14 then
                        RageUI.Button("T-Shirt #" .. tshirt[k], "Cette tenue est disponible dans notre magasin.", {
                            RightLabel = "~g~" .. Config.priceShirt .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if (Active) then
                                tshirt1 = v
                                tshirt2 = 0
                                SetPedComponentVariation(PlayerPedId(), 8, tshirt1, tshirt2, 2)
                            end
                            if (Selected) then
                                ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                    if verif then
                                        shirt = v
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                            clothe['tshirt_1'] = v
                                            clothe['tshirt_2'] = tshirt2
                                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                            TriggerServerEvent('shop:price', 25)

                                            ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                            end)
                                        end)
                                    else
                                        ESX.ShowNotification('Pas assez d\'argent')
                                    end
                                end, Config.priceShirt)
                            end
                        end)
                    end
                end

                tops = 144
            else
                for k, v in ipairs(Config.homme) do
                    if v.veste == vestes then
                        tshirt = v.tshirt
                    end
                end
                for k, v in ipairs(tshirt) do
                    if v ~= -1 or v ~= 15 then
                        RageUI.Button("T-Shirt #" .. tshirt[k], "Cette tenue est disponible dans notre magasin.", {
                            RightLabel = "~g~" .. Config.priceShirt .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if (Active) then
                                tshirt1 = v
                                tshirt2 = 0
                                SetPedComponentVariation(PlayerPedId(), 8, tshirt1, tshirt2, 2)
                            end
                            if (Selected) then
                                ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                    if verif then
                                        shirt = v
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                            clothe['tshirt_1'] = v
                                            clothe['tshirt_2'] = tshirt2
                                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                            ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                            end)
                                        end)
                                    else
                                        ESX.ShowNotification('Pas assez d\'argent')
                                    end
                                end, Config.priceShirt)
                            end
                        end)
                    end
                end

                tops = 144
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'colortshirt'), true, true, true, function()
            CreateTop()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.teeshirtfemme) do
                    if v.teeshirt == shirt then
                        variationteeshirt = v.variation
                    end
                end
                if shirt == 14 or shirt == -1 then
                else
                    for k, v in ipairs(variationteeshirt) do
                        RageUI.Button("Variations #" .. v, "Cette tenue est disponible dans notre magasin.", {
                            RightLabel = "~g~" .. Config.priceColorShirt .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if (Active) then
                                tshirt2 = v
                                CreateTop()
                                if IsControlJustPressed(0, 194) then
                                    RenderScriptCams(0, 1, 1000, 1, 1)
                                    DestroyAllCams(true)
                                    CreateMain()
                                end
                                if IsControlJustPressed(0, 22) then
                                    Tourner()
                                end
                                SetPedComponentVariation(PlayerPedId(), 8, shirt, v, 2)
                            end
                            if (Selected) then
                                ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                    if verif then
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                            clothe['tshirt_1'] = shirt
                                            clothe['tshirt_2'] = v
                                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                            TriggerServerEvent('shop:price', 25)
                                            ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                            end)
                                        end)
                                    else
                                        ESX.ShowNotification('Pas assez d\'argent')
                                    end
                                end, Config.priceColorShirt)
                            end
                        end)
                    end
                end
            else
                for k, v in ipairs(Config.teeshirthomme) do
                    if v.teeshirt == shirt then
                        variationteeshirt = v.variation
                    end
                end
                if shirt == 15 or shirt == -1 then
                else
                    for k, v in ipairs(variationteeshirt) do
                        RageUI.Button("Variations #" .. v, "Cette tenue est disponible dans notre magasin.", {
                            RightLabel = "~g~" .. Config.priceColorShirt .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if (Active) then
                                tshirt2 = v
                                CreateTop()
                                if IsControlJustPressed(0, 194) then
                                    RenderScriptCams(0, 1, 1000, 1, 1)
                                    DestroyAllCams(true)
                                    CreateMain()
                                end
                                if IsControlJustPressed(0, 22) then
                                    Tourner()
                                end
                                SetPedComponentVariation(PlayerPedId(), 8, shirt, v, 2)
                            end
                            if (Selected) then
                                ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                    if verif then
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                            clothe['tshirt_1'] = shirt
                                            clothe['tshirt_2'] = v
                                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                            TriggerServerEvent('shop:price', 25)
                                            ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                            end)
                                        end)
                                    else
                                        ESX.ShowNotification('Pas assez d\'argent')
                                    end
                                end, Config.priceColorShirt)
                            end
                        end)
                    end
                end
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'pants'), true, true, true, function()
            CreateFutal()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.pantalonfemme) do
                    RageUI.Button("Pantalon #" .. v.pantalon, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.pricePant .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            pants1 = v.pantalon
                            pants2 = 0
                            SetPedComponentVariation(PlayerPedId(), 4, pants1, pants2, 2)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    pantalon = v.pantalon
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['pants_1'] = v.pantalon
                                        clothe['pants_2'] = pants2

                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)

                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.pricePant)
                        end
                    end)
                end
                tops = 115
            else
                for k, v in ipairs(Config.pantalonhome) do
                    RageUI.Button("Pantalon #" .. v.pantalon, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.pricePant .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            pants1 = v.pantalon
                            pants2 = 0
                            SetPedComponentVariation(PlayerPedId(), 4, v.pantalon, pants2, 2)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    pantalon = v.pantalon
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['pants_1'] = v.pantalon
                                        clothe['pants_2'] = pants2

                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)

                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.pricePant)
                        end
                    end)
                end
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('menu', 'colorpants'), true, true, true, function()
            CreateFutal()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            Angle()
            if sex == 0 then
                for k, v in ipairs(Config.pantalonhome) do
                    if v.pantalon == pantalon then
                        variationpantalon = v.variation
                    end
                end
                for k, v in ipairs(variationpantalon) do
                    if v == -1 then
                    else
                        RageUI.Button("Variations #" .. variationpantalon[k],
                            "Cette tenue est disponible dans notre magasin.", {
                                RightLabel = "~g~" .. Config.priceColorPant .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    pant2 = variationpantalon[k]
                                    CreateFutal()
                                    if IsControlJustPressed(0, 194) then
                                        RenderScriptCams(0, 1, 1000, 1, 1)
                                        DestroyAllCams(true)
                                        CreateMain()
                                    end
                                    if IsControlJustPressed(0, 22) then
                                        Tourner()
                                    end
                                    SetPedComponentVariation(PlayerPedId(), 4, pantalon, pant2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['pants_1'] = pantalon
                                                clothe['pants_2'] = pant2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                TriggerServerEvent('shop:price', 25)

                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceColorPant)
                                end
                            end)
                    end
                end
            else
                for k, v in ipairs(Config.pantalonfemme) do
                    if v.pantalon == pantalon then
                        variationpantalon = v.variation
                    end
                end
                for k, v in ipairs(variationpantalon) do
                    if v == -1 then
                    else
                        RageUI.Button("Variations #" .. variationpantalon[k],
                            "Cette tenue est disponible dans notre magasin.", {
                                RightLabel = "~g~" .. Config.priceColorPant .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    pant2 = variationpantalon[k]
                                    CreateFutal()
                                    if IsControlJustPressed(0, 194) then
                                        RenderScriptCams(0, 1, 1000, 1, 1)
                                        DestroyAllCams(true)
                                        CreateMain()
                                    end
                                    if IsControlJustPressed(0, 22) then
                                        Tourner()
                                    end
                                    SetPedComponentVariation(PlayerPedId(), 4, pantalon, pant2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['pants_1'] = pantalon
                                                clothe['pants_2'] = pant2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                TriggerServerEvent('shop:price', 25)

                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceColorPant)
                                end
                            end)
                    end
                end
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'shoes'), true, true, true, function()
            CreateShoes()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.pantalonfemme) do
                    if v.pantalon == pantalon then
                        chaussure = v.chaussure
                    end
                end
                for k, v in ipairs(chaussure) do
                    if v == -1 then
                    else
                        RageUI.Button("Chaussures #" .. chaussure[k], "Cette tenue est disponible dans notre magasin.",
                            {
                                RightLabel = "~g~" .. Config.priceShoes .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    shoes1 = v
                                    shoes2 = 0
                                    SetPedComponentVariation(PlayerPedId(), 6, shoes1, shoes2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            shoes = v
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['shoes_1'] = v
                                                clothe['shoes_2'] = shoes2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                TriggerServerEvent('shop:price', 25)

                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceShoes)
                                end
                            end)
                    end
                end
                tops = 91
            else
                for k, v in ipairs(Config.pantalonhome) do
                    if v.pantalon == pantalon then
                        chaussure = v.chaussure
                    end
                end
                for k, v in ipairs(chaussure) do
                    if v == -1 then
                    else
                        RageUI.Button("Chaussures #" .. chaussure[k], "Cette tenue est disponible dans notre magasin.",
                            {
                                RightLabel = "~g~" .. Config.priceShoes .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    shoes1 = v
                                    shoes2 = 0
                                    SetPedComponentVariation(PlayerPedId(), 6, v, shoes2, 2)
                                end
                                if (Selected) then
                                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                        if verif then
                                            shoes = v
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                                clothe['shoes_1'] = v
                                                clothe['shoes_2'] = shoes2
                                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                                TriggerServerEvent('shop:price', 25)

                                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                                end)
                                            end)
                                        else
                                            ESX.ShowNotification('Pas assez d\'argent')
                                        end
                                    end, Config.priceShoes)
                                end
                            end)
                    end
                end

            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'colorshoes'), true, true, true, function()
            CreateShoes()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end

            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.chaussurefemme) do
                    if v.chaussure == shoes then
                        variationchaussure = v.variation
                    end
                end
                for k, v in ipairs(variationchaussure) do
                    RageUI.Button("Variations #" .. v, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceColorShoes .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            shoes2 = v
                            CreateShoes()
                            if IsControlJustPressed(0, 194) then
                                RenderScriptCams(0, 1, 1000, 1, 1)
                                DestroyAllCams(true)
                                CreateMain()
                            end
                            if IsControlJustPressed(0, 22) then
                                Tourner()
                            end
                            SetPedComponentVariation(PlayerPedId(), 6, shoes, shoes2, 2)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['shoes_1'] = shoes
                                        clothe['shoes_2'] = v
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceColorShoes)
                        end
                    end)
                end
                tops = 91
            else
                for k, v in ipairs(Config.chaussurehomme) do
                    if v.chaussure == shoes then
                        variationchaussure = v.variation
                    end
                end

                for k, v in ipairs(variationchaussure) do
                    RageUI.Button("Variations #" .. v, "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceColorShoes .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            shoes2 = variationchaussure[k]
                            CreateShoes()
                            if IsControlJustPressed(0, 194) then
                                RenderScriptCams(0, 1, 1000, 1, 1)
                                DestroyAllCams(true)
                                CreateMain()
                            end
                            if IsControlJustPressed(0, 22) then
                                Tourner()
                            end
                            SetPedComponentVariation(PlayerPedId(), 6, shoes, variationchaussure[k], 2)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['shoes_1'] = shoes
                                        clothe['shoes_2'] = variationchaussure[k]
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceColorShoes)
                        end
                    end)
                end
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'gant'), true, true, true, function()
            CreateGant()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            Angle()
            if sex == 1 then
                for k, v in ipairs(Config.femme) do
                    if v.veste == vestes then
                        gant = v.bras
                    end
                end
                for k, v in ipairs(gant) do
                    RageUI.Button("Gants #" .. gant[k], "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceGant .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            SetPedComponentVariation(PlayerPedId(), 3, v)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['arms'] = v
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceGant)
                        end
                    end)
                end
                tops = 144
            else
                for k, v in ipairs(Config.homme) do
                    if v.veste == vestes then
                        gant = v.bras
                    end
                end
                for k, v in ipairs(gant) do
                    RageUI.Button("Gants #" .. gant[k], "Cette tenue est disponible dans notre magasin.", {
                        RightLabel = "~g~" .. Config.priceGant .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            SetPedComponentVariation(PlayerPedId(), 3, v)
                        end
                        if (Selected) then
                            ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                                if verif then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                        clothe['arms'] = v
                                        TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                        TriggerServerEvent('shop:price', 25)

                                        ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                            TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                        end)
                                    end)
                                else
                                    ESX.ShowNotification('Pas assez d\'argent')
                                end
                            end, Config.priceGant)
                        end
                    end)
                end
                tops = 144
            end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('menu', 'bag'), true, true, true, function()
            CreateBack()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                CreateMain()
                ClearPedTasks(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin, clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            Angle()
            RageUI.Button("Aucun", "Cette tenue est disponible dans notre magasin.", {
                RightLabel = "~g~" .. 0 .. "$"
            }, true, function(Hovered, Active, Selected)
                if (Active) then
                    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 2)
                end
                if (Selected) then
                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                        if verif then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                clothe['bags_1'] = 0
                                clothe['chain_1'] = 0
                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                TriggerServerEvent('shop:price', 0)
                                TriggerServerEvent('weightextended', 40)
                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                end)
                            end)
                        else
                            ESX.ShowNotification('Pas assez d\'argent')
                        end
                    end, Config.priceBag)
                end
            end)

            RageUI.Button("Sac Tactique", "Cette tenue est disponible dans notre magasin.", {
                RightLabel = "~g~" .. Config.priceBag .. "$"
            }, true, function(Hovered, Active, Selected)
                if (Active) then
                    SetPedComponentVariation(PlayerPedId(), 5, 40, 0, 2)
                end
                if (Selected) then
                    ESX.TriggerServerCallback('verifMoneyShop', function(verif)
                        if verif then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                                clothe['bags_1'] = 40
                                clothe['torso_2'] = 0
                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                                TriggerServerEvent('shop:price', 25)
                                TriggerServerEvent('weightextended', 70)
                                ESX.TriggerServerCallback('esx_skin:getPlayerLabel', function(label)
                                    TriggerServerEvent('Monsieur:UpdateClotheShop', clothe, label)
                                end)
                            end)
                        else
                            ESX.ShowNotification('Pas assez d\'argent')
                        end
                    end, Config.priceBag)
                end
            end)
        end, function()
        end, 1)

    end
end)

AddEventHandler("refreshTenueList", function()
    ESX.TriggerServerCallback('VmLife:GetTenues', function(skin)
        TenueTable = skin
        actionsToDo = {}
        for i = 1, #TenueTable, 1 do
            table.insert(actionsToDo, i, {
                indexwatodo = 1,
                listwatodo = {'Equiper', 'Renommer', 'Supprimer'}
            })
        end
    end)
end)

Citizen.CreateThread(function()
    for _, info in pairs(Config.MagasinsBlip) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.75)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function DrawAnim()
    local ped = PlayerPedId()
    local ad = "clothingshirt"
    loadAnimDict(ad)
    RequestAnimDict(dict)
    TaskPlayAnim(ped, ad, "check_out_a", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "check_out_b", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "check_out_c", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "intro", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "outro", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "try_shirt_base", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "try_shirt_positive_a", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "try_shirt_positive_b", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "try_shirt_positive_c", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(ped, ad, "try_shirt_positive_d", 8.0, 0.6, -1, 49, 0, 0, 0, 0)
end

function CreateScale(sType)
	if scaleString ~= sType and sType == "Control" then
		scaleType = setupScaleform("instructional_buttons", "Changer la vue", 22)
		scaleString = sType
	end
end


function setupScaleform(scaleform, message, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end