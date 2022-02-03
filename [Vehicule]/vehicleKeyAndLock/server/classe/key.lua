function CreateDataStore(identifier, identifierKey,plate,model)  --1 propriétaire 2 doublon
    local self = {}

    self.identifier = identifier
    self.identifierKey = identifierKey
    self.plate = plate
    self.model = model

    self.getIdentifier = function()
        return self.identifier
    end

    self.getModel = function()
        return self.model
    end


    self.getPlate = function()
        return self.plate
    end

    self.getIdentifierKey = function()
        return self.identifierKey
    end

    self.searcheIdentifierKey = function(identifier)
        for k, v in ipairs(self.identifierKey) do
            if identifier == v.identifier then
                return true
            end
        end
    end

    self.addIdentifierKey = function(identifierKey)
        table.insert(self.identifierKey, {
                identifier = identifierKey
            })
    end

    self.addIdentifier = function(identifier)
        self.identifier = identifier
    end

    return self
end


function CreateSearchIdentifier(plate)  --1 propriétaire 2 doublon
    local self = {}

    self.plate = plate

    self.getPlate = function()
        return self.plate
    end

    
    self.addPlate = function(plate,model)
        table.insert(self.plate, {
            plate = plate,
            model = model
            })
    end

    self.removePlate = function(plate)
        for k, v in ipairs(self.plate) do
            if plate == v.plate then
                table.remove(self.plate, k)
            end
        end
    end

    return self
end