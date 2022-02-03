ESX = nil
local usePlonger = false
local playerVehicles = {}
local hud = false
local visible = false
local weapon
local mask
local glasses
local helmet
local chain
local ears
local watche
local bracelets
local sex
local torso
local pants
local shoes
local bag
local bproof
local casque
local PersonalMenu = {
    ItemSelected = {},
    ItemIndex = {},
    PapierListIdentity = {"Montrer", "Voir"},
    PapierIndex = 1,
    PapierListPermis = {"Montrer", "Voir"},
    PapierListDiplomes = {"Montrer", "Voir"},
    PermisIndex = 1,
    DiplomeIndex = 1,
    BillData = {},
    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },
    DoorIndex = 1,
    DoorList = {_U('vehicle_door_frontleft'), _U('vehicle_door_frontright'), _U('vehicle_door_backleft'),
                _U('vehicle_door_backright')},
    VoiceIndex = 2,
    VoiceList = {}
}

local accesorie

Player = {
    isDead = false,
    inAnim = false,
    crouched = false,
    handsup = false,
    pointing = false,
    noclip = false,
    godmode = false,
    ghostmode = false,
    showCoords = false,
    showName = false,
    gamerTags = {},
    group = 'user'
}

local holdingCam = false

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

    if Config.DoubleJob then
        while ESX.GetPlayerData().job2 == nil do
            Citizen.Wait(10)
        end
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while actualSkin == nil do
        TriggerEvent('skinchanger:getSkin', function(skin)
            actualSkin = skin
        end)

        Citizen.Wait(10)
    end

    for i = 1, #Config.Voice.items, 1 do
        table.insert(PersonalMenu.VoiceList, Config.Voice.items[i].label)
    end

    RMenu.Add('rageui', 'personal', RageUI.CreateMenu(Config.MenuTitle, _U('mainmenu_subtitle'), 0, 0, 'commonmenu',
        'interaction_bgd', 255, 255, 255, 255))
    RMenu.Get('rageui', 'personal').Closed = function()
        visible = false
    end
    RMenu.Add('personal', 'papier', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Papiers"))
    RMenu.Add('personal', 'clothes', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('clothes_title')))
    RMenu.Add('personal', 'arme', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Donner une arme"))
    RMenu.Add('personal', 'clef', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Gestion des clefs"))
    -- RMenu.Add('personal', 'vehicle', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('vehicle_title')),
    --   function()
    --     local plyPed = PlayerPedId()
    --      if IsPedSittingInAnyVehicle(plyPed) then
    --          if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
    --              return true
    --          end
    --      end

    --      return false
    --  end)
    RMenu.Add('personal', 'save', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), "Autre"))

end)

if Config.Voice.activated then
    Citizen.CreateThread(function()
        local voiceFixing = true
        NetworkSetTalkerProximity(0.1)

        SetTimeout(10000, function()
            voiceFixing = nil
        end)

        while voiceFixing do
            NetworkSetTalkerProximity(Config.Voice.defaultLevel)
            Citizen.Wait(10)
        end
    end)
end

AddEventHandler('esx:onPlayerDeath', function()
    Player.isDead = true
    visible = false
    RageUI.CloseAll()
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    Player.isDead = false
end)

AddEventHandler('playerSpawned', function()
    Player.isDead = false
end)

RegisterNetEvent("trunkOwnedVehicule")
AddEventHandler("trunkOwnedVehicule", function()
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
end)


-- Message text joueur
function Text(text)
    SetTextColour(186, 186, 186, 255)
    SetTextFont(0)
    SetTextScale(0.378, 0.378)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
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

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0),
        math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end

function startAttitude(lib, anim)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimSet(anim, function()
        SetPedMotionBlur(plyPed, false)
        SetPedMovementClipset(plyPed, anim, true)
        RemoveAnimSet(anim)
    end)
end

function startAnim(lib, anim)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        RemoveAnimDict(lib)
    end)
end

function startAnimAction(lib, anim)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
        RemoveAnimDict(lib)
    end)
end

function startAnimActions(lib, anim)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, 22533, 0, 0, false, false, false)
        RemoveAnimDict(lib)
    end)
end

