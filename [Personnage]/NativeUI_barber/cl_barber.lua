local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ConfigBarber = {}

ConfigBarber.Price = 100

ConfigBarber.DrawDistance = 10.0
ConfigBarber.MarkerSize   = {x = 2.0, y = 2.0, z = 0.0}
ConfigBarber.MarkerColor  = {r = 0, g = 0, b = 0}
ConfigBarber.MarkerType   = 1
ConfigBarber.Locale = 'fr'

ConfigBarber.Zones = {}



ConfigBarber.Shops = {
  {x = -814.308,  y = -183.823,  z = 37.568, taskx= -808.74 ,tasky= -180.84,taskz= 37.57,taskh= 117.6753},
  {x = 136.826,   y = -1708.373, z = 29.291, taskx= 139.38 ,tasky= -1705.13,taskz= 29.29,taskh= 140.3470},
  {x = -1282.604, y = -1116.757, z = 6.990 , taskx= -1279.3505 ,tasky= -1117.0710,taskz= 6.9901,taskh= 89.8794},--fait
  {x = 1931.513,  y = 3729.671,  z = 32.844, taskx= 1929.87 ,tasky= 3733.63,taskz= 32.84,taskh= 206.4148},
  {x = 1213.0,  y = -472.51,  z = 66.21, taskx= 1216.06 ,tasky= -473.87,taskz= 66.21,taskh= 71.3301},
  {x = -32.885,   y = -152.319,  z = 57.076 , taskx= -34.05 ,tasky= -156.23,taskz= 57.08,taskh= 339.5416},
  {x = -278.077,  y = 6228.463,  z = 31.695, taskx= -275.56 ,tasky= 6225.44,taskz= 31.7,taskh= 44.4298},
}


local sex

for i=1, #ConfigBarber.Shops, 1 do

	ConfigBarber.Zones['Shop_' .. i] = {
	 	Pos   = ConfigBarber.Shops[i],
	 	Size  = ConfigBarber.MarkerSize,
	 	Color = ConfigBarber.MarkerColor,
	 	Type  = ConfigBarber.MarkerType
  }
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
  DrawMarker(1, ConfigBarber.Shops[i].x, ConfigBarber.Shops[i].y, ConfigBarber.Shops[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
		end
	end)

end

function recxup()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin,clothe)
		TriggerEvent('skinchanger:loadClothes', skin,clothe)
		if skin['sex'] == 1 then
			TriggerEvent('skinchanger:change', 'glasses_1', 5)
		end
	end)
end

_menuPool = NativeUI.CreatePool()
_menuPool:RefreshIndex()
ESX                           = nil
local GUI                     = {}
GUI.Time                      = 0
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPayed                = false
local menuLoaded = false
local HairLoaded = false

local Colors = {
    {22, 19, 19}, -- 0
    {30, 28, 25}, -- 1
    {76, 56, 45}, -- 2
    {69, 34, 24}, -- 3
    {123, 59, 31}, -- 4
    {149, 68, 35}, -- 5
    {165, 87, 50}, -- 6
    {175, 111, 72}, -- 7
    {159, 105, 68}, -- 8
    {198, 152, 108}, -- 9
    {213, 170, 115}, -- 10
    {223, 187, 132}, -- 11
    {202, 164, 110}, -- 12
    {238, 204, 130}, -- 13
    {229, 190, 126}, -- 14
    {250, 225, 167}, -- 15
    {187, 140, 96}, -- 16
    {163, 92, 60}, -- 17
    {144, 52, 37}, -- 18
    {134, 21, 17}, -- 19
    {164, 24, 18}, -- 20
    {195, 33, 24}, -- 21
    {221, 69, 34}, -- 22
    {229, 71, 30}, -- 23
    {208, 97, 56}, -- 24
    {113, 79, 38}, -- 25
    {132, 107, 95}, -- 26
    {185, 164, 150}, -- 27
    {218, 196, 180}, -- 28
    {247, 230, 217}, -- 29
    {102, 72, 93}, -- 30
    {162, 105, 138}, -- 31
    {171, 174, 11}, -- 32
    {239, 61, 200}, -- 33
    {255, 69, 152}, -- 34
    {255, 178, 191}, -- 35
    {12, 168, 146}, -- 36
    {8, 146, 165}, -- 37
    {11, 82, 134}, -- 38
    {118, 190, 117}, -- 39
    {52, 156, 104}, -- 40
    {22, 86, 85}, -- 41
    {152, 177, 40}, -- 42
    {127, 162, 23}, -- 43
    {241, 200, 98}, -- 44
    {238, 178, 16}, -- 45
    {224, 134, 14}, -- 46
    {247, 157, 15}, -- 47
    {243, 143, 16}, -- 48
    {231, 70, 15}, -- 49
    {255, 101, 21}, -- 50
    {254, 91, 34}, -- 51
    {252, 67, 21}, -- 52
    {196, 12, 15}, -- 53
    {143, 10, 14}, -- 54
    {44, 27, 22}, -- 55
    {80, 51, 37}, -- 56
    {98, 54, 37}, -- 57
    {60, 31, 24}, -- 58
    {69, 43, 32}, -- 59
    {8, 10, 14}, -- 60
    {212, 185, 158}, -- 61
    {212, 185, 158}, -- 62
    {213, 170, 115}, -- 63
}

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


