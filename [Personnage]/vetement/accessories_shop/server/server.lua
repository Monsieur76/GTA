ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("dqp:SetNewMasque")
AddEventHandler("dqp:SetNewMasque", function(mask,variation)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local first = true
  local accesories = nil
  local charactere = {}
  local money =xPlayer.getMoney()
  if money >= 350 then
    xPlayer.removeMoney(350)
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
    accesories["mask_1"]= mask
    accesories["mask_2"]= variation
if first then
  MySQL.Sync.execute(
    'INSERT INTO user_accessories (identifier,mask) VALUES(@identifier,@mask)',
    {
      ['@mask'] = json.encode(accesories),
    ['@identifier'] =  xPlayer.identifier
    }
  )
else
  MySQL.Sync.execute(
    'UPDATE user_accessories SET `mask` = @mask WHERE identifier=@identifier',
    {
      ['@mask'] = json.encode(accesories),
      ['@identifier'] =  xPlayer.identifier
    }
  )
  TriggerClientEvent("esx:showNotification",_source,"~g~Vous avez acheté un nouveau masque à 350$" )
end
else
  TriggerClientEvent('esx:showNotification', _source, 'Pas assez d\'argent (350$)')
end
end)



RegisterServerEvent('dqp:GiveAccessories')
AddEventHandler('dqp:GiveAccessories', function(target,id,label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayer2 = ESX.GetPlayerFromId(target)
	MySQL.Async.execute(
		'UPDATE user_accessories SET identifier = @identifier WHERE id = @id',
		{
			['@identifier']   = xPlayer2.identifier,
			['@id'] = id

		}
	)
			TriggerClientEvent('esx:showNotification', _source, '~r~-1 '.. label)
			TriggerClientEvent('esx:showNotification', target, '~g~+1 '.. label)
		
			TriggerClientEvent("dqp:SyncAccess",source)
			TriggerClientEvent("dqp:SyncAccess",target)

end)


RegisterServerEvent('dqp:Delclo')
AddEventHandler('dqp:Delclo', function(id,label,data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
			MySQL.Async.execute(
				'DELETE FROM user_accessories where id = @id',
				{
					['@id']   = id,
				}
			)
			TriggerClientEvent('esx:showNotification', _source, '~r~-1 '.. label)
end)

RegisterServerEvent("dqp:RenameMasque")
AddEventHandler("dqp:RenameMasque", function(id,txt,type)
  MySQL.Async.execute(
    'UPDATE user_accessories SET label = @label WHERE id=@id',
    {
      ['@id'] = id,
      ['@label'] = txt

    }
  )
 -- TriggerClientEvent('dqp:MenuInvOpen',source)
  TriggerClientEvent("esx:showNotification",source,"Vous avez bien renommé votre "..type.." en "..txt)

end)

ESX.RegisterServerCallback('dqp:getMask', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll(
      'SELECT * FROM user_accessories WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
        cb(result)
      --  --(json.encode(result))
    end )
  end)



  ESX.RegisterServerCallback("dqp:getSelect", function(cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll(
      'SELECT * FROM user_accessories WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
      --  --(json.encode(result))
        cb(result)
    end )
  
  end)


  
  ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)
    local xPlayer = ESX.GetPlayerFromId(source)
  
    TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
      local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
      local skin = (store.get('skin') and store.get('skin') or {})
  
      cb(hasAccessory, skin)
    end)
  
  end)

  RegisterServerEvent('esx_accessories:save')
AddEventHandler('esx_accessories:save', function(skin, accessory)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		store.set('has' .. accessory, true)

		local itemSkin = {}
		local item1 = string.lower(accessory) .. '_1'
		local item2 = string.lower(accessory) .. '_2'
		itemSkin[item1] = skin[item1]
		itemSkin[item2] = skin[item2]

		store.set('skin', itemSkin)
	end)
end)