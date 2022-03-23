ESX                 = nil
Jobs                = {}
RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function stringsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function GetSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

AddEventHandler('onMySQLReady', function()

  local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

  for i=1, #result, 1 do
    Jobs[result[i].name]        = result[i]
    Jobs[result[i].name].grades = {}
  end

  local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

  for i=1, #result2, 1 do
    Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
  end

end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)

  local found = false

  local society = {
    name      = name,
    label     = label,
    account   = account,
    datastore = datastore,
    inventory = inventory,
    data      = data,
  }

  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      found                  = true
      RegisteredSocieties[i] = society
      break
    end
  end

  if not found then
    table.insert(RegisteredSocieties, society)
  end

end)

AddEventHandler('esx_society:getSocieties', function(cb)
  cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
  cb(GetSociety(name))
end)


RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if amount > 0 and account.money >= amount then
    TriggerEvent("esx:washingmoneyalert",xPlayer.name,amount)
    xPlayer.removeAccountMoney('black_money', amount)

      MySQL.Async.execute(
        'INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@society']    = society,
          ['@amount']     = amount
        },
        function(rowsChanged)
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', amount))
        end
      )

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)

  if Config.EnableESXIdentity then
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (results)
        local employees = {}

        for i=1, #results, 1 do
          table.insert(employees, {
            name        = results[i].firstname .. ' ' .. results[i].lastname,
            identifier  = results[i].identifier,
            job = {
              name        = results[i].job,
              label       = Jobs[results[i].job].label,
              grade       = results[i].job_grade,
              grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
              grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (result)
        local employees = {}

        for i=1, #result, 1 do
          table.insert(employees, {
            name        = result[i].name,
            identifier  = result[i].identifier,
            job = {
              name        = result[i].job,
              label       = Jobs[result[i].job].label,
              grade       = result[i].job_grade,
              grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
              grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)

  local job    = json.decode(json.encode(Jobs[society]))
  local grades = {}

  for k,v in pairs(job.grades) do
    table.insert(grades, v)
  end

  table.sort(grades, function(a, b)
    return a.grade < b.grade
  end)

  job.grades = grades

  cb(job)

end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)

	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer ~= nil then
		xPlayer.setJob(job, grade)
		
		if type == 'hire' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_hired', job))
		elseif type == 'promote' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_promoted'))
		elseif type == 'fire' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_fired', xPlayer.getJob().label))
		end
	end

	MySQL.Async.execute(
		'UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier',
		{
			['@job']        = job,
			['@job_grade']  = grade,
			['@identifier'] = identifier
		},
		function(rowsChanged)
			cb()
		end
	)

end)
RegisterServerEvent('Monsieur:promote')
AddEventHandler('Monsieur:promote', function(identifier, society)
    local _source = source

    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getIdentifier() == identifier then
            if xPlayer.getJob().grade == 4 then
                TriggerClientEvent('esx:showNotification', _source,
                    "Vous ne pouvez pas promouvoir cette personne, elle est déja au grade maximum")
            else
                xPlayer.setJob(society, xPlayer.getJob().grade + 1)
                TriggerClientEvent('esx:showNotification', _source, "Vous avez promu une personne")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez été promu")
            end
        end
    end
end)

RegisterServerEvent('Monsieur:retrograde')
AddEventHandler('Monsieur:retrograde', function(identifier, society)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getIdentifier() == identifier then
            if xPlayer.getJob().grade == 0 then
                TriggerClientEvent('esx:showNotification', _source,
                    "Vous ne pouvez pas rétrogradé cette personne, elle est déja au grade minimum")
            else
                xPlayer.setJob(society, xPlayer.getJob().grade - 1)
                TriggerClientEvent('esx:showNotification', _source, "Vous avez rétrogradé une personne")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez été rétrogradé")
            end
        end
    end
end)

ESX.RegisterServerCallback('Monsieur_employer_entreprise', function(source, cb, job)
    local _source = source
    local data = {}
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getJob().name == job then
            table.insert(data, {
                name = xPlayer.getName(),
                identifier = xPlayer.getIdentifier(),
                grade = xPlayer.getJob().grade_label
            })
        end
    end
    cb(data)
end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)

  MySQL.Async.execute(
    'UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade',
    {
      ['@salary']   = salary,
      ['@job_name'] = job,
      ['@grade']    = grade
    },
    function(rowsChanged)

      Jobs[job].grades[tostring(grade)].salary = salary

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == job and xPlayer.job.grade == grade then
          xPlayer.setJob(job, grade)
        end

      end

      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)

  local xPlayers = ESX.GetPlayers()
  local players  = {}

  for i=1, #xPlayers, 1 do

    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

    table.insert(players, {
      source     = xPlayer.source,
      identifier = xPlayer.identifier,
      name       = xPlayer.name,
      job        = xPlayer.job
    })

  end

  cb(players)

end)

--function WashMoneyCRON(d, h, m)

  --MySQL.Async.fetchAll(
  --  'SELECT * FROM society_moneywash',
   --{},
   -- function(result)

   --   local xPlayers = ESX.GetPlayers()

   --   for i=1, #result, 1 do
--    local foundPlayer = false
  --      local xPlayer     = nil
   --     local society     = GetSociety(result[i].society)

   --     for j=1, #xPlayers, 1 do
   --      local xPlayer2 = ESX.GetPlayerFromId(xPlayers[j])
   --       if xPlayer2.identifier == result[i].identifier then
    --        foundPlayer = true
     --       xPlayer     = xPlayer2
     --     end
    --    end

    --    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
     --     account.addMoney(result[i].amount)
    --    end)

     --   if foundPlayer then
     --     TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', result[i].amount))
     --   end

     --   MySQL.Async.execute(
    --      'DELETE FROM society_moneywash WHERE id = @id',
     --     {
      --      ['@id'] = result[i].id
      --    }
     --   )

     -- end

   -- end
 -- )

--end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)
