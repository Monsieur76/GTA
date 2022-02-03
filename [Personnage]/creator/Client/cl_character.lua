local sexeSelect = 0
local teteSelect = 0
local colorPeauSelect = 0
local cheveuxSelect = 0
local bebarSelect = -1
local poilsCouleurSelect = 0
local ImperfectionsPeau = 0
local face, acne, skin, eyecolor, skinproblem, freckle, wrinkle, hair, haircolor, eyebrow, beard, beardcolor
local camfin = false
local Character = {}
local Vetement = {}
local accesorie = {}
local ResultPrenom
local ResultNom
local ResultDateDeNaissance
local ResultTaille
local ResultSexe

--Nehco

PMenu = {}
PMenu.Data = {}

local playerPed = PlayerPedId()
local incamera = false
local board_scaleform
local handle
local board
local board_model = GetHashKey("prop_police_id_board")
local board_pos = vector3(0.0,0.0,0.0)
local overlay
local overlay_model = GetHashKey("prop_police_id_text")
local isinintroduction = false
local pressedenter = false
local introstep = 0
local timer = 0
local inputgroups = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
local enanimcinematique = false
local guiEnabled = false

local sound = false
local spawnfirst = false




local function CallScaleformMethod (scaleform, method, ...)
	local t
	local args = { ... }

	BeginScaleformMovieMethod(scaleform, method)

	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end


local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(10)
		end
		if FirstSpawn then
			--ESX.TriggerServerCallback('esx_skin:getPlayerSkinAcessesoire', function(skin, clothe, accesorie)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
				if skin == nil then
                    spawnfirst = true
                    colli ()
                    FreezeEntityPosition(PlayerPedId(), true)
					TriggerEvent('Nehco:create')
				else
                    --TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe,accesorie)
                    --spawncinematiqueplayer()
				end
			end)
			FirstSpawn = false
		end
	end)
end)


