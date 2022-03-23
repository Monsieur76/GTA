function CreateDataStore(adress, BlackMoney)
    local self = {}

    self.adress = adress
    self.BlackMoney = BlackMoney

    self.getAdress = function()
        return self.adress
    end

    self.getBlackMoney = function()
        return self.BlackMoney
    end

    self.resetApart = function ()
        self.BlackMoney = 0
        self.save()
    end

    self.addMoney = function(amount)
        self.BlackMoney = self.BlackMoney + amount
        self.save()
        return self.BlackMoney
    end

    self.removeBlackMoney = function(amount)
        self.BlackMoney = self.BlackMoney - amount
        self.save()
        return self.BlackMoney
    end

    self.save = function()
        MySQL.Async.execute("UPDATE appartement_black_inventory SET money = @money WHERE address = @address", {
            ["@address"] = self.adress,
            ["@money"] = self.BlackMoney
        })
    end


    return self
end