function setTorso()
    local plyPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        TriggerEvent('skinchanger:getSkin', function(skina)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0,
                    22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            Player.handsup, Player.pointing = false, false
            ClearPedTasks(plyPed)

            if clothe.torso_1 ~= skina.torso_1 then
                TriggerEvent('skinchanger:loadClothes', skina, {
                    ['torso_1'] = clothe.torso_1,
                    ['torso_2'] = clothe.torso_2,
                    ['tshirt_1'] = clothe.tshirt_1,
                    ['tshirt_2'] = clothe.tshirt_2,
                    ['arms'] = clothe.arms
                })
            else
                TriggerEvent('skinchanger:loadClothes', skina, {
                    ['torso_1'] = 15,
                    ['torso_2'] = 0,
                    ['tshirt_1'] = 15,
                    ['tshirt_2'] = 0,
                    ['arms'] = 15
                })
            end
        end)
    end)
end

function setShoes()
    local plyPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        TriggerEvent('skinchanger:getSkin', function(skina)
            if clothe.shoes_1 ~= skina.shoes_1 then
                TriggerEvent('skinchanger:loadClothes', skina, {
                    ['shoes_1'] = clothe.shoes_1,
                    ['shoes_2'] = clothe.shoes_2
                })
            else
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skina, {
                        ['shoes_1'] = 34,
                        ['shoes_2'] = 0
                    })
                else
                    TriggerEvent('skinchanger:loadClothes', skina, {
                        ['shoes_1'] = 35,
                        ['shoes_2'] = 0
                    })
                end
            end
        end)
    end)
end

function setPants()
    local plyPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        TriggerEvent('skinchanger:getSkin', function(skina)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533,
                    0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            ClearPedTasks(plyPed)
            if clothe.pants_1 ~= skina.pants_1 then
                TriggerEvent('skinchanger:loadClothes', skina, {
                    ['pants_1'] = clothe.pants_1,
                    ['pants_2'] = clothe.pants_2
                })
            else
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skina, {
                        ['pants_1'] = 61,
                        ['pants_2'] = 1
                    })
                else
                    TriggerEvent('skinchanger:loadClothes', skina, {
                        ['pants_1'] = 15,
                        ['pants_2'] = 0
                    })
                end
            end
        end)
    end)
end

function setBag()
    local plyPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        TriggerEvent('skinchanger:getSkin', function(skina)
            if clothe.bags_1 ~= skina.bags_1 then
                ESX.TriggerServerCallback('weight', function(sac)
                    if sac then
                        TriggerEvent('skinchanger:loadClothes', skina, {
                            ['bags_1'] = clothe.bags_1,
                            ['bags_2'] = clothe.bags_2
                        })
                        TriggerServerEvent('weightextended', Config.WeightWithBag)
                    else
                        ESX.ShowNotification('Vous êtes trop lourd')
                    end
                end, 70)
            else
                ESX.TriggerServerCallback('weight', function(sac)
                    if sac then
                        TriggerEvent('skinchanger:loadClothes', skina, {
                            ['bags_1'] = 0,
                            ['bags_2'] = 0
                        })
                        TriggerServerEvent('weightextended', Config.Weight)
                    else
                        ESX.ShowNotification('Vous ne pouvez pas retirer le sac car vous êtes trop lourd')
                    end
                end, 40)
            end
        end)
    end)
end

function setBproof()
    local plyPed = PlayerPedId()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        TriggerEvent('skinchanger:getSkin', function(skina)
            startAnimAction('clothingtie', 'try_tie_neutral_a')
            Citizen.Wait(1000)
            Player.handsup, Player.pointing = false, false
            ClearPedTasks(plyPed)

            if clothe.bproof_1 ~= skina.bproof_1 then
            else
                TriggerEvent('skinchanger:loadClothes', skina, {
                    ['bproof_1'] = 0,
                    ['bproof_2'] = 0
                })
                SetPedArmour(plyPed, 0)
            end
        end)
    end)
end

function setMask()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkinAcessesoire', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("missfbi4", function()
                    TaskPlayAnim(plyPed, "missfbi4", "takeoff_mask", 8.0, 1.0, -1, 49, 0, false, false, false)
                    RemoveAnimDict("missfbi4")
                end)
                Citizen.Wait(850)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.mask_1 ~= skina.mask_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['mask_1'] = accesorie.mask_1,
                        ['mask_2'] = accesorie.mask_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['mask_1'] = -1,
                        ['mask_2'] = 0
                    })
                end
            end)
        end)
    end)
