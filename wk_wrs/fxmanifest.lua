--[[-----------------------------------------------------------------------

    Wraith Radar System - v1.02
    Created by WolfKnight

-----------------------------------------------------------------------]]--

fx_version 'cerulean'
games {'gta5'}

ui_page "nui/radar.html"

files {
	"nui/digital-7.regular.ttf", 
	"nui/radar.html",
	"nui/radar.css",
	"nui/radar.js"
}


client_script '@np-lib/client/cl_rpc.lua'
client_script 'cl_radar.lua'