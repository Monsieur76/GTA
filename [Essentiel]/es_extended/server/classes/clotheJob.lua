function CreateClotheJob(tenue,label,job,sex)
    local self = {}

    self.tenue = tenue
    self.label = label
    self.job = job
    self.sex = sex

    self.triggerEvent = function(eventName, ...)
        TriggerClientEvent(eventName, self.source, ...)
    end

    self.GetTenue = function ()
        return self.tenue
    end

    self.setIdentifier = function(identifier)
        self.identifier = identifier
        return self.identifier
    end

    self.setColoc = function()
        self.coloc = true
        return self.coloc
    end

    self.getColoc = function()
        return self.coloc
    end

    self.setName = function(name)
        self.name = name
        return self.name
    end

    self.getName = function()
        return self.name
    end

    self.setGarage = function(garage)
        self.garage = garage
        return self.garage
    end

    self.getGarage = function()
        return self.garage
    end

end