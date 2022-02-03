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

local armoir_scarlet = false
RMenu.Add('armoir_scarlet', 'main', RageUI.CreateMenu("Armoire Scarlet", "Armoire MJ"))
RMenu:Get('armoir_scarlet', 'main').Closed = function()
    armoir_scarlet = false
end

function openScarlet()
    if not armoir_scarlet then
        armoir_scarlet = true
        RageUI.Visible(RMenu:Get('armoir_scarlet', 'main'), true)

        Citizen.CreateThread(function()
            while armoir_scarlet do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('armoir_scarlet', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Civil", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            vcivil()
                        end
                    end)
                    RageUI.ButtonWithStyle("Waren Scarlet", nil, {  -- 
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            waren()
                        end
                    end)

                    RageUI.ButtonWithStyle("Nila Lawson", nil, { -- Kyra
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            kyra()
                        end
                    end)

                    RageUI.ButtonWithStyle("David Scarlet", nil, { -- Soma
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            soma()
                        end
                    end)

                    -- RageUI.ButtonWithStyle("Andrew Scarlet", nil, { 
                    --     RightLabel = "→→"
                    -- }, true, function(Hovered, Active, Selected)
                    --     if (Selected) then
                    --         kedri()
                    --     end
                    -- end)

                    -- RageUI.ButtonWithStyle("Eden Scarlet", nil, { 
                    --     RightLabel = "→→"
                    -- }, true, function(Hovered, Active, Selected)
                    --     if (Selected) then
                    --         katsu()
                    --     end
                    -- end)

                    RageUI.ButtonWithStyle("Winter hope", nil, { 
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            toxic()
                        end
                    end)

                    RageUI.ButtonWithStyle("Butch Scarlet", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            jordaks()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jason Gontran", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            tilania()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jimmy Borovitch", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            kelbouz()
                        end
                    end)

                    RageUI.ButtonWithStyle("James Scarlett", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            sylmeaa()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jimmy Borov", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            kelbouzBorov()
                        end
                    end)

                    RageUI.ButtonWithStyle("Jason Viv", nil, {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            tilaniaGontran()
                        end
                    end)

                end, function()
                end)

            end
        end)
    end
end

local posAdmin = {
    x = -1502.41,
    y = 119.32,
    z = 55.67
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
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Armoire Scarlet")
                    if IsControlJustReleased(0, Keys["E"]) then
                        openScarlet()
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
        end)
    end)
end

function waren()
    clothesSkin = {
        ["blemishes_2"] = 0.0,
        ["beard_2"] = 1.0,
        ["lipstick_3"] = 4,
        ["eyebrows_6"] = 3,
        ["nose_1"] = 4,
        ["nose_3"] = 8,
        ["mom"] = 4,
        ["nose_2"] = 7,
        ["beard_3"] = 4,
        ["eye_squint"] = 4,
        ["jaw_1"] = 0,
        ["eye_color"] = 3,
        ["hair_1"] = 43,
        ["lipstick_1"] = 3,
        ["blemishes_1"] = 0,
        ["face_md_weight"] = 0,
        ["sex"] = 0,
        ["chin_1"] = 7,
        ["bodyb_1"] = 0,
        ["chin_2"] = 0,
        ["moles_1"] = 2,
        ["lip_thickness"] = 4,
        ["moles_2"] = 0.6,
        ["cheeks_3"] = 11,
        ["beard_1"] = 5,
        ["eyebrows_5"] = 8,
        ["hair_color_1"] = 6,
        ["tshirt_2"] = 9,
        ["pants_1"] = 25,
        ["arms"] = 14,
        ["tshirt_1"] = 30,
        ["shoes_1"] = 10,
        ["torso_2"] = 3,
        ["torso_1"] = 24,
        ["shoes_2"] = 7,
        ["pants_2"] = 5,
        ["glasse_1"] = -1,
        ["glasses_1"] = 2,
        ["glasses_2"] = 0
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function kyra()
    clothesSkin = {
        ["dad"] = 0,
        ["skin_md_weight"] = 0,
        ["nose_3"] = 0,
        ["face_md_weight"] = 1,
        ["hair_color_1"] = 37,
        ["sex"] = 1,
        ["nose_1"] = 0,
        ["eyebrows_1"] = 8,
        ["mom"] = 2,
        ["nose_2"] = 3,
        ["eye_squint"] = 0,
        ["eye_color"] = 2,
        ["hair_1"] = 37,
        ["lipstick_1"] = 0,
        ["lipstick_2"] = 1.0,
        ["makeup_1"] = 35,
        ["lip_thickness"] = 0,
        ["nose_6"] = 0,
        ["makeup_2"] = 1.0,
        ["eyebrows_6"] = 9,
        ["eyebrows_5"] = 0,
        ["eyebrows_3"] = 10,
        ["tshirt_2"] = 2,
        ["torso_1"] = 399,
        ["arms"] = 6,
        ["tshirt_1"] = 22,
        ["shoes_1"] = 77,
        ["torso_2"] = 0,
        ["pants_1"] = 44,
        ["shoes_2"] = 0,
        ["pants_2"] = 1,
        ['beard_2'] = 0.0
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function soma()
    clothesSkin = {
        ["nose_5"] = 2,
        ["face_md_weight"] = 45,
        ["hair_color_1"] = 18,
        ["sex"] = 0,
        ["nose_1"] = 6,
        ["nose_3"] = 5,
        ["sun_2"] = 0.4,
        ["age_2"] = 0.0,
        ["beard_3"] = 4,
        ["eye_squint"] = 4,
        ["age_1"] = 3,
        ["eye_color"] = 3,
        ["hair_1"] = 57,
        ["beard_2"] = 1.0,
        ["cheeks_3"] = 4,
        ["blemishes_1"] = 22,
        ["complexion_2"] = 0.2,
        ["blemishes_2"] = 1.0,
        ["cheeks_2"] = 3,
        ["nose_6"] = 3,
        ["mom"] = 32,
        ["nose_4"] = 3,
        ["lip_thickness"] = 3,
        ["nose_2"] = 6,
        ["cheeks_1"] = 3,
        ["beard_1"] = 10,
        ["complexion_1"] = 0,
        ["sun_1"] = 9,
        ["tshirt_2"] = 0,
        ["pants_1"] = 28,
        ["arms"] = 83,
        ["tshirt_1"] = 3,
        ["shoes_1"] = 20,
        ["torso_2"] = 5,
        ["torso_1"] = 35,
        ["shoes_2"] = 0,
        ["pants_2"] = 7
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
    SetPedDecoration(PlayerPedId(), "mpsmuggler_overlays", "MP_Smuggler_Tattoo_017_F")
    SetPedDecoration(PlayerPedId(), "mpimportexport_overlays", "MP_MP_ImportExport_Tat_005_F")

end

function kedri()
    clothesSkin = {
        ["eyebrows_5"] = 4,
        ["face_md_weight"] = 45,
        ["beard_2"] = 1.0,
        ["hair_color_1"] = 10,
        ["eyebrows_3"] = 8,
        ["mom"] = 10,
        ["beard_1"] = 23,
        ["complexion_1"] = 5,
        ["complexion_2"] = 1.0,
        ["blemishes_1"] = 12,
        ["hair_1"] = 11,
        ["eyebrows_6"] = 0,
        ["bodyb_1"] = 6,
        ["eyebrows_1"] = 12,
        ["beard_3"] = 9,
        ["eyebrows_2"] = 1.0,
        ["sun_1"] = 6,
        ["sex"] = 0,
        ["eye_color"] = 20,
        ["age_2"] = 0.3,
        ["shoes_2"] = 8,
        ["pants_1"] = 0,
        ["arms"] = 14,
        ["pants_2"] = 15,
        ["tshirt_1"] = 26,
        ["torso_2"] = 5,
        ["torso_1"] = 35,
        ["shoes_1"] = 40,
        ["tshirt_2"] = 3,
        ["ears_2"] = 0,
        ["chain_1"] = 20,
        ["glasses_2"] = 0,
        ["ears_1"] = 25,
        ["chain_2"] = 0,
        ["glasse_1"] = -1,
        ["glasses_1"] = 5
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
    SetPedDecoration(PlayerPedId(), "mpstunt_overlays", "MP_MP_Stunt_tat_004_F")
    SetPedDecoration(PlayerPedId(), "multiplayer_overlays", "FM_Tat_F_001")

end

function katsu()
    clothesSkin = {
        ["jaw_1"] = 4,
        ["eyebrows_5"] = 1,
        ["sex"] = 0,
        ["face_md_weight"] = 44,
        ["beard_2"] = 0.9,
        ["eyebrows_1"] = 23,
        ["eye_squint"] = 4,
        ["hair_color_1"] = 20,
        ["eyebrows_2"] = 1.0,
        ["eye_color"] = 2,
        ["hair_1"] = 19,
        ["beard_1"] = 10,
        ["arms"] = 180,
        ["pants_1"] = 126,
        ["torso_1"] = 381,
        ["pants_2"] = 0,
        ["shoes_1"] = 15,
        ["tshirt_1"] = 106,
        ["tshirt_2"] = 0,
        ["shoes_2"] = 0,
        ["torso_2"] = 7,
        ["glasses_1"] = 7,
        ["glasse_1"] = -1,
        ["glasses_2"] = 0
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function toxic()
    clothesSkin = {
        ["eyebrows_2"] = 1.0,
        ["jaw_2"] = 3,
        ["face_md_weight"] = 19,
        ["cheeks_2"] = 2,
        ["blush_2"] = 1.0,
        ["mom"] = 31,
        ["eye_color"] = 8,
        ["hair_1"] = 33,
        ["lipstick_1"] = 1,
        ["lipstick_2"] = 1.0,
        ["lip_thickness"] = 2,
        ["makeup_3"] = 19,
        ["makeup_2"] = 1.0,
        ["moles_2"] = 0.5,
        ["eyebrows_3"] = 3,
        ["lipstick_3"] = 54,
        ["eyebrows_1"] = 12,
        ["eye_squint"] = 11,
        ["hair_color_1"] = 29,
        ["sex"] = 1,
        ["makeup_1"] = 11,
        ["chin_2"] = 3,
        ["eyebrows_6"] = 8,
        ["cheeks_1"] = 2,
        ["blush_3"] = 12,
        ["eyebrows_5"] = 9,
        ["tshirt_2"] = 0,
        ["pants_1"] = 75,
        ["arms"] = 26,
        ["tshirt_1"] = 145,
        ["shoes_1"] = 31,
        ["torso_2"] = 10,
        ["torso_1"] = 194,
        ["shoes_2"] = 0,
        ["pants_2"] = 0,
        ["ears_2"] = 0,
        ["glasse_1"] = -1,
        ["chain_1"] = 7,
        ["glasses_1"] = 20,
        ["glasses_2"] = 0,
        ["chain_2"] = 0,
        ["ears_1"] = 7
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function jordaks()
    clothesSkin = {
        ["makeup_4"] = 0,
        ["blush_1"] = 0,
        ["chin_2"] = 0,
        ["eyebrows_4"] = 0,
        ["jaw_1"] = 0,
        ["eye_color"] = 2,
        ["eye_squint"] = 2,
        ["beard_1"] = 6,
        ["makeup_1"] = 0,
        ["cheeks_1"] = 0,
        ["moles_1"] = 0,
        ["chest_3"] = 0,
        ["nose_3"] = 0,
        ["mom"] = 10,
        ["lipstick_4"] = 0,
        ["eyebrows_2"] = 0.0,
        ["beard_2"] = 0.95,
        ["chin_4"] = 0,
        ["hair_2"] = 0,
        ["makeup_3"] = 0,
        ["beard_4"] = 20,
        ["blush_2"] = 0.0,
        ["chin_1"] = 0,
        ["nose_2"] = 0,
        ["eyebrows_3"] = 0,
        ["moles_2"] = 0.0,
        ["nose_4"] = 0,
        ["hair_color_1"] = 19,
        ["chin_3"] = 0,
        ["lipstick_2"] = 0.8,
        ["complexion_1"] = 0,
        ["complexion_2"] = 0.0,
        ["beard_3"] = 20,
        ["bodyb_3"] = 0,
        ["eyebrows_1"] = 0,
        ["face_md_weight"] = 0,
        ["cheeks_3"] = 0,
        ["hair_1"] = 15,
        ["sun_1"] = 0,
        ["bodyb_2"] = 0.0,
        ["neck_thickness"] = 7,
        ["makeup_2"] = 0.0,
        ["eyebrows_5"] = 4,
        ["sun_2"] = 0.0,
        ["lipstick_1"] = 8,
        ["chest_2"] = 0.0,
        ["sex"] = 0,
        ["blemishes_1"] = 0,
        ["hair_color_2"] = 19,
        ["blemishes_3"] = 0,
        ["dad"] = 0,
        ["nose_6"] = 0,
        ["age_2"] = 1.0,
        ["chest_1"] = 0,
        ["age_1"] = 1,
        ["bodyb_1"] = 0,
        ["jaw_2"] = 4,
        ["lipstick_3"] = 20,
        ["lip_thickness"] = 0,
        ["cheeks_2"] = 0,
        ["nose_5"] = 0,
        ["nose_1"] = 0,
        ["eyebrows_6"] = 4,
        ["skin_md_weight"] = 0,
        ["blemishes_2"] = 0.0,
        ["blush_3"] = 0,
        ["shoes_2"] = 4,
        ["tshirt_2"] = 2,
        ["decals_2"] = -1,
        ["decals_1"] = -1,
        ["pants_1"] = 71,
        ["tshirt_1"] = 4,
        ["torso_2"] = 7,
        ["shoes_1"] = 38,
        ["torso_1"] = 381,
        ["pants_2"] = 4,
        ["arms"] = 14,
        ["mask_1"] = -1,
        ["chain_2"] = 0,
        ["watches_2"] = 0,
        ["helmet_2"] = 0,
        ["helmet_1"] = 30,
        ["ears_2"] = -1,
        ["watches_1"] = 28,
        ["glasses_2"] = -1,
        ["mask_2"] = -1,
        ["chain_1"] = 20,
        ["bracelets_2"] = -1,
        ["bracelets_1"] = -1,
        ["glasses_1"] = -1,
        ["ears_1"] = -1
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
    SetPedDecoration(PlayerPedId(), "mpbusiness_overlays", "MP_Buis_F_Neck_001")
    SetPedDecoration(PlayerPedId(), "mpchristmas2_overlays", "MP_Xmas2_F_Tat_019")
    SetPedDecoration(PlayerPedId(), "mpsmuggler_overlays", "MP_Smuggler_Tattoo_002_F")
    SetPedDecoration(PlayerPedId(), "mplowrider2_overlays", "MP_LR_Tat_032_F")
    SetPedDecoration(PlayerPedId(), "mpchristmas2017_overlays", "MP_Christmas2017_Tattoo_017_F")
    SetPedDecoration(PlayerPedId(), "mpbiker_overlays", "MP_MP_Biker_Tat_020_F")
    SetPedDecoration(PlayerPedId(), "mphipster_overlays", "FM_Hip_F_Tat_028")
    SetPedDecoration(PlayerPedId(), "mpbiker_overlays", "MP_MP_Biker_Tat_036_F")
end

function tilania()
    clothesSkin = {
        ["makeup_3"]=0,
        ["moles_2"]=0.0,
        ["lipstick_2"]=0.0,
        ["jaw_1"]=0,
        ["bodyb_4"]=1.0,
        ["chest_2"]=1.0,
        ["nose_6"]=0,
        ["chin_3"]=0,
        ["makeup_1"]=0,
        ["beard_1"]=0,
        ["age_2"]=0.0,
        ["mom"]=30,
        ["makeup_2"]=0.0,
        ["moles_1"]=0,
        ["face_md_weight"]=5,
        ["chin_4"]=0,
        ["blemishes_2"]=0.0,
        ["eyebrows_5"]=0,
        ["cheeks_2"]=0,
        ["lipstick_3"]=0,
        ["beard_2"]=0.0,
        ["hair_1"]=2,
        ["eyebrows_2"]=1.0,
        ["blemishes_1"]=0,
        ["chin_2"]=0,
        ["jaw_2"]=0,
        ["eye_color"]=2,
        ["nose_5"]=0,
        ["cheeks_3"]=0,
        ["lipstick_1"]=0,
        ["bodyb_2"]=1.0,
        ["beard_3"]=0,
        ["nose_2"]=0,
        ["eye_squint"]=0,
        ["skin"]=12,
        ["lip_thickness"]=0,
        ["neck_thickness"]=0,
        ["eyebrows_6"]=0,
        ["nose_1"]=0,
        ["hair_color_1"]=0,
        ["dad"]=4,
        ["cheeks_1"]=0,
        ["sex"]=0,
        ["age_1"]=0,
        ["complexion_1"]=0,
        ["nose_4"]=0,
        ["eyebrows_1"]=9,
        ["chin_1"]=0,
        ["nose_3"]=0,
        ["decals_1"]=-1,
        ["torso_2"]=7,
        ["pants_1"]=4,
        ["arms"]=28,
        ["decals_2"]=-1,
        ["shoes_1"]=57,
        ["tshirt_2"]=0,
        ["pants_2"]=2,
        ["tshirt_1"]=3,
        ["torso_1"]=381,
        ["shoes_2"]=10
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function kelbouz() 
    clothesSkin = {
        ["moles_2"]=0.0,
        ["neck_thickness"]=0,
        ["face_md_weight"]=0,
        ["bodyb_4"]=1.0,
        ["nose_3"]=0,
        ["nose_5"]=0,
        ["beard_3"]=2,
        ["lipstick_3"]=0,
        ["jaw_1"]=0,
        ["lipstick_2"]=0.0,
        ["age_2"]=1.1,
        ["eyebrows_2"]=1.0,
        ["eyebrows_5"]=19,
        ["bodyb_2"]=1.0,
        ["lip_thickness"]=0,
        ["blemishes_1"]=20,
        ["nose_1"]=0,
        ["nose_4"]=19,
        ["chin_1"]=0,
        ["eyebrows_1"]=31,
        ["mom"]=45,
        ["eye_color"]=3,
        ["cheeks_2"]=13,
        ["complexion_1"]=0,
        ["jaw_2"]=0,
        ["moles_1"]=0,
        ["skin"]=25,
        ["makeup_3"]=0,
        ["dad"]=19,
        ["nose_6"]=0,
        ["hair_1"]=42,
        ["age_1"]=11,
        ["sex"]=0,
        ["chin_3"]=0,
        ["chin_2"]=0,
        ["chin_4"]=0,
        ["beard_1"]=27,
        ["cheeks_1"]=0,
        ["lipstick_1"]=0,
        ["makeup_2"]=1.0,
        ["hair_color_1"]=2,
        ["blemishes_2"]=1.0,
        ["eyebrows_6"]=9,
        ["eye_squint"]=0,
        ["makeup_1"]=11,
        ["beard_2"]=1.0,
        ["nose_2"]=0,
        ["chest_2"]=1.0,
        ["cheeks_3"]=0,

        ["pants_1"]=83,
        ["torso_1"]=381,
        ["decals_1"]=-1,
        ["arms"]=14,
        ["tshirt_1"]=15,
        ["shoes_2"]=0,
        ["pants_2"]=0,
        ["torso_2"]=7,
        ["decals_2"]=-1,
        ["shoes_1"]=37
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function sylmeaa()
    clothesSkin = {
        ["eyebrows_1"]=5,["lipstick_3"]=0,["eye_color"]=3,["cheeks_3"]=0,["eyebrows_6"]=0,["hair_1"]=6,["nose_5"]=0,["chest_2"]=1.0,["neck_thickness"]=0,["age_1"]=0,["makeup_1"]=0,["eye_squint"]=0,["beard_1"]=13,["bodyb_4"]=1.0,["nose_4"]=0,["lipstick_1"]=0,["chin_4"]=0,["skin"]=25,["lip_thickness"]=0,["blemishes_2"]=0.0,["sex"]=0,["nose_2"]=0,["blemishes_1"]=0,["jaw_1"]=0,["complexion_1"]=0,["beard_3"]=2,["eyebrows_5"]=0,["mom"]=26,["lipstick_2"]=0.0,["nose_3"]=0,["nose_6"]=0,["chin_3"]=0,["chin_2"]=0,["dad"]=43,["hair_color_1"]=53,["age_2"]=0.0,["cheeks_1"]=0,["nose_1"]=0,["beard_2"]=0.2,["face_md_weight"]=5,["makeup_2"]=0.0,["chin_1"]=0,["cheeks_2"]=0,["bodyb_2"]=1.0,["eyebrows_2"]=0.8,["moles_1"]=0,["moles_2"]=0.0,["makeup_3"]=0,["jaw_2"]=0,

        ["tshirt_1"]=27,["pants_1"]=10,["torso_2"]=5,["arms"]=50,["shoes_2"]=0,["tshirt_2"]=5,["decals_2"]=-1,["shoes_1"]=10,["decals_1"]=-1,["pants_2"]=0,["torso_1"]=35
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function tilaniaGontran() 
    clothesSkin = {
        ["makeup_3"]=0,
        ["moles_2"]=0.0,
        ["lipstick_2"]=0.0,
        ["jaw_1"]=0,
        ["bodyb_4"]=1.0,
        ["chest_2"]=1.0,
        ["nose_6"]=0,
        ["chin_3"]=0,
        ["makeup_1"]=0,
        ["beard_1"]=0,
        ["age_2"]=0.0,
        ["mom"]=30,
        ["makeup_2"]=0.0,
        ["moles_1"]=0,
        ["face_md_weight"]=5,
        ["chin_4"]=0,
        ["blemishes_2"]=0.0,
        ["eyebrows_5"]=0,
        ["cheeks_2"]=0,
        ["lipstick_3"]=0,
        ["beard_2"]=0.0,
        ["hair_1"]=2,
        ["eyebrows_2"]=1.0,
        ["blemishes_1"]=0,
        ["chin_2"]=0,
        ["jaw_2"]=0,
        ["eye_color"]=2,
        ["nose_5"]=0,
        ["cheeks_3"]=0,
        ["lipstick_1"]=0,
        ["bodyb_2"]=1.0,
        ["beard_3"]=0,
        ["nose_2"]=0,
        ["eye_squint"]=0,
        ["skin"]=12,
        ["lip_thickness"]=0,
        ["neck_thickness"]=0,
        ["eyebrows_6"]=0,
        ["nose_1"]=0,
        ["hair_color_1"]=0,
        ["dad"]=4,
        ["cheeks_1"]=0,
        ["sex"]=0,
        ["age_1"]=0,
        ["complexion_1"]=0,
        ["nose_4"]=0,
        ["eyebrows_1"]=9,
        ["chin_1"]=0,
        ["nose_3"]=0,

        ["tshirt_1"]=1,
        ["pants_1"]=4,
        ["torso_2"]=4,
        ["arms"]=14,
        ["shoes_2"]=9,
        ["tshirt_2"]=4,
        ["decals_2"]=-1,
        ["shoes_1"]=57,
        ["torso_1"]=230,
        ["pants_2"]=0,
        ["decals_1"]=-1
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end

function kelbouzBorov() 
    clothesSkin = {
        ["eyebrows_1"]=30,["lipstick_3"]=0,["eye_color"]=3,["hair_color_2"]=28,["sex"]=0,["hair_1"]=21,["nose_5"]=0,["chest_2"]=1.0,["neck_thickness"]=0,["age_1"]=0,["makeup_1"]=0,["eye_squint"]=0,["beard_1"]=14,["bodyb_4"]=1.0,["nose_4"]=0,["lipstick_1"]=0,["moles_2"]=0.0,["skin"]=12,["lip_thickness"]=16,["age_2"]=0.0,["blemishes_2"]=0.0,["bodyb_2"]=1.0,["complexion_2"]=1.0,["nose_2"]=0,["blemishes_1"]=0,["chin_3"]=0,["complexion_1"]=5,["chin_4"]=0,["beard_3"]=0,["mom"]=41,["lipstick_2"]=0.0,["chin_1"]=0,["jaw_2"]=8,["beard_2"]=1.0,["eyebrows_6"]=9,["dad"]=10,["cheeks_3"]=0,["nose_3"]=11,["cheeks_1"]=6,["jaw_1"]=8,["nose_6"]=0,["face_md_weight"]=2,["makeup_2"]=0.0,["eyebrows_5"]=15,["cheeks_2"]=0,["nose_1"]=15,["eyebrows_2"]=1.0,["moles_1"]=0,["makeup_3"]=0,["chin_2"]=0,["hair_color_1"]=27,

        

        ["tshirt_1"]=1,
        ["pants_1"]=4,
        ["torso_2"]=4,
        ["arms"]=14,
        ["shoes_2"]=9,
        ["tshirt_2"]=4,
        ["decals_2"]=-1,
        ["shoes_1"]=57,
        ["torso_1"]=230,
        ["pants_2"]=0,
        ["decals_1"]=-1
    }
    TriggerEvent('skinchanger:changeskinfull', clothesSkin)
end