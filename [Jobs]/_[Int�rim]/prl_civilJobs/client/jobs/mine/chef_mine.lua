RMenu.Add('mine', 'main', RageUI.CreateMenu("mine", " "))
RMenu:Get('mine', 'main'):SetSubtitle("~b~Manager de la mine")
RMenu:Get('mine', 'main').EnableMouse = false;
RMenu:Get('mine', 'main').Closed = function()
    RenderScriptCams(0, 1, 1500, 1, 1)
    DestroyCam(cam, 1)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
end

local vehicle = nil


local skine
local clothesSkin

RageUI.CreateWhile(1.0, function()
    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), zone.mine, true)
    if distance <= 3.0 then
        HelpMsg("Appuyer sur ~b~E~w~ pour parler avec la personne.")
        if IsControlJustPressed(1, 51) and distance <= 3.0 then
            RageUI.Visible(RMenu:Get('mine', 'main'), not RageUI.Visible(RMenu:Get('mine', 'main')))
            CreateCamera()
        end
    end

    if RageUI.Visible(RMenu:Get('mine', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()
            if not AuTravaillemine then
                RageUI.Button("Demander à travailler sur le mine", "", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        RageUI.Popup({
                            message = "Alors comme ça tu veux bosser à la ~g~mine~w~ hein ? Très bien, met un casque et prends t'es outils ! Je te préviens c'est pas pour les petite    merdes !",
                        })
                        RageUI.Visible(RMenu:Get('mine', 'main'), not RageUI.Visible(RMenu:Get('mine', 'main')))
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravaillemine = true
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skine == 0 then
                                clothesSkin = {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 59, ['tshirt_2'] = 0,
                                    ['torso_1'] = 55, ['torso_2'] = 0,
                                    ['arms'] = 30,
                                    ['pants_1'] = 31, ['pants_2'] = 0,
                                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0, ['bproof_2'] = 0,
                                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                                }
                            else
                                clothesSkin = {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 36, ['tshirt_2'] = 0,
                                    ['torso_1'] = 49, ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['pants_1'] = 45, ['pants_2'] = 0,
                                    ['shoes_1'] = 26, ['shoes_2'] = 0,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0, ['bproof_2'] = 0,
                                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                                }
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                        StartTravaillemine()
                    end
                end)
            else
                RageUI.Button("Arreter de travailler", "", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        RageUI.Popup({
                            message = "haha ! Tu stop déja ! Allez prends ta paye feignant ! Merci de ton aide, revient quand tu veux.",
                        })
                        RageUI.Visible(RMenu:Get('mine', 'main'), not RageUI.Visible(RMenu:Get('mine', 'main')))
                        RenderScriptCams(0, 1, 1500, 1, 1)
                        DestroyCam(cam, 1)
                        AuTravaillemine = false
                        endwork()
                        TriggerEvent("LS_LSPD:RemoveVeh", NetworkGetEntityFromNetworkId(vehicle))
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            local isMale = skin.sex == 0
                            skine = skin.sex
                            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerEvent('esx:restoreLoadout')
                                end)
                            end)
                        end)
                    end
                end)
            end
        end, function()
            ---Panels
        end)
    end
end, 1)