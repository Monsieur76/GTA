ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function AddLicense(target, type, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = type,
        ['@owner'] = xPlayer.identifier
    }, function(rowsChanged)
        local giveLicenceMessage = "Vous avez reçu le ~g~permis de port d'arme !"
        if type == "fishing" then
            giveLicenceMessage = "Vous avez reçu la ~g~licence de pêche !"
        elseif type == "hunting" then
            giveLicenceMessage = "Vous avez reçu le ~g~permis de chasse !"
        end
        TriggerClientEvent('esx:showNotification', xPlayer.source, giveLicenceMessage)
        if cb ~= nil then
            cb()
        end
    end)
end

function RemoveLicense(target, type, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
        ['@type'] = type,
        ['@owner'] = xPlayer.identifier
    }, function(rowsChanged)
        local removeLicenceMessage = "Votre permis de port d'arme a été ~r~retiré."
        if type == "fishing" then
            removeLicenceMessage = "Votre licence de pêche a été ~r~retirée."
        elseif type == "hunting" then
            removeLicenceMessage = "Votre permis de chasse a été ~r~retiré."
        end
        TriggerClientEvent('esx:showNotification', xPlayer.source, removeLicenceMessage)
        if cb ~= nil then
            cb()
        end
    end)
end

function GetLicense(type, cb)
    MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
        ['@type'] = type
    }, function(result)
        local data = {
            type = type,
            label = result[1].label
        }

        cb(data)
    end)
end

function GetLicenses(target, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        local licenses = {}
        local asyncTasks = {}

        for i = 1, #result, 1 do

            local scope = function(type)
                table.insert(asyncTasks, function(cb)
                    MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
                        ['@type'] = type
                    }, function(result2)
                        if result2 ~= nil and result2[1] ~= nil then
                            table.insert(licenses, {
                                type = type,
                                label = result2[1].label
                            })
                        end
                        cb()
                    end)
                end)
            end
            scope(result[i].type)
        end

        Async.parallel(asyncTasks, function(results)
            cb(licenses)
        end)

    end)
end

function CheckLicense(target, type, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
        ['@type'] = type,
        ['@owner'] = xPlayer.identifier
    }, function(result)
        if tonumber(result[1].count) > 0 then
            cb(true)
        else
            cb(false)
        end

    end)
end

function GetLicensesList(cb)
    MySQL.Async.fetchAll('SELECT * FROM licenses', {
        ['@type'] = type
    }, function(result)
        local licenses = {}

        for i = 1, #result, 1 do
            table.insert(licenses, {
                type = result[i].type,
                label = result[i].label
            })
        end
        cb(licenses)
    end)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
    AddLicense(target, type, cb)
    TriggerClientEvent("esx_license:licenseAdded", target, type)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
    RemoveLicense(target, type, cb)
    TriggerClientEvent("esx_license:licenseRemoved", target, type)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
    GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
    GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
    CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
    GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
    GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
    GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
    CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
    GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicenseCurrentUser', function(source, cb, type)
    CheckLicense(source, type, cb)
end)

ESX.RegisterCommand('getlicense', 'admin', function(xPlayer, args, showError)
    if not args.getlicense then
        args.getlicense = "PPA"
    end
    TriggerEvent('esx_license:addLicense', xPlayer.source, args.getlicense)
end, false, {
    help = "Permet de se donner un permis",
    validate = false,
    arguments = {{
        name = 'getlicense',
        help = "Nom du permis à get",
        type = 'any'
    }}
})

ESX.RegisterCommand('removelicense', 'admin', function(xPlayer, args, showError)
    if not args.removelicense then
        args.removelicense = "PPA"
    end
    TriggerEvent('esx_license:removeLicense', xPlayer.source, args.removelicense)
end, false, {
    help = "Permet de se remove un permis",
    validate = false,
    arguments = {{
        name = 'removelicense',
        help = "Nom du permis à remove",
        type = 'any'
    }}
})
