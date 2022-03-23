ESX = nil
local PlayerData = {}
local namePlayer
local coord
local invisible
local IdSelected
local modoInvisible = false
local InSpectatorMode, ShowInfos = false, false
local TargetSpectate, LastPosition, cam
local polarAngleDeg = 0
local azimuthAngleDeg = 90
local radius = -3.5
local PlayerDate = {}
local group = "user"

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

local Menu = {
    action = {'~g~Argent Liquide~s~', '~b~Argent en Banque~s~', '~r~Argent Sale~s~'},
    list = 1
}

-- ==--==--==--
-- Noclip
-- ==--==--==--

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if drawInfo then
            local text = {}
            -- cheat checks
            local targetPed = GetPlayerPed(drawTarget)

            table.insert(text, "E pour stop spectate")

            for i, theText in pairs(text) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.3, 0.7 + (i / 30))
            end

            if IsControlJustPressed(0, 103) then
                local targetPed = PlayerPedId()
                local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

                RequestCollisionAtCoord(targetx, targety, targetz)
                NetworkSetInSpectatorMode(false, targetPed)

                StopDrawPlayerInfo()

            end

        end
    end
end)
function SpectatePlayer(targetPed, target, name)
    local playerPed = PlayerPedId() -- yourself
    enable = true
    if targetPed == playerPed then
        enable = false
    end  

    if (enable) then

        local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx, targety, targetz)
        NetworkSetInSpectatorMode(true, targetPed)
        DrawPlayerInfo(targetPed)
        ESX.ShowNotification('~g~Mode spectateur en cours')
    else

        local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx, targety, targetz)
        NetworkSetInSpectatorMode(false, targetPed)
        StopDrawPlayerInfo()
        ESX.ShowNotification('~b~Mode spectateur arrêtée')
    end
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, config.controls.openKey, true))
    ButtonMessage("Disable Noclip")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Go Up")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Go Down")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Turn Left/Right")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Go Forwards/Backwards")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage("Change Speed (" .. config.speeds[index].label .. ")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

config = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        openKey = 288, -- [[F2]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32, -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21 -- [[L-Shift]]
    },

    speeds = { -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
    {
        label = "Very Slow",
        speed = 0
    }, {
        label = "Slow",
        speed = 0.5
    }, {
        label = "Normal",
        speed = 2
    }, {
        label = "Fast",
        speed = 4
    }, {
        label = "Very Fast",
        speed = 6
    }, {
        label = "Extremely Fast",
        speed = 10
    }, {
        label = "Extremely Fast v2.0",
        speed = 20
    }, {
        label = "Max Speed",
        speed = 25
    }},

    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3 -- [[How much you rotate. ]]
    },

    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80 -- [[Alpha]]
}

noclipActive = false -- [[Wouldn't touch this.]]

index = 1 -- [[Used to determine the index of the speeds table.]]

Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = config.speeds[index].speed

    while true do
        Citizen.Wait(1)

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index + 1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

            if IsControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
            end

            if IsControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
            end

            if IsControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) + config.offsets.h)
            end

            if IsControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity) - config.offsets.h)
            end

            if IsControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
            end

            if IsControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
            end

            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3),
                zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        end
    end
end)

-- ==--==--==--
-- Noclip fin
-- ==--==--==--

function getPosition()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    return x, y, z
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

function KeyBoardText(TextEntry, ExampleText, MaxStringLength)

    AddTextEntry('PLATE_ADMIN', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "PLATE_ADMIN", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function admin_tp_marker()
    local playerPed = PlayerPedId()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
        SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
        ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
    else
        ESX.ShowAdvancedNotification("Administration", "", "~r~Aucun Marqueur !", "CHAR_DREYFUSS", 1)
    end
end

function admin_tp_markerVilla()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1502.41, 119.32,55.67, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_markerFBI()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 122.39, -728.61,242.15, true, true, true, true)
    SetEntityHeading(playerPed, 95.33)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_concess()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -30.23, -1103.46,26.42, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_mairie()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -569.53, -212.6,38.23, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_bennys()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -201.32, -1315.53,31.09, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_udst()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -38.79, -707.8,50.46, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_vigne()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1873.85, 2056.44,141.50, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_burgershot()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1200.34, -887.73,13.98, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_taxi()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 909.09, -152.57,74.17, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_ron()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 555.83, 2801.81,42.26, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_autoecole()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 234.18, 373.31,106.11, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_lspdNorth()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -453.52, 6017.42,31.72, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_lspdSud()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 468.59, -983.23,30.69, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_dynasty()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -139.5, 6285.83,31.49, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_fourriere()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 375.62, -1610.12,29.29, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_lsms()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 331.23, -591.2,43.28, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_weazel()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -598.14, -915.37,33.59, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_tribunal()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 247.57, -1093.65,36.13, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_prison()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 1762.47, 2618.54,55.48, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_masque()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1338.05, -1271.76,4.9, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function admin_tp_accessoire()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -627.71, -226.76,38.06, true, true, true, true)
    SetEntityHeading(playerPed, 0)
    RageUI.CloseAll()
    ESX.ShowAdvancedNotification("Administration", "", "TP Sur Marqueur : ~g~Réussi !", "CHAR_DREYFUSS", 1)
