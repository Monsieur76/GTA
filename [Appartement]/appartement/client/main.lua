ESX = nil
local PlayerData
local reset = true
local blipsName = {}
local changementBlips = false
local exitx, exity, exitz, exith, label, price, coloc_name, level_coloc, number_coloc
local properties = {}
local owner_properties
local UserProperty = nil
local propertiesName
local garageWho = nil
local name_garage = false
local apart
local openmenu = false
local buy
-- local apartMenu = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()

end)

-- only used when script is restarting mid-session
RegisterNetEvent('esx_property:sendProperties')
AddEventHandler('esx_property:sendProperties', function()
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
        Config.Properties = properties
        ESX.TriggerServerCallback('esx_property:getUserProperty', function(property)
            UserProperty = property
            UpdateBlips()
        end)
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
        Config.Properties = properties
        ESX.TriggerServerCallback('esx_property:getUserProperty', function(property)
            UserProperty = property
            CreateBlips()
        end)
    end)
end)

---entrer---
local openapart = false
RMenu.Add('aparte', 'apartmain', RageUI.CreateMenu("Logement", "Choisir appartement"))
RMenu.Add('aparte', 'habitation', RageUI.CreateSubMenu(RMenu:Get('aparte', 'apartmain'), "Logement", "Liste"))
RMenu.Add('aparte', 'coloc',
    RageUI.CreateSubMenu(RMenu:Get('aparte', 'apartmain'), "Gestion colocataires", "Colocation"))
RMenu.Add('aparte', 'enlever', RageUI.CreateSubMenu(RMenu:Get('aparte', 'coloc'), "Retirer colocataire", "Colocation"))
RMenu.Add('aparte', 'confirmation', RageUI.CreateSubMenu(RMenu:Get('aparte', 'apartmain'), "Etes vous sur ?", "Demande de confirmation"))
RMenu:Get('aparte', 'apartmain').Closed = function()
    openapart = false
    openmenu = false
end
-- RMenu:Get('apart', 'main').Closed = function()
--  apartMenu = false
-- end

