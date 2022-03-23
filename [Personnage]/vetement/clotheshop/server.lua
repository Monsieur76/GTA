ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('VmLife:DeleteTenue')
AddEventHandler('VmLife:DeleteTenue', function(label)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('DELETE FROM clotheuser WHERE Label = @label and SteamId=@identifier', {
        ['@label'] = label,
        ['@identifier'] = xPlayer.identifier
    })
    TriggerClientEvent("esx:showNotification", source, "Tenue supprimé")

end)

RegisterServerEvent('VmLife:RenameTenue')
AddEventHandler('VmLife:RenameTenue', function(ancienLabel, newLabel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('UPDATE clotheuser SET Label = @label WHERE Label = @label1 and SteamId=@identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@label'] = newLabel,
        ['@label1'] = ancienLabel
    })

    TriggerClientEvent("esx:showNotification", source, "Vous avez bien renommé votre tenue en " .. newLabel)

end)

ESX.RegisterServerCallback('Mushy:getMask', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM user_accessories WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)

        cb(result)
        --  --(json.encode(result))

    end)

end)

ESX.RegisterServerCallback('VmLife:Select', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT LabelClothe FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
      if result[1] ~= nil and result[1].LabelClothe ~= nil then
        cb(result[1].LabelClothe)
      end
    end)
end)

RegisterServerEvent('VmLife:RenameLabelUser')
AddEventHandler('VmLife:RenameLabelUser', function(label)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('UPDATE users SET `LabelClothe` = @label WHERE identifier=@identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@label'] = label
    })
end)

RegisterServerEvent('VmLife:SaveTenueS')
AddEventHandler('VmLife:SaveTenueS', function(label, skin)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute('INSERT INTO clotheuser (SteamId,Clothe,Label) VALUES(@identifier,@skin,@label)', {
        ['@label'] = label,
        ['@skin'] = json.encode(skin),
        ['@identifier'] = xPlayer.identifier
    })

end)

ESX.RegisterServerCallback('VmLife:GetTenues', function(source, cb, _)
    -- ("ss")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM clotheuser WHERE SteamId = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('Monsieur:UpdateClotheShop')
AddEventHandler('Monsieur:UpdateClotheShop', function(clothe, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE clotheuser SET `Clothe` = @clothe WHERE SteamId = @identifier and `Label`=@label', {
        ['@clothe'] = json.encode(clothe),
        ['@identifier'] = xPlayer.identifier,
        ['@label'] = label
    })

end)

ESX.RegisterServerCallback('verifMoneyShop', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount("money").money >= price then
        xPlayer.removeMoney(50)
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez payé " .. price .. "$ ! ")
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('shop:price')
AddEventHandler('shop:price', function(prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()
	xPlayer.removeMoney(prix)
  TriggerClientEvent('usemalette', source,xPlayer.get('money'))
	TriggerClientEvent('esx:showNotification', source, "~y~Shop~w~ : Vous avez payé "..prix.."$ ! ")
end)