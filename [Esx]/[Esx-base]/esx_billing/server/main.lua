ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, label, amount, isFine)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    amount = ESX.Math.Round(amount)
    local notif = 'Facture'
        local icon = 'CHAR_YOUTUBE'
        local societyName = ""
        if isFine ~= nil then
            notif = 'Amende'
            societyName = "LSPD"
            icon = 'CHAR_ABIGAIL'
        end
        if label == "ambulance" then
            societyName = "LSMS"
        elseif label == "taxi" then
            societyName = "Taxi"
        elseif label == "mairie" then
            societyName = "Mairie"
        elseif label == "vigne" then
            societyName = "Vignerons"
        elseif label == "mechanic" then
            societyName = "Benny's"
        elseif label == "brinks" then
            societyName = "UDST"
        elseif label == "weazel" then
            societyName = "Weazel News"
        elseif label == "pls" then
            societyName = "Ron"
		elseif label == "police" then
            societyName = "police"
        elseif label == "burgershot" then
            societyName = "Burger Shot"
        end
        if amount < 0 then
            print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
        elseif societyName == nil or societyName == "" then
            if xTarget ~= nil then
                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, societyName,
                    '~b~' .. notif .. ' de ' .. amount, 'Appuyez sur ~g~Y ~s~pour payer ou sur ~r~N ~s~pour refuser',
                    icon, 9)
                TriggerClientEvent("payment_facture", xTarget.source, _source, playerId, label, amount, isFine)

            end
        else
            if xTarget ~= nil then
                TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, societyName,
                    '~b~' .. notif .. ' de ' .. amount .. "$",
                    'Appuyez sur ~g~Y ~s~pour payer ou sur ~r~N ~s~pour refuser', icon, 9)
                TriggerClientEvent("payment_facture", xTarget.source, _source, playerId, label, amount, isFine)

            end
        end

end)

RegisterServerEvent('Refus_payement')
AddEventHandler('Refus_payement', function(playerId)
    local xTarget = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent('esx:showNotification', xTarget.source, "~r~Refus~s~ : La personne à refusé de payer")
end)

RegisterServerEvent('Accept_payement')
AddEventHandler('Accept_payement', function(id_first_player, playerId, accountName, amount, isFine)
    local xPlayer = ESX.GetPlayerFromId(id_first_player)
    local xTarget = ESX.GetPlayerFromId(playerId)
    if isFine then
        if xTarget.getAccount("bank").money >= amount then
			TriggerEvent('society:getObject', accountName, function(weightSociety,store, money, inventory)
                store.addMoney(amount)

                xTarget.removeAccountMoney("bank", amount)

                TriggerClientEvent('esx:showNotification', xTarget.source, "L'amende a été payée")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "L'amende a été payée")

            end)
        else
            TriggerClientEvent('esx:showNotification', xTarget.source, "Vous n'avez pas la somme en banque")
            TriggerClientEvent('esx:showNotification', xPlayer.source,
                "La personne n'a pas l'argent sur son compte en banque")
        end
    end
    if not isFine then
        if xTarget.getAccount("money").money + xTarget.getAccount("black_money").money >= amount then
            TriggerEvent('society:getObject', accountName, function(weightSociety,store, money, inventory)
                store.addMoney(amount)

                if xTarget.getAccount("black_money").money then
                    amount2 = amount - xTarget.getAccount("black_money").money
                    amount3 = amount - amount2
                    xTarget.removeAccountMoney("money",amount3)
                    xTarget.removeAccountMoney("black_money", amount2)
                else
                    xTarget.removeAccountMoney("money", amount)
                end

                TriggerClientEvent('esx:showNotification', xTarget.source, "La facture a été payée")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "La facture a été payée")

            end)

        else
            TriggerClientEvent('esx:showNotification', xTarget.source, "Vous n'avez pas la somme sur vous")
            TriggerClientEvent('esx:showNotification', xPlayer.source, "La personne n'a pas l'argent sur elle")
        end
    end
end)
