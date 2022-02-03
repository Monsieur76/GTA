ESX = nil
local PlayerPed = false
local PlayerPos = false
local PlayerLastPos = 0

local InUse = false

-- // ANIMATION
local Anim = "S'asseoir"
local AnimScroll = 0

Citizen.CreateThread(function()
    while true do
        PlayerPed = PlayerPedId()
        PlayerPos = GetEntityCoords(PlayerPedId())
        Citizen.Wait(500)
    end
end)
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        local inRange = false
        for i = 1, #Config.objects.locations do
            local current = Config.objects.locations[i]
            local coordsObject = GetEntityCoords(current.object)
            local heading = GetEntityHeading(current.object)
            local dist = #(PlayerPos - vector3(coordsObject.x, coordsObject.y, coordsObject.z))
            if dist <= 2.0 then
                inRange = true
                if dist <= 2.0 and not InUse then

                    if (current.bed == true) then
                        if IsControlJustPressed(0, 175) then
                            Scroller(175)
                        end
                        if IsControlJustPressed(0, 174) then
                            Scroller(174)
                        end
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ " .. Anim ..
                                                     "\n~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~")
                        if IsControlJustPressed(0, Config.objects.ButtonToLayOnBed) then
                            TriggerServerEvent('ChairBedSystem:Server:Enter', current, coordsObject, heading)
                        end
                    else
                        ESX.ShowHelpNotification("~INPUT_DETONATE~ S'asseoir")
                        if IsControlJustPressed(0, Config.objects.ButtonToSitOnChair) then
                            TriggerServerEvent('ChairBedSystem:Server:Enter', current, coordsObject, heading)
                        end
                    end
                end

                if (InUse) then
                    ESX.ShowHelpNotification("~INPUT_PARACHUTE_DETACH~ Se lever")

                    if IsControlJustPressed(0, Config.objects.ButtonToStandUp) then
                        InUse = false
                        TriggerServerEvent('ChairBedSystem:Server:Leave', coordsObject)
                        ClearPedTasksImmediately(PlayerPed)
                        FreezeEntityPosition(PlayerPed, false)

                        local x, y, z = table.unpack(PlayerLastPos)
                        local dist = #(PlayerPos - vector3(x, y, z))
                        if dist <= 10 then
                            SetEntityCoords(PlayerPed, PlayerLastPos)
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        for i = 1, #Config.objects.locations do
            local current = Config.objects.locations[i]
            object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(current.objName), false,
                false, false)
            if object ~= 0 then
                current.object = object
            end
        end
    end
end)

function Scroller(input)
    if AnimScroll == 2 then
        if input == 174 then
            AnimScroll = AnimScroll - 1
        else
            AnimScroll = 0
        end
    elseif AnimScroll == 0 then
        if input == 174 then
            AnimScroll = 2
        else
            AnimScroll = AnimScroll + 1
        end
    else
        if input == 174 then
            AnimScroll = AnimScroll - 1
        else
            AnimScroll = AnimScroll + 1
        end
    end
    if AnimScroll == 1 then
        Anim = "S'allonger sur le dos"
    elseif AnimScroll == 2 then
        Anim = "S'allonger sur le ventre"
    elseif AnimScroll == 0 then
        Anim = "S'asseoir"
    end
end

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(v, coords, heading)
    local object = v.objName
    local vertx = v.verticalOffsetX
    local verty = v.verticalOffsetY
    local vertz = v.verticalOffsetZ
    local dir = v.direction
    local isBed = v.bed
    local lit = v.lit
    local objectcoords = coords

    local ped = PlayerPed
    PlayerLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
    InUse = true
    if isBed == false then
        if Config.objects.SitAnimation.dict ~= nil then
            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
            SetEntityHeading(ped, heading - 180.0)
            local dict = Config.objects.SitAnimation.dict
            local anim = Config.objects.SitAnimation.anim

            AnimLoadDict(dict, anim, ped)
        else
            TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation.anim, objectcoords.x + vertx,
                objectcoords.y + verty, objectcoords.z - vertz, heading + 180, 0, true, true)
        end
    else
        if Anim == 'S\'allonger sur le dos' then
            if Config.objects.BedBackAnimation.dict ~= nil then
                if lit == "diagnostic2" then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.95)
                    SetEntityHeading(ped, heading - 180.0)
                    local dict = Config.objects.BedBackAnimation.dict
                    local anim = Config.objects.BedBackAnimation.anim
                    Animation(dict, anim, ped)
                elseif lit == "diagnostic" then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.95)
                    SetEntityHeading(ped, heading - 180.0)
                    local dict = Config.objects.BedBackAnimation.dict
                    local anim = Config.objects.BedBackAnimation.anim
                    Animation(dict, anim, ped)
                elseif lit == "banale" then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.15)
                    SetEntityHeading(ped, heading - 180)
                    local dict = Config.objects.BedBackAnimation.dict
                    local anim = Config.objects.BedBackAnimation.anim
                    Animation(dict, anim, ped)
                elseif lit == "banale1" then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.35)
                    SetEntityHeading(ped, heading - 180)
                    local dict = Config.objects.BedBackAnimation.dict
                    local anim = Config.objects.BedBackAnimation.anim
                    Animation(dict, anim, ped)
                end
            else

                TaskStartScenarioAtPosition(ped, Config.objects.BedBackAnimation.anim, objectcoords.x + vertx,
                    objectcoords.y + verty, objectcoords.z + vertz, GetEntityHeading(object) + dir, 0, true, true)
            end
        elseif Anim == "S'allonger sur le ventre" then
            if Config.objects.BedStomachAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.BedStomachAnimation.dict
                local anim = Config.objects.BedStomachAnimation.anim

                Animation(dict, anim, ped)
            else
                if lit == "banale" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.17, heading, 0, true, true)
                elseif lit == "banale1" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.32, heading, 0, true, true)
                elseif lit == "diagnostic" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.99, GetEntityHeading(object) + dir, 0, true, true)
                elseif lit == "diagnostic2" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.99, GetEntityHeading(object) + dir, 0, true, true)
                else
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.57, GetEntityHeading(object) + dir, 0, true, true)
                end
            end
        elseif Anim == "S'asseoir" then
            if Config.objects.BedSitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 1)
                SetEntityHeading(ped, heading - 180.0)
                local dict = Config.objects.BedSitAnimation.dict
                local anim = Config.objects.BedSitAnimation.anim

                Animation(dict, anim, ped)
            else
                if lit == "banale" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.17, heading + 180.0, 0, true, true)
                elseif lit == "diagnostic" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.99, heading + 180.0, 0, true, true)
                elseif lit == "diagnostic2" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.99, heading + 180.0, 0, true, true)
                elseif lit == "banale1" then
                    TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx,
                        objectcoords.y + verty, objectcoords.z + 1.32, heading + 180.0, 0, true, true)
                end
            end
        end
    end
end)
