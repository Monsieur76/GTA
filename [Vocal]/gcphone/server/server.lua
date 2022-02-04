ESX = nil
local DataStoreMessage ={}
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

math.randomseed(os.time())


MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM phone_messages', {}, function(historiqueMessage)

        for i = 1, #historiqueMessage, 1 do
            local id = nil
            local transmitter = nil
            local receiver = nil
            local message = nil
            local time = nil
            local isRead = nil
            local owner = nil
            local isTaken = nil
            local takenBy = nil
            local fromNpc = nil
            local groupGUID = nil
            local fromNorth = nil

            if historiqueMessage[i].id ~= nil then
                id = historiqueMessage[i].id
            end

            if historiqueMessage[i].transmitter ~= nil then
                transmitter = historiqueMessage[i].transmitter
            end

            if historiqueMessage[i].receiver ~= nil then
                receiver = historiqueMessage[i].receiver
            end

            if historiqueMessage[i].message ~= nil then
                message = historiqueMessage[i].message
            end

            if historiqueMessage[i].time ~= nil then
                time = historiqueMessage[i].time
            end

            if historiqueMessage[i].isRead ~= nil then
                isRead = historiqueMessage[i].isRead
            end

            if historiqueMessage[i].owner ~= nil then
                owner = historiqueMessage[i].owner
            end

            if historiqueMessage[i].isTaken ~= nil then
                isTaken = historiqueMessage[i].isTaken
            end

            if historiqueMessage[i].takenBy ~= nil then
                takenBy = historiqueMessage[i].takenBy
            end

            if historiqueMessage[i].fromNpc ~= nil then
                fromNpc = historiqueMessage[i].fromNpc
            end

            if historiqueMessage[i].groupGUID ~= nil then
                groupGUID = historiqueMessage[i].groupGUID
            end

            if historiqueMessage[i].fromNorth ~= nil then
                fromNorth = historiqueMessage[i].fromNorth
            end

            Citizen.Wait(10)
            DataStoreMessage[id]=CreateDataStore(transmitter, receiver, message, time, isRead, owner, isTaken, takenBy, fromNpc, groupGUID,fromNorth)
        end
        print('historique ready')
    end)
end)


--- For phone number style XXX-XXXX
function getPhoneRandomNumber()
    local numBase1 = math.random(0, 9999)
    local num = string.format("%03d-%04d", 555, numBase1)
    return num
end

--- For this style 06XXXXXXXX Remove the -- from the next 3 lines
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end

--[[
  Ouverture du téphone lié a un item
  Un solution ESC basé sur la solution donnée par HalCroves
  https://forum.fivem.net/t/tutorial-for-gcphone-with-call-and-job-message-other/177904
--]]

ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
    -- print('gcphone:getItemAmount call item : ' .. item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)

    if items == nil then
        cb(0)
    else
        cb(items.count)
    end
end)

-- ====================================================================================
--  SIM CARDS // Thanks to AshKetchumza for the idea an some code.
--  TO ENABLE SIM CARDS, Remove --[[ & ]]-- on lines 49 and 76.
-- ====================================================================================

--[[
RegisterServerEvent('gcPhone:useSimCard')
AddEventHandler('gcPhone:useSimCard', function(source, identifier)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local myPhoneNumber = nil
    repeat
        myPhoneNumber = getPhoneRandomNumber()
        local id = getIdentifierByPhoneNumber(myPhoneNumber)
    until id == nil
    MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", { 
        ['@myPhoneNumber'] = myPhoneNumber,
        ['@identifier'] = xPlayer.identifier
    }, function (rows)
        xPlayer.removeInventoryItem('sim_card', 1)
        local num = getNumberPhone(xPlayer.identifier)
        TriggerClientEvent("gcPhone:myPhoneNumber", _source, num)
        TriggerClientEvent("gcPhone:contactList", _source, getContacts(identifier))
        TriggerClientEvent("gcPhone:allMessage", _source, getMessages(identifier))
        sendHistoriqueCall(_source, num)
    end)
end)