function createcamvisage(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    local coords = GetEntityCoords(PlayerPedId())
    GetEntityHeading(PlayerPedId())
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y-1.5, coords.z+0.7, 0.0, 0.0,  GetEntityHeading(PlayerPedId())+180, 15.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y-1.5, coords.z+0.7, 0.0, 0.0,  GetEntityHeading(PlayerPedId())+180, 15.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end

function createcamcinematique(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', -265.7774, -357.2067, 49.9656, -35.0, 0.0, -30.6976, 40.0, false, 0) --  -490.69, -667.96, 47.43, Personnage marche
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', -265.7774, -357.2067, 49.9656, -35.0, 0.0, -30.6976, 40.0, false, 0) --  -490.69, -667.96, 47.43, Fin de Marche
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end


function createcamyeux(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    local coords = GetEntityCoords(PlayerPedId())
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x-2.0, coords.y-1.0, coords.z+0.5, 0.0, 0.0, 88.455696105957, 10.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x-2.0, coords.y-1.0, coords.z+0.5, 0.0, 0.0, 88.455696105957, 10.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end



function createcam(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 410.2, -998.60, -98.5, -18.0, 0.0, 89.60, 70.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 410.2, -998.60, -98.5, -18.0, 0.0, 89.60, 70.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end

function createcamfin(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 414.64, -998.16, -98.68, 0.0, 0.0, 88.455696105957, 60.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 414.64, -998.16, -98.68, 0.0, 0.0, 88.455696105957, 60.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end


function CreateCamEnter()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 415.55, -998.50, -99.29, 0.00, 0.00, 89.75, 50.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true) 
end



function SpawnCharacter()
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 411.30, -998.62, -99.01, 0.00, 0.00, 89.75, 50.00, false, 0)
    PointCamAtCoord(cam2, 411.30, -998.62, -99.01)
    SetCamActiveWithInterp(cam2, cam, 5000, true, true)
end

function destorycam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent('barbershop:removeposition')
end


function openCinematique()
	hasCinematic = not hasCinematic
	if not hasCinematic then
        SendNUIMessage({openCinema = false})
        ESX.UI.HUD.SetDisplay(1.0)
        TriggerEvent('es:setMoneyDisplay', 1.0)
        TriggerEvent('esx:setDisplay', 1.0)
        DisplayRadar(true)
        TriggerEvent('ui:toggle', true)
	elseif hasCinematic then
		SendNUIMessage({openCinema = true})
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
		TriggerEvent('esx:setDisplay', 0.0)
		DisplayRadar(false)
		TriggerEvent('ui:toggle', false)
	end
end




--function startAnims(lib, anim)
	--ESX.Streaming.RequestAnimDict(lib, function()
		--TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 14, 0, false, false, false)
	--end)
--end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


	AddTextEntry('CREATOR_INPUT', TextEntry)
	
	blockinput = true
    DisplayOnscreenKeyboard(1, "CREATOR_INPUT", "", ExampleText, "", "", "", MaxStringLenght)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end 
		 
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(0)
		blockinput = false 
		return result
	else
		Citizen.Wait(0)
		blockinput = false 
		return nil 
	end
end 

local isCameraActive = false


--ESX								= nil
isRegistered = nil

local sexeSelect = 0
local teteSelect = 0
local colorPeauSelect = 0
local cheveuxSelect = 0
local bebarSelect = -1
local poilsCouleurSelect = 0
local ImperfectionsPeau = 0
local face, acne, skin, eyecolor, skinproblem, freckle, wrinkle, hair, haircolor, eyebrow, beard, beardcolor


function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

ESX = nil
PMenu = {}
PMenu.Data = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

function openCinematique()
    hasCinematic = not hasCinematic
    if not hasCinematic then -- show
        SendNUIMessage({openCinema = false})
        ESX.UI.HUD.SetDisplay(1.0)
        TriggerEvent('es:setMoneyDisplay', 1.0)
        TriggerEvent('esx:setDisplay', 1.0)
        DisplayRadar(true)
        TriggerEvent('ui:toggle', true)
    elseif hasCinematic then -- hide
        SendNUIMessage({openCinema = true})
        ESX.UI.HUD.SetDisplay(0.0)
        TriggerEvent('es:setMoneyDisplay', 0.0)
        TriggerEvent('esx:setDisplay', 0.0)
        DisplayRadar(false)
        TriggerEvent('ui:toggle', false)
    end
end

function ajoutAcces()
    if table.findKey('ears_1', accesorie) == false then
        accesorie['ears_1'] = -1
    end
    if table.findKey('ears_2', accesorie) == false then
        accesorie['ears_2'] = -1
    end
    if table.findKey('helmet_1', accesorie) == false then
        accesorie['helmet_1'] = -1
    end
    if table.findKey('helmet_2', accesorie) == false then
        accesorie['helmet_2'] = -1
    end
    if table.findKey('glasses_1', accesorie) == false then
        accesorie['glasses_1'] = -1
    end
    if table.findKey('glasses_2', accesorie) == false then
        accesorie['glasses_2'] = -1
    end
    if table.findKey('watches_1', accesorie) == false then
        accesorie['watches_1'] = -1
    end
    if table.findKey('watches_2', accesorie) == false then
        accesorie['watches_2'] = -1
    end
    if table.findKey('bracelets_1', accesorie) == false then
        accesorie['bracelets_1'] = -1
    end
    if table.findKey('bracelets_2', accesorie) == false then
        accesorie['bracelets_2'] = -1
    end
    if table.findKey('chain_1', accesorie) == false then
        accesorie['chain_1'] = -1
    end
    if table.findKey('chain_2', accesorie) == false then
        accesorie['chain_2'] = -1
    end
    if table.findKey('mask_1', accesorie) == false then
        accesorie['mask_1'] = -1
    end
    if table.findKey('mask_2', accesorie) == false then
        accesorie['mask_2'] = -1
    end
end

RegisterNetEvent('Nehco:SpawnCharacter')
AddEventHandler('Nehco:SpawnCharacter', function(spawn)
	openCinematique()
	CloseMenu('creationPerso')
	DisplayRadar(false)
    TriggerServerEvent('SavellPlayer')
	RenderScriptCams(0, 0, 1, 1, 1)
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(PlayerPedId())
    DoScreenFadeOut(0)
	SetTimecycleModifier('rply_saturation')
	SetTimecycleModifier('rply_vignette')
    SetEntityCoords(PlayerPedId(), -491.0, -737.32, 23.92-0.98)
    SetEntityHeading(PlayerPedId(), 359.3586730957)
    ExecuteCommand('e sitchair4')
    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(1500)
	Citizen.Wait(3500)
    ClearPedTasks(PlayerPedId())

    TriggerServerEvent("InteractSound_SV:PlayOnSource", "INTRO",1)


    TaskPedSlideToCoord(PlayerPedId(), -491.68, -681.96, 33.2, 359.3586730957, 1.0)
	Citizen.Wait(33000)
	openCinematique()
    SetTimecycleModifier('')
	--PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    ajoutAcces()
    TriggerServerEvent('esx_skin:saveAcess',accesorie)
    TriggerEvent('instance:close')
    for i = 0, 357 do
        EnableAllControlActions(i)
	end
	DisplayRadar(true)
    spawnfirst= false
    TriggerEvent('invisibilite',spawnfirst)
    local plate     = GeneratePlate()
    local vehicle = {["modArmor"]=-1,["modTrunk"]=-1,["modFrame"]=-1,["modLivery"]=-1,["modFrontBumper"]=-1,["pearlescentColor"]=54,["modHorns"]=-1,["xenonColor"]=255,["modTrimB"]=-1,["modAerials"]=-1,
        ["modBrakes"]=-1,["modAPlate"]=-1,["modSuspension"]=-1,["modXenon"]=false,["plate"]=plate,["tankHealth"]=1000.0,["modHood"]=-1,["modFrontWheels"]=-1,["modFender"]=-1,["wheels"]=4,["modVanityPlate"]=-1,
        ["modShifterLeavers"]=-1,["dirtLevel"]=10.0,["wheelColor"]=156,["modEngine"]=-1,["color2"]=0,["modStruts"]=-1,["modSpeakers"]=-1,["modTransmission"]=-1,["fuelLevel"]=100.0,["modSeats"]=-1,["modTank"]=-1,
        ["modRightFender"]=-1,["extras"]={["2"]=false,["1"]=false,["3"]=false},["modDial"]=-1,["modRearBumper"]=-1,["modBackWheels"]=-1,["neonColor"]={255,0,255},["bodyHealth"]=1000.0,["modExhaust"]=-1,["modSteeringWheel"]=-1,
        ["modPlateHolder"]=-1,["modSideSkirt"]=-1,["modRoof"]=-1,["color1"]=54,["modSmokeEnabled"]=false,["modGrille"]=-1,["engineHealth"]=1000.0,["neonEnabled"]={false,false,false,false},["modTrimA"]=-1,["windowTint"]=-1,
        ["model"]=92612664,["modEngineBlock"]=-1,["modDashboard"]=-1,["modTurbo"]=false,["tyreSmokeColor"]={255,255,255},["modAirFilter"]=-1,["modWindows"]=-1,["modDoorSpeaker"]=-1,["modOrnaments"]=-1,["modArchCover"]=-1,
        ["plateIndex"]=3,["modSpoilers"]=-1,["modHydrolic"]=-1}
    TriggerServerEvent('CreatVehicle',plate,vehicle)
    TriggerServerEvent('ddx_vehiclelock:registerkey', plate,"no")

end)

local sexe = { 
	"Homme",
	"Femme"
}


function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end


local Character = {}

local pedlist ={
	"zeez",
	"Test",
	"DZD"
}


function createcamcinematique(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', -265.7774, -357.2067, 49.9656, -35.0, 0.0, -30.6976, 40.0, false, 0) --  -490.69, -667.96, 47.43, Personnage marche
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', -265.7774, -357.2067, 49.9656, -35.0, 0.0, -30.6976, 40.0, false, 0) --  -490.69, -667.96, 47.43, Fin de Marche
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end



function createcam(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 402.8, -998.60, -98.5, -18.0, 0.0, 0.60, 70.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 402.8, -998.60, -98.5, -18.0, 0.0, 0.60, 70.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end

function createcamfin(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 414.64, -998.16, -98.68, 0.0, 0.0, 0.455696105957, 60.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 414.64, -998.16, -98.68, 0.0, 0.0, 0.455696105957, 60.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end



function createcamtorse(default)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    local coords = GetEntityCoords(PlayerPedId())
    if (not DoesCamExist(cam)) then
        if default then
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA',coords.x, coords.y-2.5, coords.z+0.60, 0.0, 0.0, 0.455696105957, 27.0, false, 0)
        else
            cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y-2.5, coords.z+0.60, 0.0, 0.0, 0.455696105957, 27.0, false, 0)
        end
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)
    end
end

function createcamnehco(default)
        DisplayRadar(false)
        TriggerEvent('esx:setDisplay', 0.0)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if (not DoesCamExist(cam)) then
            if default then
                cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 98.2, -603.60, 276.5, -18.0, 0.0, 89.60, 70.0, false, 0)
            else
                cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 98.2, -603.60, 276.5, -18.0, 0.0, 89.60, 70.0, false, 0)
            end
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, false)
        end
    end

    function createcamdb(default)
        DisplayRadar(false)
        TriggerEvent('esx:setDisplay', 0.0)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if (not DoesCamExist(cam)) then
            if default then
                cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 98.2, -603.60, 276.5, -18.0, 0.0, 89.60, 70.0, false, 0)
            else
                cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 98.2, -603.60, 276.5, -18.0, 0.0, 89.60, 70.0, false, 0)
            end
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, false)
        end
    end

    function ajout()
        if table.findKey('mom', Character) == false then
            Character['mom'] = 0
        end
        if table.findKey('dad', Character) == false then
            Character['dad'] = 0
        end
        if table.findKey('face_md_weight', Character) == false then
            Character['face_md_weight'] = 0
        end
        if table.findKey('skin_md_weight', Character) == false then
            Character['skin_md_weight'] = 0
        end
        if table.findKey('nose_1', Character) == false then
            Character['nose_1'] = 0
        end
        if table.findKey('nose_2', Character) == false then
            Character['nose_2'] = 0
        end
        if table.findKey('nose_3', Character) == false then
            Character['nose_3'] = 0
        end
        if table.findKey('nose_4', Character) == false then
            Character['nose_4'] = 0
        end
        if table.findKey('nose_5', Character) == false then
            Character['nose_5'] = 0
        end
        if table.findKey('nose_6', Character) == false then
            Character['nose_6'] = 0
        end
        if table.findKey('cheeks_1', Character) == false then
            Character['cheeks_1'] = 0
        end
        if table.findKey('cheeks_2', Character) == false then
            Character['cheeks_2'] = 0
        end
        if table.findKey('cheeks_3', Character) == false then
            Character['cheeks_3'] = 0
        end
        if table.findKey('lip_thickness', Character) == false then
            Character['lip_thickness'] = 0
        end
        if table.findKey('jaw_1', Character) == false then
            Character['jaw_1'] = 0
        end
        if table.findKey('jaw_2', Character) == false then
            Character['jaw_2'] = 0
        end
        if table.findKey('chin_1', Character) == false then
            Character['chin_1'] = 0
        end
        if table.findKey('chin_2', Character) == false then
            Character['chin_2'] = 0
        end
        if table.findKey('chin_3', Character) == false then
            Character['chin_3'] = 0
        end
        if table.findKey('chin_4', Character) == false then
            Character['chin_4'] = 0
        end
        if table.findKey('neck_thickness', Character) == false then
            Character['neck_thickness'] = 0
        end
        if table.findKey('age_1', Character) == false then
            Character['age_1'] = 0
        end
        if table.findKey('age_2', Character) == false then
            Character['age_2'] = 0.0
        end
        if table.findKey('eye_color', Character) == false then
            Character['eye_color'] = 0
        end
        if table.findKey('eye_squint', Character) == false then
            Character['eye_squint'] = 0
        end
        if table.findKey('beard_1', Character) == false then
            Character['beard_1'] = 0
        end
        if table.findKey('beard_2', Character) == false then
            Character['beard_2'] = 0.0
        end
        if table.findKey('beard_3', Character) == false then
            Character['beard_3'] = 0
        end
        if table.findKey('beard_4', Character) == false then
            Character['beard_4'] = 0
        end
        if table.findKey('hair_1', Character) == false then
            Character['hair_1'] = 0
        end
        if table.findKey('hair_2', Character) == false then
            Character['hair_2'] = 0
        end
        if table.findKey('hair_color_1', Character) == false then
            Character['hair_color_1'] = 0
        end
        if table.findKey('hair_color_2', Character) == false then
            Character['hair_color_2'] = 0
        end
        if table.findKey('eyebrows_1', Character) == false then
            Character['eyebrows_1'] = 0
        end
        if table.findKey('eyebrows_2', Character) == false then
            Character['eyebrows_2'] = 0.0
        end
        if table.findKey('eyebrows_3', Character) == false then
            Character['eyebrows_3'] = 0
        end
        if table.findKey('eyebrows_4', Character) == false then
            Character['eyebrows_4'] = 0
        end
        if table.findKey('eyebrows_5', Character) == false then
            Character['eyebrows_5'] = 0
        end
        if table.findKey('eyebrows_6', Character) == false then
            Character['eyebrows_6'] = 0
        end
        if table.findKey('makeup_1', Character) == false then
            Character['makeup_1'] = 0
        end
        if table.findKey('makeup_2', Character) == false then
            Character['makeup_2'] = 0.0
        end
        if table.findKey('makeup_3', Character) == false then
            Character['makeup_3'] = 0
        end
        if table.findKey('makeup_4', Character) == false then
            Character['makeup_4'] = 0
        end
        if table.findKey('lipstick_1', Character) == false then
            Character['lipstick_1'] = 0
        end
        if table.findKey('lipstick_2', Character) == false then
            Character['lipstick_2'] = 0.0
        end
        if table.findKey('lipstick_3', Character) == false then
            Character['lipstick_3'] = 0
        end
        if table.findKey('lipstick_4', Character) == false then
            Character['lipstick_4'] = 0
        end
        if table.findKey('blemishes_1', Character) == false then
            Character['blemishes_1'] = 0
        end
        if table.findKey('blemishes_2', Character) == false then
            Character['blemishes_2'] = 0.0
        end
        if table.findKey('blemishes_3', Character) == false then
            Character['blemishes_3'] = 0
        end
        if table.findKey('blush_1', Character) == false then
            Character['blush_1'] = 0
        end
        if table.findKey('blush_2', Character) == false then
            Character['blush_2'] = 0.0
        end
        if table.findKey('blush_3', Character) == false then
            Character['blush_3'] = 0
        end
        if table.findKey('complexion_1', Character) == false then
            Character['complexion_1'] = 0
        end
        if table.findKey('complexion_2', Character) == false then
            Character['complexion_2'] = 0.0
        end
        if table.findKey('sun_1', Character) == false then
            Character['sun_1'] = 0
        end
        if table.findKey('sun_2', Character) == false then
            Character['sun_2'] = 0.0
        end
        if table.findKey('moles_1', Character) == false then
            Character['moles_1'] = 0
        end
        if table.findKey('moles_2', Character) == false then
            Character['moles_2'] = 0.0
        end
        if table.findKey('chest_1', Character) == false then
            Character['chest_1'] = 0
        end
        if table.findKey('chest_2', Character) == false then
            Character['chest_2'] = 0.0
        end
        if table.findKey('chest_3', Character) == false then
            Character['chest_3'] = 0
        end
        if table.findKey('bodyb_1', Character) == false then
            Character['bodyb_1'] = 0
        end
        if table.findKey('bodyb_2', Character) == false then
            Character['bodyb_2'] = 0.0
        end
        if table.findKey('bodyb_3', Character) == false then
            Character['bodyb_3'] = 0
        end
    end

    function table.findKey(f, l)
        for k, v in pairs(l) do
          if k == f then
            return true
          end
        end
        return false
      end

