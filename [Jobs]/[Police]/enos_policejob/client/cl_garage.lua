ESX = nil

local armes = {}
local arme = {}
local loadout = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(5000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("mp_m_shopkeep_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_cop_01", 459.04, -1017.25, 27.15, 88.98, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)

-------caméra

RMenu.Add('camera', 'main', RageUI.CreateMenu("Caméra", " "))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('camera', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Caméra 4", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 1)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 5", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 2)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 6", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 3)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 7", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 4)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 8", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 5)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 9", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 6)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 10", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 7)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 11", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 8)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 12", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 9)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 13", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 10)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 14", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 11)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 15", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 12)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 16", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 13)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 17", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 14)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 18", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 15)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 19", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 16)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 20", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 17)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 21", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 18)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 22", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 19)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 23", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 20)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 24", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 21)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 25", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 22)
                end
            end)

            RageUI.ButtonWithStyle("Caméra 26", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('cctv:camera', 23)
                end
            end)

        end, function()
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
            local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
            local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.pos.camera.position.x,
                Config.pos.camera.position.y, Config.pos.camera.position.z)
            DrawMarker(1, Config.pos.camera.position.x, Config.pos.camera.position.y, Config.pos.camera.position.z, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            if dist2 <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Caméras")
                if IsControlJustPressed(1, 51) then

                    RageUI.Visible(RMenu:Get('camera', 'main'), not RageUI.Visible(RMenu:Get('camera', 'main')))
                end
            end
        end
    end
end)
