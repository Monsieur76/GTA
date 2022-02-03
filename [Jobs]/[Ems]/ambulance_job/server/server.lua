ESX = nil

local playersHealing = {}
local compteur = 10

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', 'alerte ambulance', true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance',
    'society_ambulance', {
        type = 'public'
    })

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
    else
        -- print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
    end
end)

RegisterServerEvent('ambulancehelico')
AddEventHandler('ambulancehelico', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    end
end)

local playersHealing, deadPlayers = {}, {}

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'police' then
        TriggerClientEvent('esx_ambulancejob:revive', target)
    else
        print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
    end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    deadPlayers[source] = 'dead'
    TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)
    if args[1] ~= nil then
        if GetPlayerName(tonumber(args[1])) ~= nil then
            print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
            TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
        end
    else
        TriggerClientEvent('esx_ambulancejob:revive', source)
    end
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, {
        args = {'^1SYSTEM', 'Insufficient Permissions.'}
    })
end, {
    help = _U('revive_help'),
    params = {{
        name = 'id'
    }}
})

RegisterNetEvent('esx_ambulancejob:onPlayerDistress')
AddEventHandler('esx_ambulancejob:onPlayerDistress', function()
    if deadPlayers[source] then
        deadPlayers[source] = 'distress'
        TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
    end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    if deadPlayers[source] then
        deadPlayers[source] = nil
        TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if deadPlayers[playerId] then
        deadPlayers[playerId] = nil
        TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
    end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    for k,v in pairs(xTarget.getMaladie()) do
        if v == "rhume" then
            xTarget.removeMaladie("rhume")
            TriggerClientEvent('resetmaladie',xTarget.source, "rhume")
        end
        if v == "grippe" then
            xTarget.removeMaladie("grippe")
            TriggerClientEvent('resetmaladie',xTarget.source, "grippe")
        end
        if v == "herpes" then
            xTarget.removeMaladie("herpes")
            TriggerClientEvent('resetmaladie',xTarget.source, "herpes")
        end
        if v == "soleil" then
            xTarget.removeMaladie("soleil")
            TriggerClientEvent('resetmaladie',xTarget.source, "soleil")
        end
    end
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('esx_ambulancejob:hea', target, type)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez soigné " .. xTarget.getName())
    end
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.RemoveCashAfterRPDeath then
        if xPlayer.getMoney() > 0 then

            xPlayer.removeMoney(xPlayer.getMoney() / 2)
        end

        if xPlayer.getAccount('black_money').money > 0 then
            xPlayer.setAccountMoney('black_money', xPlayer.getAccount('black_money').money / 2)

        end
    end

    if Config.RemoveItemsAfterRPDeath then
        for i = 1, #xPlayer.inventory, 1 do
            if xPlayer.inventory[i].count > 0 then
                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
            end
        end
    end

    local playerLoadout = {}
    if Config.RemoveWeaponsAfterRPDeath then
        for i = 1, #xPlayer.loadout, 1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end
    else -- save weapons & restore em' since spawnmanager removes them
        for i = 1, #xPlayer.loadout, 1 do
            table.insert(playerLoadout, xPlayer.loadout[i])
        end

        -- give back wepaons after a couple of seconds
        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            for i = 1, #playerLoadout, 1 do
                if playerLoadout[i].label ~= nil then
                    xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
                end
            end
        end)
    end

    cb()
end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundPlate, foundNum

    for k, v in ipairs(nearbyVehicles) do
        local result = MySQL.Sync.fetchAll(
            'SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = v.plate,
                ['@job'] = xPlayer.job.name
            })

        if result[1] then
            foundPlate, foundNum = result[1].plate, k
            break
        end
    end

    if not foundPlate then
        cb(false)
    else
        MySQL.Async.execute(
            'UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = foundPlate,
                ['@job'] = xPlayer.job.name
            }, function(rowsChanged)
                if rowsChanged == 0 then
                    cb(false)
                else
                    cb(true, foundNum)
                end
            end)
    end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
    local vehicles = Config.AuthorizedVehicles[type][jobGrade]

    for k, v in ipairs(vehicles) do
        if GetHashKey(v.model) == vehicleHash then
            return v.price
        end
    end

    return 0
end

RegisterNetEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)

    if item == 'bandage' then
        -- xPlayer.showNotification(_U('used_bandage'))
    elseif item == 'medikit' then
        -- xPlayer.showNotification(_U('used_medikit'))
    end
end)

RegisterNetEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= 'ambulance' then
        print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
        return
    elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
        print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
        return
    end

    if xPlayer.canCarryItem(itemName, amount) then
        xPlayer.addInventoryItem(itemName, amount)
    else
        xPlayer.showNotification(_U('max_item'))
    end
end)

