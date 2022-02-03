------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
local isSkinCreatorOpened = false -- Change this value to show/hide UI
local cam = -1 -- Camera control
local heading = 332.219879 -- Heading coord
local zoom = "visage" -- Define which tab is shown first (Default: Head)
local spawnfirst = false
local Character = {}
ESX = nil

------------------------------------------------------------------
--                          NUI
------------------------------------------------------------------
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

RegisterNUICallback('updateSkin', function(data)
    v = data.value
    -- Face
    Character['sex'] = tonumber(data.sex)
    Character['dad'] = tonumber(data.dad)
    Character['mom'] = tonumber(data.mum)
    Character['face_md_weight'] = tonumber(data.dadmumpercent)
    Character['skin'] = tonumber(data.skin)
    Character['eye_color'] = tonumber(data.eyecolor)
    Character['blemishes_1'] = tonumber(data.acne)
    Character['complexion_1'] = tonumber(data.skinproblem)
    Character['moles_1'] = tonumber(data.freckle)
    Character['age_1'] = tonumber(data.wrinkle)
    Character['age_2'] = tonumber(data.wrinkleopacity/10)
    Character['hair_1'] = tonumber(data.hair)
    Character['hair_color_1'] = tonumber(data.haircolor)
    Character['eyebrows_1'] = tonumber(data.eyebrow)
    Character['eyebrows_2'] = tonumber(data.eyebrowopacity/10)
    Character['beard_1'] = tonumber(data.beard)
    Character['beard_2'] = tonumber(data.beardopacity/10)
    Character['beard_3'] = tonumber(data.beardcolor)
    Character['nose_1'] = tonumber(data.nose1)
	Character['nose_2'] = tonumber(data.nose2)
	Character['nose_3'] = tonumber(data.nose3)
	Character['nose_4'] = tonumber(data.nose4)
	Character['nose_5'] = tonumber(data.nose5)
	Character['nose_6'] = tonumber(data.nose6)
	Character['eyebrows_5'] = tonumber(data.eyebrows_5)
	Character['eyebrows_6'] = tonumber(data.eyebrows_6)
	Character['cheeks_1'] = tonumber(data.cheeks_1)
	Character['cheeks_2'] = tonumber(data.cheeks_2)
	Character['cheeks_3'] = tonumber(data.cheeks_3)
	Character['eye_squint'] = tonumber(data.eye_squint)
	Character['lip_thickness'] = tonumber(data.lip_thickness)
	Character['jaw_1'] = tonumber(data.jaw_1)
	Character['jaw_2'] = tonumber(data.jaw_2)
	Character['chin_1'] = tonumber(data.chin_1)
	Character['chin_2'] = tonumber(data.chin_2)
	Character['chin_3'] = tonumber(data.chin_3)
	Character['chin_4'] = tonumber(data.chin_4)
	Character['neck_thickness'] = tonumber(data.neck_thickness)
	Character['bodyb_1'] = tonumber(data.bodyb_1)
	Character['bodyb_3']= tonumber(data.bodyb_3)
	Character['makeup_1']= tonumber(data.makeup_1)
	Character['lipstick_1']= tonumber(data.lipstick_1)
	Character['chest_1']= tonumber(data.chest_1)
	Character['makeup_3']= tonumber(data.makeup_3)
	Character['lipstick_3']= tonumber(data.lipstick_3)

    if (v == true) then
        local ped = PlayerPedId()
        isSkinCreatorOpened = false
        spawnfirst = false
        if Character['sex'] == 0 then
            sex = "M"
            TriggerServerEvent("skincreator:updatesex", sex)
        else
            sex="F"
            TriggerServerEvent("skincreator:updatesex", sex)
        end

        if Character['blemishes_1'] == 0 or Character['blemishes_1'] == -1 then
            Character['blemishes_2']= 0.0
        else
            Character['blemishes_2']= 1.0
        end
		
        if Character['moles_1'] == 0 or Character['moles_1'] == -1 then
             Character['moles_2']=0.0
        else
            Character['moles_2']= 1.0
        end

		if Character['bodyb_1'] == -1 or Character['bodyb_1'] == 0 then
			Character['bodyb_2']=0.0
		else
			Character['bodyb_2']=1.0
		end

		if Character['bodyb_3'] == -1 or Character['bodyb_3'] == 0 then
			Character['bodyb_4']=0.0
		else
			Character['bodyb_4']=1.0
		end

		if Character['makeup_1'] == -1 or Character['makeup_1'] == 0 then
			Character['makeup_2']=0.0
		else
			Character['makeup_2']=1.0
		end

		if Character['lipstick_1'] == -1 or Character['lipstick_1'] == 0 then
			Character['lipstick_2']=0.0
		else
			Character['lipstick_2']=1.0
		end

		if Character['chest_1'] == -1 or Character['chest_1'] == 0 then
			Character['chest_2']=0.0
		else
			Character['chest_2']=1.0
		end


		TriggerServerEvent('esx_skin:saveFirst', Character)
        TriggerEvent('invisibilite', spawnfirst)
        RenderScriptCams(0, 0, 1, 1, 1)
        SetFocusEntity(PlayerPedId())
        FreezeEntityPosition(ped, false)
		SetEntityCoords(PlayerPedId(), -1178.58, -2909.53, 13.95+1)
    	SetEntityHeading(PlayerPedId(), 262.41)
		Citizen.Wait(200)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
			TriggerEvent('skinchanger:loadClothes', skin, clothe)
		end)
    	TriggerServerEvent("InteractSound_SV:PlayOnSource", "INTRO",1)
    	TaskPedSlideToCoord(PlayerPedId(),-1125.0, -2908.86, 12.95, 272.41, 1.0)
		Citizen.Wait(33000)
		SetPlayerInvincible(ped, false)
        TriggerEvent("creatorPersonnage", false)

    else

        SetPedDefaultComponentVariation(PlayerPedId())
        -- sex
        TriggerEvent('skinchanger:change', 'sex', Character['sex'])
        -- Face
        if Character['sex'] == 0 then
        SetPedHeadBlendData(PlayerPedId(), Character['dad'], Character['mom'], Character['dad'], Character['skin'],
            Character['skin'], Character['skin'], Character['face_md_weight'] * 0.1, Character['face_md_weight'] * 0.1,
            1.0, true)
        else
            SetPedHeadBlendData(PlayerPedId(), Character['mom'], Character['dad'], Character['mom'], Character['skin'],
            Character['skin'], Character['skin'], Character['face_md_weight'] * 0.1, Character['face_md_weight'] * 0.1,
            1.0, true)
        end
        
        SetPedEyeColor(PlayerPedId(), Character['eye_color'])
        SetPedFaceFeature(PlayerPedId(), 0, (Character['nose_1'] / 10) + 0.0) -- Nose Width
        SetPedFaceFeature(PlayerPedId(), 1, (Character['nose_2'] / 10) + 0.0) -- Nose Peak Height
        SetPedFaceFeature(PlayerPedId(), 2, (Character['nose_3'] / 10) + 0.0) -- Nose Peak Length
        SetPedFaceFeature(PlayerPedId(), 3, (Character['nose_4'] / 10) + 0.0) -- Nose Bone Height
        SetPedFaceFeature(PlayerPedId(), 4, (Character['nose_5'] / 10) + 0.0) -- Nose Peak Lowering
        SetPedFaceFeature(PlayerPedId(), 5, (Character['nose_6'] / 10) + 0.0) -- Nose Bone Twist
        SetPedFaceFeature(PlayerPedId(), 6, (Character['eyebrows_5'] / 10) + 0.0) -- Eyebrow height
        SetPedFaceFeature(PlayerPedId(), 7, (Character['eyebrows_6'] / 10) + 0.0) -- Eyebrow depth
        SetPedFaceFeature(PlayerPedId(), 8, (Character['cheeks_1'] / 10) + 0.0) -- Cheekbones Height
        SetPedFaceFeature(PlayerPedId(), 9, (Character['cheeks_2'] / 10) + 0.0) -- Cheekbones Width
        SetPedFaceFeature(PlayerPedId(), 10, (Character['cheeks_3'] / 10) + 0.0) -- Cheeks Width
        SetPedFaceFeature(PlayerPedId(), 11, (Character['eye_squint'] / 10) + 0.0) -- Eyes squint
        SetPedFaceFeature(PlayerPedId(), 12, (Character['lip_thickness'] / 10) + 0.0) -- Lip Fullness
        SetPedFaceFeature(PlayerPedId(), 13, (Character['jaw_1'] / 10) + 0.0) -- Jaw Bone Width
        SetPedFaceFeature(PlayerPedId(), 14, (Character['jaw_2'] / 10) + 0.0) -- Jaw Bone Length
        SetPedFaceFeature(PlayerPedId(), 15, (Character['chin_1'] / 10) + 0.0) -- Chin Height
        SetPedFaceFeature(PlayerPedId(), 16, (Character['chin_2'] / 10) + 0.0) -- Chin Length
        SetPedFaceFeature(PlayerPedId(), 17, (Character['chin_3'] / 10) + 0.0) -- Chin Width
        SetPedFaceFeature(PlayerPedId(), 18, (Character['chin_4'] / 10) + 0.0) -- Chin Hole Size
        SetPedFaceFeature(PlayerPedId(), 19, (Character['neck_thickness'] / 10) + 0.0)

        if Character['blemishes_1'] == 0 or Character['blemishes_1'] == -1 then
            SetPedHeadOverlay(PlayerPedId(), 0, Character['blemishes_1'], 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 0, Character['blemishes_1'], 1.0)
        end
        SetPedHeadOverlay(PlayerPedId(), 6, Character['complexion_1'], 1.0)
		
        if Character['moles_1'] == 0 or Character['moles_1'] == -1 then
            SetPedHeadOverlay(PlayerPedId(), 9, Character['moles_1'], 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 9, Character['moles_1'], 1.0)
        end

		if Character['bodyb_1'] == -1 or Character['bodyb_1'] == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 11,		Character['bodyb_1'],		0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 11,		Character['bodyb_1'],		1.0)
		end

		if Character['bodyb_3'] == -1 or Character['bodyb_3'] == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 12,		Character['bodyb_3'],			0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 12,		Character['bodyb_3'],			1.0)
		end

		if Character['makeup_1'] == -1 or Character['makeup_1'] == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 4,		Character['makeup_1'],			0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 4,		Character['makeup_1'],			1.0)
		end

		if Character['lipstick_1'] == -1 or Character['lipstick_1'] == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 8,		Character['lipstick_1'],			0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 8,		Character['lipstick_1'],			1.0)
		end

		if Character['chest_1'] == -1 or Character['chest_1'] == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 10,		Character['chest_1'],			0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 10,		Character['chest_1'],			1.0)
		end

        SetPedHeadOverlay(PlayerPedId(), 3, Character['age_1'], Character['age_2'])
        SetPedComponentVariation(PlayerPedId(), 2, Character['hair_1'], 0, 2)
        SetPedHairColor(PlayerPedId(), Character['hair_color_1'], Character['hair_color_1'])
        SetPedHeadOverlay(PlayerPedId(), 2, Character['eyebrows_1'], Character['eyebrows_2'] )
        SetPedHeadOverlay(PlayerPedId(), 1, Character['beard_1'], Character['beard_2'] )
        SetPedHeadOverlayColor(PlayerPedId(), 1, 1, Character['beard_3'], Character['beard_3'])
        SetPedHeadOverlayColor(PlayerPedId(), 2, 1, Character['beard_3'], Character['beard_3'])
		SetPedHeadOverlayColor(PlayerPedId(), 4, 1,	Character['makeup_3'],Character['makeup_3'])
		SetPedHeadOverlayColor(PlayerPedId(), 8, 1,	Character['lipstick_3'],Character['lipstick_3'])
        -- Unused yet
        -- These presets will be editable in V2 release
        --SetPedHeadOverlay(PlayerPedId(), 4, 0, 0.0) -- Lipstick
        --SetPedHeadOverlay(PlayerPedId(), 8, 0, 0.0) -- Makeup
        --SetPedHeadOverlayColor(PlayerPedId(), 4, 1, 0, 0) -- Makeup Color
        --SetPedHeadOverlayColor(PlayerPedId(), 8, 1, 0, 0) -- Lipstick Color
    end

