ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type, property)
    local xPlayer = ESX.GetPlayerFromId(ID)
    local _source = ESX.GetPlayerFromId(targetID).source
    local show = false
    -- local point = nil

    MySQL.Async.fetchAll(
        'SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(user)
            if (user[1] ~= nil) then
                user[1]["jobLabel"] = xPlayer.job.label -- .. "\n" .. xPlayer.job.grade_label
                MySQL.Async.fetchAll(
                    'SELECT type,point FROM user_licenses WHERE owner = @identifier ORDER BY CASE WHEN point IS NULL THEN 1 ELSE 0 END, point',
                    {
                        ['@identifier'] = xPlayer.identifier
                    }, function(licenses)
                        if type ~= nil then
                            for i = 1, #licenses, 1 do
                                if type == 'driver' then
                                    if licenses[i].type == 'drive' or licenses[i].type == 'bike' or licenses[i].type ==
                                        'truck' or licenses[i].type == 'PPA' then
                                        show = true
                                    end
                                elseif type == 'weapon' then
                                    if licenses[i].type == 'weapon' then
                                        show = true
                                    end
                                end
                            end
                        else
                            show = true
                        end
                        if show then
                            local propertyAddress = "//"
                            if property ~= nil then
                                propertyAddress = property.label
                            end
                            local array = {
                                user = user,
                                licenses = licenses,
                                property = propertyAddress
                                -- point = point
                            }
                            TriggerClientEvent('jsfour-idcard:open', _source, array, type)
                        else
                            TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas de permis")
                        end
                    end)
            end
        end)
end)
