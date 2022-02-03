
isDead = false
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

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
AddEventHandler('esx:onPlayerSpawn', function(spawn)
    isDead = false
end)

------ Vente Export ----------

ConfPosIllegal = {
    {
        x = 1268.45,
        y = -1710.09,
        z = 53.77,
        h = 260.42
    }
}

local subPosIllegal = {
    {
        x = -555.54,
        y = -631.74,
        z = 30.17,
        h = 2.49
    }
}

local prixSac = 35

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(playerCoords, ConfPosIllegal[1].x, ConfPosIllegal[1].y, ConfPosIllegal[1].z, true)

            if distance <= 1.5 and not isDead then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Parler à l'homme")
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('export_crimi', 'main'), not RageUI.Visible(RMenu:Get('export_crimi', 'main')))
                end
            end

            if distance ~= nil then
                if distance > 1.5 then
                    RageUI.CloseAll()
                end
            end
    end
end)

RMenu.Add('export_crimi', 'main', RageUI.CreateMenu("Cartel Inconnu", "Vente illegale" ))

Citizen.CreateThread(function()
    while true do  
        RageUI.IsVisible(RMenu:Get('export_crimi', 'main'), true, true, true, function()
            ESX.PlayerData = ESX.GetPlayerData()

            for i = 1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].count ~= false or ESX.PlayerData.inventory[i].count > 0 then
                    if  ESX.PlayerData.inventory[i].name == "sac_superette" then
                        prixItem = prixSac * ESX.PlayerData.inventory[i].count
                        RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', nil, { RightLabel = "~r~ ".. math.ceil(prixItem) .." $"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('illegal:vente', ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, ESX.PlayerData.inventory[i].count, prixItem)
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

function KeyboardInput(textEntry, inputText, maxLength,index)
    AddTextEntry(index, textEntry)
    DisplayOnscreenKeyboard(1, index, '', inputText, '', '', '', maxLength)
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

CreateThread(function()
    local hash = GetHashKey("g_m_y_ballasout_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(2000)
    end
    local ped = CreatePed("PED_TYPE_CIVMALE", "g_m_y_ballasout_01", ConfPosIllegal[1].x, ConfPosIllegal[1].y, ConfPosIllegal[1].z, ConfPosIllegal[1].h, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)