ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterNetEvent('registerDocument')
AddEventHandler('registerDocument', function(data)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
MySQL.Async.insert("INSERT INTO user_documents (owner, data,society) VALUES (@owner, @data,@society)", {
    ['@owner'] = xPlayer.identifier,
     ['@data'] = json.encode(data),
     ['@society'] = data.headerJobLabel
    })

end)



RegisterNetEvent('DocumentDelete')
AddEventHandler('DocumentDelete', function(id,society)
MySQL.Async.execute('DELETE FROM user_documents WHERE id = @id AND society = @society',
{
    ['@id']  = id,
    ['@society'] = society,
})
end)



ESX.RegisterServerCallback('esx_documents:getPlayerDocuments', function(source, cb,society)
    local xPlayer = ESX.GetPlayerFromId(source)
    local forms = {}
    if xPlayer ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM user_documents WHERE society = @society", {['@society'] = society}, function(result)
        local found = false
        if result[1] then
            found = true
        end
        if found then
           if #result > 0 then

                for i=1, #result, 1 do

                    local tmp_result = result[i]
                    tmp_result.data = json.decode(result[i].data)

                    table.insert(forms, tmp_result)
                end
                cb(forms)
            end
        else
            cb (false)
        end 
    end)
    end
end)


ESX.RegisterServerCallback('esx_documents:getPlayerDetails', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cb_data = nil

    MySQL.Async.fetchAll("SELECT firstname, lastname, dateofbirth FROM users WHERE identifier = @owner", {['@owner'] = xPlayer.identifier}, function(result)

        if result[1] ~= nil then
            cb_data = result[1]
            cb(cb_data)
        else
            cb(cb_data)
        end

    end)

end)


RegisterServerEvent('esx_documents:ShowToPlayer')
AddEventHandler('esx_documents:ShowToPlayer', function(targetID, aForm)

    TriggerClientEvent('esx_documents:viewDocument', targetID, aForm)

end)