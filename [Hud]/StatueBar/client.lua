Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        Citizen.Wait(200)
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = status.getPercent()
        end)
        Citizen.Wait(200)
    end
    Citizen.Wait(200)
end)

local pause = true
local hud = true
local estaenCarro = false
local armor = false

local estaenCarro = false
Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()

        if IsPedInAnyVehicle(player, false) then
            estaenCarro = true
            if hud then
                DisplayRadar(true)
                SetRadarZoom(900)
            else
                DisplayRadar(false)
                SetRadarZoom(900)
            end
        else
            estaenCarro = true
            DisplayRadar(false)
        end

        if IsPauseMenuActive() then
            pause = false
        else
            pause = true
        end
        
        SendNUIMessage({
            action = 'tick',
            health = (GetEntityHealth(player) - 100),
            armor = GetPedArmour(player),
            armorDisplay = armor,
            hunger = hunger,
            thirst = thirst,
            stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            inVehicle = estaenCarro,
            hud = hud,
            pause = pause
        })

        Citizen.Wait(200)
    end
end)

RegisterNetEvent('hudDisable')
AddEventHandler('hudDisable', function()  
    if not hud then
        hud = true
    else
        hud = false
    end
end)

RegisterNetEvent('armorEnable')
AddEventHandler('armorEnable', function()  
    if not armor then
        armor = true
    else
        armor = false
    end
end)

Citizen.CreateThread(function()

    local minimap = RequestScaleformMovie("minimap")

    Wait(5000)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        --BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
       -- EndScaleformMovieMethod()
    end
end)
