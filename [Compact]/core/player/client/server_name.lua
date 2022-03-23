function SetData()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(players, player)
    end

    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    local label = 'joueur connecté'
    if #players > 1 then
        label = 'joueurs connectés'
    end
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO',
        "Bienvenue sur ~y~Tales~s~ ! Il y a ~y~" .. #players .. " ~s~ " .. label)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        SetData()
    end
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_LEAVE", "Se déconnecter de ~y~Tales~s~")
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_QUIT", "~o~Quitter FiveM")
end)
