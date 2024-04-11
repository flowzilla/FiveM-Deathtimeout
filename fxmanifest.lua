fx_version "adamant"
game "gta5"

author 'Flowzilla'
description 'deathtimeout'

client_scripts {
	"client/client.lua"
}

server_scripts {
	"server/server.lua",
	"config.lua",
	'@oxmysql/lib/MySQL.lua'
}

ui_page 'html/ui.html'

files {
	"html/*.*",
	"html/assets/css/style.css",
	"html/assets/js/index.js"
}