end

function setCasque()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkinAcessesoire', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie, casquee)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("missfbi4", function()
                    TaskPlayAnim(plyPed, "missfbi4", "takeoff_mask", 8.0, 1.0, -1, 49, 0, false, false, false)
                    RemoveAnimDict("missfbi4")
                end)
                Citizen.Wait(850)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if casquee.helmet_1 ~= skina.helmet_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['helmet_1'] = casquee.helmet_1,
                        ['helmet_2'] = casquee.helmet_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['helmet_1'] = -1,
                        ['helmet_2'] = 0
                    })
                end
            end)
        end)
    end)
end

function setGlasses()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("clothingspecs", function()
                    TaskPlayAnim(plyPed, "clothingspecs", "try_glasses_positive_a", 8.0, 1.0, -1, 49, 0, false, false,
                        false)
                    RemoveAnimDict("clothingspecs")
                end)
                Citizen.Wait(1000)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.glasses_1 ~= skina.glasses_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['glasses_1'] = accesorie.glasses_1,
                        ['glasses_2'] = accesorie.glasses_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['glasses_1'] = -1,
                        ['glasses_2'] = 0
                    })
                end
            end)
        end)
    end)
end

function setHelmet()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("missfbi4", function()
                    TaskPlayAnim(plyPed, "missfbi4", "takeoff_mask", 8.0, 1.0, -1, 49, 0, false, false, false)
                    RemoveAnimDict("missfbi4")
                end)
                Citizen.Wait(1000)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.helmet_1 ~= skina.helmet_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['helmet_1'] = accesorie.helmet_1,
                        ['helmet_2'] = accesorie.helmet_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['helmet_1'] = -1,
                        ['helmet_2'] = 0
                    })
                end
            end)
        end)
    end)
end

function setEars()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("mini@ears_defenders", function()
                    TaskPlayAnim(plyPed, "mini@ears_defenders", "takeoff_earsdefenders_idle", 8.0, 1.0, -1, 49, 0,
                        false, false, false)
                    RemoveAnimDict("mini@ears_defenders")
                end)
                Citizen.Wait(250)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.ears_1 ~= skina.ears_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['ears_1'] = accesorie.ears_1,
                        ['ears_2'] = accesorie.ears_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['ears_1'] = -1,
                        ['ears_2'] = 0
                    })
                end
            end)
        end)
    end)
end

function setWatche()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("mini@ears_defenders", function()
                    TaskPlayAnim(plyPed, "mini@ears_defenders", "takeoff_earsdefenders_idle", 8.0, 1.0, -1, 49, 0,
                        false, false, false)
                    RemoveAnimDict("mini@ears_defenders")
                end)
                Citizen.Wait(250)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.watches_1 ~= skina.watches_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['watches_1'] = accesorie.watches_1,
                        ['watches_2'] = accesorie.watches_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['watches_1'] = -1,
                        ['watches_2'] = 0
                    })
                end

            end)
        end)
    end)
end

function setChain()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("mini@ears_defenders", function()
                    TaskPlayAnim(plyPed, "mini@ears_defenders", "takeoff_earsdefenders_idle", 8.0, 1.0, -1, 49, 0,
                        false, false, false)
                    RemoveAnimDict("mini@ears_defenders")
                end)
                Citizen.Wait(250)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.chain_1 ~= skina.chain_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['chain_1'] = accesorie.chain_1,
                        ['chain_2'] = accesorie.chain_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['chain_1'] = -1,
                        ['chain_2'] = 0
                    })
                end

            end)
        end)
    end)
end

