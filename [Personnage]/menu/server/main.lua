ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function getMaximumGrade(jobname)

    local result = MySQL.Sync.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {

        ['@jobname'] = jobname

    })

    if result[1] ~= nil then

        return result[1].grade

    end

    return nil

end

function getAdminCommand(name)

    for i = 1, #Config.Admin, 1 do

        if Config.Admin[i].name == name then

            return i

        end

    end

    return false

end

function isAuthorized(index, group)

    for i = 1, #Config.Admin[index].groups, 1 do

        if Config.Admin[index].groups[i] == group then

            return true

        end

    end

    return false

end

ESX.RegisterServerCallback('KorioZ-PersonalMenu:Getasccesorie', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local accessories = {}
    local casque = {}
    MySQL.Async.fetchAll('SELECT * FROM user_accessories WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] ~= nil then
            accessories = json.decode(result[1].mask)
            casque = json.decode(result[1].casque)
        end
        cb(accessories, casque)
    end)
end)

ESX.RegisterServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    local plyGroup = xPlayer.getGroup()

    if plyGroup ~= nil then

        cb(plyGroup)

    else

        cb('user')

    end

end)

-- Weapon Menu --

RegisterServerEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedS')

AddEventHandler('KorioZ-PersonalMenu:Weapon_addAmmoToPedS', function(plyId, value, quantity)

    if #(GetEntityCoords(source, false) - GetEntityCoords(plyId, false)) <= 3.0 then

        TriggerClientEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedC', plyId, value, quantity)

    end

end)

ESX.RegisterServerCallback('weight', function(source, cb, sac)
    local xPlayer = ESX.GetPlayerFromId(source)
    local weight = xPlayer.getWeight()
    if weight < sac then
        cb(true)
    else
        cb(false)
    end
end)

--ESX.RegisterServerCallback('getPlayerVehiclesKeys', function(source, cb)
 --   local xPlayer = ESX.GetPlayerFromId(source)
   -- MySQL.Async.fetchAll('SELECT * FROM open_car WHERE identifier = @identifier', {
 --       ['@identifier'] = xPlayer.identifier
 --   }, function(result)
 --       if result ~= nil then
 --           cb(result)
--        end
--    end)
--end)

RegisterServerEvent('Monsieur:save')
AddEventHandler('Monsieur:save', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    ESX.SavePlayer(xPlayer)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "Position sauvegardée")
end)


RegisterServerEvent('Monsieur:giveWeapon')
AddEventHandler('Monsieur:giveWeapon', function(target_id,name,ammo,label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target_id)
    --if xTarget.hasWeapon(name) ~= name then
        xPlayer.removeWeapon(name)
        xPlayer.removeWeaponAmmo(name, ammo)
        xTarget.addWeapon(name, ammo)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez donné ~r~"..label.." avec "..ammo.." munition")
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez reçu ~g~"..label.." avec "..ammo.." munition")
        TriggerClientEvent('refreshloadout', xPlayer.source,xPlayer.getLoadout())
        TriggerClientEvent('refreshloadout', xTarget.source,xPlayer.getLoadout())
    --else
     --   TriggerClientEvent('esx:showNotification', xPlayer.source, "Arme déjà possédé")
   -- end
end)

ESX.RegisterServerCallback('getloadoutrefresh', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getLoadout())
end)
