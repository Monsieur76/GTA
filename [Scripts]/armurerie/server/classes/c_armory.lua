function CreateDataStore(society, weapon)
    local self = {}

    self.society = society
    self.weapon = weapon

    self.getSociety = function()
        return self.society
    end

    self.getWeapon = function()
        return self.weapon
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

    self.getAmmo = function(item, etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and item == v.name then
                return v.ammo
            end
        end
    end

    self.searchItemWeapon = function(name, etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and name == v.name then
                return true
            end
        end
    end

    self.removeItemWeapon = function(name, etiquette)
        for k, v in ipairs(self.weapon) do
            if etiquette == v.etiquette and name == v.name then
                table.remove(self.weapon, k)
            end
        end
        self.save()
    end

    self.getInventoryWeight = function()
        local weight = 0
        local itemWeight = 0

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
        MySQL.Async.execute("UPDATE society_armory_inventory SET weapon = @weapon WHERE society = @society", {
            ["@weapon"] = json.encode(self.weapon),
            ["@society"] = self.society
        })
    end

    return self
end