function setBracelets()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesorie)
            TriggerEvent('skinchanger:getSkin', function(skina)
                local plyPed = PlayerPedId()
                ESX.Streaming.RequestAnimDict("mini@ears_defenders", function()
                    TaskPlayAnim(plyPed, "mini@ears_defenders", "takeoff_earsdefenders_idle", 8.0, 1.0, -1, 49, 0,
                        false, false, false)
                    RemoveAnimDict("mini@ears_defenders")
                end)
                Citizen.Wait(250)
                Player.handsup, Player.pointing = false, false
                ClearPedTasks(plyPed)
                if accesorie.bracelets_1 ~= skina.bracelets_1 then
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['bracelets_1'] = accesorie.bracelets_1,
                        ['bracelets_2'] = accesorie.bracelets_2
                    })
                else
                    TriggerEvent('skinchanger:loadClothesAccesorie', skina, nil, {
                        ['bracelets_1'] = -1,
                        ['bracelets_2'] = 0
                    })
                end
            end)
        end)
    end)
end

RegisterNetEvent("clientMenuDisablePlonger")
AddEventHandler("clientMenuDisablePlonger", function()
    usePlonger = true
end)


function delplonger()
    local plyPed = PlayerPedId()
    local model = GetEntityModel(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        if model == GetHashKey("mp_m_freemode_01") then
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water',
                    8.0, 1.0, 22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['pants_1'] = clothe.pants_1,
                ['pants_2'] = clothe.pants_2,
                ['shoes_1'] = clothe.shoes_1,
                ['shoes_2'] = clothe.shoes_2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ClearPedTasks(plyPed)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                    8.0, 1.0, 22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            TriggerEvent('skinchanger:loadClothes', skin, clothe)
            TriggerEvent('skinchanger:change', 'mask_1', -1)
            TriggerEvent('skinchanger:change', 'decals_1', 0)
            TriggerEvent('skinchanger:change', 'glasses_1', -1)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', -1)
            SetPedArmour(plyPed, 0)
            ClearPedTasks(plyPed)

        else
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                    8.0, 1.0, 22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@female@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['pants_1'] = clothe.pants_1,
                ['pants_2'] = clothe.pants_2,
                ['shoes_1'] = clothe.shoes_1,
                ['shoes_2'] = clothe.shoes_2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ClearPedTasks(plyPed)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                    8.0, 1.0, 22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            TriggerEvent('skinchanger:loadClothes', skin, clothe)
            TriggerEvent('skinchanger:change', 'mask_1', -1)
            TriggerEvent('skinchanger:change', 'decals_1', 0)
            TriggerEvent('skinchanger:change', 'glasses_1', -1)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', -1)
            SetPedArmour(plyPed, 0)
            ClearPedTasks(plyPed)
        end
    end)
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

function RenderPersonalMenu()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        for i = 1, #RMenu['personal'], 1 do
            if type(RMenu['personal'][i].Restriction) == 'function' then
                if RMenu['personal'][i].Restriction() then
                    RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu['personal'][i].Menu)
                else
                    RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {
                        RightBadge = RageUI.BadgeStyle.Lock
                    }, false, function()
                    end, RMenu['personal'][i].Menu)
                end
            else
                RageUI.Button(RMenu['personal'][i].Menu.Title, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu['personal'][i].Menu)
            end
        end
    end)
end

function openPapier()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        RageUI.List("Carte d'identité", PersonalMenu.PapierListIdentity, PersonalMenu.PapierIndex, nil, {}, true,
            function(Hovered, Active, Selected, Index)
                if (Selected) then
                    ESX.TriggerServerCallback('esx_property:getUserProperty', function(property)
                        if Index == 1 then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()),
                                    GetPlayerServerId(closestPlayer), nil, property)
                                visible = false
                                RageUI.CloseAll()
                            else
                                ESX.ShowNotification(_U('players_nearby'))
                            end

                        elseif Index == 2 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()),
                                GetPlayerServerId(PlayerId()), nil, property)
                            visible = false
                            RageUI.CloseAll()
                        end
                    end)
                end
                PersonalMenu.PapierIndex = Index
            end)

        RageUI.List("Permis", PersonalMenu.PapierListPermis, PersonalMenu.PermisIndex, nil, {}, true,
            function(Hovered, Active, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()),
                                GetPlayerServerId(closestPlayer), 'driver')
                            visible = false
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification(_U('players_nearby'))
                        end
                    elseif Index == 2 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()),
                            GetPlayerServerId(PlayerId()), 'driver')
                        visible = false
                        RageUI.CloseAll()
                    end
                end
                PersonalMenu.PermisIndex = Index
            end)

        RageUI.List("Diplômes", PersonalMenu.PapierListDiplomes, PersonalMenu.DiplomeIndex, nil, {}, true,
            function(Hovered, Active, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('diploma:open', GetPlayerServerId(PlayerId()),
                                GetPlayerServerId(closestPlayer))
                            visible = false
                            RageUI.CloseAll()
                        else
                            ESX.ShowNotification(_U('players_nearby'))
                        end
                    elseif Index == 2 then
                        TriggerServerEvent('diploma:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                        visible = false
                        RageUI.CloseAll()
                    end
                end
                PersonalMenu.DiplomeIndex = Index
            end)

    end)
end

function RenderClothesMenu()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        for i = 1, #PersonalMenu.ClothesButtons, 1 do
            RageUI.Button(_U(('clothes_%s'):format(PersonalMenu.ClothesButtons[i])), nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local plyPed = PlayerPedId()
                    setUniform(PersonalMenu.ClothesButtons[i], plyPed)
                end
            end)
        end
    end)

