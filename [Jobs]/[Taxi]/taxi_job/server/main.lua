ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastPlayerSuccess = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})
TriggerEvent('esx_phone:registerNumber', 'taxi', 'alerte taxi', true, true)



RegisterNetEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local timeNow = os.clock()

	if xPlayer.job.name == 'taxi' then
		if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
			lastPlayerSuccess[source] = timeNow

			math.randomseed(os.time())
			local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
			mairie = total * 0.2
			moneys = total - mairie
			TriggerEvent('society:getObject', "taxi", function(weightSociety,store, money, inventory)
				store.addMoney(moneys)
			end)
			TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
				store.addMoney(mairie)
			end)
		end
	else
		print(('[esx_taxijob] [^3WARNING^7] %s attempted to trigger success (cheating)'):format(xPlayer.identifier))
	end
end)