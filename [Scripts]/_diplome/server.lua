ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('diploma:payDiploma')
AddEventHandler('diploma:payDiploma', function(price)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(price)
    TriggerClientEvent('usemalette', xPlayer.source,
        xPlayer.getAccount("black_money").money + xPlayer.getAccount("money").money)
end)

ESX.RegisterServerCallback('diploma:grantDiploma', function(source, cb, diplomaName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setDiplomas(diplomaName)
    MySQL.Async.execute('UPDATE users SET diplomas = @diplomas WHERE identifier = @identifier', {
        ['@diplomas'] = json.encode(xPlayer.getDiplomas()),
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(xPlayer.getDiplomas())
    end)
end)
ESX.RegisterServerCallback('diploma:enoughMoneyForDiploma', function(source, cb, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        cb(true)
    else
        cb(false)
    end
end)
ESX.RegisterServerCallback('diploma:getPlayerDetails', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cb_data = nil

    MySQL.Async.fetchAll("SELECT firstname, lastname, diplomas FROM users WHERE identifier = @owner", {
        ['@owner'] = xPlayer.identifier
    }, function(usersFound)
        if usersFound[1] ~= nil then
            cb_data = usersFound[1]
            cb(cb_data)
        else
            cb(cb_data)
        end
    end)

end)

RegisterServerEvent('diploma:open')
AddEventHandler('diploma:open', function(ID, targetID, type)
    local identifier = ESX.GetPlayerFromId(ID).identifier
    local _source = ESX.GetPlayerFromId(targetID).source
    local show = false
    -- local point = nil

    MySQL.Async.fetchAll('SELECT firstname, lastname, diplomas FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(user)
        if (user[1] ~= nil) then
            if #user[1].diplomas > 0 then
                local array = {
                    user = {
                        firstname = user[1].firstname,
                        lastname = user[1].lastname
                    },
                    diplomas = user[1].diplomas
                    -- point = point
                }
                TriggerClientEvent('diploma:open', _source, array)
            else
                TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas de diplôme")
            end
        end
    end)
end)