end)

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading + tonumber(data.value)
end)

RegisterNUICallback('rotaterightheading', function(data)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading - tonumber(data.value)
end)

-- Define which part of the body must be zoomed
RegisterNUICallback('zoom', function(data)
    zoom = data.zoom
end)

RegisterNUICallback('print', function()
    print("la")
end)

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

function SkinCreator(enable)
    local ped = PlayerPedId()
    ShowSkinCreator(enable)

    -- Disable Controls
    -- TODO: Reset controls when player confirm his character creation
    if enable == true then
        DisableControlAction(2, 14, true)
        DisableControlAction(2, 15, true)
        DisableControlAction(2, 16, true)
        DisableControlAction(2, 17, true)
        DisableControlAction(2, 30, true)
        DisableControlAction(2, 31, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(2, 33, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 24, true)

        if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
            SendNUIMessage({
                type = "click"
            })
        end

        -- Player
        -- SetPlayerInvincible(ped, true)
        -- FreezeEntityPosition(ped, true)

        -- Camera
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if (not DoesCamExist(cam)) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
            SetCamRot(cam, 0.0, 0.0, 0.0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
        end
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        if zoom == "visage" or zoom == "pilosite" then
            SetCamCoord(cam, x + 0.2, y + 0.5, z + 0.7)
            SetCamRot(cam, 0.0, 0.0, 150.0)
        elseif zoom == "vetements" then
            SetCamCoord(cam, x + 0.3, y + 2.0, z + 0.0)
            SetCamRot(cam, 0.0, 0.0, 170.0)
        end
    else
        -- FreezeEntityPosition(ped, false)
        -- SetPlayerInvincible(ped, false)
    end
end

function ShowSkinCreator(enable)
    SetNuiFocus(enable,enable)
    SendNUIMessage({
        openSkinCreator = enable
    })
end

RegisterNetEvent('skincreator:skincreator')
AddEventHandler('skincreator:skincreator', function()
    isSkinCreatorOpened = true
    local plate = GeneratePlate()
    local vehicle = {
        ["modArmor"] = -1,
        ["modTrunk"] = -1,
        ["modFrame"] = -1,
        ["modLivery"] = -1,
        ["modFrontBumper"] = -1,
        ["pearlescentColor"] = 54,
        ["modHorns"] = -1,
        ["xenonColor"] = 255,
        ["modTrimB"] = -1,
        ["modAerials"] = -1,
        ["modBrakes"] = -1,
        ["modAPlate"] = -1,
        ["modSuspension"] = -1,
        ["modXenon"] = false,
        ["plate"] = plate,
        ["tankHealth"] = 1000.0,
        ["modHood"] = -1,
        ["modFrontWheels"] = -1,
        ["modFender"] = -1,
        ["wheels"] = 4,
        ["modVanityPlate"] = -1,
        ["modShifterLeavers"] = -1,
        ["dirtLevel"] = 10.0,
        ["wheelColor"] = 156,
        ["modEngine"] = -1,
        ["color2"] = 0,
        ["modStruts"] = -1,
        ["modSpeakers"] = -1,
        ["modTransmission"] = -1,
        ["fuelLevel"] = 100.0,
        ["modSeats"] = -1,
        ["modTank"] = -1,
        ["modRightFender"] = -1,
        ["extras"] = {
            ["2"] = false,
            ["1"] = false,
            ["3"] = false
        },
        ["modDial"] = -1,
        ["modRearBumper"] = -1,
        ["modBackWheels"] = -1,
        ["neonColor"] = {255, 0, 255},
        ["bodyHealth"] = 1000.0,
        ["modExhaust"] = -1,
        ["modSteeringWheel"] = -1,
        ["modPlateHolder"] = -1,
        ["modSideSkirt"] = -1,
        ["modRoof"] = -1,
        ["color1"] = 54,
        ["modSmokeEnabled"] = false,
        ["modGrille"] = -1,
        ["engineHealth"] = 1000.0,
        ["neonEnabled"] = {false, false, false, false},
        ["modTrimA"] = -1,
        ["windowTint"] = -1,
        ["model"] = 92612664,
        ["modEngineBlock"] = -1,
        ["modDashboard"] = -1,
        ["modTurbo"] = false,
        ["tyreSmokeColor"] = {255, 255, 255},
        ["modAirFilter"] = -1,
        ["modWindows"] = -1,
        ["modDoorSpeaker"] = -1,
        ["modOrnaments"] = -1,
        ["modArchCover"] = -1,
        ["plateIndex"] = 3,
        ["modSpoilers"] = -1,
        ["modHydrolic"] = -1
    }
    TriggerServerEvent('CreatVehicle', plate, vehicle)
	SetEntityHeading(PlayerPedId(),heading )
end)

------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        if isSkinCreatorOpened == true then
            SkinCreator(true)
        else
            SkinCreator(false)
        end
        Citizen.Wait(0)
    end
end)

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

function GeneratePlate()
    local generatedPlate
    local doBreak = false
    local plateUnauthorized = false
    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        local plate = GetRandomLetter(4) .. GetRandomNumber(4)

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
