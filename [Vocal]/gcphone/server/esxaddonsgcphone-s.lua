ESX = nil
local PhoneNumbers = {}

local JobMessageries = {{
    number = 'police',
    type = 'LSPD'
}, {
    number = 'taxi',
    type = 'Taxi'
}, {
    number = 'ambulance',
    type = 'LSMS'
}, {
    number = 'vigne',
    type = 'Vigneron'
}, {
    number = 'burgershot',
    type = 'Burger Shot'
}, {
    number = 'bahamas',
    type = 'Bahama Mamas'
}, {
    number = 'weazel',
    type = 'Weazel News'
}, {
    number = 'mechanic',
    type = 'Benny\'s'
}, {
    number = 'mairie',
    type = 'Mairie'
}, {
    number = 'brinks',
    type = 'UDST'
}, {
    number = 'pls',
    type = 'Ron'
}, {
    number = 'fbi',
    type = 'FBI'
}}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj

    for k, v in pairs(JobMessageries) do
        print('= INFO = Registered number for ' .. v.number .. ' => ' .. v.type)
        PhoneNumbers[v.number] = {
            type = v.type,
            sources = {}
        }
    end

end)

function notifyAlertSMS(number, alert, listSrc, fromNpc, gpsData)
    if PhoneNumbers[number] ~= nil then
        local messText = alert.message
        local mess = ''
        local fromNorth = false
        if gpsData ~= nil and number == "police" and gpsData.y > 1500.0 then
            fromNorth = true
        end
        if fromNpc == true then
            mess = "Citoyen : " .. messText
        else
            mess = 'Numéro #' .. alert.numero .. ' : ' .. messText
            if alert.coords ~= nil then
                mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y
            end
        end
        local groupGUID = uuid()
        for k, _ in pairs(listSrc) do
            local targetPlayer = tonumber(k)
            getPhoneNumber(targetPlayer, function(n)
                if n ~= nil then
                    TriggerEvent('gcPhone:_internalAddMessage', number, n, mess, 0, fromNpc, groupGUID, fromNorth,
                        function(smsMess)
                            TriggerClientEvent('gcPhone:receiveMessage', targetPlayer, smsMess, true)
                        end)
                end
            end)
        end

    end
end

function setTakenMessageNumber(source, message, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fullname = getFullName(xPlayer.identifier)
    MySQL.Sync.execute(
        "UPDATE phone_messages SET phone_messages.isTaken = 1, phone_messages.takenBy = @takenBy WHERE phone_messages.transmitter = @transmitter AND phone_messages.owner = 0 AND phone_messages.groupingId = @groupingId",
        {
            ['@takenBy'] = fullname,
            ['@transmitter'] = message.transmitter,
            ['@groupingId'] = message.groupingId
        })
    MySQL.Async.fetchAll('SELECT * FROM phone_messages WHERE phone_messages.id = @messageId', {
        ['@messageId'] = message.id
    }, function(result)
        if result[1] ~= nil and result[1].fromNpc == 0 then
            local targetId = getIdentifierByPhoneNumber(string.match(result[1].message,
                '[5-7][5-7][5-7]%-[0-9][0-9][0-9][0-9]'))
            local xTarget = ESX.GetPlayerFromIdentifier(targetId)
            TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, "Téléphone", "",
                "~o~Votre appel a été pris", 'CHAR_BARRY', 1)
            TriggerClientEvent("playNotifSound", xTarget.source)
        end
        MySQL.Async.fetchAll(
            'SELECT * FROM phone_messages WHERE phone_messages.owner = 0 AND phone_messages.groupingId = @groupingId',
            {
                ['@groupingId'] = message.groupingId
            }, function(messages)
                cb(fullname, messages);
            end)
    end)

end
AddEventHandler('esx:setJob', function(source, job, lastJob)
    local jobName = job.name
    if jobName == "policeNorth" then
        jobName = "police"
    end
    if PhoneNumbers[lastJob.name] ~= nil then
        TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, source)
    end

    if PhoneNumbers[jobName] ~= nil then
        TriggerEvent('esx_addons_gcphone:addSource', jobName, source)
    end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, source)
    PhoneNumbers[number].sources[tostring(source)] = true
    TriggerClientEvent("gcPhone:updateJob", source, number)
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, source)
    PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('esx_addons_gcphone:setTakenMessageNumber')
AddEventHandler('esx_addons_gcphone:setTakenMessageNumber', function(number, message)
    setTakenMessageNumber(source, message, function(takenBy, messages)
        if PhoneNumbers[number] ~= nil then
            for _, v in pairs(messages) do
                local targetId = getIdentifierByPhoneNumber(v.receiver)
                local xTarget = ESX.GetPlayerFromIdentifier(targetId)
                TriggerClientEvent('setMessageTakenTel', xTarget.source, v)
            end
        end
    end)
end)

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(number, message, gpsData, fromNpc)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if number == "policeNorth" then
        number = "police"
    end
    if gpsData == nil and not fromNpc then
        gpsData = xPlayer.getCoords()
    end
    if PhoneNumbers[number] ~= nil then
        if not fromNpc then
            getPhoneNumber(source, function(phone)
                notifyAlertSMS(number, {
                    message = message,
                    numero = phone,
                    source = xPlayer.source
                }, PhoneNumbers[number].sources, fromNpc, gpsData)
            end)
        else
            notifyAlertSMS(number, {
                message = message
            }, PhoneNumbers[number].sources, fromNpc, gpsData)
        end
    end
end)

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function(number, message, coords)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
        getPhoneNumber(source, function(phone)
            notifyAlertSMS(number, {
                message = message,
                coords = coords,
                numero = phone,
                source = sourcePlayer
            }, PhoneNumbers[number].sources)
        end)
    else
        print('= WARNING = Trying to call an unregistered service => numero : ' .. number)
    end
end)

AddEventHandler('esx:playerLoaded', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)

        local phoneNumber = result[1].phone_number
        xPlayer.set('phoneNumber', phoneNumber)

        if PhoneNumbers[xPlayer.job.name] ~= nil then
            TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, source)
        end
    end)

end)

AddEventHandler('esx:playerDropped', function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if PhoneNumbers[xPlayer.job.name] ~= nil then
        TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, source)
    end
end)

function getPhoneNumber(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then
        callback(nil)
    end
        callback(xPlayer.getphone())
end

RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(number, message, _, coords)
    local source = source
    if PhoneNumbers[number] ~= nil then
        getPhoneNumber(source, function(phone)
            notifyAlertSMS(number, {
                message = message,
                coords = coords,
                numero = phone
            }, PhoneNumbers[number].sources)
        end)
    else
        -- print('esx_phone:send | Appels sur un service non enregistre => numero : ' .. number)
    end
end)

function getIdentifierByPhoneNumber(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

local random = math.random
function uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end