local barberShops = nil
function OpenBarber()
	local ped = GetPlayerPed(PlayerId())
	local coords = GetEntityCoords(ped, false)
	if coords.x < -1200 then
		local key = 3
	TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < -800 and coords.x > -840 then
		local key = 1
	TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < -25 and coords.x > -40 then
		local key = 6
		TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < 150 and coords.x > 120 then
		local key = 2
		TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < 1300 and coords.x > 1100 then
		local key = 5
		TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < 2100 and coords.x > 1800 then
		local key = 4
		TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	elseif coords.x < -200 and coords.x > -300 then
		local key = 7
		TaskPedSlideToCoord(PlayerPedId(), ConfigBarber.Shops[key].taskx, ConfigBarber.Shops[key].tasky, ConfigBarber.Shops[key].taskz, ConfigBarber.Shops[key].taskh, 1.0)
	end
	TriggerEvent("Parow:exit")
	if menuLoaded == false then
		barberShops = NativeUI.CreateMenu("", "Coiffeur", 5, 100,"shopui_title_barber3","shopui_title_barber3",true)
		_menuPool:Add(barberShops)
		OpenShopMenuS(barberShops)
		menuLoaded = true
		barberShops:Visible(not barberShops:Visible())
		_menuPool:RefreshIndex()
	else
		barberShops:Visible(not barberShops:Visible())
	end


end
	
function OpenShopMenuS(menu)
	local chev = _menuPool:AddSubMenu(menu, "Coiffure","",true,true,true)
	print(sex)
	if sex == 0 then
	local barb = _menuPool:AddSubMenu(menu, "Barbes","",true,true,true)
	BarbeMenuFct(barb)
	end
	local maq = _menuPool:AddSubMenu(menu, "Maquillage","",true,true,true)

	MakeupMenuFct(maq)
	HairCutMenuFct(chev)