function openaparttt()
    if not openapart then
        openapart = true
        RageUI.Visible(RMenu:Get('aparte', 'apartmain'), true)
        while openapart do
            RageUI.IsVisible(RMenu:Get('aparte', 'apartmain'), true, true, true, function()
                if owner_properties == "no" then
                    for i = 1, #Config.Properties, 1 do
                        local property = Config.Properties[i]
                        if property.name == propertiesName and not property.owner and not buy then
                            -- ajouté la coloc aussi
                            RageUI.ButtonWithStyle(property.label, nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exitx = property.exit.x
                                    exity = property.exit.y
                                    exitz = property.exit.z
                                    exith = property.exit.h
                                    label = property.label
                                    price = property.price
                                end
                            end, RMenu:Get('aparte', 'habitation'))
                        elseif property.owner then
                            if property.name == propertiesName and property.owner then
                                RageUI.ButtonWithStyle("Sonner " .. property.label, nil, {
                                    RightLabel = "→"
                                }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        local ped = PlayerPedId()
                                        ESX.Streaming.RequestAnimDict("mp_doorbell", function()
                                            TaskPlayAnim(ped, "mp_doorbell", "ring_bell_a_left", 8.0, -8.0, -1, 0, 0,
                                                false, false, false)
                                            RemoveAnimDict("mp_doorbell")
                                        end)
                                        TriggerServerEvent("properties:phone", property.label,
                                            property.owner_identifier, property.exit.x, property.exit.y,
                                            property.exit.z, property.exit.h)
                                        ESX.ShowNotification("Vous avez sonné à " .. property.label)
                                        openapart = false
                                        RageUI.CloseAll()
                                        openmenu = false
                                    end
                                end)
                            end
                        end
                    end
                elseif owner_properties == "owned" then
                    for i = 1, #Config.Properties, 1 do
                        local property = Config.Properties[i]
                        if property.name == propertiesName and label == property.label then
                            RageUI.ButtonWithStyle("Entrer dans le logement", nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local playerPed = PlayerPedId()
                                    RageUI.CloseAll()
                                    entry(playerPed, property.exit.x, property.exit.y, property.exit.z, property.exit.h)
                                    openapart = false
                                    openmenu = false
                                end
                            end)
                            RageUI.ButtonWithStyle("⚠ Vendre", nil, {
                                RightLabel = "~g~" .. property.price / 2 .. "$"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then

                                    RageUI.CloseAll()
                                    TriggerServerEvent("properties:sellProperties", property.label, property.price / 2)
                                    openapart = false
                                    openmenu = false

                                end
                            end)
                            RageUI.ButtonWithStyle("Gestion colocataires", nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    label = property.label
                                    coloc_name = property.coloc_name
                                    level_coloc = property.level_coloc
                                    number_coloc = property.number_coloc
                                end
                            end, RMenu:Get('aparte', 'coloc'))
                        elseif property.owner and property.owner_identifier ~= ESX.PlayerData.identifier and
                            property.name == propertiesName then
                            RageUI.ButtonWithStyle("Sonner " .. property.label, nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local ped = PlayerPedId()
                                    ESX.Streaming.RequestAnimDict("mp_doorbell", function()
                                        TaskPlayAnim(ped, "mp_doorbell", "ring_bell_a_left", 8.0, -8.0, -1, 0, 0, false,
                                            false, false)
                                        RemoveAnimDict("mp_doorbell")
                                    end)
                                    TriggerServerEvent("properties:phone", property.label, property.owner_identifier,
                                        property.exit.x, property.exit.y, property.exit.z, property.exit.h)
                                    ESX.ShowNotification("Vous avez sonné à " .. property.label)
                                    openapart = false
                                    RageUI.CloseAll()
                                    openmenu = false
                                end
                            end)
                        end
                    end
                elseif owner_properties == "coloc" then
                    for i = 1, #Config.Properties, 1 do
                        local property = Config.Properties[i]
                        if property.name == propertiesName and label == property.label then
                            RageUI.ButtonWithStyle("Entrer dans le logement", nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local playerPed = PlayerPedId()
                                    RageUI.CloseAll()
                                    entry(playerPed, property.exit.x, property.exit.y, property.exit.z, property.exit.h)
                                    openapart = false
                                    openmenu = false
                                end
                            end)
                        elseif property.owner and property.name == propertiesName and property.owner_identifier ~=
                            ESX.PlayerData.identifier then
                            RageUI.ButtonWithStyle("Sonner " .. property.label, nil, {
                                RightLabel = "→"
                            }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local ped = PlayerPedId()
                                    ESX.Streaming.RequestAnimDict("mp_doorbell", function()
                                        TaskPlayAnim(ped, "mp_doorbell", "ring_bell_a_left", 8.0, -8.0, -1, 0, 0, false,
                                            false, false)
                                        RemoveAnimDict("mp_doorbell")
                                    end)
                                    TriggerServerEvent("properties:phone", property.label, property.owner_identifier,
                                        property.exit.x, property.exit.y, property.exit.z, property.exit.h)
                                    ESX.ShowNotification("Vous avez sonné à " .. property.label)
                                    openapart = false
                                    RageUI.CloseAll()
                                    openmenu = false
                                end
                            end)
                        end
                    end
                end
            end, function()
            end, 1)
            RageUI.IsVisible(RMenu:Get('aparte', 'habitation'), true, true, true, function()
                RageUI.ButtonWithStyle('Visiter ', nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        RageUI.CloseAll()
                        entry(playerPed, exitx, exity, exitz, exith)
                        IsVisiting = true
                        TriggerEvent("playerVisitingHouse", true)
                        openapart = false
                        openmenu = false
                    end
                end)
                if owner_properties ~= "owned" and owner_properties ~= "coloc" then
                    RageUI.ButtonWithStyle('⚠ Acheter', nil, {
                        RightLabel = "~g~" .. price .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            TriggerServerEvent("properties:buyProperties", label, price)
                            openapart = false
                            openmenu = false
                        end
                    end)
                end
            end, function()
            end, 1)
            RageUI.IsVisible(RMenu:Get('aparte', 'coloc'), true, true, true, function()
                RageUI.ButtonWithStyle('Ajouter un colocataire',
                    "Nombre de place(s) disponible(s) : " .. number_coloc .. "/" .. level_coloc + 1, {
                        RightLabel = ""
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            local playerPed = PlayerPedId()
                            if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                                TriggerServerEvent("properties:NewColoc", label, target_id)
                            else
                                ESX.ShowNotification('Personne à proximité.')
                            end
                            openapart = false
                            RageUI.CloseAll()
                            openmenu = false
                        end
                    end)
                if coloc_name ~= nil and coloc_name ~= {} then
                    RageUI.ButtonWithStyle('Renvoyer un colocataire', nil, {
                        RightLabel = "→"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, RMenu:Get('aparte', 'enlever'))
                end
            end, function()
            end, 1)
            RageUI.IsVisible(RMenu:Get('aparte', 'enlever'), true, true, true, function()
                for k, v in pairs(coloc_name) do
                    RageUI.ButtonWithStyle(v.name, nil, {
                        RightLabel = "→"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            TriggerServerEvent("properties:removeColoc", v.name, label, v.identifier)
                            openapart = false
                            openmenu = false
                        end
                    end)
                end
            end, function()
            end, 1)
            RageUI.IsVisible(RMenu:Get('aparte', 'confirmation'), true, true, true, function()
                for k, v in pairs(coloc_name) do
                    RageUI.ButtonWithStyle("Etes vous sur ?", nil, {
                        RightLabel = "→"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            TriggerServerEvent("properties:removeColoc", v.name, label, v.identifier)
                            openapart = false
                            openmenu = false
                        end
                    end)
                end
            end, function()
            end, 1)
            Citizen.Wait(0)
        end
    else
        openapart = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        for i = 1, #Config.enter, 1 do
            local propertys = Config.enter[i]
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, propertys.x, propertys.y, propertys.z - 1)
            if jobdist < 50 then
                DrawMarker(1, propertys.x, propertys.y, propertys.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25,
                    25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)

        if Config.Properties[1] == nil and reset then
            TriggerEvent('esx_property:sendProperties')
            reset = false
            openapart = false
        else
            for k, v in pairs(Config.Properties) do
                local propertys = Config.Properties[k]
                local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, propertys.enter.x, propertys.enter.y,
                    propertys.enter.z - 1)
                if jobdist < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Entrer dans le logement")

                    if IsControlJustPressed(1, Config.Controls.ouvrirMenu.keyboard) and not openapart and not openmenu then
                            openmenu = true
                            propertiesName = propertys.name
                            ESX.TriggerServerCallback('esx_property:getowned', function(build,lab)
                                label = lab
                                owner_properties = build
                            end, propertys.name)
                            ESX.TriggerServerCallback('esx_property:getownedpropertyorcoloc', function(build)
                                buy = build
                            end)
                            if owner_properties == nil then
                                Citizen.Wait(500)
                            end
                            print(owner_properties)
                            openaparttt()
                    end
                else
                    RageUI.CloseAll()
                    openapart = false
                    openmenu = false
                end
                local jobdistt = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, propertys.exit.x, propertys.exit.y,
                    propertys.exit.z - 1)
                if jobdistt < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Sortir du logement")
                    if IsControlJustPressed(1, Config.Controls.ouvrirMenu.keyboard) then
                        local playerPed = PlayerPedId()
                        entry(playerPed, propertys.enter.x, propertys.enter.y, propertys.enter.z, propertys.enter.h)
                        if IsVisiting then
                            IsVisiting = false
                            TriggerEvent("playerVisitingHouse", false)
                        end
                    end
                end
            end
        end
    end
end)

local sonnet = false
local calculate = 0

RegisterNetEvent('properties:sonnette')
AddEventHandler('properties:sonnette', function(source, x, y, z, h)
    Citizen.CreateThread(function()
        sonnet = true
        calculate = 0
        while sonnet do
            Citizen.Wait(1)
            calculate = calculate + 1
            if sonnet then
                if calculate >= 1500 then
                    sonnet = false
                end
                if IsControlJustReleased(0, 246) then
                    TriggerServerEvent("properties:notify", source, true, x, y, z, h)
                    ESX.ShowNotification("Vous avez autorisé la personne à entrer")
                    sonnet = false

                elseif IsControlJustReleased(0, 249) or IsControlJustPressed(0, 306) then
                    TriggerServerEvent("properties:notify", source, false)
                    ESX.ShowNotification("Vous n'avez pas autorisé la personne à entrer")
                    sonnet = false
                end

            end
        end
    end)
end)

function entry(source, x, y, z, h)
    SetEntityCoords(source, x, y, z, true, true, true, true)
    SetEntityHeading(source, h)
    RageUI.CloseAll()
    openapart = false
    openmenu = false
end

function CreateBlips()
    for _, configProperty in pairs(Config.Properties) do
        if UserProperty ~= nil and UserProperty.name == configProperty.name then
            blipsName[configProperty.name] = AddBlipForCoord(configProperty.enter.x, configProperty.enter.y,
                configProperty.enter.z)

            SetBlipSprite(blipsName[configProperty.name], 40)
            SetBlipDisplay(blipsName[configProperty.name], 4)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Votre logement")
            EndTextCommandSetBlipName(blipsName[configProperty.name])

            SetBlipScale(blipsName[configProperty.name], 0.90)
        else
            blipsName[configProperty.name] = AddBlipForCoord(configProperty.enter.x, configProperty.enter.y,
                configProperty.enter.z)

            SetBlipSprite(blipsName[configProperty.name], 350)
            if UserProperty ~= nil then
                SetBlipDisplay(blipsName[configProperty.name], 0)
            else
                SetBlipDisplay(blipsName[configProperty.name], 4)
            end

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Logement")
            EndTextCommandSetBlipName(blipsName[configProperty.name])

            SetBlipScale(blipsName[configProperty.name], 0.70)
        end
        SetBlipAsShortRange(blipsName[configProperty.name], true)
    end
end

function UpdateBlips()
    for _, configProperty in pairs(Config.Properties) do
        if UserProperty ~= nil and UserProperty.name == configProperty.name then
            SetBlipSprite(blipsName[configProperty.name], 40)
            SetBlipDisplay(blipsName[configProperty.name], 4)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Votre logement")
            EndTextCommandSetBlipName(blipsName[configProperty.name])

            SetBlipScale(blipsName[configProperty.name], 0.90)
        else
            SetBlipSprite(blipsName[configProperty.name], 350)
            if UserProperty ~= nil then
                SetBlipDisplay(blipsName[configProperty.name], 0)
            else
                SetBlipDisplay(blipsName[configProperty.name], 4)
            end

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Logement")
            EndTextCommandSetBlipName(blipsName[configProperty.name])

            SetBlipScale(blipsName[configProperty.name], 0.70)
        end

        SetBlipAsShortRange(blipsName[configProperty.name], true)
    end
end
