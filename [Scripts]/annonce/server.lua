local ESX = nil
local timer = 0
local time = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('annonce_open')
AddEventHandler('annonce_open', function(message, title, type)
    local show = false
    local Players = ESX.GetPlayers()

    if type == "WeazelBreaking" then
        show = true
    elseif type == "WeazelInfo" then
        show = true
    elseif type == "WeazelPub" then
        show = true
    elseif type == "WeazelAnonce" then
        show = true
    end
    if time then
        if show and type == "WeazelAnonce" or type == "WeazelPub" or type == "WeazelInfo" or type == "WeazelBreaking" then
            local open = true
            timer = 0
            for i = 1, #Players, 1 do
                TriggerClientEvent('annonce_open', Players[i], message, title, type)
                TriggerClientEvent('ArticleOpen', Players[i], open)
            end
			time = false
        end
    else
        numbe = 150000 - timer
        number = numbe / 1000
        TriggerClientEvent('esx:showNotification', source, "Vous devez encore attendre " .. number .. " Seconde")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if not time then
            timer = timer + 1000
            if timer >= 150000 then
                time = true
            end
        end
    end
end)
