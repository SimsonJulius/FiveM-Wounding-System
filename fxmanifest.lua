fx_version 'cerulean'
game 'gta5'

author 'Julius'

description 'Wounding System for FiveM'

version 'beta'

client_scripts {
	'client/wunden.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'server/wundensv.lua',
	'server/mainsv.lua',
	'server/itemssv.lua',
}

dependencies {
	'mythic_progbar',
	'mythic_notify',
}

exports {
    'isInjuredOrBleeding',
}

server_exports {
    'GetCharInjuries',
}