function CreateCam()
  --  cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.1680, -998.27, -99.00, 0.00, 300.00, 0.75, 30.00, false, 0)
  	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 403.03, -998.33, -98.20, -20.00, 0.00, 0.00, 70.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true) 
end
function CreateCame()
	SetCamActive(cam, false)
	RenderScriptCams(true, false, 2000, true, true) 
end


local creationPerso = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, Blocked = true , HeaderColor = {0, 255, 255}, Title = "Menu Création"},
	Data = { currentMenu = "Commencer à créer votre carte d'identité !" },
	Events = {onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
		--PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		--PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		local slide = btn.slidenum
		local btn = btn.name --bug
		local check = btn.unkCheckbox
		local myIdentity = {}
		local data = {}
		local currentMenu, ped = menuData.currentMenu, PlayerPedId()
		if btn.name == "Traits du visage" then 
			OpenMenu("Traits du visage")
		elseif btn.name == "Apparence" then
			OpenMenu("Apparence")
		elseif btn.name == "Barbe" then 
			OpenMenu("Barbe")
		elseif btn.name == "Pilosité" then 
			OpenMenu("Pilosité")
		elseif btn.name == "Maquillage" then 
			OpenMenu("Maquillage")
		elseif btn.name == "Tenues" then 
			OpenMenu("Tenues")
		elseif btn.name == "Bras" then 
            OpenMenu("Bras")
        elseif btn.name == "Peau" then 
            OpenMenu("Peau")
        elseif btn.name == "Type de bras" then 
            OpenMenu("Type de bras")
        elseif btn.name == "Couleur des bras" then 
            OpenMenu("Couleur des bras")
        elseif btn.name == "Couleur des yeux" then 
            OpenMenu("Couleur des yeux")
        elseif btn.name == "Imperfections du corps" then 
            OpenMenu("Imperfections du corps")
        elseif btn.name == "Opacité imperfections du corps" then 
            OpenMenu("Opacité imperfections du corps")
        elseif btn == "Chaussures" then
            OpenMenu('Chaussures')
        elseif btn == "Couleur des chaussures" then
            OpenMenu('Couleur des chaussures')
        elseif btn == "Bas" then
            OpenMenu('Bas')
        elseif btn == "Couleur du bas" then
            OpenMenu('Couleur du bas')
        elseif btn == "Veste" then
            OpenMenu('Veste')
        elseif btn == "Couleur veste" then
            OpenMenu('Couleur veste')
        elseif btn == "Couleur t-shirt" then
            OpenMenu('Couleur t-shirt')
        elseif btn == "T-shirt" then
            OpenMenu('T-shirt')
        elseif btn == "Type de maquillage" then
            OpenMenu('Type de maquillage')
        elseif btn == "Opacité du maquillage" then
            OpenMenu('Opacité du maquillage')
        elseif btn == "Couleur du maquillage" then
            OpenMenu('Couleur du maquillage')
        elseif btn == "Type de rouge à lèvres" then
            OpenMenu('Type de rouge à lèvres')
        elseif btn == "Opacité du rouge à lèvres" then
            OpenMenu('Opacité du rouge à lèvres')
        elseif btn == "Couleur du rouge à lèvres" then
            OpenMenu('Couleur du rouge à lèvres')
        elseif btn == "Acné" then
            OpenMenu('Acné')
        elseif btn == "Taille de la barbe" then
            OpenMenu('Taille de la barbe')
        elseif btn == "Type de la barbe" then
            OpenMenu('Type de la barbe')
        elseif btn == "Couleur de la barbe" then
            OpenMenu('Couleur de la barbe')
        elseif btn == "Dommages UV" then
            OpenMenu('Dommages UV')
        elseif btn == "Opacité du teint" then
            OpenMenu('Opacité du teint')
        elseif btn == "Teint" then
            OpenMenu('Teint')
        elseif btn == "Couleur des poils du torse" then
            OpenMenu('Couleur des poils du torse')
        elseif btn == "Taille des poils du torse" then
            OpenMenu('Taille des poils du torse')
        elseif btn == "Poils du torse" then
            OpenMenu('Poils du torse')
        elseif btn == "Opacité des dommages UV" then
            OpenMenu('Opacité des dommages UV')
        elseif btn == "Couleur des rougeurs" then
            OpenMenu('Couleur des rougeurs')
        elseif btn == "Opacité des rougeurs" then
            OpenMenu('Opacité des rougeurs')
        elseif btn == "Rougeurs" then
            OpenMenu('Rougeurs')
        elseif btn == "Type des sourcils" then
            OpenMenu('Type des sourcils')
        elseif btn == "Couleur des cheveux" then
            OpenMenu('Couleur des cheveux') 
        elseif btn == "Taille des sourcils" then
            OpenMenu('Taille des sourcils') 
        elseif btn == "Type de cheveux" then
            OpenMenu('Type de cheveux') 
        elseif btn == "Taches de rousseur" then
            OpenMenu('Taches de rousseur') 
        elseif btn == "Opacité des rides" then
            OpenMenu('Opacité des rides') 
        elseif btn == "Rides" then
            OpenMenu('Rides')
        elseif btn == "Boutons" then
            OpenMenu('Boutons')
        elseif btn == "Opacité des boutons" then
            OpenMenu('Opacité des boutons')
		elseif btn == "Sexe" then
				local result = KeyboardInput("Sexe (M ou F)", "", 25)
                if result ~= nil then
                    ResultSexe = result
				end
			elseif btn == "Prénom" then
				local result = KeyboardInput("Prénom", "", 25)
                if result ~= nil then
                    ResultPrenom = result
				end
			elseif btn == "Nom" then	
				local result = KeyboardInput("Nom", "", 25)
                if result ~= nil then
                    ResultNom = result
				end
			elseif btn == "Date de naissance" then
				local result = KeyboardInput("Date de naissance (format JJ/MM/AAAA)", "", 25)
                if result ~= nil then
                    ResultDateDeNaissance = result
				end
			elseif btn == "Taille" then
				local result = KeyboardInput("Taille (cm)", "", 25)
                if result ~= nil then
                	ResultTaille = result
				end
            elseif btn == "~g~Commencer à créer votre carte d'identité" then
				--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 800.0, "drake-toosie-slide-lyrics-bass-boost", 0.6)
                LoadingPrompt("Sauvegarde de votre identité en cours", 3)
                if Character['sex'] == nil then
                    Character['sex'] = 0
                end
                TriggerEvent('skinchanger:change', 'sex', 0)
				DisplayRadar(false)
				SetEntityHeading(PlayerPedId(), 2.9283561706543)
				SetEntityCoords(PlayerPedId(), 409.4, -1001.64, -99.0-0.98, 0.0, 0.0, 0.0, 10)
                SetEntityHeading(PlayerPedId(), 268.72219848633)
                createcamnehco()
				RemoveLoadingPrompt()
				OpenMenu('Voulez-vous continuer ?')
				TriggerEvent('instance:create')
				--DrawSub("~g~Invincible", 12000)
                Wait(250)
            elseif btn == "~g~Oui" then
				--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 800.0, "drake-toosie-slide-lyrics-bass-boost", 0.6)
                LoadingPrompt("Sauvegarde de votre identité en cours", 3)
				DisplayRadar(false)
				SetEntityHeading(PlayerPedId(), 2.9283561706543)
				SetEntityCoords(PlayerPedId(), 409.4, -1001.64, -99.0-0.98, 0.0, 0.0, 0.0, 10)
                SetEntityHeading(PlayerPedId(), 268.72219848633)
                createcamnehco()
				RemoveLoadingPrompt()
				OpenMenu('Création de personnage')
				TriggerEvent('instance:create')
				--DrawSub("~g~Invincible", 12000)
                Wait(1500)
            elseif btn == "~g~Continuer" then
                if ResultSexe == ""  then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                elseif ResultPrenom == "" then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                elseif ResultNom == "" then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                elseif ResultDateDeNaissance == "" then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                elseif ResultTaille == "" then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                elseif ResultTaille == nil or ResultDateDeNaissance == nil or ResultNom == nil or ResultPrenom == nil or ResultSexe == nil then
                    OpenMenu('Votre carte d\'identité n\'a pas été faite correctement')
                else
                LoadingPrompt("Sauvegarde de votre identité en cours", 3)
				DisplayRadar(false)
				CreateCam()
				SetEntityHeading(PlayerPedId(), 2.9283561706543)
				SetEntityCoords(PlayerPedId(), 402.8, -996.64, -99.0-0.98, 0.0, 0.0, 0.0, 10)
				SetEntityHeading(PlayerPedId(), 183.72219848633)
				RemoveLoadingPrompt()
				OpenMenu('Choisissez le sexe de votre personnage (H ou F)')
				TriggerEvent('instance:create')
				--DrawSub("~g~Invincible", 12000)
                Wait(2500)
                end
			elseif btn == "~g~Choisissez le sexe de votre personnage (H ou F)" then
				OpenMenu('Sexe de votre personnage')
			elseif btn == "Votre sexe" and slide == 1 then
				TriggerEvent('skinchanger:change', 'sex', 0)
                Character['sex'] = 0
			elseif btn == "Votre sexe" and slide == 2 then
				TriggerEvent('skinchanger:change', 'sex', 1)
                Character['sex'] = 1
			elseif btn == "~g~Valider votre sexe." then
                OpenMenu('Apparence')
            elseif btn == "~g~Valider votre apparence." then
                OpenMenu('Maquillage')
            elseif btn == "~g~Valider votre maquillage." then
                OpenMenu('Traits du visage')
            elseif btn == "~g~Valider vos traits du visage." then
                OpenMenu('Pilosité')
            elseif btn == "~g~Valider votre pilosité." then
                TriggerEvent('skinchanger:change', 'torso_1', 0)
                TriggerEvent('skinchanger:change', 'arms', 0)
                if  Character['sex']== 0 then
                    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                else
                    TriggerEvent('skinchanger:change', 'tshirt_1', 2)
                end
                OpenMenu('Tenues')
            elseif btn == "Bras" then
                OpenMenu('Bras')
            elseif btn == "Couleur des bras" then
                OpenMenu('Couleur des bras')
            elseif btn == "Couleur des yeux" then
                OpenMenu('Couleur des yeux')
            elseif btn == "Imperfections du corps" then
                OpenMenu('Imperfections du corps') 
            elseif btn == "Opacité imperfections du corps" then
                OpenMenu('Opacité imperfections du corps')
            elseif btn == "Type de bras" then
                OpenMenu('Type de bras')
            elseif btn == "Nez" then
                OpenMenu('Nez')
            elseif btn == "Sourcils" then 
                OpenMenu("Sourcils")
            elseif btn == "Les yeux" then 
                OpenMenu("Les yeux")
            elseif btn == "Pommettes" then 
                OpenMenu("Pommettes")
            elseif btn == "Lèvres" then 
                OpenMenu("Lèvres")
            elseif btn == "Mâchoire" then 
                OpenMenu("Mâchoire")
            elseif btn == "Menton" then 
                OpenMenu("Menton")
            elseif btn == "Cou" then 
                OpenMenu("Cou")
            elseif btn == "Peau" then
                OpenMenu('Peau')
            elseif btn == "Largeur du nez" then
                OpenMenu('Largeur du nez')
            elseif btn == "Épaisseur du cou" then
                OpenMenu('Épaisseur du cou')
            elseif btn == "Taille du trou du menton" then
                OpenMenu('Taille du trou du menton')
            elseif btn == "Hauteur du menton" then
                OpenMenu('Hauteur du menton')
            elseif btn == "Longueur du menton" then
                OpenMenu('Longueur du menton')
            elseif btn == "Largeur du menton" then
                OpenMenu('Largeur du menton')
            elseif btn == "Longueur de l'os de la mâchoire" then
                OpenMenu("Longueur de l'os de la mâchoire")
            elseif btn == "Largeur de l'os de la mâchoire" then
                OpenMenu("Largeur de l'os de la mâchoire")
            elseif btn == "Largeur des joues" then
                OpenMenu('Largeur des joues')
            elseif btn == "Plissement des yeux" then
                OpenMenu('Plissement des yeux')
            elseif btn == "La plénitude des lèvres" then
                OpenMenu('La plénitude des lèvres')
            elseif btn == "Hauteur des pommettes" then
                OpenMenu('Hauteur des pommettes')
            elseif btn == "Largeur des pommettes" then
                OpenMenu('Largeur des pommettes')
            elseif btn == "Hauteur des sourcils" then
                OpenMenu('Hauteur des sourcils')
            elseif btn == "Profondeur des sourcils" then
                OpenMenu('Profondeur des sourcils')
            elseif btn == "Hauteur du pic du nez" then
                OpenMenu('Hauteur du pic du nez')
            elseif btn == "Longueur du pic du nez" then
                OpenMenu('Longueur du pic du nez')
            elseif btn == "Hauteur de l'os du nez" then
                OpenMenu("Hauteur de l'os du nez")
            elseif btn == "Abaissement de la pointe du nez" then
                OpenMenu('Abaissement de la pointe du nez')
            elseif btn == "Torsion de l'os du nez" then
                OpenMenu("Torsion de l'os du nez")
            elseif btn == "Chaussures" then
				OpenMenu('Chaussures')
            elseif btn == "Couleur des sourcils" then
				OpenMenu("Couleur des sourcils")
            elseif btn == "Type de maquillage" then
                OpenMenu('Type de maquillage')
            elseif btn == "Opacité du maquillage" then
                OpenMenu('Opacité du maquillage')
            elseif btn == "Couleur du maquillage" then
                OpenMenu('Couleur du maquillage')
            elseif btn == "Type de rouge à lèvres" then
                OpenMenu('Type de rouge à lèvres')
            elseif btn == "Opacité du rouge à lèvres" then
                OpenMenu('Opacité du rouge à lèvres')
            elseif btn == "Couleur du rouge à lèvres" then
                OpenMenu('Couleur du rouge à lèvres')
            elseif btn == "Acné" then
                OpenMenu('Acné')
            elseif btn == "Taille de la barbe" then
                OpenMenu('Taille de la barbe')
            elseif btn == "Type de la barbe" then
                OpenMenu('Type de la barbe')
            elseif btn == "Couleur de la barbe" then
                OpenMenu('Couleur de la barbe')
            elseif btn == "Dommages UV" then
                OpenMenu('Dommages UV')
            elseif btn == "Opacité du teint" then
                OpenMenu('Opacité du teint')
            elseif btn == "Teint" then
                OpenMenu('Teint')
            elseif btn == "Couleur des poils du torse" then
                OpenMenu('Couleur des poils du torse')
            elseif btn == "Taille des poils du torse" then
                OpenMenu('Taille des poils du torse')
            elseif btn == "Poils du torse" then
                OpenMenu('Poils du torse')
            elseif btn == "Couleur des rougeurs" then
                OpenMenu('Couleur des rougeurs')
            elseif btn == "Opacité des rougeurs" then
                OpenMenu('Opacité des rougeurs')
            elseif btn == "Rougeurs" then
                OpenMenu('Rougeurs')
            elseif btn == "Type des sourcils" then
                OpenMenu('Type des sourcils')
            elseif btn == "Couleur des cheveux" then
                OpenMenu('Couleur des cheveux') 
            elseif btn == "Taille des sourcils" then
                OpenMenu('Taille des sourcils') 
            elseif btn == "Type de cheveux" then
				OpenMenu('Type de cheveux') 
            elseif btn == "Taches de rousseur" then
                OpenMenu('Taches de rousseur') 
            elseif btn == "Opacité des rides" then
				OpenMenu('Opacité des rides') 
            elseif btn == "Rides" then
                OpenMenu('Rides')
            elseif btn == "Opacité des taches de rousseurs" then
                OpenMenu('Opacité des taches de rousseurs') 
            elseif btn == "Boutons" then
                OpenMenu('Boutons')
            elseif btn == "Opacité des boutons" then
                OpenMenu('Opacité des boutons')  
            elseif btn == "Opacité des dommages UV" then
				OpenMenu('Opacité des dommages UV') 
			elseif btn == "~g~Valider votre personnalisation." then
                OpenMenu('Valider votre personnage')
            elseif btn == "~g~Commencer à créer votre carte d'identité" then
                OpenMenu('Création de personnage')
            elseif btn == "~r~Non" then
                OpenMenu('Commencer à créer votre carte d\'identité') 
            elseif btn == "~g~Oui" then
				OpenMenu('Création de personnage') 
            elseif btn == "~g~Recommencer" then
                OpenMenu('Création de personnage')
			elseif btn == "~g~Valider votre personnage" then
				TriggerEvent('skinchanger:getSkin', function(skin)
                    LastSkin = skin
                end)
                if Character['sex'] == nil then
                    Character['sex'] = 0
                end
                --TriggerServerEvent('esx_skin:save', skin)
                TriggerServerEvent('InteractSound_CL:PlayOnOne',"INTRO",0.6)
                ajout()
                TriggerServerEvent('esx_skin:saveFirst',Character,ResultPrenom,ResultNom,ResultDateDeNaissance,ResultTaille,ResultSexe)
				TriggerEvent('Nehco:SpawnCharacter')
				RemoveLoadingPrompt()
		end
	end,
        onSlide = function(menuData, currentButton, currentSlt, PMenu)
            local currentMenu, ped = menuData.currentMenu, PlayerPedId()
            if currentMenu == "Nouveau personnage" then
                createcam(true)
                if currentSlt ~= 1 then return end
                currentButton = currentButton.slidenum - 1
                local sex = currentButton
                TriggerEvent('skinchanger:change', 'sex', sex)
                Character['sex']= sex
            end
            if currentMenu == "Apparence" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                currentButton = currentButton.slidenum - 1
                face = currentButton
                TriggerEvent('skinchanger:change', 'face_md_weight', face)
                Character['face_md_weight']= face
            end
            if currentMenu == "Peau" then
                createcam(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                skin = currentButton
                TriggerEvent('skinchanger:change', 'mom', skin)
                Character['mom']= skin
            end
            if currentMenu == "Largeur du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_1', nose1)
                Character['nose_1']= nose1
            end
            if currentMenu == "Épaisseur du cou" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local neckthickness = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'neck_thickness', neckthickness)
                Character['neck_thickness']= neckthickness
            end
            if currentMenu == "Hauteur du menton" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local chin1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chin_1', chin1)
                Character['chin_1']= chin1
            end
            if currentMenu == "Longueur du menton" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local chin2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chin_2', chin2)
                Character['chin_2']= chin2
            end
            if currentMenu == "Largeur du menton" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local chin3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chin_3', chin3)
                Character['chin_3']= chin3
            end
            if currentMenu == "Taille du trou du menton" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local chin4 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chin_4', chin4)
                Character['chin_4']= chin4
            end
            if currentMenu == "Longueur de l'os de la mâchoire" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local jaw2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'jaw_2', jaw2)
                Character['jaw_2']= jaw2
            end
            if currentMenu == "Largeur de l'os de la mâchoire" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local jaw1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'jaw_1', jaw1)
                Character['jaw_1']= jaw1
            end
            if currentMenu == "La plénitude des lèvres" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local lipthickness = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'lip_thickness', lipthickness)
                Character['lip_thickness']= lipthickness
            end
            if currentMenu == "Plissement des yeux" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local eyesquint = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'eye_squint', eyesquint)
                Character['eye_squint']= eyesquint
            end
            if currentMenu == "Largeur des joues" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local cheeks3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'cheeks_3', cheeks3)
                Character['cheeks_3']= cheeks3
            end
            if currentMenu == "Largeur des pommettes" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local cheeks2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'cheeks_2', cheeks2)
                Character['cheeks_2']= cheeks2
            end
            if currentMenu == "Hauteur des pommettes" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local cheeks1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'cheeks_1', cheeks1)
                Character['cheeks_1']= cheeks1
            end
            if currentMenu == "Hauteur des sourcils" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local eyebrown5 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'eyebrows_5', eyebrown5)
                Character['eyebrows_5']= eyebrown5
            end
            if currentMenu == "Profondeur des sourcils" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local eyebrown6 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'eyebrows_6', eyebrown6)
                Character['eyebrows_6']= eyebrown6
            end
            if currentMenu == "Hauteur du pic du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_2', nose2)
                Character['nose_2']= nose2
            end
            if currentMenu == "Longueur du pic du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_3', nose3)
                Character['nose_3']= nose3
            end
            if currentMenu == "Hauteur de l'os du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose4 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_4', nose4)
                Character['nose_4']= nose4
            end
            if currentMenu == "Abaissement de la pointe du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose5 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_5', nose5)
                Character['nose_5']= nose5
            end
            if currentMenu == "Torsion de l'os du nez" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local nose6 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'nose_6', nose6)
                Character['nose_6']= nose6
            end
            if currentMenu == "Type de la barbe" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                beard = currentButton
                TriggerEvent('skinchanger:change', 'beard_1', beard)
                Character['beard_1']= beard
            end
            if currentMenu == "Couleur de la barbe" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                local beard3 = currentButton
                TriggerEvent('skinchanger:change', 'beard_3', beard3)
                Character['beard_3']= beard3
            end
            if currentMenu == "Taille de la barbe" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                local beard2 = currentButton
                TriggerEvent('skinchanger:change', 'beard_2', beard2/ 10)
                Character['beard_2']= beard2/ 10
            end
            if currentMenu == "Couleur des yeux" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                eyecolor = currentButton
                TriggerEvent('skinchanger:change', 'eye_color', eyecolor)
                Character['eye_color']= eyecolor
            end
            if currentMenu == "Type de cheveux" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                hair = currentButton
                TriggerEvent('skinchanger:change', 'hair_1', hair)
                Character['hair_1']= hair
            end
            if currentMenu == "Couleur des cheveux" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
                local hair2 = currentButton
                TriggerEvent('skinchanger:change', 'hair_color_1', hair2)
                Character['hair_color_1']= hair2
            end
            if currentMenu == "Type des sourcils" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                eyebrow = currentButton
                TriggerEvent('skinchanger:change', 'eyebrows_1', eyebrow)
                Character['eyebrows_1']= eyebrow
            end
            if currentMenu == "Taille des sourcils" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                eyebrow = currentButton
                TriggerEvent('skinchanger:change', 'eyebrows_2', eyebrow/ 10)
                Character['eyebrows_2']= eyebrow/ 10
            end
            if currentMenu == "Vos imperfections" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local skinproblem = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'complexion_1', skinproblem)
                Character['complexion_1']= skinproblem
            end
            if currentMenu == "Opacité des imperfections" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local skinproblem2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'complexion_2', skinproblem2/ 10)
                Character['complexion_2']= skinproblem2/ 10
            end
            if currentMenu == "Taches de rousseur" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local freckle = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'moles_1', freckle)
                Character['moles_1']= freckle
            end
            if currentMenu == "Opacité des taches de rousseurs" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local freckle2 = currentButton.slidenum - 1
                local freckl2 =  freckle2 / 10
                TriggerEvent('skinchanger:change', 'moles_2', freckl2)
                Character['moles_2']= freckle2/ 10
            end
            if currentMenu == "Rides" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local wrinkle = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'age_1', wrinkle)
                Character['age_1']= wrinkle
            end
            if currentMenu == "Opacité des rides" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local wrinkle2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'age_2', wrinkle2/ 10)
                Character['age_2']= wrinkle2/ 10
            end
            if currentMenu == "Votre acné" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local acne = currentButton.slidenum - 1
                SetPedHeadOverlay(PlayerPedId(), 0, acne, 1.0)
            end
            if currentMenu == "Dommages UV" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local sun1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'sun_1', sun1)
                Character['sun_1']= sun1
            end
            if currentMenu == "Opacité des dommages UV" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local sun2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'sun_2', sun2/ 10)
                Character['sun_2']= sun2/ 10
            end
            if currentMenu == "Teint" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local complexion1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'complexion_1', complexion1)
                Character['complexion_1']= complexion1
            end
            if currentMenu == "Opacité du teint" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local complexion2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'complexion_2', complexion2/ 10)
                Character['complexion_2']= complexion2/ 10
            end
            if currentMenu == "Rougeurs" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local blush1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'blush_1', blush1)
                Character['blush_1']= blush1
            end
            if currentMenu == "Opacité des rougeurs" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local blush2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'blush_2', blush2/ 10)
                Character['blush_2']= blush2/ 10
            end
            if currentMenu == "Couleur des rougeurs" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local blush3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'blush_3', blush3)
                Character['blush_3']= blush3
            end
            if currentMenu == "Boutons" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local blemishes1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'blemishes_1', blemishes1)
                Character['blemishes_1']= blemishes1
            end
            if currentMenu == "Opacité des boutons" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local blemishes2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'blemishes_2', blemishes2/ 10)
                Character['blemishes_2']= blemishes2/ 10
            end
            if currentMenu == "Imperfections du corps" then
                createcamtorse(true)
                if currentSlt ~= 1 then return end
                local bodyb1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'bodyb_1', bodyb1)
                Character['bodyb_1']= bodyb1
            end
            if currentMenu == "Opacité imperfections du corps" then
                createcamtorse(true)
                if currentSlt ~= 1 then return end
                local bodyb2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'bodyb_2', bodyb2/ 10)
                Character['bodyb_2']= bodyb2/ 10
            end
            if currentMenu == "Poils du torse" then
                createcamtorse(true)
                TriggerEvent('skinchanger:change', 'torso_1', 15)
                TriggerEvent('skinchanger:change', 'arms', 15)
                if  Character['sex']== 0 then
                    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                else
                    TriggerEvent('skinchanger:change', 'tshirt_1', 2)
                end
                if currentSlt ~= 1 then return end
                local chest1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chest_1', chest1)
                Character['chest_1']= chest1
            end
            if currentMenu == "Taille des poils du torse" then
                createcamtorse(true)
                TriggerEvent('skinchanger:change', 'torso_1', 15)
                TriggerEvent('skinchanger:change', 'arms', 15)
                if  Character['sex']== 0 then
                    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                else
                    TriggerEvent('skinchanger:change', 'tshirt_1', 2)
                end
                if currentSlt ~= 1 then return end
                local chest2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chest_2', chest2/ 10)
                Character['chest_2']= chest2/ 10
            end
            if currentMenu == "Couleur des sourcils" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local eyebrows3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'eyebrows_3', eyebrows3)
                Character['eyebrows_3']= eyebrows3
            end
            if currentMenu == "Couleur des poils du torse" then
                createcamtorse(true)
                TriggerEvent('skinchanger:change', 'torso_1', 15)
                TriggerEvent('skinchanger:change', 'arms', 15)
                if  Character['sex']== 0 then
                    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                else
                    TriggerEvent('skinchanger:change', 'tshirt_1', 2)
                end
                if currentSlt ~= 1 then return end
                local chest3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'chest_3', chest3)
                Character['chest_3']= chest3
            end
            if currentMenu == "Type de maquillage" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local makeup1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'makeup_1', makeup1)
                Character['makeup_1']= makeup1
            end
            if currentMenu == "Opacité du maquillage" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local makeup2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'makeup_2', makeup2/ 10)
                Character['makeup_2']= makeup2/ 10
            end
            if currentMenu == "Couleur du maquillage" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local makeup3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'makeup_3', makeup3)
                Character['makeup_3']= makeup3
            end
            if currentMenu == "Type de rouge à lèvres" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local lipstick1 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'lipstick_1', lipstick1)
                Character['lipstick_1']= lipstick1
            end
            if currentMenu == "Opacité du rouge à lèvres" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local lipstick2 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'lipstick_2', lipstick2/ 10)
                Character['lipstick_2']= lipstick2/ 10
                
            end
            if currentMenu == "Couleur du rouge à lèvres" then
                createcamvisage(true)
                if currentSlt ~= 1 then return end
                local lipstick3 = currentButton.slidenum - 1
                TriggerEvent('skinchanger:change', 'lipstick_3', lipstick3)
                Character['lipstick_3']= lipstick3
            end
        end,
    },
	Menu = {
        ["Nouveau personnage"] = {
            useFilter = true,
			b = {
               -- {name = "Skin", slidemax = 1, Description = "~r~Attention ! ~s~Si vous avez un problème merci de faire un Ticket sur le Discord."},
                {name = "Apparence", ask = "→", askX = true, Description = "Choisissez votre apparence."},
                {name = "Maquillage", ask = "→", askX = true, Description = "Choisissez votre maquillage."},
                {name = "Traits du visage", ask = "→", askX = true, Description = "Choisissez vos traits du visage."},
                {name = "Tenues", ask = "→", askX = true, Description = "Choisissez votre tenue."},
               -- {name = "Identité", ask = "→", askX = true, Description = "Choisissez votre identité."},
			   {name = "~g~Valider votre personnalisation.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true}
			}
        },

		["Commencer à créer votre carte d'identité !"] = {
			b = {
                {name = "~g~Commencer à créer votre carte d'identité", Description = "Êtes-vous sûr de vos informations si-dessus ? Si oui, continuez la création de votre personnage", ask = ">", askX = true}
			}
        },
        
		["Voulez-vous continuer ?"] = {
			b = {
                {name = "~g~Oui", Description = "Êtes-vous sûr de vos informations si-dessus ? Si oui, continuez la création de votre personnage", ask = ">", askX = true},
                {name = "~r~Non", Description = "Êtes-vous sûr de vos informations si-dessus ? Si oui, continuez la création de votre personnage", ask = ">", askX = true}
			}
        },
           
        ["Votre carte d'identité n'a pas été faite correctement"] = {
			b = {
                {name = "~g~Recommencer", Description = "Modifier les informations", ask = ">", askX = true}
			}
        },
        
        
		["Création de personnage"] = {
			b = {
				{name = "Prénom"},
				{name = "Nom"},
				{name = "Date de naissance"},
				--{name = "Lieu de naissance"},
				{name = "Taille"},
				{name = "Sexe", Description = "Homme = M / Femme = F"},
                {name = "~g~Continuer", Description = "Êtes-vous sûr de vos informations si-dessus ? Si oui, continuez la création de votre personnage", ask = ">", askX = true}
			}
		},
		
		["Choisissez le sexe de votre personnage (H ou F)"] = {
			b = {
				--{name = "~g~Choisir un ped", Description = "Personnage PNJ, customisation restreinte (Only)"}, -- En Dev
				{name = "~g~Choisissez le sexe de votre personnage (H ou F)", Description = "Customisation complète de A à Z (Tête, bouche, héritage...)"}
			}
		},

		["Choisi ton ped:"] = {
			b = {
				{name = "~g~Ped:", Description = "Listes des peds disponibles sur FiveM/GTA V", slidemax = pedlist},
				{name = "~g~Valider votre ped:", Description = "~r~Attention.~w~Action irréversible. Choissiez bien votre personnage"}
			}
		},
		
		["Sexe de votre personnage"] = {
			b = {
				{name = "Votre sexe", Description = "Sexe du personnage.", slidemax = sexe},
				{name = "~g~Valider votre sexe.", Description = "~r~Attention.~w~Êtes-vous sûr de valider votre sexe, si oui appuyez sur ENTRER", ask = ">", askX = true}

			}
		},
        ["Tenues"] = {   
            useFilter = true,        
			b = {
                {name = "~g~Valider votre personnalisation.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true},
            }
        },
        ["Identité"] = { 
			b = {
                {name = "Prénom", ask = "Prénom" },    
                {name = "Nom", ask = "Nom" },
                {name = "Date de naissance", ask = "Jour/Mois/Année" }, 
                {name = "Lieu de naissance", ask = "Lieu de naissance" },
                {name = "Taille", ask = "Taille" },
                {name = "Sexe", ask = "m/f" }, 
                {name = "~g~Continuer & Sauvegarder"}, 
			}
        },
        ["Apparence"] = {   
            useFilter = true,        
			b = {
                {name = "Visage", slidemax = 45, Description = "Choisissez votre visage."},
                {name = "Peau", ask = "→", askX = true, Description = "Choisissez votre couleur de peau."},
                {name = "Sourcils", ask = "→", askX = true, Description = "Choisissez vos sourcils."},
                {name = "Les yeux", ask = "→", askX = true, Description = "Choisissez vos les yeux."},
                {name = "Couleur des yeux", ask = "→", askX = true, Description = "Choisissez votre couleur des yeux."},
                {name = "Nez", ask = "→", askX = true, Description = "Choisissez votre nez."},
                {name = "Pommettes", ask = "→", askX = true, Description = "Choisissez vos pommettes."},
                {name = "Lèvres", ask = "→", askX = true, Description = "Choisissez vos lèvres."},
                {name = "Mâchoire", ask = "→", askX = true, Description = "Choisissez votre mâchoire."},
                {name = "Menton", ask = "→", askX = true, Description = "Choisissez votre menton."},
                {name = "Cou", ask = "→", askX = true, Description = "Choisissez votre cou."},
                {name = "Imperfections du corps", ask = "→", askX = true, Description = "Choisissez vos imperfections du corps."},
                {name = "Opacité imperfections du corps", ask = "→", askX = true, Description = "Choisissez l'opacité de vos imperfections."},
                {name = "~g~Valider votre apparence.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true},
            }
        },
        ["Maquillage"] = { 
            useFilter = true,          
			b = {
                {name = "Type de maquillage", ask = "→", askX = true, Description = "Choisissez votre type de maquillage."},
                {name = "Opacité du maquillage", ask = "→", askX = true, Description = "Choisissez la taille de votre maquillage."},
                {name = "Couleur du maquillage", ask = "→", askX = true, Description = "Choisissez la couleur de votre maquillage."},
                {name = "Type de rouge à lèvres", ask = "→", askX = true, Description = "Choisissez votre type de rouge à lèvres."},
                {name = "Opacité du rouge à lèvres", ask = "→", askX = true, Description = "Choisissez la taille de votre rouge à lèvres."},
                {name = "Couleur du rouge à lèvres", ask = "→", askX = true, Description = "Choisissez la couleur de votre rouge à lèvres."},
                {name = "~g~Valider votre maquillage.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true},
            }
        },
        ["Traits du visage"] = {     
            useFilter = true,      
			b = {
                {name = "Rides", ask = "→", askX = true, Description = "Choisissez vos rides."},
                {name = "Opacité des rides", ask = "→", askX = true, Description = "Choisissez la taille de vos rides."},
                {name = "Dommages UV", ask = "→", askX = true, Description = "Choisissez vos dommages UV."},
                {name = "Opacité des dommages UV", ask = "→", askX = true, Description = "Choisissez l'opacité de vos dommages UV."},
                {name = "Boutons", ask = "→", askX = true, Description = "Choisissez vos boutons."},
                {name = "Opacité des boutons", ask = "→", askX = true, Description = "Choisissez l'opacité de vos boutons."},
                {name = "Teint", ask = "→", askX = true, Description = "Choisissez votre teint."},
                {name = "Opacité du teint", ask = "→", askX = true, Description = "Choisissez l'opacité de votre teint."},
                {name = "Taches de rousseur", ask = "→", askX = true, Description = "Choisissez vos taches de rousseur."},
                {name = "Opacité des taches de rousseurs", ask = "→", askX = true, Description = "Choisissez l'opacité de vos tahes de rousseur."},
                {name = "Rougeurs", ask = "→", askX = true, Description = "Choisissez vos rougeurs."},
                {name = "Opacité des rougeurs", ask = "→", askX = true, Description = "Choisissez l'opacité des rougeurs."},
                {name = "Couleur des rougeurs", ask = "→", askX = true, Description = "Choisissez la couleur de vos rougeurs."},
                {name = "~g~Valider vos traits du visage.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true},
            }
        },
        ["Pilosité"] = {     
            useFilter = true,      
			b = {
                {name = "Type de cheveux", ask = "→", askX = true, Description = "Choisissez votre type de coiffure."},
                {name = "Couleur des cheveux", ask = "→", askX = true, Description = "Choisissez la couleur de votre coiffure."},
                {name = "Taille de la barbe", ask = "→", askX = true, Description = "Choisissez la taille de votre barbe."},
                {name = "Type de la barbe", ask = "→", askX = true, Description = "Choisissez votre type de barbe."},
                {name = "Couleur de la barbe", ask = "→", askX = true, Description = "Choisissez la couleur de votre barbe."},
                {name = "Type des sourcils", ask = "→", askX = true, Description = "Choisissez le type de sourcils."},
                {name = "Taille des sourcils", ask = "→", askX = true, Description = "Choisissez la taille de vos sourcils."},
                {name = "Couleur des sourcils", ask = "→", askX = true, Description = "Choisissez la couleur des sourcils."},
                {name = "Poils du torse", ask = "→", askX = true, Description = "Choisissez le type de poils de torse."},
                {name = "Taille des poils du torse", ask = "→", askX = true, Description = "Choisissez la taille de vos poils de torse."},
                {name = "Couleur des poils du torse", ask = "→", askX = true, Description = "Choisissez la couleur de vos poils de torse."},
                {name = "~g~Valider votre pilosité.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true},
			}
		},	
        ["Couleur des sourcils"] = {            
            b = {
                { name = "Couleur des sourcils", slidemax = 20, Description = "Choisissez la couleur des sourcils."},
            }
        },
        ["Chaussures"] = {            
            b = {
                { name = "Chaussures", slidemax = 114, Description = "Choisissez vos chaussures."},
            }
        },
        ["Couleur des chaussures"] = {            
            b = {
                { name = "Couleur des chaussures", slidemax = 20, Description = "Choisissez votre couleur de chaussure."},
            }
        },
        ["Bas"] = {            
            b = {
                { name = "Bas", slidemax = 114, Description = "Choisissez votre bas."},
            }
        },
        ["Couleur du bas"] = {            
            b = {
                { name = "Couleur du bas", slidemax = 20, Description = "Choisissez votre couleur de bas."},
            }
        },
        ["Veste"] = {            
            b = {
                { name = "Veste", slidemax = 289, Description = "Choisissez votre veste."},
            }
        },
        ["Couleur veste"] = {            
            b = {
                { name = "Couleur Veste", slidemax = 20, Description = "Choisissez votre couleur de veste."},
            }
        },
        ["Couleur t-shirt"] = {            
            b = {
                { name = "Couleur t-shirt", slidemax = 20, Description = "Choisissez votre couleur de t-shirt."},
            }
        },
        ["T-shirt"] = {            
            b = {
                { name = "T-Shirt", slidemax = 143, Description = "Choisissez votre t-shirt."},
            }
        },
        ["Bras"] = {            
            b = {
                { name = "Type de bras", ask = "→", askX = true, Description = "Choisissez votre type de bras."},
                { name = "Couleur des bras", ask = "→", askX = true, Description = "Choisissez votre couleur de bras."},
            }
        },
        ["Nez"] = {            
            b = {
                { name = "Largeur du nez", ask = "→", askX = true, Description = "Choisissez la largeur du nez."},
                { name = "Hauteur du pic du nez", ask = "→", askX = true, Description = "Choisissez la hauteur du pic du nez."},
                { name = "Longueur du pic du nez", ask = "→", askX = true, Description = "Choisissez la longueur du pic du nez."},
                { name = "Hauteur de l'os du nez", ask = "→", askX = true, Description = "Choisissez hauteur de l'os du nez."},
                { name = "Abaissement de la pointe du nez", ask = "→", askX = true, Description = "Choisissez l'abaissement de la pointe du nez."},
                { name = "Torsion de l'os du nez", ask = "→", askX = true, Description = "Choisissez la torsion de l'os du nez."},
            }
        },
        ["Sourcils"] = {            
            b = {
                { name = "Hauteur des sourcils", ask = "→", askX = true, Description = "Choisissez la hauteur des sourcils."},
                { name = "Profondeur des sourcils", ask = "→", askX = true, Description = "Choisissez la profondeur des sourcils."},
            }
        },
        ["Pommettes"] = {            
            b = {
                { name = "Largeur des pommettes", ask = "→", askX = true, Description = "Choisissez la largeur des pommettes."},
                { name = "Hauteur des pommettes", ask = "→", askX = true, Description = "Choisissez la hauteur des pommettes."},
                { name = "Largeur des joues", ask = "→", askX = true, Description = "Choisissez la largeur des joues."},
            }
        },
        ["Mâchoire"] = {            
            b = {
                { name = "Largeur de l'os de la mâchoire", ask = "→", askX = true, Description = "Choisissez la largeur de l'os de la mâchoire."},
                { name = "Longueur de l'os de la mâchoire", ask = "→", askX = true, Description = "Choisissez la longueur de l'os de la mâchoire."},
            }
        },
        ["Menton"] = {            
            b = {
                { name = "Hauteur du menton", ask = "→", askX = true, Description = "Choisissez la hauteur du menton."},
                { name = "Longueur du menton", ask = "→", askX = true, Description = "Choisissez la longueur du menton."},
                { name = "Largeur du menton", ask = "→", askX = true, Description = "Choisissez la largeur du menton."},
                { name = "Taille du trou du menton", ask = "→", askX = true, Description = "Choisissez la taille du trou du menton."},
            }
        },
        ["Cou"] = {            
            b = {
                { name = "Épaisseur du cou", ask = "→", askX = true, Description = "Choisissez l'épaisseur du cou."},
            }
        },
        ["Épaisseur du cou"] = {            
            b = {
                { name = "Épaisseur du cou", slidemax = 16, Description = "Choisissez l'épaisseur du cou."},
            }
        },
        ["Taille du trou du menton"] = {            
            b = {
                { name = "Taille du trou du menton", slidemax = 16, Description = "Choisissez la taille du trou du menton."},
            }
        },
        ["Hauteur du menton"] = {            
            b = {
                { name = "Hauteur du menton", slidemax = 16, Description = "Choisissez la hauteur du menton."},
            }
        },
        ["Longueur du menton"] = {            
            b = {
                { name = "Longueur du menton", slidemax = 16, Description = "Choisissez la longueur du menton."},
            }
        },
        ["Largeur du menton"] = {            
            b = {
                { name = "Largeur du menton", slidemax = 16, Description = "Choisissez la largeur du menton."},
            }
        },
        ["Largeur de l'os de la mâchoire"] = {            
            b = {
                { name = "Largeur de l'os de la mâchoire", slidemax = 16, Description = "Choisissez la largeur de l'os de la mâchoire."},
            }
        },
        ["Longueur de l'os de la mâchoire"] = {            
            b = {
                { name = "Longueur de l'os de la mâchoire", slidemax = 16, Description = "Choisissez la longueur de l'os de la mâchoire."},
            }
        },
        ["Les yeux"] = {            
            b = {
                { name = "Plissement des yeux", ask = "→", askX = true, Description = "Choisissez le plissement des yeux."},
            }
        },
        ["Lèvres"] = {            
            b = {
                { name = "La plénitude des lèvres", ask = "→", askX = true, Description = "Choisissez la plénitude des lèvres."},
            }
        },
        ["Plissement des yeux"] = {            
            b = {
                { name = "Plissement des yeux", slidemax = 16, Description = "Choisissez le plissement des yeux."},
            }
        },
        ["La plénitude des lèvres"] = {            
            b = {
                { name = "La plénitude des lèvres", slidemax = 16, Description = "Choisissez la plénitude des lèvres."},
            }
        },
        ["Largeur des joues"] = {            
            b = {
                { name = "Largeur des joues", slidemax = 16, Description = "Choisissez la largeur des joues."},
            }
        },
        ["Largeur des pommettes"] = {            
            b = {
                { name = "Largeur des pommettes", slidemax = 16, Description = "Choisissez la largeur des pommettes."},
            }
        },
        ["Hauteur des pommettes"] = {            
            b = {
                { name = "Hauteur des pommettes", slidemax = 16, Description = "Choisissez la hauteur des pommettes."},
            }
        },
        ["Hauteur des sourcils"] = {            
            b = {
                { name = "Hauteur des sourcils", slidemax = 16, Description = "Choisissez la hauteur des sourcils."},
            }
        },
        ["Profondeur des sourcils"] = {            
            b = {
                { name = "Profondeur des sourcils", slidemax = 16, Description = "Choisissez la profondeur des sourcils."},
            }
        },
        ["Largeur du nez"] = {            
            b = {
                { name = "Largeur du nez", slidemax = 16, Description = "Choisissez la largeur du nez."},
            }
        },
        ["Hauteur du pic du nez"] = {            
            b = {
                { name = "Hauteur du pic du nez", slidemax = 16, Description = "Choisissez la hauteur du pic du nez."},
            }
        },
        ["Longueur du pic du nez"] = {            
            b = {
                { name = "Longueur du pic du nez", slidemax = 16, Description = "Choisissez la longueur du pic du nez."},
            }
        },
        ["Hauteur de l'os du nez"] = {            
            b = {
                { name = "Hauteur de l'os du nez", slidemax = 16, Description = "Choisissez hauteur de l'os du nez."},
            }
        },
        ["Abaissement de la pointe du nez"] = {            
            b = {
                { name = "Abaissement de la pointe du nez", slidemax = 16, Description = "Choisissez l'abaissement de la pointe du nez."},
            }
        },
        ["Torsion de l'os du nez"] = {            
            b = {
                { name = "Torsion de l'os du nez", slidemax = 16, Description = "Choisissez la torsion de l'os du nez."},
            }
        },
        ["Type de bras"] = {            
            b = {
                { name = "Type de bras", slidemax = 163, Description = "Choisissez votre type de bras."},
            }
        },
        ["Couleur des bras"] = {            
            b = {
                { name = "Couleur des bras", slidemax = 10, Description = "Choisissez votre couleur de bras."},
            }
        },
        ["Type de maquillage"] = {            
            b = {
                { name = "Type de maquillage", slidemax = 71, Description = "Choisissez votre type de maquillage."},
            }
        },
        ["Opacité du maquillage"] = {
            b = {
                { name = "Opacité du maquillage", slidemax = 10, Description = "Choisissez la taille de votre maquillage."},
            }
        },
        ["Couleur du maquillage"] = {            
            b = {
                { name = "Couleur du maquillage", slidemax = 63, Description = "Choisissez la couleur de votre maquillage."},
            }
        },
        ["Type de rouge à lèvres"] = {
            b = {
                { name = "Type de rouge à lèvres", slidemax = 9, Description = "Choisissez votre type de rouge à lèvres."},
            }
        },
        ["Opacité du rouge à lèvres"] = {            
            b = {
                { name = "Opacité du rouge à lèvres", slidemax = 10, Description = "Choisissez la taille de votre rouge à lèvres."},
            }
        },
        ["Couleur du rouge à lèvres"] = {            
            b = {
                { name = "Couleur du rouge à lèvres", slidemax = 63, Description = "Choisissez la couleur de votre rouge à lèvres."},
            }
        },
        ["Imperfections du corps"] = {            
			b = {
                { name = "Imperfections du corps", slidemax = 11, Description = "Choisissez vos imperfections du corps."},
            }
        },
        ["Opacité imperfections du corps"] = {
            b = {
                { name = "Opacité imperfections du corps", slidemax = 10, Description = "Choisissez l'opacité de vos imperfections."},
            }
        },
        ["Boutons"] = {            
			b = {
                { name = "Boutons", slidemax = 23, Description = "Choisissez vos boutons."},
            }
        },
        ["Opacité des boutons"] = {
            b = {
                { name = "Opacité des boutons", slidemax = 10, Description = "Choisissez l'opacité de vos boutons."},
            }
        },
        ["Rougeurs"] = {            
			b = {
                { name = "Rougeurs", slidemax = 32, Description = "Choisissez vos rougeurs."},
            }
        },
        ["Opacité des rougeurs"] = {
            b = {
                { name = "Opacité des rougeurs", slidemax = 10, Description = "Choisissez l'opacité des rougeurs."},
            }
        },
        ["Couleur des rougeurs"] = {            
			b = {
                { name = "Couleur des rougeurs", slidemax = 63, Description = "Choisissez la couleur de vos rougeurs."},
            }
        },
        ["Poils du torse"] = {            
			b = {
                { name = "Poils du torse", slidemax = 16, Description = "Choisissez le type de poils de torse."},
            }
        },
        ["Taille des poils du torse"] = {
            b = {
                { name = "Taille des poils du torse", slidemax = 10, Description = "Choisissez la taille de vos poils de torse."},
            }
        },
        ["Couleur des poils du torse"] = {            
			b = {
                { name = "Couleur des poils du torse", slidemax = 63, Description = "Choisissez la couleur de vos poils de torse."},
            }
        },
        ["Teint"] = {            
			b = {
                { name = "Teint", slidemax = 11, Description = "Choisissez votre teint."},
            }
        },
        ["Opacité du teint"] = {
            b = {
                { name = "Opacité du teint", slidemax = 10, Description = "Choisissez l'opacité de votre teint."},
            }
        },
        ["Dommages UV"] = {            
			b = {
                { name = "Dommages UV", slidemax = 10, Description = "Choisissez vos dommages UV."},
            }
        },
        ["Opacité des dommages UV"] = {
            b = {
                { name = "Opacité des dommages UV", slidemax = 10, Description = "Choisissez l'opacité de vos dommages UV."},
            }
        },
        ["Couleur de la barbe"] = {            
			b = {
                { name = "Couleur de la barbe", slidemax = 63, Description = "Choisissez la couleur de votre barbe."},
            }
        },
        ["Type de la barbe"] = {            
			b = {
                { name = "Type de la barbe", slidemax = 28, Description = "Choisissez votre type de barbe."},
            }
        },
        ["Taille de la barbe"] = {            
			b = {
                { name = "Taille de la barbe", slidemax = 10, Description = "Choisissez la taille de votre barbe."},
            }
        },
        ["Votre acné"] = {            
			b = {
                { name = "Acné", slidemax = 15},
            }
        },
        ["Rides"] = {            
			b = {
                { name = "Rides", slidemax = 15, Description = "Choisissez vos rides."},
            }
        },
        ["Opacité des rides"] = {            
			b = {
                { name = "Opacité des rides", slidemax = 10, Description = "Choisissez la taille de vos rides."},
            }
        },
        ["Taches de rousseur"] = {            
			b = {
                { name = "Taches de rousseurs", slidemax = 17, Description = "Choisissez vos taches de rousseur."},
            }
        },
        ["Opacité des taches de rousseurs"] = {
            b = {
                { name = "Opacité des taches de rousseurs", slidemax = 10, Description = "Choisissez l'opacité de vos tahes de rousseur."},
            }
        },
        ["Votre tête"] = {
			b = {
                { name = "Visage", slidemax = 45 },
			}
        },
        ["Peau"] = {
			b = {
				{ name = "Peau", slidemax = 45, Description = "Choisissez votre couleur de peau."},
			}
        },
        ["Couleur des yeux"] = {
			b = {
				{ name = "Couleur des yeux", slidemax = 31, Description = "Choisissez votre couleur des yeux."},
			}
        },
        ["Type de cheveux"] = {
			b = {
				{ name = "Type de cheveux", slidemax = 73, Description = "Choisissez votre type de coiffure."}
			}
        },
        ["Couleur des cheveux"] = {
			b = {
				{ name = "Couleur des cheveux", slidemax = 63, Description = "Choisissez la couleur de votre coiffure."}
			}
		},
		["Valider votre personnage"] = {
			b = {
				{name = "~g~Valider votre personnage", Description = "~r~Attention.~w~Cette action est irréversible."}

			}
        },
        ["Commencer à créer votre carte d'identité !"] = {
			b = {
				{name = "~g~Commencer à créer votre carte d'identité", Description = "~r~Attention.~w~Cette action est irréversible."}

			}
        },
        ["Voulez-vous continuer ?"] = {
			b = {
                {name = "~g~Oui", Description = "~r~Attention.~w~Cette action est irréversible."},
                {name = "~r~Non", Description = "~r~Attention.~w~Cette action est irréversible."}

			}
		},
        ["Type des sourcils"] = {
			b = {
				{ name = "Type des sourcils", slidemax = 33, Description = "Choisissez le type de sourcils."},
			}
        },
        ["Taille des sourcils"] = {
			b = {
				{ name = "Taille des sourcils", slidemax = 10, Description = "Choisissez la taille de vos sourcils."},
			}
        },
	}
}

function ajoutvet()
    if table.findKey('decals_1', Vetement) == false then
        Vetement['decals_1'] = -1
    end
    if table.findKey('decals_2', Vetement) == false then
        Vetement['decals_2'] = -1
    end
end

local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false


TriggerEvent('instance:registerType', 'skin')
TriggerEvent('instance:registerType', 'property')

RegisterNetEvent('Nehco:create')
AddEventHandler('Nehco:create', function()
    TriggerEvent('invisibilite',spawnfirst)
    DisplayRadar(false)
    TriggerEvent('esx:setDisplay', 0.0)
    TriggerEvent('instance:create', 'skin')
    TriggerEvent('skinchanger:change', 'tshirt_1', 0)
    Vetement['tshirt_1']=0
    TriggerEvent('skinchanger:change', 'torso_1', 0)
    Vetement['torso_1']=0
    TriggerEvent('skinchanger:change', 'arms', 0)
    Vetement['arms']=0
    TriggerEvent('skinchanger:change', 'pants_1', 0)
    Vetement['pants_1']=0
    TriggerEvent('skinchanger:change', 'shoes_1', 1)
    Vetement['shoes_1']=1
    isCameraActive = true
    ajoutvet()
    TriggerServerEvent('esx_skin:saveClothe',Vetement,"Tenue de base")
     
    CreateCamEnter()
    SpawnCharacter()
    SetEntityHeading(PlayerPedId(), 2.9283561706543)
    SetEntityCoords(PlayerPedId(), 408.8, -998.64, -99.0-0.98, 0.0, 0.0, 0.0, 10)
    SetEntityHeading(PlayerPedId(), 268.72219848633)
    --PrepareMusicEvent("FM_INTRO_DRIVE_START")
    --TriggerMusicEvent("FM_INTRO_DRIVE_START")
    CreateMenu(creationPerso)
    FreezeEntityPosition(PlayerPedId(), true)
    incamera = true
    ClearPedTasks(PlayerPedId())
    DeleteObject(board)
    DeleteObject(overlay)

end)


RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'skin' then
		TriggerEvent('instance:enter', instance)
	end
end)

--Citizen.CreateThread(function()
   -- while true do
     --   Citizen.Wait(0)
     --   if isCameraActive then
     --       if IsControlJustPressed(1, 107) then 
     --           SetEntityHeading(PlayerPedId(), 0.50)
     --       elseif IsControlJustPressed(1, 108) then 
      --          SetEntityHeading(PlayerPedId(), 193.26)
     --       elseif IsControlJustPressed(1, 112) then 
     --          SetEntityHeading(PlayerPedId(), 268.72219848633)
      --      elseif IsControlJustPressed(1, 111) then 
      --          SetEntityHeading(PlayerPedId(), 91.04)
      --      end
     --   end
  --  end
--end)
function colli ()
Citizen.CreateThread(function()
    while spawnfirst do
        Citizen.Wait(0)
        if spawnfirst then
            DisableControlAction(0,30)
            DisableControlAction(0,31)
            DisableControlAction(0,32)
            DisableControlAction(0,33)
            DisableControlAction(0,34)
            DisableControlAction(0,35)
            DisableControlAction(0,24)
            DisableControlAction(0,22)
            for i=1,256 do
                if NetworkIsPlayerActive(i) then
                    SetEntityNoCollisionEntity(GetPlayerPed(i), PlayerPedId(), false)
                end
            end
        else
            for i=1,256 do
                if NetworkIsPlayerActive(i) then
                    SetEntityNoCollisionEntity(GetPlayerPed(i), PlayerPedId(), true)
                end
            end
        end
    end
end)
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())

			generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))

		ESX.TriggerServerCallback('h4ci_concess:verifierplaquedispo', function (isPlateTaken)
			if not isPlateTaken then
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