shared_script '@vk_Antiloader/modul/antidump.lua'
name 'f17_uijobs'
author 'Thảo#3922'
version 'v2.0.0'
description 'f17_uijobs by F17 Team'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

VoKy_AntiLoader {
    'client/main.lua',
}

dependencies {
	'f17-ttvl'
}

shared_script { 
	'@ox_lib/init.lua',
	'config.lua'
}
client_scripts {
	'main_fc.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/favicon.ico',
	'html/image/*.jpg',
	'html/image/*.png',
	'html/image/*.svg',
	'html/image/*.mp4',
	'html/sound/*.mp3',
	'html/sound/*.wav',
	'html/*.css',
	'html/*.js'
}