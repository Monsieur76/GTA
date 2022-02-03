function CreateDataStore(transmitter, receiver, message, time, isRead, owner, isTaken, takenBy, fromNpc, groupGUID,
    fromNorth)
    local self = {}
    self.transmitter = transmitter
    self.receiver = receiver
    self.message = message
    self.time = time
    self.isRead = isRead
    self.owner = owner
    self.isTaken = isTaken
    self.takenBy = takenBy
    self.fromNpc = fromNpc
    self.groupGUID = groupGUID
    self.fromNorth = fromNorth


    

    return self
end
