local invisible = false


AddEventHandler('invisibilite', function(invisibilite)
  invisible = invisibilite
end)


Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      if invisible then
          SetEntityVisible(PlayerPedId(), false, false)
          SetEntityLocallyVisible(PlayerPedId())
      else
          SetEntityVisible(PlayerPedId(), true, true)
      end
  end
end)