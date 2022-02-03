fx_version 'adamant'

game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
}


client_scripts {
    '@es_extended/locale.lua',
  --  'drogues/weed/cl_weed.lua',
  --  'drogues/coke/cl_coke.lua',
 --   'drogues/opium/cl_opium.lua',
 --   'drogues/meth/cl_meth.lua',
 --   'drogues/ecstasy/cl_ecstasy.lua',
 --   'drogues/lsd/cl_lsd.lua',
 --   'drogues/vente/vente.lua',
  --  'pnj_sale/cl_shop.lua',
    'sWipe/client/client.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
  --  'drogues/server/server.lua',
   -- 'pnj_sale/sv_shop.lua',
    'sWipe/server/server.lua',
}

dependencies {
	'es_extended'
}