end

function GiveCash()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            TriggerServerEvent('Administration:GiveCash', amount)
        end
    end
end

function admin_tp_marker2(x, y, z)
    print(x, y, z)
    local playerPed = PlayerPedId()
    if x ~= nil or y ~= nil or z ~= nil then
        SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true)
        SetEntityHeading(playerPed, 0)
        ESX.ShowAdvancedNotification("Administration", "", "TP  : ~g~Réussi !", "CHAR_DREYFUSS", 1)
    else
        ESX.ShowAdvancedNotification("Administration", "", "~r~Rentrer des coordonnées valides !", "CHAR_DREYFUSS", 1)
    end
end

function GiveBanque()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            TriggerServerEvent('Administration:GiveBanque', amount)
        end
    end
end

function DrawTxt(text, r, z)
    SetTextColour(MainColor.r, MainColor.g, MainColor.b, 255)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(r, z)
end

Citizen.CreateThread(function()
    while true do
        if Admin.showcoords then
            x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
            roundx = tonumber(string.format("%.2f", x))
            roundy = tonumber(string.format("%.2f", y))
            roundz = tonumber(string.format("%.2f", z))
            DrawTxt("~r~X:~s~ " .. roundx, 0.05, 0.00)
            DrawTxt("     ~r~Y:~s~ " .. roundy, 0.11, 0.00)
            DrawTxt("        ~r~Z:~s~ " .. roundz, 0.17, 0.00)
            DrawTxt("             ~r~Angle:~s~ " .. GetEntityHeading(PlayerPedId()), 0.21, 0.00)
        end
        Citizen.Wait(0)
    end
end)

Admin = {
    showcoords = false
}
MainColor = {
    r = 225,
    g = 55,
    b = 55,
    a = 255
}

function GiveND()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            TriggerServerEvent('Administration:GiveND', amount)
        end
    end
end

function changer_skin()
    TriggerEvent('esx_skin:openSaveableMenu', source)
end

local ServersIdSession = {}

function admin_mode_fantome()
    invisible = not invisible
    --local ped = PlayerPedId()
    if not modoInvisible then
        modoInvisible = true
        TriggerEvent('invisibilite', modoInvisible)
        ESX.ShowAdvancedNotification("Administration", "", "Invisibilité : ~g~activé", "CHAR_DREYFUSS", 1)
    else
        modoInvisible = false
        TriggerEvent('invisibilite', modoInvisible)
        ESX.ShowAdvancedNotification("Administration", "", "Invisibilité : ~r~désactivé", "CHAR_DREYFUSS", 1)
    end
end

function admin_vehicle_flip()

    local player = PlayerPedId()
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0, 0, 70)
    if carTargetDep ~= nil then
        platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(PlayerPedId())
    playerCoords = playerCoords + vector3(0, 2, 0)

    SetEntityCoords(carTargetDep, playerCoords)

    ESX.ShowAdvancedNotification("Administration", "", "~g~Véhicule retourné", "CHAR_DREYFUSS", 1)

end

function admin_godmode()
    godmode = not godmode
    local ped = PlayerPedId()

    if godmode then -- activé
        SetEntityInvincible(ped, true)
        ESX.ShowAdvancedNotification("Administration", "", "Invincibilité : ~g~activé", "CHAR_DREYFUSS", 1)
    else
        SetEntityInvincible(ped, false)
        ESX.ShowAdvancedNotification("Administration", "", "Invincibilité : ~r~désactivé", "CHAR_DREYFUSS", 1)
    end
end
local invincible = false

function admin_tp_toplayer()
    local plyId = KeyBoardText("ID", "", "", 8)

    if plyId ~= nil then
        plyId = tonumber(plyId)

        if type(plyId) == 'number' then
            local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
            SetEntityCoords(plyPed, targetPlyCoords)
        end
    end
