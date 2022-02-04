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
    ["BACKSPACE"] = 177,
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
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

-- menu F6--

local armoire_FBI = false
RMenu.Add('armoire_FBI', 'main', RageUI.CreateMenu("Armoire FBI", "Armoire MJ"))
RMenu:Get('armoire_FBI', 'main').Closed = function()
    armoire_FBI = false
end

function openFBI()
    if not armoire_FBI then
        armoire_FBI = true
        RageUI.Visible(RMenu:Get('armoire_FBI', 'main'), true)

        Citizen.CreateThread(function()
            while armoire_FBI do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('armoire_FBI', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Civil", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            vcivil()
                        end
                    end)
                    RageUI.ButtonWithStyle("Faith Obeyron - Civil", nil, {  -- Kyra
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            faith_civil()
                        end
                    end)

                    RageUI.ButtonWithStyle("Faith Obeyron - FBI", nil, { -- Kyra
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            faith_civil()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jefferson Harrelson - Civil", nil, { -- Soma
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            harrelson_civil()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jefferson Harrelson - FBI", nil, { -- Soma
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            harrelson_civil()
                        end
                    end)

                    RageUI.ButtonWithStyle("Thalia Garland - Proc FED", nil, { -- Soma
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            thaliaGarlandPROC()
                        end
                    end)

                end, function()
                end)

            end
        end)
    end
end

local posAdmin = {
    x = 118.55,
    y = -728.48,
    z = 242.15
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(Config.admin) do
            if ESX.PlayerData.identifier == v then
                local playerPed = PlayerPedId()
                local plyCoords = GetEntityCoords(playerPed, false)
                local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, posAdmin.x, posAdmin.y, posAdmin.z - 1)
                DrawMarker(1, posAdmin.x, posAdmin.y, posAdmin.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25,
                    95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                if jobdist < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Armoire FBI")
                    if IsControlJustReleased(0, Keys["E"]) then
                        openFBI()
                    end
                end
            end
        end
    end
end)

function vcivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('esx_skin:getaccesorie', function(accessories, casque)
            if skin.hair_color_1 == nil then
                skin.hair_color_1 = 0
            end
            if skin.hair_color_2 == nil then
                skin.hair_color_2 = 0
            end
            if skin.lipstick_2 == nil then
                skin.lipstick_2 = 0.0
            end
            if skin.makeup_1 == nil then
                skin.makeup_2 = 0.0
            end
            ClearPedDecorations(PlayerPedId())
            ESX.TriggerServerCallback('SmallTattoos:GetPlayerTattoos', function(tattooList)
                if tattooList then
                    ClearPedDecorations(PlayerPedId())
                    for k, v in pairs(tattooList) do
                        if v.Count ~= nil then
                            for i = 1, v.Count do
                                SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                            end
                        else
                            SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
                        end
                    end
                end
            end)
            TriggerEvent('skinchanger:loadClothesAccesorie', skin, clothe, accessories)
            if skin.sex == 0 then
                SetPedComponentVariation(PlayerPedId(), 9, 0, 0) -- bulletwear
            else
                SetPedComponentVariation(PlayerPedId(), 9, 0, 0) -- bulletwear
            end
        end)
    end)
end

function faith_civil()
    clothesSkin = {
        ["chin_2"] = 0,
        ["nose_6"] = 0,
        ["blemishes_1"] = 0,
        ["jaw_2"] = 0,
        ["beard_2"] = 0.0,
        ["age_1"] = 0,
        ["makeup_1"] = 4,
        ["complexion_1"] = 0,
        ["cheeks_3"] = 0,
        ["age_2"] = 0.0,
        ["face_md_weight"] = 5,
        ["makeup_3"] = 0,
        ["moles_1"] = 0,
        ["beard_1"] = 0,
        ["hair_color_1"] = 28,
        ["chest_2"] = 1.0,
        ["chin_4"] = 0,
        ["lipstick_3"] = 5,
        ["sex"] = 1,
        ["cheeks_1"] = 0,
        ["lip_thickness"] = 0,
        ["nose_3"] = 0,
        ["hair_1"] = 37,
        ["eye_squint"] = 0,
        ["cheeks_2"] = 0,
        ["nose_5"] = 0,
        ["skin"] = 25,
        ["dad"] = 0,
        ["eyebrows_6"] = 0,
        ["eyebrows_5"] = 0,
        ["moles_2"] = 0.0,
        ["beard_3"] = 0,
        ["eye_color"] = 1,
        ["chin_3"] = 0,
        ["blemishes_2"] = 0.0,
        ["mom"] = 34,
        ["nose_4"] = 0,
        ["lipstick_2"] = 1.0,
        ["makeup_2"] = 1.0,
        ["nose_1"] = 0,
        ["bodyb_2"] = 1.0,
        ["chin_1"] = 0,
        ["lipstick_1"] = 2,
        ["neck_thickness"] = 0,
        ["nose_2"] = 0,
        ["eyebrows_1"] = 0,
        ["bodyb_4"] = 1.0,
        ["eyebrows_2"] = 1.0,
        ["jaw_1"] = 0,
        ["helmet_2"] = -1,
        ["bracelets_2"] = -1,
        ["helmet_1"] = 121,
        ["ears_1"] = -1,
        ["bracelets_1"] = -1,
        ["chain_1"] = -1,
        ["mask_2"] = -1,
        ["ears_2"] = -1,
        ["watches_2"] = -1,
        ["glasses_1"] = -1,
        ["mask_1"] = 121,
        ["chain_2"] = -1,
        ["watches_1"] = -1,
        ["glasses_2"] = -1,
        ["tshirt_2"] = 0,
        ["shoes_2"] = 0,
        ["shoes_1"] = 0,
        ["arms"] = 5,
        ["pants_2"] = 2,
        ["decals_1"] = -1,
        ["tshirt_1"] = 1,
        ["torso_1"] = 340,
        ["pants_1"] = 36,
        ["decals_2"] = -1,
        ["torso_2"] = 0,
        ["bproof_1"] = 53,
    }

    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
    end

function harrelson_civil()
    clothesSkin = {
        ["beard_2"] = 1.0,
        ["makeup_3"] = 0,
        ["cheeks_2"] = 0,
        ["jaw_1"] = 0,
        ["chin_2"] = 0,
        ["moles_2"] = 0.0,
        ["chin_1"] = 0,
        ["hair_color_1"] = 0,
        ["eyebrows_5"] = 0,
        ["age_1"] = 0,
        ["chest_2"] = 1.0,
        ["eyebrows_1"] = 0,
        ["eye_color"] = 4,
        ["beard_3"] = 0,
        ["eye_squint"] = 0,
        ["sex"] = 0,
        ["eyebrows_6"] = 0,
        ["nose_3"] = 0,
        ["cheeks_3"] = 0,
        ["blemishes_2"] = 0.0,
        ["skin"] = 25,
        ["lipstick_2"] = 0.0,
        ["age_2"] = 0.0,
        ["hair_1"] = 38,
        ["nose_6"] = 0,
        ["face_md_weight"] = 5,
        ["dad"] = 0,
        ["beard_1"] = 10,
        ["nose_1"] = 0,
        ["complexion_1"] = 0,
        ["nose_5"] = 0,
        ["bodyb_4"] = 1.0,
        ["neck_thickness"] = 0,
        ["lipstick_3"] = 0,
        ["lipstick_1"] = 0,
        ["chin_3"] = 0,
        ["jaw_2"] = 0,
        ["mom"] = 21,
        ["makeup_1"] = 0,
        ["lip_thickness"] = 0,
        ["blemishes_1"] = 0,
        ["nose_4"] = 0,
        ["cheeks_1"] = 0,
        ["chin_4"] = 0,
        ["makeup_2"] = 0.0,
        ["moles_1"] = 0,
        ["bodyb_2"] = 1.0,
        ["nose_2"] = 0,
        ["eyebrows_2"] = 1.0,
        ["bracelets_1"] = -1,
        ["ears_1"] = -1,
        ["bracelets_2"] = -1,
        ["watches_1"] = -1,
        ["watches_2"] = -1,
        ["helmet_1"] = -1,
        ["mask_1"] = 121,
        ["chain_1"] = -1,
        ["glasses_1"] = 5,
        ["glasses_2"] = 0,
        ["helmet_2"] = -1,
        ["chain_2"] = -1,
        ["mask_2"] = 0,
        ["ears_2"] = -1,
        ["pants_1"] = 10,
        ["shoes_1"] = 10,
        ["decals_2"] = -1,
        ["arms"] = 28,
        ["tshirt_1"] = 4,
        ["decals_1"] = -1,
        ["tshirt_2"] = 0,
        ["torso_1"] = 10,
        ["shoes_2"] = 0,
        ["pants_2"] = 0,
        ["torso_2"] = 0,
        ["bproof_1"] = 53
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function thaliaGarlandPROC()
    clothesSkin = {
        ["eye_color"]=2,
        ["lipstick_1"]=1,
        ["age_2"]=0.0,
        ["lip_thickness"]=0,
        ["nose_1"]=0,
        ["skin"]=25,
        ["makeup_1"]=1,
        ["cheeks_2"]=0,
        ["chin_3"]=0,
        ["nose_3"]=0,
        ["hair_1"]=49,
        ["chin_1"]=0,
        ["chest_2"]=1.0,
        ["dad"]=42,
        ["bodyb_4"]=1.0,
        ["eyebrows_2"]=1.0,
        ["eyebrows_5"]=0,
        ["makeup_3"]=0,
        ["bodyb_2"]=1.0,
        ["sex"]=1,
        ["beard_3"]=8,
        ["beard_2"]=0.0,
        ["nose_4"]=0,
        ["beard_1"]=0,
        ["makeup_2"]=1.0,
        ["nose_6"]=0,
        ["lipstick_2"]=1.0,
        ["blemishes_2"]=0.0,
        ["age_1"]=0,
        ["moles_2"]=0.0,
        ["nose_2"]=0,
        ["face_md_weight"]=0,
        ["nose_5"]=0,
        ["hair_color_1"]=12,
        ["neck_thickness"]=0,
        ["mom"]=25,
        ["blemishes_1"]=0,
        ["jaw_2"]=0,
        ["eyebrows_1"]=1,
        ["eye_squint"]=0,
        ["chin_4"]=0,
        ["complexion_1"]=0,
        ["chin_2"]=0,
        ["cheeks_3"]=0,
        ["moles_1"]=0,
        ["cheeks_1"]=0,
        ["lipstick_3"]=19,
        ["eyebrows_6"]=0,
        ["jaw_1"]=0,
        ["tshirt_2"]=0,
        ["shoes_2"]=0,
        ["pants_1"]=36,
        ["shoes_1"]=6,
        ["pants_2"]=2,
        ["tshirt_1"]=37,
        ["decals_1"]=-1,
        ["torso_2"]=0,
        ["decals_2"]=-1,
        ["arms"]=5,
        ["torso_1"]=340
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

-- function kyra()
--     clothesSkin = {
--         ["dad"] = 0,
--         ["skin_md_weight"] = 0,
--         ["nose_3"] = 0,
--         ["face_md_weight"] = 1,
--         ["hair_color_1"] = 37,
--         ["sex"] = 1,
--         ["nose_1"] = 0,
--         ["eyebrows_1"] = 8,
--         ["mom"] = 2,
--         ["nose_2"] = 3,
--         ["eye_squint"] = 0,
--         ["eye_color"] = 2,
--         ["hair_1"] = 37,
--         ["lipstick_1"] = 0,
--         ["lipstick_2"] = 1.0,
--         ["makeup_1"] = 35,
--         ["lip_thickness"] = 0,
--         ["nose_6"] = 0,
--         ["makeup_2"] = 1.0,
--         ["eyebrows_6"] = 9,
--         ["eyebrows_5"] = 0,
--         ["eyebrows_3"] = 10,
--         ["tshirt_2"] = 2,
--         ["torso_1"] = 399,
--         ["arms"] = 6,
--         ["tshirt_1"] = 22,
--         ["shoes_1"] = 77,
--         ["torso_2"] = 0,
--         ["pants_1"] = 44,
--         ["shoes_2"] = 0,
--         ["pants_2"] = 1,
--         ['beard_2'] = 0.0
--     }
--     TriggerEvent('skinchanger:changeskinfull', clothesSkin)
-- end

-- function soma()
--     clothesSkin = {
--         ["nose_5"] = 2,
--         ["face_md_weight"] = 45,
--         ["hair_color_1"] = 18,
--         ["sex"] = 0,
--         ["nose_1"] = 6,
--         ["nose_3"] = 5,
--         ["sun_2"] = 0.4,
--         ["age_2"] = 0.0,
--         ["beard_3"] = 4,
--         ["eye_squint"] = 4,
--         ["age_1"] = 3,
--         ["eye_color"] = 3,
--         ["hair_1"] = 57,
--         ["beard_2"] = 1.0,
--         ["cheeks_3"] = 4,
--         ["blemishes_1"] = 22,
--         ["complexion_2"] = 0.2,
--         ["blemishes_2"] = 1.0,
--         ["cheeks_2"] = 3,
--         ["nose_6"] = 3,
--         ["mom"] = 32,
--         ["nose_4"] = 3,
--         ["lip_thickness"] = 3,
--         ["nose_2"] = 6,
--         ["cheeks_1"] = 3,
--         ["beard_1"] = 10,
--         ["complexion_1"] = 0,
--         ["sun_1"] = 9,
--         ["tshirt_2"] = 0,
--         ["pants_1"] = 28,
--         ["arms"] = 83,
--         ["tshirt_1"] = 3,
--         ["shoes_1"] = 20,
--         ["torso_2"] = 5,
--         ["torso_1"] = 35,
--         ["shoes_2"] = 0,
--         ["pants_2"] = 7
--     }
--     TriggerEvent('skinchanger:changeskinfull', clothesSkin)
--     SetPedDecoration(PlayerPedId(), "mpsmuggler_overlays", "MP_Smuggler_Tattoo_017_F")
--     SetPedDecoration(PlayerPedId(), "mpimportexport_overlays", "MP_MP_ImportExport_Tat_005_F")

-- end