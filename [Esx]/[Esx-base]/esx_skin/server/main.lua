ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
    {
      ['@skin']       = json.encode(skin),
      ['@identifier'] = xPlayer.identifier
    }
  )

end)

RegisterServerEvent('esx_skin:saveFirst')
AddEventHandler('esx_skin:saveFirst', function(Character)
  local xPlayer = ESX.GetPlayerFromId(source)
print('saveskin')
  MySQL.Async.execute(
    'UPDATE users SET `skin` = @skin,`LabelClothe`=@LabelClothe WHERE identifier = @identifier',
    {
      ['@skin']       = json.encode(Character),
      ['@identifier'] = xPlayer.identifier,
      ['@LabelClothe'] = "Tenue de base",
    }
  )

end)

RegisterServerEvent('esx_skin:saveClothe')
AddEventHandler('esx_skin:saveClothe', function(clothe,label)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'INSERT INTO clotheuser (`SteamId`,`Clothe`,`Label`) VALUES (@identifier ,@clothe,@label)',
    {
      ['@identifier'] = xPlayer.identifier,
      ['@clothe']       = json.encode(clothe),
      ['@label'] = label
    }
  )

end)

RegisterServerEvent('esx_skin:saveAcess')
AddEventHandler('esx_skin:saveAcess', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'INSERT INTO user_accessories (`identifier`,`mask`) VALUES (@identifier ,@mask)',
    {
      ['@mask']       = json.encode(skin),
      ['@identifier'] = xPlayer.identifier
    }
  )
end)

RegisterServerEvent('esx_skin:UpdateClothe')
AddEventHandler('esx_skin:UpdateClothe', function(clothe,label)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'UPDATE clotheuser SET `Clothe` = @clothe,`Label`=@label WHERE identifier = @identifier',
    {
      ['@clothe']       = json.encode(clothe),
      ['@identifier'] = xPlayer.identifier,
      ['@label'] = label
    }
  )
  MySQL.Async.execute(
    'UPDATE users SET `LabelClothe` = @LabelClothe WHERE identifier = @identifier',
    {
      ['@LabelClothe'] = label,
      ['@identifier'] = xPlayer.identifier
    }
  )

end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

  local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

  file:write(json.encode(skin) .. "\n\n")
  file:flush()
  file:close()

end)

RegisterServerEvent('weightextended')
AddEventHandler('weightextended', function(sac)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setMaxWeight(sac)
    TriggerClientEvent("setDataMaxWeight", xPlayer.source, sac)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)

      local user = users[1]
      local label = nil
      local skin = nil
      local clothe = nil
      local acces = nil

      if user.skin ~= nil then
        skin = json.decode(user.skin)
      end
      if user.LabelClothe ~= nil then
        label = user.LabelClothe
      end
      if skin ~= nil then
      MySQL.Async.fetchAll(
        'SELECT * FROM clotheuser WHERE SteamId = @identifier AND Label=@label',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@label'] = label
        },
        function(clotheuser)
  
          local cloth = clotheuser[1]
         -- local clothe = nil
          if cloth.Clothe ~= nil then
            clothe = json.decode(cloth.Clothe)
          end
          cb(skin,clothe)
        end)
      else
        cb(skin)
      end
    end
  )
end)

ESX.RegisterServerCallback('esx_skin:getaccesorie', function(source, cb)
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

ESX.RegisterServerCallback('esx_skin:getPlayerSkinAcessesoire', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)

      local user = users[1]
      local label = nil
      local skin = nil
      local clothe = nil
      local acces = nil

      if user.skin ~= nil then
        skin = json.decode(user.skin)
      end
      if user.LabelClothe ~= nil then
        label = user.LabelClothe
      end
      if skin ~= nil then
      MySQL.Async.fetchAll(
        'SELECT * FROM clotheuser WHERE SteamId = @identifier AND Label=@label',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@label'] = label
        },
        function(clotheuser)
  
          local cloth = clotheuser[1]
         -- local clothe = nil
          if cloth.Clothe ~= nil then
            clothe = json.decode(cloth.Clothe)
          end
        end)
        MySQL.Async.fetchAll(
        'SELECT * FROM user_accessories WHERE identifier = @identifier',
        {
          ['@identifier'] = xPlayer.identifier,
        },
        function(accesorie)
  
          local aceseori = accesorie[1]
          if aceseori.mask ~= nil then
            acces = json.decode(aceseori.mask)
          end
          cb(skin,clothe,acces)
        end)
      else
        cb(skin)
      end
    end
  )
end)

ESX.RegisterServerCallback('esx_skin:getPlayerLabel', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)

      local user = users[1]
      local label = nil
      local skin = nil

      if user.skin ~= nil then
        skin = json.decode(user.skin)
      end
      if user.LabelClothe ~= nil then
        label = user.LabelClothe
      end
      if skin ~= nil then
      MySQL.Async.fetchAll(
        'SELECT * FROM clotheuser WHERE SteamId = @identifier AND Label=@label',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@label'] = label
        },
        function(clotheuser)
  
          local cloth = clotheuser[1]
          local clothe = nil
  
          if cloth.Clothe ~= nil then
            clothe = json.decode(cloth.Clothe)
          end
          cb(cloth.Label)
        end)
      end
    end
  )
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkinJob', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)

      local user = users[1]
      --local label = nil
      local skin = nil

      local jobSkin = {
        skin_male   = xPlayer.job.skin_male,
        skin_female = xPlayer.job.skin_female
      }

      if user.skin ~= nil then
        skin = json.decode(user.skin)
      end
      cb(skin,jobSkin)
    end
  )

end)

-- Commands
TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, args, user)
  TriggerClientEvent('esx_skin:openSaveableMenu', source)
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Insufficient permissions!')
end, {help = _U('skin')})

TriggerEvent('es:addGroupCommand', 'skinsave', 'admin', function(source, args, user)
  TriggerClientEvent('esx_skin:requestSaveSkin', source)
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('saveskin')})


