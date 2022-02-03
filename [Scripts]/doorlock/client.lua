local object
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(1000)
      for k,v in ipairs(Config.DoorList) do
        object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
        FreezeEntityPosition(object,v.freeze)
      end
  end
end)