end
function MakeupMenuFct(menu)
	ppp = {
		GetLabelText("CC_MKUP_0"),
		GetLabelText("CC_MKUP_1"),
		GetLabelText("CC_MKUP_2"),
		GetLabelText("CC_MKUP_3"),
		GetLabelText("CC_MKUP_4"),
		GetLabelText("CC_MKUP_5"),
		GetLabelText("CC_MKUP_6"),
		GetLabelText("CC_MKUP_7"),
		GetLabelText("CC_MKUP_8"),
		GetLabelText("CC_MKUP_9"),
		GetLabelText("CC_MKUP_10"),
		GetLabelText("CC_MKUP_11"),
		GetLabelText("CC_MKUP_12"),
		GetLabelText("CC_MKUP_13"),
		GetLabelText("CC_MKUP_14"),
		GetLabelText("CC_MKUP_15"),
		GetLabelText("CC_MKUP_16"),
		GetLabelText("CC_MKUP_17"),
		GetLabelText("CC_MKUP_18"),
		GetLabelText("CC_MKUP_19"),
		GetLabelText("CC_MKUP_20"),
		GetLabelText("CC_MKUP_21"),
		GetLabelText("CC_MKUP_26"),
		GetLabelText("CC_MKUP_27"),
		GetLabelText("CC_MKUP_28"),
		GetLabelText("CC_MKUP_29"),
		GetLabelText("CC_MKUP_30"),
		GetLabelText("CC_MKUP_31"),
		GetLabelText("CC_MKUP_32"),
		GetLabelText("CC_MKUP_33"),
		GetLabelText("CC_MKUP_34"),
		GetLabelText("CC_MKUP_35"),
		GetLabelText("CC_MKUP_36"),
		GetLabelText("CC_MKUP_37"),
		GetLabelText("CC_MKUP_38"),
		GetLabelText("CC_MKUP_39"),
		GetLabelText("CC_MKUP_40"),
		GetLabelText("CC_MKUP_41"),
		GetLabelText("CC_MKUP_42"),
		GetLabelText("CC_MKUP_43"),
		GetLabelText("CC_MKUP_44"),
		GetLabelText("CC_MKUP_45"),
		GetLabelText("CC_MKUP_46"),
		GetLabelText("CC_MKUP_47"),
		GetLabelText("CC_MKUP_48"),
		GetLabelText("CC_MKUP_49"),
		GetLabelText("CC_MKUP_50"),
		GetLabelText("CC_MKUP_51"),
		GetLabelText("CC_MKUP_52"),
		GetLabelText("CC_MKUP_53"),
		GetLabelText("CC_MKUP_54"),
		GetLabelText("CC_MKUP_55"),
		GetLabelText("CC_MKUP_56"),
		GetLabelText("CC_MKUP_57"),
		GetLabelText("CC_MKUP_58"),
		GetLabelText("CC_MKUP_59"),
		GetLabelText("CC_MKUP_60"),
		GetLabelText("CC_MKUP_61"),
		GetLabelText("CC_MKUP_62"),
		GetLabelText("CC_MKUP_63"),
		GetLabelText("CC_MKUP_64"),
		GetLabelText("CC_MKUP_65"),
		GetLabelText("CC_MKUP_66"),
		GetLabelText("CC_MKUP_67"),
		GetLabelText("CC_MKUP_68"),
		GetLabelText("CC_MKUP_69"),
		GetLabelText("CC_MKUP_70"),
		GetLabelText("CC_MKUP_71")
	
	
	}
	local makeupSelect = NativeUI.CreateListItem("Maquillage", ppp, 0)
	local makeupBaseColor = NativeUI.CreateColourPanel("Couleur du maquillage", Colors)
	local makeupHighColor = NativeUI.CreateColourPanel("Seconde couleur du maquillage", Colors)
		local makeupOpacity = NativeUI.CreatePercentagePanel("0%", "Opacité du maquillage", "100%")

		makeupSelect:AddPanel(makeupOpacity)
        makeupSelect:AddPanel(makeupBaseColor)
        makeupSelect:AddPanel(makeupHighColor)
        makeupOpacity:Percentage(0.0)
		menu:AddItem(makeupSelect)
		pp = {}
		djkq = NativeUI.CreateItem("~g~Valider","")
		djkq:RightLabel("50$")
		menu:AddItem(djkq)
        makeupSelect.OnListChanged = function(_, SelectedItem, Index)
            local ActiveItem = SelectedItem:IndexToItem(Index)
			skin32 = Index
			playerPed = PlayerPedId()
            skin33 = (ActiveItem.Panels and ActiveItem.Panels[1] or 0.0)
            skin34 = (ActiveItem.Panels and ActiveItem.Panels[2] or 1) 
			skin35 = (ActiveItem.Panels and ActiveItem.Panels[3] or 1) 
			SetPedHeadOverlay(playerPed, 4, skin32, skin33)
			SetPedHeadOverlayColor  (playerPed, 4, 1, skin34,      skin35)

			pp = {skin32,skin33,skin34,skin35}
        end
		menu.OnItemSelect = function(_, _, _)
            
			ESX.TriggerServerCallback("Parow:GetCoiffeurMontant", function(result)
				if result then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
						skin.makeup_1 = pp[1]
						skin.makeup_2 = pp[2]
						skin.makeup_3 = pp[3]
						skin.makeup_4 = pp[4]
						TriggerServerEvent('esx_skin:save', skin)
						ESX.ShowNotification("~g~Nouveau maquillage acheté 50$")
						HasPayed = true
					end)
	   
				else
					ESX.ShowNotification("~r~Pas assez d'argent")
				end
			end)
		end