end

function RenderAccessoriesMenu(mask, glasses, helmet, chain, ears, watche, bracelets, sex, torso, pants, shoes, bag,
    bproof, casque)
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        if not usePlonger then
        else
            RageUI.Button("Enlever tenue de plonger", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    delplonger()
                    usePlonger = false
                end
            end)
        end
        if mask == nil or mask == -1 then
        else
            RageUI.Button("Masque", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setMask()
                end
            end)
        end
        if sex == 0 then
            if glasses == nil or glasses == -1 then
            else
                RageUI.Button("Lunette", nil, {
                    RightBadge = RageUI.BadgeStyle.Clothes
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        setGlasses()
                    end
                end)
            end
        else
            if glasses == nil or glasses == -1 then
            else
                RageUI.Button("Lunette", nil, {
                    RightBadge = RageUI.BadgeStyle.Clothes
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        setGlasses()
                    end
                end)
            end
        end
        if helmet == nil or helmet == -1 then
        else
            RageUI.Button("Chapeau", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setHelmet()
                end
            end)
        end
        if casque == nil or casque == -1 then
        else
            RageUI.Button("Casque", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setCasque()
                end
            end)
        end
        if chain == nil or chain == -1 then
        else
            RageUI.Button("Collier", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setChain()
                end
            end)
        end
        if ears == nil or ears == -1 then
        else
            RageUI.Button("Boucle d'oreille", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setEars()
                end
            end)
        end
        if watche == nil or watche == -1 then
        else
            RageUI.Button("Montre", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setWatche()
                end
            end)
        end
        if bracelets == nil or bracelets == -1 then
        else
            RageUI.Button("Bracelets", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setBracelets()
                end
            end)
        end
        if torso == nil or torso == -1 then
        else
            RageUI.Button("Haut", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setTorso()
                end
            end)
        end
        if shoes == nil or shoes == -1 then
        else
            RageUI.Button("Chaussure", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setShoes()
                end
            end)
        end
        if pants == nil or pants == -1 then
        else
            RageUI.Button("Pantalon", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setPants()
                end
            end)
        end
        if bag == nil or bag == -1 then
        else
            RageUI.Button("Sac", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setBag()
                end
            end)
        end
        if bproof == nil or bproof == -1 then
        else
            RageUI.Button("Gilet par balle", nil, {
                RightBadge = RageUI.BadgeStyle.Clothes
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    setBproof()
                end
            end)
        end
    end)
end


function renderclef()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        print('ici')
        for k, v in ipairs(playerVehicles) do
            RageUI.Button(
                playerVehicles[k].model
                , nil, {
                RightLabel = playerVehicles[k].plate
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestDistance ~= -1 and closestDistance <= 3 then
                        local target_id = GetPlayerServerId(closestPlayer)
                        TriggerServerEvent("ddx_vehiclelock:duplicateKey", target_id, playerVehicles[k].plate,playerVehicles[k].model)
                        visible = false
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification(_U('players_nearby'))
                    end
                end
            end)
        end
    end)
end

function openSave()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        RageUI.Button("Afficher/cacher HUD", nil, {
            RightLabel = "→"
        }, true, function(Hovered, Active, Selected)
            if (Selected) then
                TriggerEvent("hudDisable")
                visible = false
                RageUI.CloseAll()
            end
        end)
        RageUI.Button("Mode film (bandes noires)", nil, {
            RightLabel = "→"
        }, true, function(Hovered, Active, Selected)
            if (Selected) then
                TriggerEvent("filmHudnoir")
                TriggerEvent("hudDisable")
                visible = false
                RageUI.CloseAll()
            end
        end)
        RageUI.Button("Save position", nil, {
            RightLabel = "→"
        }, true, function(Hovered, Active, Selected)
            if (Selected) then
                TriggerServerEvent("Monsieur:save")
                visible = false
                RageUI.CloseAll()
            end
        end)
    end)
end

function openArme()
    RageUI.DrawContent({
        header = true,
        instructionalButton = true
    }, function()
        ESX.PlayerData = ESX.GetPlayerData()
        local weapons = ESX.PlayerData.loadout
        for k, v in pairs(weapons) do
            RageUI.Button(v.label, nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestDistance ~= -1 and closestDistance <= 3 then
                        local target_id = GetPlayerServerId(closestPlayer)
                        local ammoCount = GetAmmoInPedWeapon(ESX.PlayerData.ped, v.name)
                        TriggerServerEvent("Monsieur:giveWeapon", target_id, v.name, ammoCount, v.label)
                    else
                        ESX.ShowNotification(_U('players_nearby'))
                    end
                end
            end)
        end
    end)
end

-- 'Ears', 'Glasses', 'Helmet', 'Mask',"Chain","Watche","Bracelets"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not visible then
            if IsControlJustReleased(0, Config.Controls.OpenMenu.keyboard) and not Player.isDead then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                        sex = nil
                        torso = nil
                        pants = nil
                        shoes = nil
                        bag = nil
                        bproof = nil
                        sex = skin['sex']
                        torso = clothe.torso_1
                        pants = clothe.pants_1
                        shoes = clothe.shoes_1
                        bag = clothe.bags_1
                        bproof = clothe.bproof_1
                    end)
                    ESX.TriggerServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(accesories, casquee)
                        mask = nil
                        glasses = nil
                        helmet = nil
                        chain = nil
                        ears = nil
                        watche = nil
                        bracelets = nil
                        casque = nil
                        mask = accesories.mask_1
                        glasses = accesories.glasses_1
                        helmet = accesories.helmet_1
                        chain = accesories.chain_1
                        ears = accesories.ears_1
                        watche = accesories.watches_1
                        bracelets = accesories.bracelets_1
                        casque = casquee.helmet_1
                        
                    end)
                    ESX.TriggerServerCallback('getPlayerVehiclesKeys', function(vehicles)
                        playerVehicles = {}
                        playerVehicles = vehicles
                    end)
                    RageUI.Visible(RMenu.Get('rageui', 'personal'), true)
                        visible = true
            end
        else
            if RageUI.Visible(RMenu.Get('rageui', 'personal')) then
                RenderPersonalMenu()
            end

            if RageUI.Visible(RMenu.Get('personal', 'clothes')) then
                RenderAccessoriesMenu(mask, glasses, helmet, chain, ears, watche, bracelets, sex, torso, pants, shoes,
                    bag, bproof, casque)
            end

            if RageUI.Visible(RMenu.Get('personal', "papier")) then
                openPapier()
            end

            if RageUI.Visible(RMenu.Get('personal', "arme")) then
                openArme()
            end

            if RageUI.Visible(RMenu.Get('personal', "save")) then
                openSave()
            end

            if RageUI.Visible(RMenu.Get('personal', 'clef')) then
                print('la')
                renderclef()
            end


            if IsControlJustReleased(0, Config.Controls.OpenMenu.keyboard) then
                visible = false
                RageUI.CloseAll()
            end
        end
    end
end)

RegisterNetEvent('animationtarget')
AddEventHandler('animationtarget', function(target)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict("mp_common", function()
        TaskPlayAnim(plyPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, false, false, false)
        RemoveAnimDict("mp_common")
    end)
    Citizen.Wait(3000)
    ClearPedTasks(plyPed)
end)
