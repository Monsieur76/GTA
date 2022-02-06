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


    self.save = function()
        MySQL.Async.execute("UPDATE society_vault_inventory SET money = @money,inventory = @inventory WHERE society = @society", {
            ["@society"] = self.society,
            ["@money"] = self.money,
            ["@inventory"] = self.inventory,
        })
    end

    self.getOwned = function(identifier)
        if self.owner_identifier == identifier then
            return true
        end
        for k,v in pairs(self.coloc_name) do
            if v.identifier == identifier then
                return true
            end
        end
        return false
    end

    

    return self
end