ESX.RegisterUsableItem('sim_card', function (source)
    TriggerEvent('gcPhone:useSimCard', source)
end)
]] --

-- ====================================================================================
--  Utils
-- ====================================================================================
function getSourceFromIdentifier(identifier, cb)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if (xPlayer.identifier ~= nil and xPlayer.identifier == identifier) or (xPlayer.identifier == identifier) then
            cb(xPlayer.source)
            return
        end
    end
    cb(nil)
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function getOrGeneratePhoneNumber(identifier, cb)
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", {
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end
-- ====================================================================================
--  Contacts
-- ====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll(
        "SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier", {
            ['@identifier'] = identifier
        })
    return result
end

function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert(
        "INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
            ['@identifier'] = identifier,
            ['@number'] = number,
            ['@display'] = display
        }, function()
            notifyContactChange(sourcePlayer, identifier)
        end)
end

function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", {
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id
    }, function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id
    })
    notifyContactChange(sourcePlayer, identifier)
end

function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end

function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteContact(sourcePlayer, identifier, id)
end)

-- ====================================================================================
--  Messages
-- ====================================================================================
function getMessages(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    --local result = MySQL.Sync.fetchAll(
    --    "SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number",
    --    {
    --        ['@identifier'] = identifier
    --    })
    local finalResult = {}
    for _, v in pairs(DataStoreMessage) do
        --if v.transmitter:match('[5-7][5-7][5-7]%-[0-9][0-9][0-9][0-9]') or v.transmitter == xPlayer.job.name then
        if v.receiver == xPlayer.getphone() or v.transmitter == xPlayer.job.name then
            table.insert(finalResult, v)
        end
    end
    return finalResult
    -- return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, fromNpc, groupGUID, fromNorth, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner, fromNpc, groupGUID, fromNorth))
end)

function _internalAddMessage(transmitter, receiver, message, owner, fromNpc, groupGUID, fromNorth)
    local Query =
        "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`,`fromNpc`,`groupingId`,`fromNorth`) VALUES(@transmitter, @receiver, @message, @isRead, @owner, @fromNpc, @groupingId, @fromNorth);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
    local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner,
        ['@fromNpc'] = fromNpc,
        ['@groupingId'] = groupGUID,
        ['@fromNorth'] = fromNorth
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    DataStoreMessage[id]=CreateDataStore(transmitter, receiver, message, 0, owner, owner, 0, nil, fromNpc, groupGUID,fromNorth)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message, gps_data)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)

    -- Config.JobMessageries
    if otherIdentifier ~= nil then
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0, false)
        getSourceFromIdentifier(otherIdentifier, function(osou)
            local targetPlayer = tonumber(osou)
            if targetPlayer ~= nil then
                -- TriggerClientEvent("gcPhone:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("gcPhone:receiveMessage", targetPlayer, tomess)
            end
        end)
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1, false)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute(
        "UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter",
        {
            ['@receiver'] = mePhoneNumber,
            ['@transmitter'] = num
        })
end

function getFullName(identifier)
    local result = MySQL.Sync.fetchAll(
        "SELECT users.firstname, users.lastname FROM users WHERE users.identifier = @identifier", {
            ['@identifier'] = identifier
        })
    if result[1] ~= nil then
        return result[1].firstname .. " " .. result[1].lastname
    end
    return nil
end
function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number",
        {
            ['@mePhoneNumber'] = mePhoneNumber,
            ['@phone_number'] = phone_number
        })
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message, gpsData, fromNpc)
    if not fromNpc then
        local _source = source
        local sourcePlayer = tonumber(_source)
        xPlayer = ESX.GetPlayerFromId(_source)
        identifier = xPlayer.identifier
        addMessage(sourcePlayer, identifier, phoneNumber, message, gpsData)
    end
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessageFromPhoneNumber(sourcePlayer, identifier, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

-- ====================================================================================
--  Gestion des appels
-- ====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall(num)
    local result = MySQL.Sync.fetchAll(
        "SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
            ['@num'] = num
        })
    return result
end

