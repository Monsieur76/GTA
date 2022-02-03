function CreateDataStore(addres,weapon, inventory)
    local self = {}

    self.weapon = weapon
    self.inventory = inventory
    self.addres = addres

    self.getAddres= function()
        return self.addres
    end

    self.getInventory = function()
        return self.inventory
    end

    self.getWeapon = function()
        return self.weapon
    end

    self.addItemInventory = function(name, count, label)
        for k, v in ipairs(self.inventory) do
            if v.name == name then
                v.count = v.count + count
                self.save()
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

    self.addItemWeapon = function(item, count, label, etiquette)
            table.insert(self.weapon, {
                name = item,
                label = label,
                ammo = count,
                etiquette = etiquette
            })
        self.save()
    end

    self.getAmmo = function(item,etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and item == v.name then
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

    self.searchItemWeapon = function(name,etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and name == v.name then
                return true
            end
        end
    end

    self.removeItemWeapon = function(name,etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and name == v.name then
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

    self.getInventoryWeight =  function ()
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

    self.resetApart = function ()
        self.weapon = {}
        self.inventory = {}
        self.save()
    end

    self.save = function()
        MySQL.Async.execute("UPDATE appartement_inventory SET inventory = @inventory,weapon=@weapon WHERE address = @address", {
            ["@inventory"] = json.encode(self.inventory),
            ["@weapon"] = json.encode(self.weapon),
            ["@address"] = self.addres
        })
    end


    return self
end