end

RegisterNetEvent("hAdmin:envoyer")
AddEventHandler("hAdmin:envoyer", function(msg)
    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    local head = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do
        Wait(1)
    end
    headshot = GetPedheadshotTxdString(head)
    ESX.ShowAdvancedNotification('Message du Staff', '~r~Informations', '~r~Raison ~w~: ' .. msg, headshot, 3)
end)

function admin_tp_playertome()
    local plyId = KeyBoardText("ID :", "", "", 8)

    if plyId ~= nil then
        plyId = tonumber(plyId)

        if type(plyId) == 'number' then
            local plyPedCoords = GetEntityCoords(plyPed)
            print(plyId)
            TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
        end
    end
end

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if drawInfo then
            local text = {}
            -- cheat checks
            local targetPed = drawTarget

            table.insert(text, "E pour stop spectate")

            for i, theText in pairs(text) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.3, 0.7 + (i / 30))
            end

            if IsControlJustPressed(0, 103) then
                local targetPed = PlayerPedId()
                local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

                RequestCollisionAtCoord(targetx, targety, targetz)
                NetworkSetInSpectatorMode(false, targetPed)

                StopDrawPlayerInfo()

            end

        end
    end
end)

function SpectatePlayer(targetPed,target ,name)
    local playerPed = PlayerPedId() -- yourself
    enable = true
    if targetPed == playerPed then
        enable = false
    end


    if (enable) then

        local targetx, targety, targetz = table.unpack(GetEntityCoords(PlayerPedId(target), false))

        RequestCollisionAtCoord(targetx, targety, targetz)
        NetworkSetInSpectatorMode(true, PlayerPedId(target))
        DrawPlayerInfo(PlayerPedId(target))
        ESX.ShowNotification('~g~Mode spectateur en cours')
    else

        local targetx, targety, targetz = table.unpack(GetEntityCoords(PlayerPedId(target), false))

        RequestCollisionAtCoord(targetx, targety, targetz)
        NetworkSetInSpectatorMode(false, PlayerPedId(target))
        StopDrawPlayerInfo()
        ESX.ShowNotification('~b~Mode spectateur arrêtée')
    end
end

RegisterCommand("spect", function(source, args, rawCommand)
    ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
        playergroup = group
        if playergroup == 'superadmin' or playergroup == 'owner' then
            idnum = tonumber(args[1])
            local playerId = GetPlayerFromServerId(idnum)
            SpectatePlayer(GetPlayerPed(playerId), playerId, GetPlayerName(playerId))
        else
            ESX.ShowNotification("Vous n'avez pas accès à cette commande")
        end
    end)
end)

