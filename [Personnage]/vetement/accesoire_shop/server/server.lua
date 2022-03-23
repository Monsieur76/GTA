ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("dqp:SetAccessorie")
AddEventHandler("dqp:SetAccessorie", function(acces,variation,type)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local first = true
  local accesories = {}

  if xPlayer.getAccount("money").money >= 25 then
    xPlayer.removeMoney(25)

    local result = MySQL.Sync.fetchAll(
      'SELECT * FROM user_accessories WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      })
      for k,v in ipairs(result) do
        if result[k].mask ~= nil then
            accesories = json.decode(result[k].mask)
            first = false
        end
      end
if type == 1 then
    accesories["glasses_1"]= acces
    accesories["glasses_2"]= variation
elseif type == 7 then
    accesories["chain_1"]= acces
    accesories["chain_2"]= variation
elseif type == 2 then
    accesories["ears_1"]= acces
    accesories["ears_2"]= variation
  elseif type == 6 then
    accesories["watches_1"]= acces
    accesories["watches_2"]= variation
  elseif type == 0 then
    accesories["helmet_1"]= acces
    accesories["helmet_2"]= variation
  elseif type == 4 then
    accesories["bracelets_1"]= acces
    accesories["bracelets_2"]= variation
end
if first then
  MySQL.Sync.execute(
    'INSERT INTO user_accessories (identifier,mask) VALUES(@identifier,@mask)',
    {
      ['@mask'] = json.encode(accesories),
    ['@identifier'] =  xPlayer.identifier
    }
  )
  TriggerClientEvent("esx:showNotification",_source,"Accessoire acheté ~r~25$" )
else
  MySQL.Sync.execute(
    'UPDATE user_accessories SET `mask` = @mask WHERE identifier=@identifier',
    {
      ['@mask'] = json.encode(accesories),
      ['@identifier'] =  xPlayer.identifier
    }
  )
  TriggerClientEvent("esx:showNotification",_source,"Accessoire acheté ~r~25$" )
end
else
  TriggerClientEvent('esx:showNotification', _source, 'Pas assez d\'argent (25$)')
end
end)


RegisterServerEvent("dqp:SetAccessorieCasque")
AddEventHandler("dqp:SetAccessorieCasque", function(acces,variation)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local first = true
  local accesories = {}
  if xPlayer.getAccount("money").money >= 25 then
    xPlayer.removeMoney(25)

    local result = MySQL.Sync.fetchAll(
      'SELECT * FROM user_accessories WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      })
      for k,v in ipairs(result) do
        if result[k].casque ~= nil then
            accesories = json.decode(result[k].casque)
            first = false
        end
      end
      accesories["helmet_1"]= acces
      accesories["helmet_2"]= variation
if first then
  MySQL.Sync.execute(
    'INSERT INTO user_accessories (identifier,casque) VALUES(@identifier,@casque)',
    {
      ['@casque'] = json.encode(accesories),
    ['@identifier'] =  xPlayer.identifier
    }
  )
  TriggerClientEvent("esx:showNotification",_source,"Accessoire acheté ~r~25$" )
else
  MySQL.Sync.execute(
    'UPDATE user_accessories SET `casque` = @casque WHERE identifier=@identifier',
    {
      ['@casque'] = json.encode(accesories),
      ['@identifier'] =  xPlayer.identifier
    }
  )
  TriggerClientEvent("esx:showNotification",_source,"Accessoire acheté ~r~25$" )
end
else
  TriggerClientEvent('esx:showNotification', _source, 'Pas assez d\'argent (25$)')
end
end)

