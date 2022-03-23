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
RMenu.Add('police_form', 'form_doc', RageUI.CreateMenu("Rapport", "Rapport"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('police_form', 'form_doc'), true, true, true, function()
            local job = 'police'
            if ESX.PlayerData.job.name == "policeNorth" then
                job = "police"
            end
            if DOCUMENT_FORMS[job] ~= nil then
                for i = 1, #DOCUMENT_FORMS[job], 1 do
                    RageUI.ButtonWithStyle(DOCUMENT_FORMS[job][i].headerTitle, nil, {}, true,
                        function(hovered, active, selected)
                            if (selected) then
                                CreateNewForm(DOCUMENT_FORMS[job][i])
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

local position = 
{
    {
        x = 448.19,
        y = -978.55,
        z = 30.69
    }, {
        x = 456.34,
        y = -978.57,
        z = 30.69
    }, {
        x = -433.18,
        y = 6002.94,
        z = 31.71
    }, {
        x = -436.07,
        y = 6000.27,
        z = 31.71
    },
    {
        x = 440.65,
        y = -980.27,
        z = 34.19
    },
    {
        x = 437.11,
        y = -990.31,
        z = 34.19
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

                if dist <= 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Faire un rapport")
                    if IsControlJustReleased(1, Config.MenuKey) and GetLastInputMethod(2) then
                        RageUI.Visible(RMenu:Get('police_form', 'form_doc'),
                            not RageUI.Visible(RMenu:Get('police_form', 'form_doc')))
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
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
                DrawMarker(1, position[k].x, position[k].y, position[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                    0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            end
        end
    end
end)