ESX.RegisterUsableItem('medikit', function(source)
    if not playersHealing[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('medikit', 1)

        playersHealing[source] = true
        TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

        Citizen.Wait(10000)
        playersHealing[source] = nil
    end
end)

ESX.RegisterUsableItem('bandage', function(source)
    if not playersHealing[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('bandage', 1)

        playersHealing[source] = true
        TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

        Citizen.Wait(10000)
        playersHealing[source] = nil
    end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(isDead)

            if isDead then
                print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted combat logging'):format(xPlayer.identifier))
            end

            cb(isDead)
        end)
    else
    end
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type(isDead) == 'boolean' then
        MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@isDead'] = isDead
        })
    end
end)

RegisterServerEvent('esx_ambulancejob:RetirerBlipServer')
AddEventHandler('esx_ambulancejob:RetirerBlipServer', function(blipsRenfort)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'ambulance' then
            TriggerClientEvent('esx_ambulancejob:BlipRetirer', xPlayers[i], blipsRenfort)
        end
    end
end)

-- Prise Appel EMS 

-- Notification appel ems pour tout les ems
RegisterServerEvent("Server:emsAppel")
AddEventHandler("Server:emsAppel", function(coords, id)
    local _id = id
    local _coords = coords
    local xPlayers = ESX.GetPlayers()
    -- print(_id)
    -- print(_coords)

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            TriggerClientEvent("AppelemsTropBien", xPlayers[i], _coords, _id)
        end
    end
end)

-- Prise d'appel ems
RegisterServerEvent('EMS:PriseAppelServeur')
AddEventHandler('EMS:PriseAppelServeur', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local name = xPlayer.getName(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'ambulance' then
            TriggerClientEvent('EMS:AppelDejaPris', xPlayers[i], name)
        end
    end
end)

ESX.RegisterServerCallback('EMS:GetID', function(source, cb)
    local idJoueur = source
    cb(idJoueur)
end)

local AppelTotal = 0
RegisterServerEvent('EMS:AjoutAppelTotalServeur')
AddEventHandler('EMS:AjoutAppelTotalServeur', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local name = xPlayer.getName(source)
    local xPlayers = ESX.GetPlayers()
    AppelTotal = AppelTotal + 1

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'ambulance' then
            TriggerClientEvent('EMS:AjoutUnAppel', xPlayers[i], AppelTotal)
        end
    end

end)

RegisterServerEvent('EMS:SyncPNJ')
AddEventHandler('EMS:SyncPNJ', function()
    local _source = source
    TriggerClientEvent("EMS:NpcAppel", _source)
end)

RegisterNetEvent('kaiiroz:BuyKit')
AddEventHandler('kaiiroz:BuyKit', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('medikit', 1) then
        xPlayer.addInventoryItem('medikit', 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('kaiiroz:BuyBandage')
AddEventHandler('kaiiroz:BuyBandage', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('bandage', 2) then
        xPlayer.addInventoryItem('bandage', 2)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('Monsieur:creme')
AddEventHandler('Monsieur:creme', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('pommade', 1) then
        xPlayer.addInventoryItem('pommade', 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('Monsieur:medicament')
AddEventHandler('Monsieur:medicament', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('medicament', 1) then
        xPlayer.addInventoryItem('medicament', 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('Monsieur:canne')
AddEventHandler('Monsieur:canne', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('canne', 1) then
        xPlayer.addInventoryItem('canne', 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('Monsieur:plonger')
AddEventHandler('Monsieur:plonger', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('dive', 1) then
        xPlayer.addInventoryItem('dive', 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
    else
        TriggerClientEvent('esx:showNotification', _source, "Vous êtes trop lourd")
    end
end)

RegisterNetEvent('compteurp')
AddEventHandler('compteurp', function()
    compteur = compteur + 1
end)

RegisterNetEvent('compteurm')
AddEventHandler('compteurm', function()
    compteur = compteur - 1
end)

ESX.RegisterServerCallback('compteur', function(source, cb)
    cb(compteur)
end)

RegisterServerEvent('escorte')
AddEventHandler('escorte', function(target)
    local _source = source
    TriggerClientEvent('escorterr', target, _source)
end)

-- escorte

RegisterServerEvent('mettrevehicule')
AddEventHandler('mettrevehicule', function(target)
    TriggerClientEvent('mettrevehiculeclient', target)
end)

RegisterCommand('setheal', function(source, args, raw)
    TriggerClientEvent("heal", source)
end, true)

RegisterServerEvent('incapacite')
AddEventHandler('incapacite', function(inca, target, incapacite)
    local _source = source
    local checked
    local xPlayer = ESX.GetPlayerFromId(target)
    if check(inca,xPlayer) then
        xPlayer.removeMaladie(inca)
        TriggerClientEvent('esx:showNotification', _source, "Vous avez retirer l'incapacité " .. inca)
    else
        xPlayer.setMaladie(inca)
        TriggerClientEvent('esx:showNotification', _source, "Vous avez mis l'incapacité " .. inca)
    end
    TriggerClientEvent('incapacitevu', xPlayer.source, inca)
end)

function check (inca,xPlayer)
	for k, v in pairs(xPlayer.getMaladie()) do
        if v == inca then
            return true
        end
    end
	return false
end

ESX.RegisterServerCallback('getjobambulance', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local nombre = 0
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            nombre = nombre + 1
        end
    end
    cb(nombre)
end)