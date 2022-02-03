Config = {}
Translation = {}

Config.Locale = 'custom' -- 'en', 'sv' or 'custom'
Config.cops = 3   --3
Config.hour = 0
Config.minute = 4
Config.second = 0

Config.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, blip = true: add blip on map false: don't add blip, name = name of the store (when cops get alarm, blip name etc)}
    --superette
    {coords = vector3(372.98,328.18,102.57),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 252.8312, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(2555.27, 380.84, 107.62),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 349.1913, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3040.69, 584.02, 6.91),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 15.5802, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3243.97, 1000.14, 11.83),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 347.5801, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(549.3, 2669.57, 41.16),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 93.3226, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(1959.22, 3741.4, 31.34),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 299.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(2676.5, 3280.2, 54.24),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 331.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1728.73, 6416.92, 34.04),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 241.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1134.23, -983.05, 45.42),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 274.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1221.51, -908.05, 11.33),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 30.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1486.53, -377.7, 39.16),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 128.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-2966.32, 391.4, 14.04),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 79.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(1165.57, 2710.87, 37.16),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 176.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(1392.24, 3606.25, 33.98),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 201.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-47.61, -1759.05, 28.42),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 49.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1164.9, -323.99, 68.21),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 97.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-706.16, -914.92, 18.22),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 84.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1819.26, 793.21, 137.08),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 128.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1697.06, 4923.65, 41.06),type="PED_TYPE_CIVMALE",haskKey="s_m_m_ammucountry", heading = 327.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(24.47, -1345.56, 28.5),type="PED_TYPE_CIVMALE",haskKey="mp_m_shopkeep_01", heading = 264.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --tatoo
    {coords = vector3(1324.43, -1650.02, 51.28),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 133.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1152.42, -1423.57, 3.95),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 130.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(319.71, 180.75, 102.59),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 251.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3170.26, 1072.88, 19.83),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 329.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1862.45, 3748.35, 32.03),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 32.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(-292.02,6199.79,30.49),type="PED_TYPE_CIVMALE",haskKey="u_m_y_tattoo_01", heading = 224.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Tatoo', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
   --coiffeur
    {coords = vector3(-822.03,-183.4,36.57),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 203.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(134.62,-1707.93,28.29),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 138.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1284.24,-1115.29,5.99),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 91.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(1930.89,3728.2,31.84),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 204.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1211.49,-470.76,65.21),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 67.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-30.92,-151.66,56.08),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 333.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-277.96,6230.39,30.7),type="PED_TYPE_CIVFEMALE",haskKey="cs_jewelass", heading = 36.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Coiffeur', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --vetement
    {coords = vector3(73.98,-1393.02,28.39),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 267.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-709.04,-151.68,36.42),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 123.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-164.99,-303.02,38.73),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 251.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(427.07,-806.3,28.49),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 87.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1448.87,-238.1,48.81),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 44.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(5.72,6511.22,30.88),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 38.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(126.82,-224.7,53.56),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 68.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(1695.35,4823.06,41.06),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 98.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(612.96,2763.32,41.09),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 271.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --{coords = vector3(1196.49,2711.67,37.22),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 181.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-1193.39,-766.61,16.40),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 216.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-3169.6,1042.75,19.86),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 70.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
   -- {coords = vector3(-1102.35,2711.64,18.11),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 222.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-805.4,-594.82,29.28),type="PED_TYPE_CIVFEMALE",haskKey="a_f_y_genhot_01", heading = 241.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    --bijouterie
    {coords = vector3(-622.55,-229.55,37.06),type="PED_TYPE_CIVFEMALE",haskKey="cs_molly", heading = 304.0, money = {7500, 10000}, cops = 2, blip = false, name = 'Braquage Vêtement', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},

}   

