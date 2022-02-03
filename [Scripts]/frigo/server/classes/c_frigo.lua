function CreateDataStore(owner, inventory)
    local self = {}

    self.owner = owner
    self.inventory = inventory

    self.getOwner = function()
        return self.owner
    end

    self.getInventory = function()
        return self.inventory
    end

    self.addItemInventory = function(name, count, label)
            for k, v in ipairs(self.inventory) do
                if v.name == name then
                    v.count = v.count + count
                    return
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
        MySQL.Async.execute("UPDATE frigo_inventory SET inventory = @inventory WHERE owner = @owner", {
            ["@inventory"] = json.encode(self.inventory),
            ["@owner"] = self.owner
        })
    end

    return self
end
