ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('esx_phone:registerNumber', 'fbi', 'fbi', true, true)

TriggerEvent('esx_society:registerSociety', 'fbi', 'fbi', 'society_fbi', 'society_fbi', 'society_fbi', {
    type = 'private'
})