--Config.Ped = {
    --tatoo
	--{pedx=1324.43,pedy=-1650.02,pedz=51.28,pedh=133.0010,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-1152.42,pedy=-1423.57,pedz=3.95,pedh=130.6832,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=319.71,pedy=180.75,pedz=102.59,pedh=251.7727,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-3170.26,pedy=1072.88,pedz=19.83,pedh=329.2711,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=1862.45,pedy=3748.35,pedz=32.03,pedh=32.9646,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-292.02,pedy=6199.79,pedz=30.49,pedh=224.8248,hashKey="u_m_y_tattoo_01",pedtype="PED_TYPE_CIVMALE"},
    --coiffeur
    --{pedx=-822.03,pedy=-183.4,pedz=36.57,pedh=203.7581,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=134.62,pedy=-1707.93,pedz=28.29,pedh=138.7263,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-1284.24,pedy=-1115.29,pedz=5.99,pedh=91.8495,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=1930.89,3728.2,31.84,pedh=204.5738,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=1211.49,-470.76,65.21,pedh=67.4733,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-30.92,-151.66,56.08,pedh=333.5345,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-277.96,6230.39,30.7,pedh=36.8602,hashKey="cs_jewelass",pedtype="PED_TYPE_CIVFEMALE"},
    --vetement
   -- {pedx=73.98,-1393.02,28.39,pedh=267.5617,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-709.04,-151.68,36.42,pedh=123.3165,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-164.99,-303.02,38.73,pedh=251.0183,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=427.07,-806.3,28.49,  87.0846,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-1448.87,-238.1,48.81,pedh=44.8044,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=5.72,6511.22,30.88,pedh=38.3763,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=126.82,-224.7,53.56,pedh=68.4436,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
    --{pedx=1695.35,4823.06,41.06,pedh=98.4611,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=612.96,2763.32,41.09,pedh=271.2434,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=1196.49,2711.67,37.22,pedh=181.4553,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
   --{pedx=-1193.39,-766.61,16.40,pedh=216.9128,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-3169.6,1042.75,19.86,pedh=70.6173,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
	--{pedx=-1102.35,2711.64,18.11,pedh=222.9389,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
    --{pedx=-805.4,-594.82,29.28,pedh=241.3711,hashKey="a_f_y_genhot_01",pedtype="PED_TYPE_CIVFEMALE"},
    --superette
    --{pedx=372.98,328.18,102.57,pedh=252.8312,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-709.04,pedy=-151.68,pedz=36.42,pedh=123.3165,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-164.99,pedy=-303.02,pedz=38.73,pedh=251.0183,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=427.07,pedy=-806.3,pedz=28.49,pedh=87.0846,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=-1448.87,pedy=-238.1,pedz=48.81,pedh=44.8044,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=5.72,pedy=6511.22,pedz=30.88,pedh=38.3763,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=126.82,pedy=-224.7,pedz=53.56,pedh=68.4436,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
   -- {pedx=1695.35,pedy=4823.06,pedz=41.06,pedh=98.4611,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
	--{pedx=612.96,pedy=2763.32,pedz=41.09,pedh=271.2434,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
--	{pedx=1196.49,pedy=2711.67,pedz=37.22,pedh=181.4553,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
   -- {pedx=-1193.39,pedy=-766.61,pedz=16.40,pedh=216.9128,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
--	{pedx=-3169.6,pedy=1042.75,pedz=19.86,pedh=70.6173,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
--	{pedx=-1102.35,pedy=2711.64,pedz=18.11,pedh=222.9389,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},
  --  {pedx=-805.4,pedy=-594.82,pedz=29.28,pedh=241.3711,hashKey="s_m_m_ammucountry",pedtype="PED_TYPE_CIVMALE"},

    --s_m_m_ammucountry
--}



Translation = {
    ['en'] = {
        ['shopkeeper'] = 'shopkeeper',
        ['robbed'] = "I was just robbed and ~r~don't ~w~have any money left!",
        ['cashrecieved'] = 'You got:',
        ['currency'] = '€',
        ['scared'] = 'Scared:',
        ['no_cops'] = 'There are ~r~not~w~ enough cops online!',
        ['cop_msg'] = 'We have sent a photo of the robber taken by the CCTV camera!',
        ['set_waypoint'] = 'Set waypoint to the store',
        ['hide_box'] = 'Close this box',
        ['robbery'] = 'Robbery in progress',
        ['walked_too_far'] = 'You walked too far away!'
    },
    ['sv'] = {
        ['shopkeeper'] = 'butiksbiträde',
        ['robbed'] = 'Jag blev precis rånad och har inga pengar kvar!',
        ['cashrecieved'] = 'Du fick:',
        ['currency'] = 'SEK',
        ['scared'] = 'Rädd:',
        ['no_cops'] = 'Det är inte tillräckligt med poliser online!',
        ['cop_msg'] = 'Vi har skickat en bild på rånaren från övervakningskamerorna!',
        ['set_waypoint'] = 'Sätt GPS punkt på butiken',
        ['hide_box'] = 'Stäng denna rutan',
        ['robbery'] = 'Pågående butiksrån',
        ['walked_too_far'] = 'Du gick för långt bort!'
    },
    ['custom'] = { -- edit this to your language
        ['shopkeeper'] = 'Commerçant',
        ['robbed'] = 'On vient de me voler et je ~r~n\'ai plus ~w~d\'argent !',
        ['cashrecieved'] = 'Vous avez :',
        ['currency'] = '$',
        ['scared'] = 'Effrayé :',
        ['no_cops'] = 'Il n\'y a ~r~pas~w~ assez de flics en ligne !',
        ['cop_msg'] = 'Nous avons envoyé une photo du voleur prise par la caméra de vidéosurveillance !',
        ['set_waypoint'] = 'Définir le waypoint jusqu\'au magasin',
        ['hide_box'] = 'Fermer cette boîte',
        ['robbery'] = 'Braquage en cours',
        ['walked_too_far'] = 'Tu es parti trop loin !'
    }
}