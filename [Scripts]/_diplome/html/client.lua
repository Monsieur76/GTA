ESX = nil
local PlayerData = {}
local BlipPosition = vector3(-1635.31, 181.25, 61.76)
CreateThread(function()
    local blipDiploma = AddBlipForCoord(BlipPosition.x, BlipPosition.y, BlipPosition.z)
    SetBlipSprite(blipDiploma, 498)
    SetBlipDisplay(blipDiploma, 4)
    SetBlipColour(blipDiploma, 24)
    SetBlipScale(blipDiploma, 0.7)
    SetBlipAsShortRange(blipDiploma, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Université")
    EndTextCommandSetBlipName(blipDiploma)

end)
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.IsPlayerLoaded == false do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    SetNuiFocus(false, false)

    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = #(pos - BlipPosition)
        local plyCoords = GetEntityCoords(ped, false)
        DrawMarker(1, BlipPosition.x, BlipPosition.y, BlipPosition.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.5,
            25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
        if dist <= 2 then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Université")

            if IsControlJustReleased(0, 38) then
                RageUI.Visible(RMenu:Get('universite', 'main'), not RageUI.Visible(RMenu:Get('universite', 'main')))
            end
        end
        if dist > 3 then
            RageUI.CloseAll()
        end
    end

end)

RMenu.Add('universite', 'main', RageUI.CreateMenu("Université", "~b~Bienvenue à l\'université"))
Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('universite', 'main'), true, true, true, function()
            for k, v in pairs(Config.Diplomas) do
                local userHasDiploma = HasValue(PlayerData.diplomas, v)
                local descriptionString = userHasDiploma and "Vous avez déjà le diplôme de " .. v.label .. "." or
                                              "Passer le diplôme de " .. v.label .. " pour " .. v.price .. "$."
                RageUI.Button("Diplôme de " .. v.label, descriptionString, {
                    RightLabel = userHasDiploma and "" or v.price .. "$",
                    RightBadge = userHasDiploma and RageUI.BadgeStyle.Tick or nil
                }, true, function(Hovered, Active, Selected)
                    if Selected and not userHasDiploma then
                        if PayDiploma(v.price) then
                            LaunchDiplomaTest(v)
                        end
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end)

        Citizen.Wait(0)
    end
end)
function PayDiploma(price)
    if PlayerData.money < price then
        ESX.ShowNotification("Vous n'avez pas assez ~r~d\'argent~w~ (" .. price .. "$)")
        return false
    else
        TriggerServerEvent("diploma:payDiploma", price)
        ESX.ShowNotification("Vous avez payé ~g~" .. price .. "$")
        return true
    end

end
function LaunchDiplomaTest(diploma)
    ESX.TriggerServerCallback('esx_documents:getPlayerDetails', function(cb_player_details)
        if cb_player_details ~= nil then
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "createNewForm",
                data = {
                    headerTitle = "Examen",
                    headerSubtitle = "Examen pour le diplôme de " .. diploma.label .. ".",
                    headerFirstName = cb_player_details.firstname,
                    headerLastName = cb_player_details.lastname,
                    diplomaQuestions = diploma.questions,
                    diplomaLabel = diploma.label,
                    diplomaName = diploma.name
                }
            })
        else
            print("Received nil from newely created scale object.")
        end
    end)

end

function HasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

RegisterNUICallback('form_close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('form_submit', function(data, cb)
    local errors = 0
    for k, v in pairs(data.elements) do
        if v.value ~= v.answer then
            errors = errors + 1
        end
    end
    local isNoErrorsDiploma = HasValue(Config.DiplomasNoErrorsAllowed, data.diplomaName)
    if isNoErrorsDiploma and errors > 0 or not isNoErrorsDiploma and errors > Config.MaxErrorsAllowed then
        ESX.ShowNotification("Vous avez ~r~raté~w~ le diplôme de " .. data.diplomaLabel .. " avec ~r~" .. errors ..
                                 " erreurs !~w~")
    else
        TriggerServerEvent("diploma:grantDiploma", data.diplomaName)
        ESX.ShowNotification("Vous avez ~g~réussi~w~ le diplôme de " .. data.diplomaLabel ..
                                 " ! ~g~Félicitations~w~ !")

    end
    SetNuiFocus(false, false)
end)
