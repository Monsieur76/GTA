local guiEnabled = false
local myIdentity = {}
local myIdentifiers = {}
local hasIdentity = false
ESX = nil
local heading = 332.219879
local spawnfirst = false
local Vetement = {}
local accesorie = {}
local FirstSpawn     = true
local PlayerLoaded   = false
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state
	})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(10)
		end
		if FirstSpawn then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
				if skin == nil then
                    FreezeEntityPosition(PlayerPedId(), true)
					SetPlayerInvincible(PlayerPedId(), true)
					spawnfirst = true
					TriggerEvent("esx_identity:showRegisterIdentity")
					TriggerEvent('skinchanger:change', 'sex', 0)
					TriggerEvent('skinchanger:change', 'tshirt_1', 0)
					Vetement['tshirt_1']=0
					TriggerEvent('skinchanger:change', 'torso_1', 0)
					Vetement['torso_1']=0
					TriggerEvent('skinchanger:change', 'arms', 0)
					Vetement['arms']=0
					TriggerEvent('skinchanger:change', 'pants_1', 0)
					Vetement['pants_1']=0
					TriggerEvent('skinchanger:change', 'shoes_1', 1)
					Vetement['shoes_1']=1
					ajoutvet()
					TriggerServerEvent('esx_skin:saveClothe',Vetement,"Tenue de base")
					ajoutAcces()
					TriggerServerEvent('esx_skin:saveAcess',accesorie)
					TriggerEvent('invisibilite',spawnfirst)
					TriggerEvent("creatorPersonnage", true)
				else

				end
			end)
			FirstSpawn = false
		end
	end)
end)


RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	EnableGui(true)
end)

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('escape', function(data, cb)
		EnableGui(false)
end)

RegisterNUICallback('register', function(data, cb)
	local reason = ""
	myIdentity = data

	
	if reason == "" then
		TriggerServerEvent('esx_identity:setIdentity', myIdentity)
		EnableGui(false)
		Citizen.Wait(500)
		TriggerServerEvent('skincreator:skincreator')
	else
		ESX.ShowNotification(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		if guiEnabled then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		end
		Citizen.Wait(10)
	end
end)


function ajoutAcces()
    if table.findKey('ears_1', accesorie) == false then
        accesorie['ears_1'] = -1
    end
    if table.findKey('ears_2', accesorie) == false then
        accesorie['ears_2'] = -1
    end
    if table.findKey('helmet_1', accesorie) == false then
        accesorie['helmet_1'] = -1
    end
    if table.findKey('helmet_2', accesorie) == false then
        accesorie['helmet_2'] = -1
    end
    if table.findKey('glasses_1', accesorie) == false then
        accesorie['glasses_1'] = -1
    end
    if table.findKey('glasses_2', accesorie) == false then
        accesorie['glasses_2'] = -1
    end
    if table.findKey('watches_1', accesorie) == false then
        accesorie['watches_1'] = -1
    end
    if table.findKey('watches_2', accesorie) == false then
        accesorie['watches_2'] = -1
    end
    if table.findKey('bracelets_1', accesorie) == false then
        accesorie['bracelets_1'] = -1
    end
    if table.findKey('bracelets_2', accesorie) == false then
        accesorie['bracelets_2'] = -1
    end
    if table.findKey('chain_1', accesorie) == false then
        accesorie['chain_1'] = -1
    end
    if table.findKey('chain_2', accesorie) == false then
        accesorie['chain_2'] = -1
    end
    if table.findKey('mask_1', accesorie) == false then
        accesorie['mask_1'] = -1
    end
    if table.findKey('mask_2', accesorie) == false then
        accesorie['mask_2'] = -1
    end
end

function ajoutvet()
    if table.findKey('decals_1', Vetement) == false then
        Vetement['decals_1'] = -1
    end
    if table.findKey('decals_2', Vetement) == false then
        Vetement['decals_2'] = -1
    end
end

function table.findKey(f, l)
	for k, v in pairs(l) do
	  if k == f then
		return true
	  end
	end
	return false
  end