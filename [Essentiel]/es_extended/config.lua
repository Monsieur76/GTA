Config = {}
Config.Locale = 'fr'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney 	= {bank = 5000}

Config.EnableSocietyPayouts 	= true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            	= false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            	= 40   -- the max inventory weight without backpack
Config.PaycheckInterval         = 1000 * 900 -- how often to recieve pay checks in milliseconds
Config.EnableDebug              = false -- Use Debug options?
Config.EnableDefaultInventory   = false -- Display the default Inventory ( F2 )
Config.EnableWantedLevel    	= false -- Use Normal GTA wanted Level?
Config.EnablePVP                = true -- Allow Player to player combat

Config.Multichar                = false -- Enable support for esx_multicharacter
Config.Identity                 = false -- Select a characters identity data before they have loaded in (this happens by default with multichar)

Config.admin =
{ 
"steam:11000010d76afc9" --kyra
,
"steam:110000116ec46b9"
,
"steam:11000013d167d5e"
,
"steam:110000100e8cf30"
,
"steam:1100001014507c7"
,
"steam:11000010d9af6d1"--soma
,
"steam:110000105e8d999"
,
"steam:110000109d43dfb"--teddy
,
"steam:110000100e8cf30"
}