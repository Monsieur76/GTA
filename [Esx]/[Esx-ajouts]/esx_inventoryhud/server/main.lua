ESX = nil
ServerItems = {}
itemShopList = {}
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb)
    local Xplayer = ESX.GetPlayerFromId(source)
    if Xplayer ~= nil then
        cb({
            inventory = Xplayer.getInventory(false),
            money = Xplayer.getMoney(),
            accounts = Xplayer.getAccounts(false),
            weapons = Xplayer.getLoadout(false)
        })
    else
        cb(nil)
    end
end)


--ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb)
--    local Xplayer = ESX.GetPlayerFromId(source)
--    if Xplayer ~= nil then
--        cb({
--            inventory = Xplayer.getInventory(true),
--            money = Xplayer.getMoney(),
--            accounts = Xplayer.getAccounts(true),
--            weapons = Xplayer.getLoadout(true)
--        })
--    else
--        cb(nil)
--    end
--end)