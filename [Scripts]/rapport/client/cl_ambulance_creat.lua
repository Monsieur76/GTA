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

-- LSPD--
RMenu.Add('ambulance_form', 'form_doc', RageUI.CreateMenu("Dossier patient", "Dossier patient"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('ambulance_form', 'form_doc'), true, true, true, function()
            if DOCUMENT_FORMS[ESX.PlayerData.job.name] ~= nil then
                for i = 1, #DOCUMENT_FORMS[ESX.PlayerData.job.name], 1 do
                    RageUI.ButtonWithStyle(DOCUMENT_FORMS[ESX.PlayerData.job.name][i].headerTitle, nil, {}, true,
                        function(hovered, active, selected)
                            if (selected) then
                                CreateNewForm(DOCUMENT_FORMS[ESX.PlayerData.job.name][i])
                                RageUI.CloseAll()
                            end
                        end)
                end
            end
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

local position = {{
    x = 315.63,
    y = -570.43,
    z = 43.28
}, {
    x = 317.96,
    y = -571.04,
    z = 43.28
}, {
    x = 324.25,
    y = -572.29,
    z = 43.28
}, {
    x = 355.32,
    y = -596.2,
    z = 43.28
}, {
    x = 341.19,
    y = -579.13,
    z = 43.28
}, {
    x = 308.53,
    y = -594.79,
    z = 43.28
}, {
    x = 311.25,
    y = -593.99,
    z = 43.28
}}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

                if dist <= 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Créer un dossier patient")

                    if IsControlJustReleased(1, Config.MenuKey) and GetLastInputMethod(2) then
                        RageUI.Visible(RMenu:Get('ambulance_form', 'form_doc'),
                            not RageUI.Visible(RMenu:Get('ambulance_form', 'form_doc')))
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                DrawMarker(1, position[k].x, position[k].y, position[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                    0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            end
        end
    end
end)
