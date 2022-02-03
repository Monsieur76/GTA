function creatDataStore(owner,plate,type,vehicle,model,price,stored,dateranged)
    local self = {}

    self.owner = owner
    self.plate = plate
    self.type = type
    self.vehicle = vehicle
    self.model = model
    self.price = price
    self.stored = stored
    self.dateranged = dateranged

    self.getOwner = function()
        return self.owner
    end

    self.setOwner = function(owner)
        self.owner = owner
        self.save()
    end

    self.getPlate = function()
        return self.plate
    end

    self.getType = function()
        return self.type
    end

    self.getVehicle = function()
        return self.vehicle
    end

    self.setVehicle = function(vehicle)
        self.vehicle = vehicle
        self.save()
    end

    self.getModel = function()
        return self.model
    end

    self.getPrice = function()
        return self.price
    end

    self.getStored = function()
        return self.stored
    end

    self.setStored = function(stored)
        self.stored = stored
    end

    self.getDateranged = function()
        return self.dateranged
    end

    self.save = function()
        MySQL.Async.execute("UPDATE owned_vehicles SET owner = @owner,type = @type,vehicle = @vehicle,model = @model,price = @price,stored = @stored,dateranged = NOW() WHERE plate = @plate", {
            ["@owner"] = self.owner,
            ["@type"] = self.type,
            ["@vehicle"] = json.encode(self.vehicle),
            ["@model"] = self.model,
            ["@price"] = self.price,
            ["@stored"] = self.stored,
            ["@plate"] = self.plate,
        })
    end
    
    self.delete = function(plate)
        MySQL.Async.execute("DELETE FROM owned_vehicles WHERE plate = @plate", {
            ["@plate"] = plate,
        })
    end


    return self
end
