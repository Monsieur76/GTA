StartPayCheck = function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.PaycheckInterval)
            local xPlayers = ESX.GetExtendedPlayers()
            for _, xPlayer in pairs(xPlayers) do
                local job = xPlayer.job.grade_name
                local salary = xPlayer.job.grade_salary

                if salary > 0 then
                    if job == 'unemployed' then -- unemployed
                        xPlayer.addMoney( salary)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'),
                            _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
                    elseif Config.EnableSocietyPayouts then -- possibly a society
                        TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
                            if society ~= nil then -- verified society
                                TriggerEvent('society:getObject', xPlayer.job.name, function(weightSociety,store, money, inventory)
                                    local moneyAccount = money
                                    if moneyAccount ~= nil and moneyAccount >= salary then -- does the society money to pay its employees?
                                        xPlayer.addMoney(salary)
                                        store.removeMoney(salary)

                                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'),
                                            _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
                                    else
                                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'),
                                            '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
                                    end
                                end)
                            else -- not a society
                                xPlayer.addMoney( salary)
                                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'),
                                    _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
                            end
                        end)
                    else -- generic job
                        xPlayer.addMoney( salary)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'),
                            _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
                    end
                end
            end
        end
    end)
end
