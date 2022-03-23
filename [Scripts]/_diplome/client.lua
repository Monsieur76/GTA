ESX = nil
local BlipPosition = vector3(-1635.31, 181.25, 61.76)
local diplomasOpen = false
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
        if IsControlJustReleased(0, 322) and diplomasOpen then
            SendNUIMessage({
                type = "closeDiplomas",
                data = {}
            })
            diplomasOpen = false
        end
    end

end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RMenu.Add('universite', 'main', RageUI.CreateMenu("Université", "~b~Bienvenue à l\'université"))
Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('universite', 'main'), true, true, true, function()
            for k, v in pairs(Config.Diplomas) do
                local userHasDiploma = HasValue(ESX.PlayerData.diplomas, v.name)
                local descriptionString = userHasDiploma and "Vous avez déjà le diplôme de " .. v.label .. "." or
                                              "Passer le diplôme de " .. v.label .. " pour " .. v.price .. "$."
                RageUI.Button("Diplôme de " .. v.label, descriptionString, {
                    RightLabel = userHasDiploma and "" or v.price .. "$",
                    RightBadge = userHasDiploma and RageUI.BadgeStyle.Tick or nil
                }, not userHasDiploma, function(Hovered, Active, Selected)
                    if Selected and not userHasDiploma then
                        ESX.TriggerServerCallback('diploma:enoughMoneyForDiploma', function(enoughMoney)
                            if enoughMoney then
                                TriggerServerEvent("diploma:payDiploma", v.price)
                                ESX.ShowNotification("Vous avez payé ~g~" .. v.price .. "$")
                                LaunchDiplomaTest(v)
                            else
                                ESX.ShowNotification("Vous n'avez pas assez ~r~d\'argent~w~ (" .. v.price .. "$)")
                            end
                            RageUI.CloseAll()
                        end, v.price)
                    end
                end)
            end
        end, function()
        end)

        Citizen.Wait(0)
    end
end)
function LaunchDiplomaTest(diploma)
    ESX.TriggerServerCallback('diploma:getPlayerDetails', function(cb_player_details)
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

RegisterNetEvent('diploma:open')
AddEventHandler('diploma:open', function(data)
    local dataToSend = {}
    dataToSend.diplomas = {}
    dataToSend.user = data.user
    ESX.PlayerData.diplomas = json.decode(data.diplomas)
    for k, v in pairs(ESX.PlayerData.diplomas) do
        local foundDiploma = Find(function(value)
            return value.name == v
        end, Config.Diplomas)
        if foundDiploma ~= nil then
            table.insert(dataToSend.diplomas, foundDiploma.label)
        end
    end
    SendNUIMessage({
        type = "openDiplomas",
        data = dataToSend
    })
    diplomasOpen = true

end)
function HasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
function Find(f, l) -- find element v of l satisfying f(v)
    for _, v in ipairs(l) do
        if f(v) then
            return v
        end
    end
    return nil
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
        SetNuiFocus(false, false)
    else
        ESX.TriggerServerCallback('diploma:grantDiploma', function(diplomas)
            ESX.ShowNotification("Vous avez ~g~réussi~w~ le diplôme de " .. data.diplomaLabel ..
                                     " ! ~g~Félicitations~w~ !")
            ESX.PlayerData.diplomas = diplomas
            SetNuiFocus(false, false)
        end, data.diplomaName)
    end

end)
