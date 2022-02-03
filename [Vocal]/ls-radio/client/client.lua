ESX = nil
local PlayerData = {}
local radioMenu, isRadioUsable = false, false
IsDead = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

end)

AddEventHandler('playerSpawned', function()
    IsDead = false
    ESX.TriggerServerCallback("esx_ambulancejob:getDeathStatus", function(dead)
        if dead then
            IsDead = true
        end
    end)
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
    disableRadio(false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "LS-Radio", {255, 0, 0}, text)
end

function enableRadio(enable)
    SetNuiFocus(true, true)
    radioMenu = enable

    --Afficher ou pas la radio
    if enable then
        RadioPlayIn()
    else
        RadioPlayOut()
    end

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

function disableRadio(enable)
    SetNuiFocus(false, false)
    radioMenu = enable

    --Fermer radio
    RadioPlayOut()

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
    local getPlayerRadioChannel1 = exports.saltychat:GetRadioChannel(true)
    local getPlayerRadioChannel2 = exports.saltychat:GetRadioChannel(false)

    if getPlayerRadioChannel1 ~= '' then
        exports.saltychat:SetRadioChannel('', true)
    end
    if getPlayerRadioChannel2 ~= '' then
        exports.saltychat:SetRadioChannel('', false)
    end
end

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
        enableRadio(true)
    end
end, false)

RegisterCommand('radiotest', function(source, args)
    local playerName = GetPlayerName(PlayerId())
    local data = exports.saltychat:GetRadioChannel(true)

    if data == nil or data == '' then
        ESX.ShowNotification(Config.messages['not_on_radio'])
    else
        ESX.ShowNotification(Config.messages['on_radio'] .. data .. '.00 MHz </b>')
    end
end, false)

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(data.primary)
    print(data.channel)
    if tonumber(data.channel) <= 0 or 999 < tonumber(data.channel) then
        ESX.ShowNotification('Fréquence incorrecte')
    else
        local volume = 1
        if data.volume ~= nil then
            volume = data.volume / 100.0
            print(volume)
        end
        print(volume)
        if data.channel ~= getPlayerRadioChannel then
            if tonumber(data.channel) <= Config.RestrictedChannels then
                if (string.find(PlayerData.job.name, 'police') or PlayerData.job.name == 'ambulance') then
                    exports.saltychat:SetRadioChannel(data.channel, data.primary)
                    exports.saltychat:SetRadioVolume(volume)
                    --ESX.ShowNotification(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
                elseif not (string.find(PlayerData.job.name, 'police') or PlayerData.job.name == 'ambulance') then
                    ESX.ShowNotification(Config.messages['restricted_channel_error'])
                end
            end
            if tonumber(data.channel) > Config.RestrictedChannels then
                exports.saltychat:SetRadioChannel(data.channel, data.primary)
                --ESX.ShowNotification(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
            end
        else
            --ESX.ShowNotification(Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
        end

        -- Debug output
        --[[
  PrintChatMessage("radio: " .. data.channel)
  print('radiook')
  ]]

        cb('ok')
    end

end)

RegisterNUICallback('leaveRadio', function(data, cb)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel1 = exports.saltychat:GetRadioChannel(true)
    local getPlayerRadioChannel2 = exports.saltychat:GetRadioChannel(false)

    if getPlayerRadioChannel1 == nil or getPlayerRadioChannel1 == '' then
        --ESX.ShowNotification(Config.messages['not_on_radio'])
    else
        exports.saltychat:SetRadioChannel('', data.primary)
        --ESX.ShowNotification(Config.messages['you_leave'] .. getPlayerRadioChannel1 .. '.00 MHz </b>')
    end
    if getPlayerRadioChannel2 == nil or getPlayerRadioChannel2 == '' then
        --ESX.ShowNotification(Config.messages['not_on_radio'])
    else
        exports.saltychat:SetRadioChannel('', data.primary)
        --ESX.ShowNotification(Config.messages['you_leave'] .. getPlayerRadioChannel2 .. '.00 MHz </b>')
    end
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    enableRadio(false)
    SetNuiFocus(false, false)

    cb('ok')
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
    local playerName = GetPlayerName(source)
    local getPlayerRadioChannel1 = exports.saltychat:GetRadioChannel(true)
    local getPlayerRadioChannel2 = exports.saltychat:GetRadioChannel(false)

    if getPlayerRadioChannel1 ~= '' then
        exports.saltychat:SetRadioChannel('', true)
        --ESX.ShowNotification(Config.messages['you_leave'] .. getPlayerRadioChannel1 .. '.00 MHz </b>')
    end
    if getPlayerRadioChannel2 ~= '' then
        exports.saltychat:SetRadioChannel('', false)
        --ESX.ShowNotification(Config.messages['you_leave'] .. getPlayerRadioChannel2 .. '.00 MHz </b>')
    end
end)

Citizen.CreateThread(function()
    while true do

        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsControlPressed(0, 166) and not IsDead then
            ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
                if qtty > 0 then
                    enableRadio(not radioMenu)
                    if (not radioMenu) then
                        print(exports.saltychat:GetRadioVolume())

                        SetNuiFocus(false, false)
                    end
                else
                    ESX.ShowNotification("Vous n'avez pas de radio")
                end
            end, 'radio')
        end

        Citizen.Wait(100)
    end
end)
