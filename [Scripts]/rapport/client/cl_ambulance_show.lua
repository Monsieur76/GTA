ESX = nil
local PlayerData = {}
local USER_DOCUMENTS
local fontId
local DOCUMENT_FORMS = nil

local MENU_OPTIONS = {
    x = 0.5,
    y = 0.2,
    width = 0.5,
    height = 0.04,
    scale = 0.4,
    font = fontId,
    menu_subtitle = _U('document_options'),
    color_r = 0,
    color_g = 128,
    color_b = 255
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.IsPlayerLoaded == false do
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    DOCUMENT_FORMS = Config.Documents[Config.Locale]

    if Config.UseCustomFonts == true then
        RegisterFontFile(Config.CustomFontFile)
        fontId = RegisterFontId(Config.CustomFontId)
        MENU_OPTIONS.font = fontId
    else
        MENU_OPTIONS.font = 4
    end

    -- GetAllUserForms()
    SetNuiFocus(false, false)

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- LSMS--

RMenu.Add('ambulance_search', 'form_search', RageUI.CreateMenu("Rapport", "Rapport"))
RMenu.Add('ambulance_search', 'regarder',
    RageUI.CreateSubMenu(RMenu:Get('ambulance_search', 'form_search'), "LSMS", "Rapport"))
RMenu.Add('ambulance_search', 'delete',
    RageUI.CreateSubMenu(RMenu:Get('ambulance_search', 'form_search'), "LSMS", "Supprimer un document"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('ambulance_search', 'form_search'), true, true, true, function()
            RageUI.ButtonWithStyle("Regarder un document", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('ambulance_search', 'regarder'))
            RageUI.ButtonWithStyle("Supprimer un document", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('ambulance_search', 'delete'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('ambulance_search', 'regarder'), true, true, true, function()
            if USER_DOCUMENTS then
                for i = #USER_DOCUMENTS, 1, -1 do
                    print(USER_DOCUMENTS[i].data.headerJobLabel)
                    if USER_DOCUMENTS[i].data.headerJobLabel == "LSMS" then
                        RageUI.ButtonWithStyle(USER_DOCUMENTS[i].data.headerTitle .. " fait le " ..
                                                   USER_DOCUMENTS[i].data.headerDateCreated, USER_DOCUMENTS[i].data
                            .headerFirstName .. " " .. USER_DOCUMENTS[i].data.headerLastName, {}, true,
                            function(hovered, active, selected)
                                if (selected) then
                                    ViewDocument(USER_DOCUMENTS[i].data)
                                    RageUI.CloseAll()
                                end
                            end)
                    end
                end
            end
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('ambulance_search', 'delete'), true, true, true, function()
            if USER_DOCUMENTS then
                for i = #USER_DOCUMENTS, 1, -1 do
                    if USER_DOCUMENTS[i].data.headerJobLabel == "LSMS" then
                        RageUI.ButtonWithStyle(USER_DOCUMENTS[i].data.headerTitle .. " fait le " ..
                                                   USER_DOCUMENTS[i].data.headerDateCreated, USER_DOCUMENTS[i].data
                            .headerFirstName .. " " .. USER_DOCUMENTS[i].data.headerLastName, {}, true,
                            function(hovered, active, selected)
                                if (selected) then
                                    DeleteDocument(USER_DOCUMENTS[i])
                                    RageUI.CloseAll()
                                end
                            end)
                    end
                end
            end
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

local position2 = {{
    x = 315.87,
    y = -563.95,
    z = 43.28
}, {
    x = 321.91,
    y = -572.53,
    z = 43.28
}, 
{
    x = 320.16,
    y = -586.09,
    z = 43.28
},
 {
    x = 321.65,
    y = -582.01,
    z = 43.28
}, 
{
    x = 311.00,
    y = -597.26,
    z = 43.28
},
 {
    x = 311.56,
    y = -578.37,
    z = 43.28
}, {
    x = 327.04,
    y = -567.22,
    z = 43.28
}, {
    x = 341.85,
    y = -588.98,
    z = 43.28
}, {
    x = 342.81,
    y = -574.97,
    z = 43.28

}, {
    x = 355.92,
    y = -585.14,
    z = 43.28

}, {
    x = 357.78,
    y = -581.73,
    z = 43.28

}, {
    x = 357.18,
    y = -594.53,
    z = 43.28
}, {
    x = 350.68,
    y = -599.72,
    z = 43.28
}}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position2) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist =
                    Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position2[k].x, position2[k].y, position2[k].z)

                if dist <= 1.2 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Dossiers patient")

                    if IsControlJustReleased(1, Config.MenuKey) and GetLastInputMethod(2) then
                        ESX.TriggerServerCallback('esx_documents:getPlayerDocuments', function(cb_forms)
                            if cb_forms ~= nil then
                                USER_DOCUMENTS = {}
                                USER_DOCUMENTS = cb_forms
                            else
                                print("Received nil from newely created scale object.")
                            end
                        end, "LSMS")
                        RageUI.Visible(RMenu:Get('ambulance_search', 'form_search'),
                            not RageUI.Visible(RMenu:Get('ambulance_search', 'form_search')))
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)

        for k, v in pairs(position2) do
            local dist =
                    Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position2[k].x, position2[k].y, position2[k].z)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                if dist <= 10 then
                DrawMarker(1, position2[k].x, position2[k].y, position2[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                    1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                end
            end
        end
    end
end)