RMenu.Add('AdminMenu', 'main', RageUI.CreateMenu("Menu Admin", "Intéractions"))
RMenu.Add('AdminMenu', 'perso', RageUI.CreateSubMenu(RMenu:Get('AdminMenu', 'main'), "Actions Perso", "Intéractions"))
RMenu.Add('AdminMenu', 'perso_tp', RageUI.CreateSubMenu(RMenu:Get('AdminMenu', 'perso'), "Téléportation", "Intéractions"))
RMenu.Add('AdminMenu', 'veh', RageUI.CreateSubMenu(RMenu:Get('AdminMenu', 'main'), "Actions Véhicules", "Intéractions"))
RMenu.Add('AdminMenu', 'joueurs', RageUI.CreateSubMenu(RMenu:Get('AdminMenu', 'main'), "Liste des joueurs", "Intéractions"))
RMenu.Add('AdminMenu', 'options', RageUI.CreateSubMenu(RMenu:Get('AdminMenu', 'joueurs'), "Actions sur joueur", "Intéractions"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'main'), true, true, true, function()
            RageUI.Checkbox("Mode Administration", nil, service, {}, function(Hovered, Ative, Selected, Checked)
                if (Selected) then

                    service = Checked

                    if Checked then
                        onservice = true
                        local head = RegisterPedheadshot(PlayerPedId())
                        while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do
                            Wait(1)
                        end
                        -- headshot = GetPedheadshotTxdString(head)
                        -- SetPedPropIndex(PlayerPedId() , 0, 91, 9)   --helmet
                        -- SetPedComponentVariation(PlayerPedId() , 8, 15, 0) --tshirt 
                        -- SetPedComponentVariation(PlayerPedId() , 11, 178, 9)  --torse
                        -- SetPedComponentVariation(PlayerPedId() , 4, 77, 9)   --pants
                        -- SetPedComponentVariation(PlayerPedId() , 6, 55, 9)   --shoes
                        RageUI.Text({
                            message = "~g~Mode Administration actif",
                            time_display = 4555555555555
                        })

                    else
                        onservice = false
                        RageUI.Text({
                            message = "~r~Mode Administration Désactivé",
                            time_display = 2500
                        })
                    end
                end
            end)

            if onservice then

                RageUI.ButtonWithStyle("Actions Perso", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('AdminMenu', 'perso'))

                RageUI.ButtonWithStyle("Actions Véhicules", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('AdminMenu', 'veh'))

                RageUI.ButtonWithStyle("Liste des joueurs", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('AdminMenu', 'joueurs'))

                RageUI.ButtonWithStyle("Menu Wipe", nil, {
                    RightLabel = "→"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        RageUI.CloseAll()
                        ExecuteCommand("wipe")
                    end
                end)

            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'perso'), true, true, true, function()

            RageUI.ButtonWithStyle("TP-Marqueur", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_marker()
                end
            end)

            RageUI.ButtonWithStyle("Téléportation", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('AdminMenu', 'perso_tp'))

            RageUI.ButtonWithStyle("Afficher/Cacher coordonnées", description, {}, true,
                function(Hovered, Active, Selected)
                    if (Selected) then
                        Admin.showcoords = not Admin.showcoords
                    end
                end)
                

            RageUI.ButtonWithStyle("NoClip", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    noclipActive = not noclipActive

                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
                    else
                        noclipEntity = PlayerPedId()
                    end

                    SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
                    FreezeEntityPosition(noclipEntity, noclipActive)
                    SetEntityInvincible(noclipEntity, noclipActive)
                    SetVehicleRadioEnabled(noclipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
                end
            end)

            RageUI.Checkbox("GodMod", nil, checkbox2, {}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    checkbox2 = Checked
                    if Checked then
                        Checked = true
                        admin_godmode()
                    else
                        admin_godmode()
                    end
                end
            end)

            RageUI.Checkbox("Invisible", nil, checkbox3, {}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    checkbox3 = Checked
                    if Checked then
                        Checked = true
                        admin_mode_fantome()
                    else
                        admin_mode_fantome()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Heal", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("healadminmenu")
                end
            end)

            RageUI.ButtonWithStyle("Revive", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("reviveadminmenu")
                end
            end)

            RageUI.List('Give', Menu.action, Menu.list, nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                        GiveCash()
                    elseif Index == 2 then
                        GiveBanque()
                    elseif Index == 3 then
                        GiveND()
                    end
                end
                Menu.list = Index;
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'perso_tp'), true, true, true, function()

            RageUI.ButtonWithStyle("TP-Villa Scarlet", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_markerVilla()
                end
            end)

            RageUI.ButtonWithStyle("Tour FBI", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_markerFBI()
                end
            end)

            RageUI.ButtonWithStyle("Concessionnaire", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_concess()
                end
            end)

            RageUI.ButtonWithStyle("Benny's", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_bennys()
                end
            end)

            RageUI.ButtonWithStyle("UDST", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_udst()
                end
            end)

            RageUI.ButtonWithStyle("Vignerons", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_vigne()
                end
            end)

            RageUI.ButtonWithStyle("Burgershot", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_burgershot()
                end
            end)

            RageUI.ButtonWithStyle("Taxi", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_taxi()
                end
            end)

            RageUI.ButtonWithStyle("RON", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_ron()
                end
            end)

            RageUI.ButtonWithStyle("Auto-École", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_autoecole()
                end
            end)

            RageUI.ButtonWithStyle("LSPD Nord", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_lspdNorth()
                end
            end)

            RageUI.ButtonWithStyle("LSPD Sud", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_lspdSud()
                end
            end)

            RageUI.ButtonWithStyle("Dynasty8", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_dynasty()
                end
            end)

            RageUI.ButtonWithStyle("Fourrière", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_fourriere()
                end
            end)

            RageUI.ButtonWithStyle("LSMS", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_lsms()
                end
            end)

            RageUI.ButtonWithStyle("Mairie", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_mairie()
                end
            end)

            RageUI.ButtonWithStyle("Weazel News", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_weazel()
                end
            end)

            RageUI.ButtonWithStyle("Tribunal", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_tribunal()
                end
            end)

            RageUI.ButtonWithStyle("Prison", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_prison()
                end
            end)

            RageUI.ButtonWithStyle("Magasin de masque", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_masque()
                end
            end)

            RageUI.ButtonWithStyle("Magasin d'accessoire", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_tp_accessoire()
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'veh'), true, true, true, function()

            RageUI.ButtonWithStyle("Spawn un véhicule", nil, {
                RightLabel = ""
            }, true, function(_, _, Selected)
                if Selected then
                    local ped = GetPlayerPed(tgt)
                    local ModelName = KeyBoardText("Véhicule", "", 100)
                    if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                        local PlateCustom = KeyBoardText("Plaque Custom", "", 8)
                        if PlateCustom ~= "" then
                            RequestModel(ModelName)
                            while not HasModelLoaded(ModelName) do
                                Citizen.Wait(0)
                            end
                            local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId()),
                                GetEntityHeading(PlayerPedId()), true, true)
                            SetVehicleNumberPlateText(veh, PlateCustom)
                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                            Wait(50)
                        else
                            RequestModel(ModelName)
                            while not HasModelLoaded(ModelName) do
                                Citizen.Wait(0)
                            end
                            local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId()),
                                GetEntityHeading(PlayerPedId()), true, true)
                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                            Wait(50)
                        end
                    else
                        ESX.ShowNotification("~r~Vehicule invalide !")
                    end
                end
            end)

            RageUI.ButtonWithStyle("Réparer le véhicule", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if DoesEntityExist(vehicle) then
                            SetVehicleFixed(vehicle)
                            SetVehicleDeformationFixed(vehicle)
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("Retourner le véhicule", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    admin_vehicle_flip()
                end
            end)

            RageUI.ButtonWithStyle("Changer la plaque", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local PlateCustom = KeyBoardText("Plaque Custom", "", 8)
                    TriggerEvent('client:ChangePlate', PlateCustom)
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'joueurs'), true, true, true, function()

            for k, v in ipairs(ServersIdSession) do
                print()
                RageUI.ButtonWithStyle("ID : " .. v.id .. " → " .. v.name, nil, {}, true,
                    function(Hovered, Active, Selected)
                        if (Selected) then
                            IdSelected = v.id
                            namePlayer = v.name
                            coord = v.coord
                        end
                    end, RMenu:Get('AdminMenu', 'options'))
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('AdminMenu', 'options'), true, true, true, function()

            RageUI.Separator("Joueur : " .. namePlayer)

            RageUI.ButtonWithStyle("Envoyer un message", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local msg = KeyBoardText("Raison", "", 100)

                    if msg ~= nil then
                        msg = tostring(msg)

                        if type(msg) == 'string' then
                            TriggerServerEvent("hAdmin:Message", IdSelected, msg)
                        end
                    end
                    ESX.ShowNotification("Vous venez d'envoyer le message à ~b~" .. namePlayer)
                end
            end)

            RageUI.ButtonWithStyle("Téléporter sur joueur", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local currentPos = GetEntityCoords(IdSelected)
                    SetEntityCoords(PlayerPedId(), coord)
                    ESX.ShowNotification('~b~Vous venez de vous Téléporter à~s~ ' .. namePlayer .. '')
                end
            end)

            RageUI.ButtonWithStyle("Téléporter à vous", nil, {}, true, function(Hovered, Active, Selected, target)
                if (Selected) then
                    ExecuteCommand("bring " .. IdSelected)
                    ESX.ShowNotification('~b~Vous venez de Téléporter ~s~ ' .. namePlayer .. ' ~b~à vous~s~ !')
                end
            end)

            RageUI.ButtonWithStyle("Spectate", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerId = GetPlayerFromServerId(IdSelected)
                    SpectatePlayer(IdSelected,playerId, namePlayer)
                end
            end)

            RageUI.Checkbox("Freeze / Defreeze", description, Frigo, {}, function(Hovered, Ative, Selected, Checked)
                if Selected then
                    Frigo = Checked
                    if Checked then
                        ESX.ShowNotification("~r~Joueur Freeze (" .. namePlayer .. ")")
                        ExecuteCommand("freeze " .. IdSelected)

                    else
                        ESX.ShowNotification("~g~Joueur Defreeze (" .. namePlayer .. ")")
                        ExecuteCommand("unfreeze " .. IdSelected)
                    end
                end
            end)

            if superadmin then
                RageUI.ButtonWithStyle("Wipe l'inventaire", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ExecuteCommand("clearinventory " .. IdSelected)
                        ESX.ShowNotification("Vous venez d'enlever tout les items de ~b~" .. namePlayer .. "~s~ !")
                    end
                end)
            end

            if superadmin then
                RageUI.ButtonWithStyle("Wipe les armes", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ExecuteCommand("clearloadout " .. IdSelected)
                        ESX.ShowNotification("Vous venez de enlever toutes les armes de ~b~" .. namePlayer .. "~s~ !")
                    end
                end)
            end

            RageUI.ButtonWithStyle("Give un item", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local item = KeyBoardText("Item", "", 10)
                    local amount = KeyBoardText("Nombre", "", 10)
                    if item and amount then
                        ExecuteCommand("giveitem " .. IdSelected .. " " .. item .. " " .. amount)
                        ESX.ShowNotification("Vous venez de donner ~g~" .. amount .. " " .. item .. " ~w~à " ..
                                                 namePlayer)
                    else
                        RageUI.CloseAll()
                    end
                end
            end)

            if superadmin then
                RageUI.ButtonWithStyle("Give une arme", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local weapon = KeyBoardText("WEAPON_...", "", 100)
                        local ammo = KeyBoardText("Munitions", "", 100)
                        if weapon and ammo then
                            ExecuteCommand("giveweapon " .. IdSelected .. " " .. weapon .. " " .. ammo)
                            ESX.ShowNotification("Vous venez de donner ~g~" .. weapon .. " avec " .. ammo ..
                                                     " munitions ~w~à " .. namePlayer)
                        else
                            RageUI.CloseAll()
                        end
                    end
                end)

                RageUI.ButtonWithStyle("~o~Kick", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local raison = KeyBoardText("Raison du kick", "", 100)
                        ExecuteCommand('kick ' .. IdSelected .. " " .. raison)
                    end
                end)

                RageUI.ButtonWithStyle("~r~Ban", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local quelid = KeyBoardText("ID", "", 100)
                        local day = KeyBoardText("Jours", "", 100)
                        local raison = KeyBoardText("Raison du kick", "", 100)
                        if quelid and day and raison then
                            ExecuteCommand("sqlban " .. quelid .. " " .. day .. " " .. raison)
                            ESX.ShowNotification("Vous venez de ban l\'ID :" .. quelid .. " " .. day ..
                                                     " pour la raison suivante : " .. raison)
                        else
                            RageUI.CloseAll()
                        end
                    end
                end)

            end

        end, function()
        end)

        Citizen.Wait(0)
    end