end


function BarbeMenuFct(menu)
	p = {"Barbe de 3 jours","Bouc","Mamène","Bouc Style","Menton","Petite Barbe","Collier","Mal Rasé","D'Artagnan","Moustache","Garnis","Mal Rasée 2","Bouc 2","Collier 2","Collier Prononcé","Collier Tracé","Innovant","Rouflak","Prisonnier","Mexicano","Mexicano  Fournis","Mexicano Imposant","Mexicano Tombant","Mexicano Classe","Mexicano Garnis","Biker","Rouflak Chargée","Biker Chargée","Barbu"}
	local beardSelect = NativeUI.CreateListItem("Beard", p, 0)
	local beardOpacity = NativeUI.CreatePercentagePanel("0%", "Longueur", "100%")
	local beardBaseColor = NativeUI.CreateColourPanel("Couleur de la barbe", Colors)
	local beardHighColor = NativeUI.CreateColourPanel("Deuxième couleur de la barbe", Colors)
	beardSelect:AddPanel(beardOpacity)
	beardOpacity:Percentage(0.0)
	beardSelect:AddPanel(beardBaseColor)
	beardSelect:AddPanel(beardHighColor)
	menu:AddItem(beardSelect)
	djkq = NativeUI.CreateItem("~g~Valider","")
	djkq:RightLabel("50$")
	menu:AddItem(djkq)
	pp = {}
	beardSelect.OnListChanged = function(_, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
		playerPed = PlayerPedId()
		skin33 = (ActiveItem.Panels and ActiveItem.Panels[1] or 0.0)
		skin34 = (ActiveItem.Panels and ActiveItem.Panels[2] or 1) - 1
		skin35 = (ActiveItem.Panels and ActiveItem.Panels[3] or 1) - 1

		SetPedHeadOverlay(playerPed, 1, Index - 1, skin33)
		SetPedHeadOverlayColor(playerPed, 1, 1, skin34,skin35)

		pp = {Index - 1, skin33,skin34,skin35}
	end
	menu.OnItemSelect = function(_, _, _)
            
		ESX.TriggerServerCallback("Parow:GetCoiffeurMontant", function(result)
			if result then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
					skin.beard_1 = pp[1]
					skin.beard_2 = pp[2]
					skin.beard_3 = pp[3]
					skin.beard_4 = pp[4]
					TriggerServerEvent('esx_skin:save', skin)
					ESX.ShowNotification("~g~Nouvelle barbe achetée 50$")
					HasPayed = true
				end)
   
			else
				ESX.ShowNotification("~r~Pas assez d'argent")
			end
		end)
	end
end

