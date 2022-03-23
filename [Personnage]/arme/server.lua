ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('connexion_player_load')
AddEventHandler('connexion_player_load', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('setmaladieconnection', xPlayer.source)
    TriggerClientEvent("launchMaletteCheck", xPlayer.source)
end)

ESX.RegisterUsableItem('parachute', function(source)
    TriggerClientEvent('useparachute', source)
    TriggerClientEvent('esx:showNotification', source, "Vous équipez un parachute")
end)

ESX.RegisterUsableItem('chargeur_mitraillette', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_SMG') then
        xPlayer.addWeaponAmmo("WEAPON_SMG", 12)
        xPlayer.removeInventoryItem('chargeur_mitraillette', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de mp5")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_sniper', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_SNIPERRIFLE') then
        xPlayer.addWeaponAmmo("WEAPON_SNIPERRIFLE", 12)
        xPlayer.removeInventoryItem('chargeur_sniper', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de sniper")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_pistolet', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_PISTOL') then
        xPlayer.addWeaponAmmo("WEAPON_PISTOL", 12)
        xPlayer.removeInventoryItem('chargeur_pistolet', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de pistolet")

	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end

end)

ESX.RegisterUsableItem('chargeur_fap', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.hasWeapon('WEAPON_PUMPSHOTGUN') then
        xPlayer.addWeaponAmmo("WEAPON_PUMPSHOTGUN", 6)
        xPlayer.removeInventoryItem('chargeur_fap', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de pompe")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_carabine', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.hasWeapon('WEAPON_CARBINERIFLE') then
        xPlayer.addWeaponAmmo("WEAPON_CARBINERIFLE", 30)
        xPlayer.removeInventoryItem('chargeur_carabine', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de carabine")

	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_flaregun', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_FLAREGUN') then
        xPlayer.addWeaponAmmo("WEAPON_FLAREGUN", 1)
        xPlayer.removeInventoryItem('chargeur_flaregun', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de pistolet de détresse")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_mousquet', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_MUSKET') then
        xPlayer.addWeaponAmmo("WEAPON_MUSKET", 10)
        xPlayer.removeInventoryItem('chargeur_mousquet', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de mousquet")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_uzi', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_MICROSMG') then
        xPlayer.addWeaponAmmo("WEAPON_MICROSMG", 32)
        xPlayer.removeInventoryItem('chargeur_uzi', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de uzi")

	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end

end)

ESX.RegisterUsableItem('chargeur_revolver', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_REVOLVER') then
        xPlayer.addWeaponAmmo("WEAPON_REVOLVER", 6)
        xPlayer.removeInventoryItem('chargeur_revolver', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de revolver")

	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('roquette_rpg', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_RPG') then
        xPlayer.addWeaponAmmo("WEAPON_RPG", 1)
        xPlayer.removeInventoryItem('roquette_rpg', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de rpg")

	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('chargeur_assaut', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon('WEAPON_ASSAULTRIFLE') then
        xPlayer.addWeaponAmmo("WEAPON_ASSAULTRIFLE", 30)
        xPlayer.removeInventoryItem('chargeur_assaut', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous utilisez un chargeur de ak47")
	else
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas cette arme sur vous")
    end
end)

ESX.RegisterUsableItem('canne', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setCanne()
    TriggerClientEvent('usecanne', source, xPlayer.getCanne())
    TriggerClientEvent('esx:showNotification', source, "Vous utilisez une canne")
    -- xPlayer.removeInventoryItem('Canne', 1)
end)

ESX.RegisterUsableItem('dive', function(source)
    local __source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('useplonger', source)
    xPlayer.removeInventoryItem('dive', 1)
    TriggerClientEvent('esx:showNotification', source, "Vous utilisez une tenue de plonger")
    TriggerClientEvent('clientMenuDisablePlonger', source)
end)

AddEventHandler('esx:playerDropped', function(playerId)
    TriggerClientEvent("arme:deleteMallette", source)
    TriggerClientEvent("arme:deleteWeapons", source)
end)
