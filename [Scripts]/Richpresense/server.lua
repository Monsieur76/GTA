ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)
AddEventHandler('esx:playerLoaded', function(source)
    if #ESX.Items == 0 then
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end)

ESX.RegisterServerCallback('presencePlayer', function(source, cb)
    local xPlayersAll = ESX.GetPlayers()
    local attempt = 0
    for i = 1, #xPlayersAll, 1 do
        attempt = attempt + 1
    end
    cb(attempt)
end)
