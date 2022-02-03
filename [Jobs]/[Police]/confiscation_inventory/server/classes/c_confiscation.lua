function CreateDataStore(society, money, inventory, weapon)
    local self = {}

    self.society = society
    self.money = money
    self.inventory = inventory
    self.weapon = weapon

    self.getSociety = function()
        return self.society
    end

    self.getMoney = function()
        return self.money
    end

    self.getWeapon = function()
        return self.weapon
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

    self.addItemWeapon = function(item, count, label)
        table.insert(self.weapon, {
            name = item,
            label = label,
            ammo = count,
        })
        self.save()
    end

    self.getAmmo = function(item,label)
        for k, v in ipairs(self.weapon) do
            if item == v.name and label == v.label then
                return v.ammo
            end
        end
    end

    self.searchItemInventory = function(item, count)
        for k, v in ipairs(self.inventory) do
            if count <= v.count and item == v.name then
                return true
            end
        end
    end

    self.searchItemWeapon = function(name)
        for k, v in ipairs(self.weapon) do
            if name == v.name then
                return true
            end
        end
    end

    self.removeItemWeapon = function(name)
        for k, v in ipairs(self.weapon) do
            if name == v.name then
                table.remove(self.weapon, k)
            end
        end
        self.save()
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
        if self.weapon ~= nil then
            for i = 1, #self.weapon, 1 do
                if self.weapon[i] ~= nil then
                    if ESX.GetItemWeight(self.weapon[i].name) ~= nil then
                        itemWeight = ESX.GetItemWeight(self.weapon[i].name)
                    else
                        itemWeight = Config.DefaultWeight
                    end
                    weight = weight + (itemWeight * (self.weapon[i].count or 1))
                end
            end
        end
        return weight
    end

    self.save = function()
        MySQL.Async.execute(
            "UPDATE police_confiscation_inventory SET money = @money,inventory = @inventory,weapon=@weapon WHERE society = @society",
            {
                ["@society"] = self.society,
                ["@money"] = self.money,
                ["@weapon"] = json.encode(self.weapon),
                ["@inventory"] = json.encode(self.inventory)
            })
    end

    return self
end
