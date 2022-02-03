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

RMenu.Add('police_search', 'form_search', RageUI.CreateMenu("Rapport", "Rapport"))
RMenu.Add('police_search', 'regarder',
    RageUI.CreateSubMenu(RMenu:Get('police_search', 'form_search'), "LSPD", "Rapport"))
RMenu.Add('police_search', 'delete',
    RageUI.CreateSubMenu(RMenu:Get('police_search', 'form_search'), "LSPD", "Supprimer un document"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('police_search', 'form_search'), true, true, true, function()
            RageUI.ButtonWithStyle("Regarder un document", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police_search', 'regarder'))
            RageUI.ButtonWithStyle("Supprimer un document", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police_search', 'delete'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police_search', 'regarder'), true, true, true, function()
            if USER_DOCUMENTS then
                for i = #USER_DOCUMENTS, 1, -1 do
                    if USER_DOCUMENTS[i].data.headerJobLabel == "LSPD" then
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
        RageUI.IsVisible(RMenu:Get('police_search', 'delete'), true, true, true, function()
            if USER_DOCUMENTS then
                for i = #USER_DOCUMENTS, 1, -1 do
                    if USER_DOCUMENTS[i].data.headerJobLabel == "LSPD" then
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

local position2 = {
    {
        x = 443.54,
        y = -991.83,
        z = 30.69
    },
    {
        x = -433.92,
        y = 6007.29,
        z = 31.72
    },
    {
        x = 439.31,
        y = -987.98,
        z = 34.19
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position2) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist =
                    Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position2[k].x, position2[k].y, position2[k].z)
                DrawMarker(1, position2[k].x, position2[k].y, position2[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                    1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                if dist <= 1.2 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Rapports")
                    if IsControlJustReleased(1, Config.MenuKey) and GetLastInputMethod(2) then
                        ESX.TriggerServerCallback('esx_documents:getPlayerDocuments', function(cb_forms)
                            if cb_forms ~= nil then
                                USER_DOCUMENTS = {}
                                USER_DOCUMENTS = cb_forms
                            else
                                print("Received nil from newely created scale object.")
                            end
                        end, "LSPD")
                        RageUI.Visible(RMenu:Get('police_search', 'form_search'),
                            not RageUI.Visible(RMenu:Get('police_search', 'form_search')))
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(position2) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
                DrawMarker(1, position2[k].x, position2[k].y, position2[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                    1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            end
        end
    end
end)
