ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('RubyMenu:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	print(GetPlayerName(source).." - "..group)
	cb(group)
end)

RegisterServerEvent("Administration:GiveCash")
AddEventHandler("Administration:GiveCash", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addAccountMoney("money",total)
    sendToDiscord(xPlayer.getName(),"```Give de : ```"..total.."``` money en liquide```",56108)
    TriggerClientEvent('usemalette', xPlayer.source,xPlayer.getAccount("black_money").money+xPlayer.getAccount("money").money)
    local item = '~g~$ en liquide.'
    local message = '~g~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
end)

RegisterServerEvent("Administration:GiveBanque")
AddEventHandler("Administration:GiveBanque", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addAccountMoney('bank', total)
    sendToDiscord(xPlayer.getName(),"```Give de : ```"..total.."``` money en banque```",56108)
    local item = '~b~$ en banque.'
    local message = '~b~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
end)

RegisterServerEvent("Administration:GiveND")
AddEventHandler("Administration:GiveND", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    sendToDiscord(xPlayer.getName(),"```Give de : ```"..total.."``` money sale```",56108)
    xPlayer.addAccountMoney('black_money', total)
    TriggerClientEvent('usemalette', xPlayer.source,xPlayer.getAccount("black_money").money+xPlayer.getAccount("money").money)
    local item = '~r~$ d\'argent sale.'
    local message = '~r~Give de : '
    TriggerClientEvent('esx:showNotification', _source, message..total..item)
end)

RegisterNetEvent("hAdmin:Message")
AddEventHandler("hAdmin:Message", function(id, type)
	TriggerClientEvent("hAdmin:envoyer", id, type)
end)


ESX.RegisterServerCallback('serversessionid', function(source, cb)
    local data ={}
    local xTarget = ESX.GetPlayers()
    for i=1, #xTarget ,1 do
        local xTarget = ESX.GetPlayerFromId(xTarget[i])
            ped = GetPlayerPed(xTarget.source)
            table.insert(data,{id=xTarget.source,name=xTarget.getName(),coord=GetEntityCoords(ped)})
    end
	cb(data)
end)


RegisterCommand('tpcoord', function(source, args, raw)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if (source > 0) then
        local x = tonumber(args[1])
        local y = tonumber(args[2])
        local z = tonumber(args[3])
        SetEntityCoords(_source, x, y, z, true, true, true, true)
    end
    sendToDiscord(xPlayer.getName(),"```Tp Coord ```",56108)
end)

RegisterCommand('plate', function(source, args, raw)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local plate = args[1]
    TriggerClientEvent('client:ChangePlate', _source, plate)
    sendToDiscord(xPlayer.getName(),"```Changement plaque```",56108)
end)


function sendToDiscord(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Le staff vous voit",
              },
          }
      }
    PerformHttpRequest("https://discord.com/api/webhooks/920734310355599361/xcXEB5s27UqGuhrns8nGtQh8HS1SwXZ-BvbLjGRm89TsvuyzuO3Fc4JtGe5cM-YH3J8g", function(err, text, headers) end, 'POST', json.encode({username = "Tales - GTA RP", embeds = connect, avatar_url = "https://zupimages.net/up/21/50/vshz.jpg"}), { ['Content-Type'] = 'application/json' })
  end