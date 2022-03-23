ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
local xPlayer = nil
ESX.RegisterUsableItem('turtlebait', function(source)
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('fishingrod').count > 0 then
        TriggerClientEvent('fishing:setbait', _source, "turtle")

        xPlayer.removeInventoryItem('turtlebait', 1)
        TriggerClientEvent('esx:showNotification', _source,
            "~g~Vous attachez l'appât à tortue sur votre canne à pêche")
    else
        TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas de canne à pêche")
    end

end)
--[[ESX.RegisterUsableItem('fish', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fish', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, "Vous avez mangé ~y~1x~s~ ~o~Poisson~s~")
end)]]
ESX.RegisterUsableItem('fishbait', function(source)

    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('fishingrod').count > 0 then
        TriggerClientEvent('fishing:setbait', _source, "fish")

        xPlayer.removeInventoryItem('fishbait', 1)
        TriggerClientEvent('esx:showNotification', _source,
            "~g~Vous attachez l'appât à poisson sur votre canne à pêche")

    else
        TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas de canne à pêche")
    end

end)

ESX.RegisterUsableItem('turtle', function(source)

    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('fishingrod').count > 0 then
        TriggerClientEvent('fishing:setbait', _source, "shark")

        xPlayer.removeInventoryItem('turtle', 1)
        TriggerClientEvent('esx:showNotification', _source,
            "~g~Vous attachez la viande de tortue sur votre canne à pêche")
    else
        TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas de canne à pêche")
    end

end)

ESX.RegisterUsableItem('fishingrod', function(source)

    local _source = source
    TriggerClientEvent('fishing:fishstart', _source)

end)

RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)

    _source = source
    local count = 2
    local rnd = math.random(1, 100)
    xPlayer = ESX.GetPlayerFromId(_source)
    if bait == "turtle" then
        if rnd >= 78 then
            if rnd >= 94 then
                TriggerClientEvent('fishing:setbait', _source, "none")
                TriggerClientEvent('esx:showNotification', _source,
                    "~r~Le poisson était trop gros et a brisé votre canne à pêche")
                TriggerClientEvent('fishing:break', _source)
                xPlayer.removeInventoryItem('fishingrod', 1)
            else
                TriggerClientEvent('fishing:setbait', _source, "none")
                if not xPlayer.canCarryItem("turtle", xPlayer.getInventoryItem('turtle').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de tortues")
                else
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé une tortue")
                    xPlayer.addInventoryItem('turtle', 1)
                end
            end
        else
            if rnd >= 75 then
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end

            else
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(2, 6)
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end
            end
        end
    else
        if bait == "fish" then
            if rnd >= 75 then
                TriggerClientEvent('fishing:setbait', _source, "none")
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(4, 11)
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end

            else
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(1, 6)
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end
            end
        end
        if bait == "none" then

            if rnd >= 70 then
                TriggerClientEvent('esx:showNotification', _source, "~y~Vous êtes en train de pêcher sans appât")
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(2, 4)
                    TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez attrapé un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end

            else
                TriggerClientEvent('esx:showNotification', _source, "~y~Vous êtes en train de pêcher sans appât")
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(1, 2)
                    TriggerClientEvent('esx:showNotification', _source, "Vous avez attrapé ~g~un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end
            end
        end
        if bait == "shark" then
            if rnd >= 82 then

                if rnd >= 91 then
                    TriggerClientEvent('fishing:setbait', _source, "none")
                    TriggerClientEvent('esx:showNotification', _source,
                        "Le poisson était trop gros et a ~r~brisé ~w~votre canne à pêche")
                    TriggerClientEvent('fishing:break', _source)
                    xPlayer.removeInventoryItem('fishingrod', 1)
                else
                    if not xPlayer.canCarryItem("shark", xPlayer.getInventoryItem('shark').count + 1) then
                        TriggerClientEvent('fishing:setbait', _source, "none")
                        TriggerClientEvent('esx:showNotification', _source,
                            "~r~Vous ne pouvez pas porter plus de requins")
                    else
                        TriggerClientEvent('esx:showNotification', _source, "Vous avez attrapé ~g~un requin")
                        TriggerClientEvent('fishing:spawnPed', _source)
                        xPlayer.addInventoryItem('shark', 1)
                    end
                end
            else
                if not xPlayer.canCarryItem("fish", xPlayer.getInventoryItem('fish').count + 1) then
                    TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas porter plus de poissons")
                else
                    count = math.random(4, 8)
                    TriggerClientEvent('esx:showNotification', _source, "Vous avez attrapé ~g~un poisson")
                    xPlayer.addInventoryItem('fish', count)
                end

            end
        end

    end

end)

RegisterServerEvent("fishing:lowmoney")
AddEventHandler("fishing:lowmoney", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(money)

end)