end)

----------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 82) then
            ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
                playergroup = group
                if playergroup == 'admin' then
                    superadmin = true
                    ESX.TriggerServerCallback('serversessionid', function(ServersIdSessio)
                        ServersIdSession = ServersIdSessio
                        RageUI.Visible(RMenu:Get('AdminMenu', 'main'),
                            not RageUI.Visible(RMenu:Get('AdminMenu', 'main')))
                            for k, v in ipairs(ServersIdSession) do
                                IdSelected = v.id
                                namePlayer = v.name
                                coord = v.coord
                            end
                            TriggerServerEvent('discordlog:adminmenu',namePlayer,"```Passe en admin ```",56108)
                    end)
                else
                    superadmin = false
                end
            end)
        end
    end
end)



------------

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

function GeneratePlate(job)
    local generatedPlate
    local doBreak = false
    local plateUnauthorized = false
    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        local plate = GetRandomLetter(4) .. GetRandomNumber(4)

        for k, v in pairs(Config.PlaquesJob) do
            if job ~= nil then
                if v.job == job then
                    plate = v.plaque .. GetRandomNumber(4)
                end
            else
                if plate:find(v.plaque) then
                    plateUnauthorized = true
                end
            end
        end

        generatedPlate = string.upper(plate)

        ESX.TriggerServerCallback('h4ci_concess:verifierplaquedispo', function(isPlateTaken)
            if not isPlateTaken and not plateUnauthorized then
                doBreak = true
            end
        end, generatedPlate)

        if doBreak then
            break
        end
    end

    return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
    local callback = 'waiting'

    ESX.TriggerServerCallback('h4ci_concess:verifierplaquedispo', function(isPlateTaken)
        callback = isPlateTaken
    end, plate)

    while type(callback) == 'string' do
        Citizen.Wait(0)
    end

    return callback
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

----------

RegisterNetEvent("client:ChangePlate")
AddEventHandler("client:ChangePlate", function(plate)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)
    SetVehicleNumberPlateText(vehicle, plate)
end)

