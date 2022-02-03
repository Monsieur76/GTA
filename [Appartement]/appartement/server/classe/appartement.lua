function CreateDataStore(name,label, price, enter,exit,garage,owner,owner_identifier,name_owner,coloc_name,level_garage,level_coffre_fort,level_coffre,level_coloc)
    local self = {}

    self.name = name
    self.label = label
    self.price = price
    self.enter = enter
    self.exit = exit
    self.garage = garage
    self.owner = owner
    self.owner_identifier = owner_identifier
    self.name_owner = name_owner
    self.coloc_name = coloc_name
    self.level_garage = level_garage
    self.level_coffre_fort = level_coffre_fort
    self.level_coffre = level_coffre
    self.level_coloc = level_coloc

    self.getSociety = function()
        return self.society
    end

    self.getMoney = function()
        return self.money
    end

    self.addMoney = function(amount)
        self.money = self.money + amount
        self.save()
        return self.money
    end

    self.removeMoney = function(amount)
        self.money = self.money - amount
        self.save()
        return self.money
    end

    self.getInventory = function()
        return self.inventory
    end

    self.addItemInventory = function(name, count, label)
        if self.inventory ~= nil then
            for k, v in ipairs(self.inventory) do
                if v.name == name then
                    v.count = v.count + count
                    return
                end
            end
        end
        table.insert(self.inventory, {
            name = name,
            label = label,
            count = count
        })
        self.save()
    end

    self.searchItemInventory = function(item, count)
        for k, v in ipairs(self.inventory) do
            if count <= v.count and item == v.name then
                return true
            end
        end
    end

    self.removeItemInventory = function(item, count)
        for k, v in ipairs(self.inventory) do
            if count <= v.count and item == v.name then
                v.count = v.count - count
                if v.count == 0 then
                    table.remove(self.inventory, k)
                end
            end
        end
        self.save()
    end

    self.getInventoryWeight = function()
        local weight = 0
        local itemWeight = 0
        if self.inventory ~= nil then
            for i = 1, #self.inventory, 1 do
                if self.inventory[i] ~= nil then
                    if ESX.GetItemWeight(self.inventory[i].name) ~= nil then
                        itemWeight = ESX.GetItemWeight(self.inventory[i].name)
                    else
                        itemWeight = Config.DefaultWeight
                    end
                    weight = weight + (itemWeight * (self.inventory[i].count or 1))
                end
            end
        end
        return weight
    end

    self.save = function()
        MySQL.Async.execute("UPDATE society_vault_inventory SET money = @money,inventory = @inventory WHERE society = @society", {
            ["@society"] = self.society,
            ["@money"] = self.money,
            ["@inventory"] = self.inventory,
        })
    end

    return self
end