function HairCutMenuFct(menu)
	local index = nil
    if sex == 0 then
        hairstyles = { GetLabelText("CC_M_HS_0"),GetLabelText("CC_M_HS_1"), GetLabelText("CC_M_HS_2"), GetLabelText("CC_M_HS_3"), GetLabelText("CC_M_HS_4"),
                       "Calvicie", GetLabelText("CC_M_HS_6"), GetLabelText("CC_M_HS_7"),
                        GetLabelText("CC_M_HS_9"), GetLabelText("CC_M_HS_10"),
                       GetLabelText("CC_M_HS_11"), GetLabelText("CC_M_HS_12"), GetLabelText("CC_M_HS_13"),
                       GetLabelText("CC_M_HS_14"), GetLabelText("CC_M_HS_15"), GetLabelText("CC_M_HS_16"),
                       GetLabelText("CC_M_HS_17"), GetLabelText("CC_M_HS_18"), GetLabelText("CC_M_HS_19"),
                       GetLabelText("CC_M_HS_20"), GetLabelText("CC_M_HS_21"), GetLabelText("CC_M_HS_22"), "Natte Tressées 1", "Natte Tressées 2", "Natte Tressées 3", "Natte Tressées 4", "Plaqué"
					   , "Dégradé côté", "Iroquoise", "Ebouriffés", "Long raie millieu", "Coupe courte"
                    }
					index = {0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,25,26,27,28,31,33,34,35,36,37}
    else
        hairstyles = { "Coupe courte", "Coupe dégradé", "Natte",
                       "Queue de cheval", "Crête trésser", "Tresse",
                       "Coupe au carré", "Chignon banane",
                      "Mi-long", "Chignon négligé", "Coupe garçonne",
                       "Côté rasé", "Chignon", "Mi-long ondulé",
                       "Chignon avec bandeau", "Chignon décoiffé", "Pin-up",
                       "Chignon sérré", "Coupe afro", "Carré ondulé",
                      "Chignon tressé", "Tresses Plaquées 1","Tresses Plaquées 2","Tresses Plaquées 3","Natte et frange"
					  ,"Queue de cheval 2","Carré avec frange","Cheveux long lisse","Crête","Asiatique","Queue de cheval long","Cheveux long tressés"
                   }
		 index = {1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,25,26,27,28,31,33,34,35,36,37,38}
	end
	
	local hairSelect = NativeUI.CreateListItem("Coiffure", hairstyles, 0)
	local hairBaseColor = NativeUI.CreateColourPanel("Couleur", Colors)
	local hairHighColor = NativeUI.CreateColourPanel("Deuxième couleur", Colors)
	hairSelect:AddPanel(hairBaseColor)
	hairSelect:AddPanel(hairHighColor)
	menu:AddItem(hairSelect)

	djkq = NativeUI.CreateItem("~g~Valider","")
	djkq:RightLabel("50$")
	menu:AddItem(djkq)
	pp = {}
	hairSelect.OnListChanged = function(_, SelectedItem, Index)
            
		local ActiveItem = SelectedItem:IndexToItem(Index)
		skin33 = (ActiveItem.Panels and ActiveItem.Panels[1] or 1) - 1
		skin44 = (ActiveItem.Panels and ActiveItem.Panels[2] or 1) - 1
		SetPedComponentVariation(PlayerPedId(), 2, index[Index])
		SetPedHairColor(PlayerPedId(),skin33,skin44)
		pp = {index[Index],skin33,skin44}
	end
	menu.OnItemSelect = function(_, SelectedItem, Index)
            
		ESX.TriggerServerCallback("Parow:GetCoiffeurMontant", function(result)
			if result then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
					skin.hair_1 = pp[1]
					skin.hair_color_1 = pp[2]
					skin.hair_color_2 = pp[3]
					TriggerServerEvent('esx_skin:save', skin)
					ESX.ShowNotification("~g~Nouvelle coupe de cheveux achetée 50$")
					HasPayed = true
				end)
			else
				ESX.ShowNotification("~r~Pas assez d'argent")
			end
		end)
	end
	
	menu.OnMenuClosed = function()
		recxup()
	end
end

AddEventHandler('esx_barbershop:hasEnteredMarker', function(_)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = '~INPUT_CONTEXT~ Coiffeur'
	CurrentActionData = {}
end)

AddEventHandler('esx_barbershop:hasExitedMarker', function(_)
	
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

end)

-- Create Blips
Citizen.CreateThread(function()
	
	for i=1, #ConfigBarber.Shops, 1 do
		
		local blip = AddBlipForCoord(ConfigBarber.Shops[i].x, ConfigBarber.Shops[i].y, ConfigBarber.Shops[i].z)

		SetBlipSprite (blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.80)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Barbier, Salon de Coiffure")
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		_menuPool:ProcessMenus()
		Wait(0)
		
		local coords = GetEntityCoords(PlayerPedId())
		
		for _,v in pairs(ConfigBarber.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < ConfigBarber.DrawDistance) then
				--Drawing.draw3DText(v.Pos.x, v.Pos.y, v.Pos.z, "Appuyez sur [~r~E~w~] pour changer votre coiffure", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		
		Wait(1000)
		
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(ConfigBarber.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k		
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_barbershop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_barbershop:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 0, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
				
				if CurrentAction == 'shop_menu' then
					OpenBarber()
					
				end

				--CurrentAction = nil
				GUI.Time      = GetGameTimer()
				
			end

		end

	end
end)