function sendHistoriqueCall(src, num)
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels(appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert(
            "INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)",
            {
                ['@owner'] = appelInfo.transmitter_num,
                ['@num'] = appelInfo.receiver_num,
                ['@incoming'] = 1,
                ['@accepts'] = appelInfo.is_accepts
            }, function()
                notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
            end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "###-####"
        end
        MySQL.Async.insert(
            "INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)",
            {
                ['@owner'] = appelInfo.receiver_num,
                ['@num'] = num,
                ['@incoming'] = 0,
                ['@accepts'] = appelInfo.is_accepts
            }, function()
                if appelInfo.receiver_src ~= nil then
                    notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
                end
            end)
    end
end

function notifyNewAppelsHisto(src, num)
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(identifier)
    sendHistoriqueCall(sourcePlayer, num)
end)

RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)

    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(identifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= identifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }

    if is_valid == true then
        getSourceFromIdentifier(destPlayer, function(srcTo)
            if srcTo ~= nill then
                AppelsEnCours[indexCall].receiver_src = srcTo
                TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                local xPlayer = ESX.GetPlayerFromId(srcTo)
                local hasPhone = xPlayer.getInventoryItem('phone').count
                --print(hasPhone)
                if hasPhone >= 1 and Config.ItemRequired then
                    TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
                elseif hasPhone == 0 and Config.ItemRequired then
                    print("no phone")
                elseif not Config.ItemRequired then
                    TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
                end
            else
                TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end)
    else
        TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end
end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    local _source = source
    TriggerEvent('gcPhone:internal_startCall', _source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function(callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local _source = source
        local to = AppelsEnCours[callId].transmitter_src
        if _source == to then
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)

RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then

        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src ~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            SetTimeout(1000, function() -- change to +1000, if necessary.
                TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            end)
            saveAppels(AppelsEnCours[id])

            exports['saltychat']:EstablishCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src)
            exports['saltychat']:EstablishCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src)
        end
    end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function(infoCall)
    local _source = source
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
            exports['saltychat']:EndCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src)
            exports['saltychat']:EndCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
            exports['saltychat']:EndCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src)
            exports['saltychat']:EndCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function(numero)
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    appelsDeleteAllHistorique(identifier)
end)

-- ====================================================================================
--  OnLoad
-- ====================================================================================
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local sourcePlayer = playerId
    local identifier = xPlayer.identifier
    local num = getNumberPhone(identifier)

    getOrGeneratePhoneNumber(identifier, function(myPhoneNumber)
        TriggerClientEvent('gcPhone:myPhoneNumber', sourcePlayer, myPhoneNumber)
        TriggerClientEvent("gcPhone:updateJob", sourcePlayer, xPlayer.job.name)
        TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(identifier))
        TriggerClientEvent('gcPhone:allMessage', sourcePlayer, getMessages(identifier))
        sendHistoriqueCall(sourcePlayer, num)
    end)
end)
RegisterCommand("loadPhone", function(source, args)
    local sourcePlayer = source
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
    local identifier = xPlayer.identifier
    local num = getNumberPhone(identifier)

    getOrGeneratePhoneNumber(identifier, function(myPhoneNumber)
        TriggerClientEvent('gcPhone:myPhoneNumber', sourcePlayer, myPhoneNumber)
        TriggerClientEvent("gcPhone:updateJob", sourcePlayer, xPlayer.job.name)
        TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(identifier))
        TriggerClientEvent('gcPhone:allMessage', sourcePlayer, getMessages(identifier))
        sendHistoriqueCall(sourcePlayer, num)
    end)
end)
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do
        Citizen.Wait(10000)
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    local identifier = xPlayer.identifier
    local num = getNumberPhone(identifier)
    TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(identifier))
    TriggerClientEvent("gcPhone:updateJob", sourcePlayer, xPlayer.job.name)
    sendHistoriqueCall(sourcePlayer, num)
end)

--[[ AddEventHandler('onMySQLReady', function ()
    MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end) --]]

-- ====================================================================================
--  App ... WIP
-- ====================================================================================
-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)

-- end)

-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)

-- end)
