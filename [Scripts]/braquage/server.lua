ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local deadPeds = {}

RegisterServerEvent('loffe_robbery:pedDead')
AddEventHandler('loffe_robbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('loffe_robbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do
                if k == store then
                    table.remove(deadPeds, k)
                end
            end
            TriggerClientEvent('loffe_robbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('loffe_robbery:handsUp')
AddEventHandler('loffe_robbery:handsUp', function(store)
    TriggerClientEvent('loffe_robbery:handsUp', -1, store)
end)

RegisterServerEvent('loffe_robbery:pickUp')
AddEventHandler('loffe_robbery:pickUp', function(sac, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem("sac_superette", sac) then
        xPlayer.addInventoryItem("sac_superette", sac)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~" .. sac .. " Sac(s) de superette")
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus de place sur vous !")
    end
end)

ESX.RegisterServerCallback('loffe_robbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == "police" or xPlayer.job.name == "policeNorth" then
            cops = cops + 1
        end
    end
    if cops >= Config.cops then
        if not Config.Shops[store].robbed and cops then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('loffe_robbery:rob')
AddEventHandler('loffe_robbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    TriggerClientEvent('loffe_robbery:robberyTrue', -1)
    local xPlayers = ESX.GetPlayers()
    rand = math.random(0, 10000) / 100
    if rand < 60 then
        local msg = "braquage en cours : GPS: " .. Config.Shops[store].coords.x .. ", " .. Config.Shops[store].coords.y
        TriggerEvent('gcPhone:sendMessage', "police", msg, Config.Shops[store].coords, true)
    end

    TriggerClientEvent('loffe_robbery:rob', source, store)
    Wait(300000)

    TriggerClientEvent('loffe_robbery:robberyOver', -1)
    TriggerClientEvent('loffe_robbery:robberystoreTrue', -1, store)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local wait = Config.hour * hour + Config.minute * minute + Config.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    TriggerClientEvent('loffe_robbery:resetStore', -1, store)
end)

RegisterServerEvent('robberyInCourt')
AddEventHandler('robberyInCourt', function(store)
    Config.Shops[store].robbed = true
    TriggerClientEvent('loffe_robbery:robberyOver', -1)
    TriggerClientEvent('loffe_robbery:robberystoreTrue', -1, store)
    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local wait = Config.hour * hour + Config.minute * minute + Config.second * second
    Wait(wait)
    TriggerClientEvent('loffe_robbery:resetStore', -1, store)
end)

RegisterServerEvent('robberyInCourtStore')
AddEventHandler('robberyInCourtStore', function()
    TriggerClientEvent('loffe_robbery:robberyTrue', -1)
end)

RegisterServerEvent('robberyInCourtStorefalse')
AddEventHandler('robberyInCourtStorefalse', function()
    TriggerClientEvent('loffe_robbery:robberyOver', -1)
end)

RegisterServerEvent('robberyInCourtStoretrue1store')
AddEventHandler('robberyInCourtStoretrue1store', function(store)
    TriggerClientEvent('loffe_robbery:robberystoreTrue', -1, store)
end)
