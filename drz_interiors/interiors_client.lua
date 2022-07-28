-- Original creator https://forum.fivem.net/t/release-simple-enters-exits-system-updated-v-0-2/9968


-- The array that will be filled with the server data
-- If you want, you can put your array in this file. It should works fine.
interiors = {
	[1] = { ['e'] = vector4(139.185943603516, -762.684997558594, 45.7520523071289, 0.00), ['o'] = vector4(135.770202636719, -762.303344726563, 242.151962280273, 0.00), ["name"] = 'Bureau', ["locked"] = true },
	[2] = { ['e'] = vector4(127.321395874023, -729.368957519531, 242.151962280273, 0.00), ['o'] = vector4(116.158660888672, -741.4140625, 258.152160644531, 0.00), ["name"] = 'FBI Zone', ["locked"] = false },
	[3] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[4] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[5] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[6] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[7] = { ['e'] = vector4(-428.778, 1111.61, 0.0, 0.000), ['o'] = vector4(135.770202636719, -762.303344726563, 242.151962280273, 0.00), ["name"] = 'Bureau 2'},
	[8] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[9] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[10] = { ['e'] = vector4(-674.75909423828, -879.26324462891, 24.448152542114, 248.85), ['o'] = vector4(1110.5560302734, -3165.8803710938, -37.518630981445, 0.00), ["name"] = 'Mr Fix It', ["locked"] = true },  
	[11] = { ['e'] = vector4(-1486.63, -909.62, 10.03, 131.28), ['o'] = vector4(1088.76, -3187.51, -38.99, 176.41), ["name"] = 'Coke And Cola', ["locked"] = true },
	[12] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.00), ["name"] = 'The Greenery' , ["locked"] = true },
	[13] = { ['e'] = vector4(2188.9, 2785.98, -145.5925, 0.000), ['o'] = vector4(2093.6, 2196.6, -138.99841, 0.00), ["name"] = 'Drug Warehouse', ["locked"] = false },
	[14] = { ['e'] = vector4(-971.26887512207, -2064.03, 230.4925, 0), ['o'] = vector4(1137.9639892578, -3198.359375, -39.665657043457, 0.00), ["name"] = 'The Laundry', ["locked"] = true },
	[15] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[16] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false }, 
	[17] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[18] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[19] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[20] = { ['e'] = vector4(236.101, -413.360, -118.150, 0.000), ['o'] = vector4(-1003.2850341797, -478.16638183594, 50.027095794678, 0.00), ["name"] = 'Boss Office', ["locked"] = true },
	[21] = { ['e'] = vector4(-1048.7210693359, -238.54693603516, -44.021018981934, 0.000), ['o'] = vector4(-1046.9608154297, -237.78092956543, -44.021018981934, 0.00), ["name"] = 'Invader Office', ["locked"] = false },
	[22] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[23] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[24] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[25] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[26] = { ['e'] = vector4(1793.08288574228, 2552.0686035154, 0, 0.00), ['o'] = vector4(1786.098266601, 2675.4948730469, 0, 0.00), ["name"] = 'Jail Food Block', ["locked"] = false },
	[27] = { ['e'] = vector4(1774.618652343, 2551.939208984, 0, 0.00), ['o'] = vector4(1792.108398437, 2657.515625, 0, 0.00), ["name"] = 'Jail Food Block', ["locked"] = false },	
	[28] = { ['e'] = vector4(6.1114993095398, -708.26983642578, 16.13104057312, 0.00), ['o'] = vector4(1690.85, 2591.39, 45.92, 174.95), ["name"] = 'Max Sec Jail', ["locked"] = false},	
	[29] = { ['e'] = vector4(0.0, -985.98718261719, 00.0, 180.00), ['o'] = vector4(0.0, 0.0, 0.0, 180.00), ["name"] = 'Interrogations', ["locked"] = false },	
	[30] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[31] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'Vinewood PD', ["locked"] = false },	
	[32] = { ['e'] = vector4(-138.06, -256.72, 43.6, 220.28), ['o'] = vector4(-175.39, -259.35, 24.28, 178.33), ['name'] = 'Cluckin Bell' },
	[33] = { ['e'] = vector4(1172.8729248047, -3196.6640625, -39.007961273193, 97.41), ['o'] = vector4(992.72039794922, -3097.9880371094, -38.995868682861, 271.6), ["name"] = 'Trading', ["locked"] = false },
	[34] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[35] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[36] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[37] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[38] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[39] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[40] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[41] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[42] = { ['e'] = vector4(1100.15, -3158.99, -37.51, 0.16), ['o'] = vector4(1100.24, -3161.02, -37.49, 179.99), ["name"] = 'Paint Shop', ["locked"] = true },
	[43] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false }, 
	[44] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[45] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[46] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[47] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ['name'] = ' The Church' },
	[48] = { ['e'] = vector4(106.21, 3597.03, 40.73, 264.37), ['o'] = vector4(105.7, 3604.02, -23.84, 264.72), ['name'] = ' The Lost' }, -- LOST Church Room
	[49] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[50] = { ['e'] = vector4(-1093.22, -808.32, 3.76, 126.0), ['o'] = vector4(-1092.47,-848.56,13.53,306.6), ['name'] = ' VBPD Garage <-> Processing ' },
	[51] = { ['e'] = vector4(-1079.45, -833.22, 19.3, 217.12), ['o'] = vector4(-1107.06, -832.63, 37.68, 36.01), ['name'] = ' VBPD Helipad <-> Lockers' }, --Lockers to Helipad
	[52] = { ['e'] = vector4(-1158.98, -857.08, 3.76, 306.84), ['o'] = vector4(-1083.38, -816.34, 31.27, 303.79),  ['name'] = ' VBPD Garage <-> Helipad' }, -- Garage to Helipad 
 	[53] = { ['e'] = vector4(-784.94, -1222.26, 7.34, 321.63), ['o'] = vector4(-773.89, -1207.13, 51.15, 136.75), ['name'] = ' Hospital <-> Helipad'  }, -- Garage to Helipad
  [54] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ['o'] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[55] = { ['e'] = vector4(0.0, 0.0, -250.0, 0.0), ["o"] = vector4(0.0, 0.0, -250.0, 0.0), ["name"] = 'can be reused', ["locked"] = false },
	[56] = { ['e'] = vector4(132.23,-726.86,258.16,345.02), ["o"] = vector4(156.69,-757.46,258.16,316.84), ["name"] = 'FIB', ["locked"] = false },
}

local closeinteriors = {}

local winerySpawns = {
	[1] =  { ['x'] = 1017.11,['y'] = -3194.2,['z'] = -38.19,['h'] = 65.92, ['object'] = 'prop_cs_cardbox_01' },
	[2] =  { ['x'] = 1013.91,['y'] = -3194.02,['z'] = -38.19,['h'] = 174.64, ['object'] = 'prop_cs_cardbox_01' },
	[3] =  { ['x'] = 1011.97,['y'] = -3194.05,['z'] = -38.19,['h'] = 187.93, ['object'] = 'prop_cs_cardbox_01' },
	[4] =  { ['x'] = 1010.35,['y'] = -3194.26,['z'] = -38.2,['h'] = 100.57, ['object'] = 'prop_cs_cardbox_01' },
	[5] =  { ['x'] = 1009.28,['y'] = -3194.33,['z'] = -38.19,['h'] = 92.68, ['object'] = 'prop_cs_cardbox_01' },
	[6] =  { ['x'] = 1013.7,['y'] = -3201.7,['z'] = -38.99,['h'] = 107.46, ['object'] = 'prop_cs_cardbox_01' },
	[7] =  { ['x'] = 1011.9,['y'] = -3202.52,['z'] = -38.99,['h'] = 173.75, ['object'] = 'prop_cs_cardbox_01' },
	[8] =  { ['x'] = 1010.68,['y'] = -3202.53,['z'] = -38.99,['h'] = 119.67, ['object'] = 'prop_cs_cardbox_01' },
	[9] =  { ['x'] = 1009.43,['y'] = -3201.34,['z'] = -38.99,['h'] = 75.11, ['object'] = 'prop_cs_cardbox_01' },
	[10] =  { ['x'] = 1010.91,['y'] = -3201.42,['z'] = -38.99,['h'] = 296.03, ['object'] = 'prop_cs_cardbox_01' },
	[11] =  { ['x'] = 1012.99,['y'] = -3201.21,['z'] = -38.99,['h'] = 242.8, ['object'] = 'prop_cs_cardbox_01' },
	[12] =  { ['x'] = 1011.19,['y'] = -3194.27,['z'] = -38.19,['h'] = 360.0, ['object'] = 'winerow' },
	[13] =  { ['x'] = 1012.8,['y'] = -3194.25,['z'] = -38.19,['h'] = 270.56, ['object'] = 'winerow' },
	[14] =  { ['x'] = 1014.91,['y'] = -3194.26,['z'] = -38.19,['h'] = 267.96, ['object'] = 'winerow' },
	[15] =  { ['x'] = 1016.26,['y'] = -3194.1,['z'] = -38.19,['h'] = 264.44, ['object'] = 'prop_cs_cardbox_01' },
	[16] =  { ['x'] = 1012.67,['y'] = -3201.78,['z'] = -38.99,['h'] = 355.56, ['object'] = 'prop_cs_cardbox_01' },
}

local canEnterXO = nil
local canEnterXE = nil

function enterWinery()
	for i = 1, #winerySpawns do
		CreateObject(GetHashKey(winerySpawns[i]["object"]), winerySpawns[i]["x"],winerySpawns[i]["y"],winerySpawns[i]["z"]-1, 0, 0, 0)
	end
end



local cokespawns = {
	[1] =  { ['x'] = 1101.99,['y'] = -3193.72,['z'] = -38.99,['h'] = 355.19, ['model'] = 'mp_f_cocaine_01' },
	[2] =  { ['x'] = 1099.56,['y'] = -3194.44,['z'] = -38.99,['h'] = 45.81, ['model'] = 'mp_f_cocaine_01' },
	[3] =  { ['x'] = 1093.13,['y'] = -3194.92,['z'] = -38.99,['h'] = 175.54, ['model'] = 'mp_f_cocaine_01' },
	[4] =  { ['x'] = 1092.6,['y'] = -3196.67,['z'] = -38.99,['h'] = 350.64, ['model'] = 'mp_f_cocaine_01' },
}
function DelCokePeds()

end
function CokePeds()

	for i = 1, #cokespawns do

		local pedType = `mp_f_cocaine_01`

        RequestModel(pedType)
        while not HasModelLoaded(pedType) do
            Citizen.Wait(0)
        end


		local ped = CreatePed(26, pedType, cokespawns[i]["x"],cokespawns[i]["y"],cokespawns[i]["z"],cokespawns[i]["h"], 1, 1)
		DecorSetBool(ped, 'ScriptedPed', true)
	    local testdic = "anim@amb@business@coc@coc_unpack_cut@"
	    local testanim = "fullcut_cycle_v6_cokecutter"	
        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) do
            Citizen.Wait(0)
        end

		SetModelAsNoLongerNeeded(pedType)
        TriggerEvent("timed:anim",ped,testdic,testanim)
		
	end
end


RegisterNetEvent('timed:anim')
AddEventHandler('timed:anim', function(ped,testdic,testanim)


	    local testdic2 = "friends@fra@ig_1"
	    local testanim2 = "base_idle"	
	    if math.random(4) == 1 then
	    	testanim2 = "impatient_idle_c"	
    	elseif math.random(3) > 1 then
    		testanim2 = "impatient_idle_a"	
    	else
    		testanim2 = "idle_b"	
    	end
        RequestAnimDict(testdic2)
        while not HasAnimDictLoaded(testdic2) do
            Citizen.Wait(0)
        end


	TaskPlayAnim(ped, testdic2, testanim2, 1.0, 1.0, -1, 1, -1, 0, 0, 0)
	SetBlockingOfNonTemporaryEvents(ped, true)		
	SetPedSeeingRange(ped, 0.0)		
	SetPedHearingRange(ped, 0.0)		
	SetPedFleeAttributes(ped, 0, false)		
	SetPedKeepTask(ped, true)	
	Citizen.Wait(math.random(35000))
	TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, -1, 1, -1, 0, 0, 0)

	SetBlockingOfNonTemporaryEvents(ped, true)		
	SetPedSeeingRange(ped, 0.0)		
	SetPedHearingRange(ped, 0.0)		
	SetPedFleeAttributes(ped, 0, false)		
	SetPedKeepTask(ped, true)	


end)




function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 175)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local prisonDoors = false

RegisterNetEvent("ai:lockAllDoors")
AddEventHandler("ai:lockAllDoors", function(result)
	prisonDoors = result
end)


RegisterNetEvent('inter:clientUpdate')
AddEventHandler('inter:clientUpdate', function(interArray)
	interiors = interArray
end)


RegisterNetEvent('lockunlock')
AddEventHandler('lockunlock', function(houseNumberSent)
	interiors[houseNumberSent].locked = not interiors[houseNumberSent].locked
end)

distance = 10.5999 -- distance to draw
timer = 0
current_int = 0

-- Basic draw text
function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	  N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

local policeped = 0


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function createProcessPed()
	policeped = CreatePed(GetPedType(1581098148), 1581098148, 401.58,-1002.059,-100.004, 15, false, 0)
	DecorSetBool(policeped, 'ScriptedPed', true)
	FreezeEntityPosition(policeped)
	loadAnimDict( "missheist_jewel@hacking" )
	TaskPlayAnim( policeped, "missheist_jewel@hacking", "hack_loop", 8.0, -8, -1, 49, 0, 0, 0, 0 )
	SetPedKeepTask(policeped, true)
end
function delProcessPed()

	DeleteEntity(policeped)
end

spawnedPeds = {}
spawnedPedLocations = {
	[1] = { ["pedType"] = 1581098148, ["x"] = 2107.7724609375, ["y"] = 2929.2177734375, ["z"] = -61.901931762695, ["h"] = 139.06498718262, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[2] = { ["pedType"] = 368603149, ["x"] = 2111.0961914063, ["y"] = 2929.0212402344, ["z"] = -61.901931762695, ["h"] = 299.44998168945, ["animDict"] = "missheist_jewel@hacking", ["anim"] = "hack_loop"},
	[3] = { ["pedType"] = 1581098148, ["x"] = 2121.3715820313, ["y"] = 2925.6013183594, ["z"] = -61.90193939209, ["h"] = 176.32382202148, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[4] = { ["pedType"] = 1581098148, ["x"] = 2132.4958496094, ["y"] = 2925.4846191406, ["z"] = -61.901893615723, ["h"] = 267.89236450195, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},
	[5] = { ["pedType"] = 368603149, ["x"] = 2130.7924804688, ["y"] = 2924.328125, ["z"] = -61.901893615723, ["h"] = 185.47744750977, ["animDict"] = "amb@world_human_cop_idles@male@idle_a", ["anim"] = "idle_b"},

	[6] = { ["pedType"] = 1092080539, ["x"] = 2099.15234375, ["y"] = 2942.9895019531, ["z"] = -65.501823425293, ["h"] = 121.15898132324},
	[7] = { ["pedType"] = 1581098148, ["x"] = 2064.3310546875, ["y"] = 2945.65625, ["z"] = -65.502021789551, ["h"] = 284.78601074219},
	[8] = { ["pedType"] = 1092080539, ["x"] = 2064.982421875, ["y"] = 2947.8371582031, ["z"] = -65.502021789551, ["h"] = 212.32131958008},
	[9] = { ["pedType"] = 368603149, ["x"] = 2047.8717041016, ["y"] = 2955.6459960938, ["z"] = -65.502021789551, ["h"] = 265.44512939453},
	[10] = { ["pedType"] = 1581098148, ["x"] = 2043.9493408203, ["y"] = 2955.6618652344, ["z"] = -65.502021789551, ["h"] = 78.124046325684},
	[11] = { ["pedType"] = 1581098148, ["x"] = 2035.0772705078, ["y"] = 2965.7717285156, ["z"] = -65.502021789551, ["h"] = 21.757316589355},
	[12] = { ["pedType"] = 368603149, ["x"] = 2036.3978271484, ["y"] = 2967.34375, ["z"] = -65.502021789551, ["h"] = 70.922843933105},
	[13] = { ["pedType"] = 1650288984, ["x"] = 2036.3647460938, ["y"] = 2966.0642089844, ["z"] = -65.502021789551, ["h"] = 43.284496307373},
	[14] = { ["pedType"] = 1581098148, ["x"] = 2028.2233886719, ["y"] = 2976.6044921875, ["z"] = -65.502021789551, ["h"] = 75.95450592041},
	[15] = { ["pedType"] = 368603149, ["x"] = 2026.6433105469, ["y"] = 2975.1135253906, ["z"] = -65.502021789551, ["h"] = 9.5711069107056},

	[16] = { ["pedType"] = 1581098148, ["x"] = 2047.0968017578, ["y"] = 2960.8471679688, ["z"] = -65.502021789551, ["h"] = 92.319404602051},
	[17] = { ["pedType"] = 368603149, ["x"] = 2033.6658935547, ["y"] = 2973.009765625, ["z"] = -65.502021789551, ["h"] = 62.04626083374},
	[18] = { ["pedType"] = 1581098148, ["x"] = 2042.0290527344, ["y"] = 2959.8764648438, ["z"] = -65.502021789551, ["h"] = 255.01411437988},
	[19] = { ["pedType"] = 368603149, ["x"] = 2071.2592773438, ["y"] = 2946.4331054688, ["z"] = -65.502029418945, ["h"] = 258.10818481445},
	[20] = { ["pedType"] = 1581098148, ["x"] = 2071.2092285156, ["y"] = 2945.8088378906, ["z"] = -65.502029418945, ["h"] = 239.19422912598},
	[21] = { ["pedType"] = 368603149, ["x"] = 2083.8115234375, ["y"] = 2947.8137207031, ["z"] = -65.501899719238, ["h"] = 242.61120605469},
	[22] = { ["pedType"] = 1581098148, ["x"] = 2083.1064453125, ["y"] = 2941.0427246094, ["z"] = -65.501899719238, ["h"] = 243.56161499023},
	[23] = { ["pedType"] = 368603149, ["x"] = 2080.3305664063, ["y"] = 2943.9006347656, ["z"] = -65.501899719238, ["h"] = 51.285091400146},
	[24] = { ["pedType"] = 368603149, ["x"] = 2079.9599609375, ["y"] = 2941.7927246094, ["z"] = -65.501899719238, ["h"] = 102.3041229248},
	[25] = { ["pedType"] = 1092080539, ["x"] = 2095.73046875, ["y"] = 2938.8049316406, ["z"] = -65.501899719238, ["h"] = 302.30474853516},
	[26] = { ["pedType"] = 1581098148, ["x"] = 2095.9440917969, ["y"] = 2940.8825683594, ["z"] = -65.501899719238, ["h"] = 246.9533996582},
	[27] = { ["pedType"] = 1581098148, ["x"] = 2095.5952148438, ["y"] = 2942.8999023438, ["z"] = -65.501899719238, ["h"] = 308.25518798828},
	[28] = { ["pedType"] = 368603149, ["x"] = 2107.2661132813, ["y"] = 2945.34765625, ["z"] = -65.501899719238, ["h"] = 233.36782836914},
	[29] = { ["pedType"] = 1581098148, ["x"] = 2107.416015625, ["y"] = 2942.7631835938, ["z"] = -65.501899719238, ["h"] = 296.83337402344},
	[30] = { ["pedType"] = 368603149, ["x"] = 2110.419921875, ["y"] = 2940.7756347656, ["z"] = -65.501899719238, ["h"] = 74.760299682617},
	[31] = { ["pedType"] = 1092080539, ["x"] = 2112.0483398438, ["y"] = 2948.0483398438, ["z"] = -65.501899719238, ["h"] = 180.2264251709},
}
function randomScenario2()
	local math = math.random(10)
	ret = "WORLD_HUMAN_HANG_OUT_STREET"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math == 4 then
		ret = "WORLD_HUMAN_DRINKING"
	elseif math < 4 then
		ret = "WORLD_HUMAN_SMOKING"
	end
	return ret
end

function randomScenario()
	local math = math.random(10)
	ret = "WORLD_HUMAN_CLIPBOARD"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math == 4 then
		ret = "WORLD_HUMAN_DRINKING"
	elseif math < 4 then
		ret = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
	end

	return ret
end

function GetRandomWeapon()
	ret = "WEAPON_COMBATPISTOL"
	local math = math.random(10)

	if math == 9 then
		ret = "WEAPON_PISTOL"
	elseif math == 8 then
		ret = "WEAPON_COMBATPISTOL"
	elseif math == 5 then
		ret = "WEAPON_PISTOL"
	end

	return ret
end
--s_m_m_scientist_01


local retry = 0
local retry2 = 0

function DelCocainePeds()
	local playerped = PlayerPedId()
    local handle, ObjectFound = FindFirstPed()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(vector3(1088.472, -3191.326, -38.993) - pos)
        if distance < 175.0 and ObjectFound ~= playerped then
    		if IsPedAPlayer(ObjectFound) then
    		else
    			SetEntityAsNoLongerNeeded(ObjectFound)

    			DeleteEntity(ObjectFound)
    		end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end


RegisterNetEvent('accept:cocainespawn')
AddEventHandler('accept:cocainespawn', function()
	CokePeds()
end)

RegisterNetEvent('delete:cocainespawn')
AddEventHandler('delete:cocainespawn', function(entspawn)
	

	if entspawn then

		DelCocainePeds()
	end

	SetEntityCoords(PlayerPedId(),-1486.63,-909.62, 10.03)


end)

RegisterNetEvent('jail:lockdown')
AddEventHandler('jail:lockdown', function(lockdownState)
    prisonDoors = lockdownState
end)

RegisterNetEvent('np-binds:keyEvent')
AddEventHandler('np-binds:keyEvent', function(name,onDown)
    if onDown then return end

    if name == "general" then
		if canEnterXO then
			EnterXO(canEnterXO)
			scannedEntry = 0
			canEnterXO = nil
		elseif canEnterXE then
			EnterXE(canEnterXE)
			scannedEntry = 0
			canEnterXE = nil
		end
    end
end)


function fixhead(heading)
	SetGameplayCamRelativeHeading(0.0)
end
 -- standing normal
-- Tick tick tick
local fading = false
local scannedEntry = 0
Citizen.CreateThread(function()
	SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
	DoScreenFadeIn(300)
	Citizen.Wait(3111)
	local dstchecked = 1000
	while true do

		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		if scannedEntry == 0 then
			dstchecked = 1000
			for i=1, #interiors do
				if interiors[i] and not IsEntityDead(PlayerPedId()) then
					local comparedst = #(playerCoords - interiors[i].e.xyz)
					if comparedst < dstchecked then
						dstchecked = comparedst
						scannedEntry = i
					end
					local comparedst2 = #(playerCoords - interiors[i].o.xyz)
					if comparedst2 < dstchecked then
						dstchecked = comparedst2
						scannedEntry = i
					end
				end
			end
		end
		
		if dstchecked > 4.1 then

			local waittime = math.ceil(dstchecked * 100) 

			Citizen.Wait(waittime)
			scannedEntry = 0
		else
			if scannedEntry ~= 0 then
				local comparedst2 = #(playerCoords - interiors[scannedEntry].o.xyz)
				local comparedst = #(playerCoords - interiors[scannedEntry].e.xyz)
				if comparedst < 1.1 then
					if not interiors[scannedEntry].locked then
						DrawMarker(27, interiors[scannedEntry].e.x,interiors[scannedEntry].e.y,interiors[scannedEntry].e.z-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						if scannedEntry == 49 then
							-- local rank = exports["isPed"]:GroupRank("sahara_int")
							-- if rank > 3 then
							-- 	DrawText3DTest(interiors[scannedEntry].e.x,interiors[scannedEntry].e.y,interiors[scannedEntry].e.z, "[General] " .. interiors[scannedEntry].name)
							-- end
						else
							DrawText3DTest(interiors[scannedEntry].e.x,interiors[scannedEntry].e.y,interiors[scannedEntry].e.z, "[General] " .. interiors[scannedEntry].name)
						end
						
						if comparedst < 1.1 and timer == 0 then
							canEnterXO = scannedEntry
						end
					else
						DrawMarker(27,interiors[scannedEntry].e.x,interiors[scannedEntry].e.y,interiors[scannedEntry].e.z-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].e.x,interiors[scannedEntry].e.y,interiors[scannedEntry].e.z, "[Locked] " .. interiors[scannedEntry].name)
					end
				elseif comparedst2 < 1.1 then
	
					if not interiors[scannedEntry].locked then
						DrawMarker(27,interiors[scannedEntry].o.x,interiors[scannedEntry].o.y,interiors[scannedEntry].o.z-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].o.x,interiors[scannedEntry].o.y,interiors[scannedEntry].o.z, "[General] " .. interiors[scannedEntry].name)						
					
						if comparedst2 < 1.1 and timer == 0 then
							canEnterXE = scannedEntry
						end
					else
						DrawMarker(27,interiors[scannedEntry].o.x,interiors[scannedEntry].o.y,interiors[scannedEntry].o.z-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].o.x,interiors[scannedEntry].o.y,interiors[scannedEntry].o.z, "[Locked] " .. interiors[scannedEntry].name)
					end
				elseif comparedst > 1.1 and comparedst2 > 1.1 then
					scannedEntry = 0
				end
			end
		end
	end
end)


function EnterXE(i)
	
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local comparedst = #(playerCoords - interiors[i].o.xyz)
	if comparedst > 1.1 then scannedEntry = 0 return end
	DoScreenFadeOut(300)
	Citizen.Wait(300)

	if ((i == 10) or (i == 11) or (i == 14) or (i == 12)) and interiors[i].locked then
		TriggerEvent("DoShortHudText",'Building locked',7)
		timer = 5
	elseif i == 11 then
		TriggerServerEvent("request:cocainedelete")
		timer = 5

	elseif i == 49 then

		local rank = exports["isPed"]:GroupRank("sahara_int")
		if rank < 3 then
			timer = 5	
		else
			local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
			local entity = PlayerPedId()
			if isInVehicle then
				entity = GetVehiclePedIsUsing(entity)
			end
			SetEntityCoords(entity, interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
			SetEntityHeading(entity, interiors[i].e.w)
			timer = 5	
		end

	elseif i == 42 then
	-- elseif i == 44 then
	-- 	SetEntityCoords(PlayerPedId(),interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
	-- 	SetEntityHeading(PlayerPedId(), interiors[i].e.w)
	-- 	enterWinery()
	-- 	timer = 5
	elseif i == 43 then

		SetEntityCoords(PlayerPedId(),interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
		timer = 5
	elseif i == 48 then
		-- if exports["isPed"]:GroupRank("lost_mc") > 0 then
			SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
		-- end
		timer = 5
	elseif i == 45 then
		CleanUpArea()
		
		SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
		timer = 5


	elseif i == 38 then

		
		SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z)

		timer = 5

	elseif i == 15 then

		CleanUpArea()
		
		SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
		timer = 5
	--dicks
	elseif i == 20 then
		if timer == 0 and interiors[i].locked == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].e.w)
			fixhead(interiors[i].e.w)
			ClearAreaOfPeds(interiors[i].e.x,interiors[i].e.y,interiors[i].e.z, 45.0, 1)
			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("DoLongHudText","Its Locked",2)
			end
			timer = 5
		end
	elseif i == 17 or i == 18 or i == 25 or i == 26 or i == 27 then
		if timer == 0 and prisonDoors == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].e.w)
			fixhead(interiors[i].e.w)
			ClearAreaOfPeds(interiors[i].e.x,interiors[i].e.y,interiors[i].e.z, 45.0, 1)
			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("DoLongHudText","Its Locked",2)
			end
			timer = 5
		end
	else

		if timer == 0 then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			if i == 29 then
				createProcessPed()	
				timer = 5					
			end
			if i == 54 then
				TriggerEvent("hotel:clearWarehouse")
				timer = 5
			else									
				SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)
				SetEntityHeading(PlayerPedId(), interiors[i].e.w)
				fixhead(interiors[i].e.w)
				ClearAreaOfPeds(interiors[i].e.x,interiors[i].e.y,interiors[i].e.z, 45.0, 1)

				current_int = i
				timer = 5
				SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

				while IsScreenFadingIn() do Citizen.Wait(0)	end
			end
		end
	end
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
end



function EnterXO(i)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local comparedst = #(playerCoords - interiors[i].e.xyz)
	if comparedst > 1.1 then scannedEntry = 0 return end
	DoScreenFadeOut(300)

	if ((i == 10) or (i == 11) or (i == 14) or (i == 12)) and interiors[i].locked then
		TriggerEvent("DoShortHudText",'Building locked.',7)
		Citizen.Wait(2000)
		timer = 5
	elseif i == 11 then

		TriggerServerEvent("request:cocainespawn")
		SetEntityCoords(PlayerPedId(),interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
		SetEntityHeading(PlayerPedId(), interiors[i].o.w)
		timer = 5
	-- elseif i == 43 or i == 44 then
	-- 	SetEntityCoords(PlayerPedId(),interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
	-- 	SetEntityHeading(PlayerPedId(), interiors[i].o.w)
	-- 	Citizen.Wait(2500)
	-- 	timer = 5

	elseif i == 54 then
    -- TODO: Add a load function to warehouse new housing?
		TriggerEvent("hotel:loadWarehouse")
		SetEntityCoords(GetPlayerPed(-1), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.1)
		timer = 5
	elseif i == 49 then

		local rank = exports["isPed"]:GroupRank("sahara_int")
		if rank < 3 then
			timer = 5
		else
			local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
			local entity = PlayerPedId()
			if isInVehicle then
				entity = GetVehiclePedIsUsing(entity)
			end
			SetEntityCoords(entity,interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
			SetEntityHeading(entity, interiors[i].o.w)
			timer = 5	
		end
	elseif i == 48 then
		-- if exports["isPed"]:GroupRank("lost_mc") > 0 then	
			SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
		-- end
		timer = 5
	-- elseif i == 45 then
	-- 	FreezeEntityPosition(PlayerPedId(),true)
	-- 	buildWineOffice()
	-- 	Citizen.Wait(1000)
	-- 	FreezeEntityPosition(PlayerPedId(),false)
		
	-- 	timer = 5
	elseif i == 42 then
		local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 3.0, 1544229216, 0, 0, 0)
		FreezeEntityPosition(objFound,false)
		
		timer = 25
	elseif i == 22 then
		SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z)
	elseif i == 20 then
		if timer == 0 and interiors[i].locked == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
			
			SetEntityHeading(PlayerPedId(), interiors[i].o.w)
			fixhead(interiors[i].o.w)

			ClearAreaOfPeds(interiors[i].o.x,interiors[i].o.y,interiors[i].o.z, 45.0, 1)

			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("DoLongHudText","Its Locked",2)
			end
			timer = 5
		end

	elseif i == 41 or i == 42 then
		if timer == 0 then
			-- load in hospital interior?
			DoScreenFadeOut(1)
			SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
			Citizen.Wait(700)
			SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z-0.7)

			if i == 43 then

				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 918.43,38.95,-180.88)
				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 918.43,38.95,-185.88)
				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 926.65,52.19,-180.88)
				SetEntityHeading(PlayerPedId(),350.0)
			end

			Citizen.Wait(500)
			DoScreenFadeIn(500)
			SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].o.w)
			timer = 8
		end
	elseif i == 18 then
		SetEntityCoords(PlayerPedId(),interiors[i].o.x-5,interiors[i].o.y-5,interiors[i].o.z)

		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].o.x-35,interiors[i].o.y-35,interiors[i].o.z)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].o.x,interiors[i].o.y,interiors[i].o.z)
		timer = 5
	elseif i == 38 then

		SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z)

		Citizen.Wait(500)

		SetEntityCoords(PlayerPedId(), interiors[i].e.x,interiors[i].e.y,interiors[i].e.z)

		Citizen.Wait(500)

		SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z)
		timer = 5

	elseif i == 17 or i == 18 or i == 25 or i == 26 or i == 27 then
		if timer == 0 and prisonDoors == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].o.w)
			fixhead(interiors[i].o.w)

			ClearAreaOfPeds(interiors[i].o.x,interiors[i].o.y,interiors[i].o.z, 45.0, 1)

			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("DoLongHudText","Its Locked",2)
			end
			timer = 5
		end
	elseif i == 32 then

		TriggerEvent("hotel:loadWarehouse")
		SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.1)

		timer = 5

	else

		if timer == 0 then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			if i == 29 then
				delProcessPed()	
				timer = 5						
			end


			if i == 30 then
				delMetalDetector()
				timer = 5
			end


			if i == 31 then
				TriggerServerEvent("request:vinewooddel")
				timer = 5

			else
				SetEntityCoords(PlayerPedId(), interiors[i].o.x,interiors[i].o.y,interiors[i].o.z-0.7)
				SetEntityHeading(PlayerPedId(), interiors[i].o.w)
				fixhead(interiors[i].o.w)

				ClearAreaOfPeds(interiors[i].o.x,interiors[i].o.y,interiors[i].o.z, 45.0, 1)
				--NetworkFadeInEntity(PlayerPedId(), 0)
				current_int = i
				timer = 5
				SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
				while IsScreenFadingIn() do 
					Citizen.Wait(0)	
				end
			end
		end

	end

	Citizen.Wait(500)
	DoScreenFadeIn(1000)

end

-- Sick timer by the creator of the original script.
Citizen.CreateThread(function()

	while true do
		Wait(1000)
		if timer > 0 then
			timer=timer-1
			if timer == 0 then current_int = 0 end
		end
	end
end)

DoScreenFadeIn(5000)

function GroupRank(groupid)
  local rank = 0
  local mypasses = exports["isPed"]:isPed("passes")
  for i=1, #mypasses do
    if mypasses[i]["pass_type"] == groupid then
      rank = mypasses[i]["rank"]
    end 
  end
  return rank
end

function buildWineOffice()

	SetEntityCoords(PlayerPedId(),-74.88, -831.33, 243.39 )

	Citizen.Wait(2000)

  	local generator = { x = -1892.26, y =2056.36, z = 61.39} -- spawn location-
	local building = CreateObject(`ex_office_03b_shell`,generator.x+0.82022000,generator.y+1.45879100,generator.z-4.22499600,false,false,false)

	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+3.83883900,generator.y-1.44630700,generator.z+0.80139000,false,false,false)
	local easyChair1 = CreateObject(`ex_mp_h_off_easychair_01`,generator.x+0.50250100,generator.y-3.06935000,generator.z-0.00704300,false,false,false)
	local easyChair2 = CreateObject(`ex_mp_h_off_easychair_01`,generator.x+0.49876200,generator.y-4.32264400,generator.z-0.00705000,false,false,false)
	SetEntityHeading(easyChair1,GetEntityHeading(easyChair1)+90)
	SetEntityHeading(easyChair2,GetEntityHeading(easyChair2)+90)
	CreateObject(`ex_mp_h_acc_bowl_ceramic_01`,generator.x+0.35230600,generator.y+3.71305300,generator.z+0.95000000,false,false,false)
	CreateObject(`ex_office_03b_skirt1`,generator.x+0.82022000,generator.y+1.45879100,generator.z+0.08499600,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_Reception`,generator.x+5.59351200,generator.y+0.97565800,generator.z+3.40000800,false,false,false)
	local mon = CreateObject(`ex_prop_trailer_monitor_01`,generator.x+3.99114800,generator.y+0.66242900,generator.z+0.86899500,false,false,false)
	SetEntityHeading(mon,GetEntityHeading(mon)+90)
	CreateObject(`ex_office_03b_recdesk`,generator.x+4.05373600,generator.y-0.02752400,generator.z+0.08000000,false,false,false)
	
	CreateObject(`prop_mouse_02`,generator.x+4.37081900,generator.y+0.82507800,generator.z+0.80046800,false,false,false)
	CreateObject(`prop_off_phone_01`,generator.x+4.10196800,generator.y-0.88896700,generator.z+0.80051900,false,false,false)
	local l1 = CreateObject(`v_serv_2socket`,generator.x-2.12396500,generator.y-2.06103500,generator.z+0.30746700,false,false,false)
	local l2 =CreateObject(`v_serv_switch_3`,generator.x-2.21688300,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	local l3 =CreateObject(`v_serv_switch_3`,generator.x-2.02786100,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	SetEntityHeading(l1,GetEntityHeading(l1)+90)
	SetEntityHeading(l2,GetEntityHeading(l2)+90)
	SetEntityHeading(l3,GetEntityHeading(l3)+90)

	local alarm = CreateObject(`v_res_tre_alarmbox`,generator.x-2.74074700,generator.y-1.48556800,generator.z+1.24797900,false,false,false)
	SetEntityHeading(alarm,GetEntityHeading(alarm)+90)
	CreateObject(`ex_office_03b_EdgesRecep`,generator.x+4.60805000,generator.y-1.47149300,generator.z+0.01280200,false,false,false)
	CreateObject(`ex_office_03b_WorldMap`,generator.x+7.09353500,generator.y+5.30796300,generator.z+1.66799300,false,false,false)
	CreateObject(`ex_office_03b_Shad_Recep`,generator.x+3.65794100,generator.y-0.10437700,generator.z+0.00000000,false,false,false)
	local pow = CreateObject(`ex_office_03b_sideboardPower_003`,generator.x+0.34884700,generator.y+3.70960600,generator.z+0.10705600,false,false,false)
	SetEntityHeading(pow,GetEntityHeading(pow)-90)
	
	CreateObject(`ex_officedeskcollision`,generator.x+4.00000000,generator.y+0.00000000,generator.z-0.10000000,false,false,false)
	CreateObject(`v_res_fh_speakerdock`,generator.x+10.04326000,generator.y+10.36692000,generator.z+1.08903000,false,false,false)
	CreateObject(`ex_office_03b_WinGlass00`,generator.x+17.59416000,generator.y+13.05352000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass01`,generator.x+17.59416000,generator.y+11.13831000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass02`,generator.x+17.59416000,generator.y+9.22329500,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass03`,generator.x+17.59416000,generator.y+7.30808600,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass08`,generator.x+17.59421000,generator.y+4.40942000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass09`,generator.x+17.59416000,generator.y-7.16629200,generator.z+0.49340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass10`,generator.x+17.59416000,generator.y-9.13228000,generator.z+0.49340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass11`,generator.x+17.59416000,generator.y-11.09808000,generator.z+0.49340900,false,false,false)
	CreateObject(`v_res_paperfolders`,generator.x+15.23951000,generator.y+11.01277000,generator.z+0.90960600,false,false,false)

	CreateObject(`v_res_binder`,generator.x+15.18253000,generator.y+11.43653000,generator.z+0.82427700,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0104`,generator.x+16.83519000,generator.y+14.41163000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_LampTable_01`,generator.x+12.73544000,generator.y+10.97619000,generator.z+0.79879500,false,false,false)
	CreateObject(`ex_Office_03b_hskirt3`,generator.x+13.31318000,generator.y+1.32258700,generator.z+0.05000100,false,false,false)
	CreateObject(`ex_off_03b_GEOLIGHT_FrontOffice`,generator.x+12.77866000,generator.y-11.67066000,generator.z+3.22427500,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0103`,generator.x+10.77528000,generator.y+14.41163000,generator.z-0.00005500,false,false,false)
	local flat = CreateObject(`ex_prop_ex_tv_flat_01`,generator.x+10.48212000,generator.y-0.02673700,generator.z+1.41501200,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)+90)
	local telescope = CreateObject(`prop_t_telescope_01b`,generator.x+16.81530000,generator.y+7.60000000,generator.z+0.03700000,false,false,false)
	SetEntityHeading(telescope,GetEntityHeading(telescope)+180)
	local c2 = CreateObject(`v_corp_offchair`,generator.x+14.77600000,generator.y+9.43131200,generator.z+0.00000000,false,false,false)
	local c1 = CreateObject(`v_corp_offchair`,generator.x+13.07700000,generator.y+9.39931100,generator.z+0.00000000,false,false,false)
	SetEntityHeading(c2,GetEntityHeading(c2)-180)
	SetEntityHeading(c1,GetEntityHeading(c1)-180)
	local mon = CreateObject(`ex_prop_monitor_01_ex`,generator.x+13.97009000,generator.y+11.27176000,generator.z+0.86899500,false,false,false)
	SetEntityHeading(mon,GetEntityHeading(mon)-180)
	CreateObject(`prop_mouse_02`,generator.x+13.54931000,generator.y+11.64707000,generator.z+0.80050400,false,false,false)
	CreateObject(`prop_off_phone_01`,generator.x+13.14856000,generator.y+11.42315000,generator.z+0.80050400,false,false,false)
	CreateObject(`prop_bar_cockshaker`,generator.x+9.50759800,generator.y+8.39425200,generator.z+0.94999900,false,false,false)
	local spirt = CreateObject(`spiritsrow`,generator.x+9.38967800,generator.y+9.29554300,generator.z+0.94999900,false,false,false)
	SetEntityHeading(spirt,GetEntityHeading(spirt)+90)
	
	CreateObject(`ex_office_03b_desk`,generator.x+13.97011000,generator.y+11.21162000,generator.z+0.06995700,false,false,false)
	local g1 = CreateObject(`v_res_fa_plant01`,generator.x+9.40017600,generator.y+8.24227200,generator.z+1.15825100,false,false,false)
	local g2 =CreateObject(`prop_glass_stack_05`,generator.x+9.37649400,generator.y+10.12211000,generator.z+1.80909900,false,false,false)
	local g3 =CreateObject(`prop_glass_stack_02`,generator.x+9.35501000,generator.y+8.88657900,generator.z+1.81202900,false,false,false)
	local g4 =CreateObject(`prop_glass_stack_06`,generator.x+9.35501000,generator.y+9.47272600,generator.z+1.54725900,false,false,false)
	local g5 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+9.96296000,generator.z+1.54725900,false,false,false)
	local g6 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+8.95143200,generator.z+1.54725900,false,false,false)
	local g7 =CreateObject(`prop_glass_stack_01`,generator.x+9.35501000,generator.y+9.47264200,generator.z+1.81202900,false,false,false)
	local g8 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+9.74093600,generator.z+2.08021800,false,false,false)
	local g9 =CreateObject(`prop_glass_stack_06`,generator.x+9.35501000,generator.y+9.13371200,generator.z+2.07399200,false,false,false)
	SetEntityHeading(g1,GetEntityHeading(g1)+90)
	SetEntityHeading(g2,GetEntityHeading(g2)+90)
	SetEntityHeading(g3,GetEntityHeading(g3)+90)
	SetEntityHeading(g4,GetEntityHeading(g4)+90)
	SetEntityHeading(g5,GetEntityHeading(g5)+90)
	SetEntityHeading(g6,GetEntityHeading(g6)+90)
	SetEntityHeading(g7,GetEntityHeading(g7)+90)
	SetEntityHeading(g8,GetEntityHeading(g8)+90)
	SetEntityHeading(g9,GetEntityHeading(g9)+90)

	
	CreateObject(`ex_mp_h_acc_bowl_ceramic_01`,generator.x+10.58087000,generator.y-0.98099200,generator.z+0.73129800,false,false,false)
	local winrow = CreateObject(`winerow`,generator.x+9.41506900,generator.y+10.32958000,generator.z+0.94999900,false,false,false)
	SetEntityHeading(winrow,GetEntityHeading(winrow)+90)
	CreateObject(`prop_champ_01a`,generator.x+9.46340900,generator.y+8.61231800,generator.z+0.94999900,false,false,false)

	CreateObject(`prop_champ_jer_01a`,generator.x+9.38967800,generator.y+8.51190000,generator.z+0.94999900,false,false,false)
	CreateObject(`prop_bar_stirrers`,generator.x+9.67305700,generator.y+10.51067000,generator.z+0.94999900,false,false,false)
	CreateObject(`ex_office_03b_Boardtable`,generator.x+13.69090000,generator.y-8.69550800,generator.z+0.00030500,false,false,false)
	CreateObject(`ex_mp_h_acc_plant_palm_01`,generator.x+16.49393000,generator.y+5.80993500,generator.z+0.00000000,false,false,false)

	CreateObject(`v_serv_2socket`,generator.x+10.21870000,generator.y+12.57842000,generator.z+0.30746700,false,false,false)
	CreateObject(`prop_box_ammo07a`,generator.x+11.91324000,generator.y+14.98271000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.08518000,generator.y+14.95856000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.20990000,generator.y+14.93168000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+12.01649000,generator.y+14.95856000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_guncase_02a`,generator.x+12.30792000,generator.y+14.77875000,generator.z+0.33298800,false,false,false)
	CreateObject(`Prop_Drop_ArmsCrate_01b`,generator.x+12.31815000,generator.y+14.97308000,generator.z+0.39096400,false,false,false)
	CreateObject(`prop_box_ammo07b`,generator.x+11.70625000,generator.y+14.89851000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_guncase_01a`,generator.x+12.31427000,generator.y+14.97308000,generator.z+0.94427500,false,false,false)
	CreateObject(`prop_box_ammo07a`,generator.x+11.51516000,generator.y+15.02956000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.46920000,generator.y+14.96635000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.34637000,generator.y+14.96635000,generator.z+1.54383200,false,false,false)

	CreateObject(`Prop_Drop_ArmsCrate_01b`,generator.x+12.31815000,generator.y+14.97308000,generator.z+0.75934600,false,false,false)
	CreateObject(`ex_office_03b_StripLamps`,generator.x+13.13106000,generator.y+11.69762000,generator.z+0.80118800,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+12.43525000,generator.y+14.95856000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+11.73945000,generator.y+14.92581000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+11.54390000,generator.y+14.92581000,generator.z+1.18664200,false,false,false)
	local safe = CreateObject(`ex_office_03b_Safes`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.00000000,false,false,false)
	SetEntityHeading(safe,GetEntityHeading(safe)-90)
	--CreateObject(`ex_prop_safedoor_office3a_l`,generator.x+11.41656000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_Edges_Main`,generator.x+13.61647000,generator.y+1.94954700,generator.z+0.01285300,false,false,false)
	--CreateObject(`ex_prop_safedoor_office3a_r`,generator.x+16.25136000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0105`,generator.x+17.09381000,generator.y-11.74412000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0101`,generator.x+10.29999000,generator.y-11.74412000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_tvtable`,generator.x+13.80864000,generator.y-0.14030900,generator.z-0.01227000,false,false,false)
	
	CreateObject(`ex_office_03b_MetalShelf`,generator.x+9.22459100,generator.y+9.78214800,generator.z+1.50955900,false,false,false)
	CreateObject(`ex_office_03b_Shad_Main`,generator.x+13.86071000,generator.y+0.08125000,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_office_03b_TVUnit`,generator.x+10.57312000,generator.y-0.03527800,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+16.99567000,generator.y-5.02271800,generator.z+0.92395100,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+10.47731000,generator.y-1.23041900,generator.z+0.73129800,false,false,false)
	local wframe =  CreateObject(`ex_office_03b_wFrame003`,generator.x+12.31777000,generator.y-5.44320100,generator.z+0.10772200,false,false,false)
	SetEntityHeading(wframe,GetEntityHeading(wframe)-90)
	
	CreateObject(`ex_office_03b_SoundBaffles1`,generator.x+14.50548000,generator.y-0.94601400,generator.z+3.39024900,false,false,false)
	local sc1 = CreateObject(`ex_Office_03b_stripChair1`,generator.x+12.03766000,generator.y+2.14166100,generator.z+0.00000000,false,false,false)
	local sc2 = CreateObject(`ex_Office_03b_stripChair2`,generator.x+11.96429000,generator.y-2.23546000,generator.z+0.00000000,false,false,false)
	local window =CreateObject(`ex_prop_office_louvres`,generator.x+18.06730000,generator.y-0.23932300,generator.z+0.10772200,false,false,false)
	local sc3 = CreateObject(`ex_mp_h_off_sofa_02`,generator.x+15.66240000,generator.y+0.03326700,generator.z+0.00000000,false,false,false)
	SetEntityHeading(window,GetEntityHeading(window)+90)
	SetEntityHeading(sc1,GetEntityHeading(sc1)+70)
	SetEntityHeading(sc2,GetEntityHeading(sc2)+110)
	SetEntityHeading(sc3,GetEntityHeading(sc3)-90)
	
	CreateObject(`ex_office_03b_GlassPane2`,generator.x+11.06012000,generator.y-5.40525200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane004`,generator.x+16.32030000,generator.y-5.41362200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane003`,generator.x+11.06012000,generator.y-5.41357300,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane1`,generator.x+16.32030000,generator.y-5.40530200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass020`,generator.x+17.59421000,generator.y-2.51997600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass019`,generator.x+17.59421000,generator.y-4.25111800,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass022`,generator.x+17.59421000,generator.y+0.94213700,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass023`,generator.x+17.59421000,generator.y+2.67310600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass021`,generator.x+17.59421000,generator.y-0.78900700,generator.z+0.50725900,false,false,false)
	
	CreateObject(`ex_office_03b_sideboardPower_1`,generator.x+16.32105000,generator.y-5.01578000,generator.z+0.10705600,false,false,false)
	CreateObject(`ex_office_citymodel_01`,generator.x+13.74981000,generator.y-8.72368000,generator.z+0.80427800,false,false,false)
	CreateObject(`ex_prop_tv_settop_remote`,generator.x+10.71205000,generator.y+0.19141700,generator.z+0.47649700,false,false,false)
	CreateObject(`ex_prop_tv_settop_box`,generator.x+10.69669000,generator.y-0.02768300,generator.z+0.48917300,false,false,false)
	local iw1 = CreateObject(`ex_office_03b_WinGlass014`,generator.x+6.15745700,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw2 = CreateObject(`ex_office_03b_WinGlass015`,generator.x+8.12344600,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw3 = CreateObject(`ex_office_03b_WinGlass013`,generator.x+4.19166100,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local frame2 = CreateObject(`ex_office_03b_wFrame2`,generator.x+6.14261300,generator.y-5.40933400,generator.z+0.00772200,false,false,false)
	SetEntityHeading(frame2,GetEntityHeading(frame2)-90)
	SetEntityHeading(iw1,GetEntityHeading(iw1)-90)
	SetEntityHeading(iw2,GetEntityHeading(iw2)-90)
	SetEntityHeading(iw3,GetEntityHeading(iw3)-90)
	
	CreateObject(`prop_printer_02`,generator.x+4.44948700,generator.y-5.72865900,generator.z+0.80441900,false,false,false)
	CreateObject(`prop_kettle`,generator.x+4.13300000,generator.y-11.87105000,generator.z+0.95783400,false,false,false)
	local micro = CreateObject(`prop_micro_02`,generator.x+3.64373400,generator.y-11.82465000,generator.z+1.09977400,false,false,false)
	local sink = CreateObject(`ex_office_03b_kitchen`,generator.x+4.23552100,generator.y-11.73340000,generator.z+0.06602100,false,false,false)
	local cm = CreateObject(`ex_mp_h_acc_coffeemachine_01`,generator.x+4.93680700,generator.y-11.69780000,generator.z+0.95783400,false,false,false)
	CreateObject(`ex_office_03b_skirt2`,generator.x+4.10593700,generator.y-8.57737300,generator.z+0.04999800,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_WaitingArea`,generator.x+3.34384900,generator.y-10.12492000,generator.z+3.40000800,false,false,false)
	CreateObject(`ex_p_h_acc_artwallm_01`,generator.x+1.01400200,generator.y-11.41125000,generator.z+2.19531300,false,false,false)
	CreateObject(`ex_mp_h_tab_sidelrg_07`,generator.x-0.76488900,generator.y-10.34824000,generator.z-0.01339100,false,false,false)
	CreateObject(`prop_glass_stack_02`,generator.x-0.96651900,generator.y-10.26981000,generator.z+0.43167700,false,false,false)
	CreateObject(`ex_mp_h_acc_bottle_01`,generator.x-0.98562300,generator.y-10.59739000,generator.z+0.43070100,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)-90)
	SetEntityHeading(micro,GetEntityHeading(micro)-180)
	SetEntityHeading(cm,GetEntityHeading(cm)-180)
	
	CreateObject(`v_res_fashmag1`,generator.x-0.62925100,generator.y-6.73683400,generator.z+0.42972400,false,false,false)
	CreateObject(`v_res_fashmagopen`,generator.x+0.96242300,generator.y-8.98048600,generator.z+0.45161400,false,false,false)
	CreateObject(`v_res_r_silvrtray`,generator.x-0.93600100,generator.y-10.36643000,generator.z+0.43167700,false,false,false)
	CreateObject(`ex_mp_h_tab_sidelrg_07`,generator.x-0.76488900,generator.y-6.54443400,generator.z-0.01339100,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+5.17286500,generator.y-9.76032300,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+5.17288600,generator.y-9.76032300,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+3.34560200,generator.y-6.32599200,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+3.34560200,generator.y-6.13697000,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+3.34574400,generator.y-6.23307400,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+4.03587600,generator.y-6.92667400,generator.z+1.49840300,false,false,false)

	local edges4 = CreateObject(`ex_office_03b_EdgesWait`,generator.x+9.14111600,generator.y-5.90339900,generator.z+0.00000400,false,false,false)
	SetEntityHeading(edges4,GetEntityHeading(edges4)-90)
	CreateObject(`ex_office_03b_FloorLamp0102`,generator.x-0.76488900,generator.y-11.02532000,generator.z+0.01312800,false,false,false)
	local gdesk = CreateObject(`ex_office_03b_desk004`,generator.x+1.10171100,generator.y-8.50667800,generator.z+0.03023800,false,false,false)
	SetEntityHeading(gdesk,GetEntityHeading(gdesk)+90)
	local iw4 = CreateObject(`ex_office_03b_WinGlass018`,generator.x+5.07940000,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw5 =CreateObject(`ex_office_03b_WinGlass017`,generator.x+7.04538900,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw6 =CreateObject(`ex_office_03b_WinGlass016`,generator.x+9.01118500,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	SetEntityHeading(iw4,GetEntityHeading(iw4)+90)
	SetEntityHeading(iw5,GetEntityHeading(iw5)+90)
	SetEntityHeading(iw6,GetEntityHeading(iw6)+90)
	CreateObject(`ex_office_03b_StripLamps_kitchen`,generator.x+4.25069000,generator.y-11.88272000,generator.z+1.67102200,false,false,false)
	local sof = CreateObject(`ex_mp_h_off_sofa_003`,generator.x-0.76884700,generator.y-8.46005400,generator.z+0.00000000,false,false,false)
	SetEntityHeading(sof,GetEntityHeading(sof)+90)
	local armChair = CreateObject(`ex_Office_03b_WaitRmChairs`,generator.x+1.84398500,generator.y-10.90230000,generator.z+0.00000000,false,false,false)
	SetEntityHeading(armChair,GetEntityHeading(armChair)+180)
	CreateObject(`prop_laptop_01a`,generator.x+6.83454500,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+8.33620700,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+5.30988200,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	
	CreateObject(`ex_office_03b_skirt4`,generator.x+5.87873900,generator.y+9.78554600,generator.z+0.04999900,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Bathroom`,generator.x+5.14397000,generator.y+8.93845400,generator.z+2.91470400,false,false,false)
	CreateObject(`v_serv_bs_foam1`,generator.x+9.68656100,generator.y+13.41801000,generator.z+0.93879600,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x+1.71013600,generator.y+7.30080300,generator.z+0.00000000,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+8.67294200,generator.y+5.77780000,generator.z+0.76876200,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+7.91499300,generator.y+5.81820500,generator.z+0.21617000,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+8.71047600,generator.y+5.81699000,generator.z+0.21617000,false,false,false)

	CreateObject(`v_ret_ps_cologne`,generator.x+9.47080200,generator.y+12.13796000,generator.z+0.79701900,false,false,false)
	CreateObject(`ex_office_03b_LampTable_02`,generator.x+9.69349400,generator.y+11.74564000,generator.z+0.80134400,false,false,false)
	CreateObject(`ex_mp_h_acc_candles_01`,generator.x+8.90054500,generator.y+9.01688700,generator.z+0.94888600,false,false,false)
	CreateObject(`ex_mp_h_acc_candles_04`,generator.x+8.88957000,generator.y+8.72137000,generator.z+0.94888600,false,false,false)
	CreateObject(`ex_prop_offchair_exec_03`,generator.x+8.55600000,generator.y+13.13900000,generator.z+0.10198100,false,false,false)
	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+10.03610000,generator.y+11.24539000,generator.z+0.80134400,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+9.00073400,generator.y+8.85563500,generator.z+0.94888600,false,false,false)
	CreateObject(`v_serv_bs_gel`,generator.x+9.45322400,generator.y+13.29018000,generator.z+0.83455500,false,false,false)

	CreateObject(`ex_office_03b_FloorLamp01`,generator.x+2.87563600,generator.y+13.78156000,generator.z-0.00005500,false,false,false)
	local gshelf = CreateObject(`ex_office_03b_GlassShelves2`,generator.x+10.06959000,generator.y+12.40041000,generator.z+0.75042600,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+10.10841000,generator.y+11.46752000,generator.z+0.80134400,false,false,false)
	CreateObject(`v_serv_tc_bin3_`,generator.x+9.63415500,generator.y+13.87192000,generator.z+0.25574800,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+1.51790700,generator.y+6.78857800,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+1.51944800,generator.y+6.78857800,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+2.51535200,generator.y+12.63103000,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+2.51381100,generator.y+12.63103000,generator.z+1.49840300,false,false,false)
	CreateObject(`ex_office_03b_Edges_Chng`,generator.x+4.58213600,generator.y+10.05374000,generator.z+0.00000400,false,false,false)
	CreateObject(`v_club_brush`,generator.x+9.45322400,generator.y+13.54335000,generator.z+0.79894100,false,false,false)
	CreateObject(`ex_prop_exec_bed_01`,generator.x+5.50940000,generator.y+13.10000000,generator.z-0.00000300,false,false,false)
	CreateObject(`ex_office_03b_Shad_Bath`,generator.x+5.59655300,generator.y+12.34816000,generator.z+0.00000000,false,false,false)
	local art = CreateObject(`ex_Office_03b_bathroomArt`,generator.x+10.19056000,generator.y+12.57837000,generator.z+1.66302500,false,false,false)
	local power4 = CreateObject(`ex_office_03b_sideboardPower_004`,generator.x+8.81734200,generator.y+9.50928800,generator.z+0.10705600,false,false,false)
	SetEntityHeading(art,GetEntityHeading(art)-90)
	SetEntityHeading(gshelf,GetEntityHeading(gshelf)-180)
	SetEntityHeading(power4,GetEntityHeading(power4)+90)
	
	local plate = CreateObject(`ex_mp_h_acc_dec_plate_01`,generator.x-16.45605000,generator.y-0.05843100,generator.z+1.00123400,false,false,false)
	local art3 = CreateObject(`ex_p_h_acc_artwallm_03`,generator.x-16.69037000,generator.y-0.05843100,generator.z+1.76771000,false,false,false)
	local table0 = CreateObject(`ex_prop_ex_console_table_01`,generator.x-16.33744000,generator.y-0.05843100,generator.z+0.00000000,false,false,false)
	SetEntityHeading(art3,GetEntityHeading(art3)+90)
	SetEntityHeading(plate,GetEntityHeading(plate)+90)
	SetEntityHeading(table0,GetEntityHeading(table0)+90)

	
	CreateObject(`ex_office_03b_LIGHT_Foyer`,generator.x-3.82964100,generator.y+0.02804200,generator.z+3.10086700,false,false,false)
	CreateObject(`ex_office_03b_normalonly1`,generator.x-8.42918000,generator.y-0.02619600,generator.z+0.71280200,false,false,false)
	CreateObject(`ex_office_03b_foyerdetail`,generator.x-9.78775400,generator.y-0.02673700,generator.z+0.09000000,false,false,false)
	CreateObject(`ex_Office_03b_numbers`,generator.x-9.93670100,generator.y-0.02917200,generator.z+2.40085100,false,false,false)
	local detail = CreateObject(`ex_office_03b_elevators`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.08000000,false,false,false)
	CreateObject(`ex_office_03b_CARPETS`,generator.x+8.07606700,generator.y+1.32258800,generator.z+0.00198900,false,false,false)
	CreateObject(`ex_office_03b_Shower`,generator.x+0.34558600,generator.y+6.88265700,generator.z-0.06255700,false,false,false)
	CreateObject(`ex_p_mp_h_showerdoor_s`,generator.x-0.59146200,generator.y+7.00626500,generator.z+1.20006700,false,false,false)
	SetEntityHeading(detail,GetEntityHeading(detail)-90)
	

	CreateObject(`ex_p_mp_door_apart_doorbrown_s`,generator.x+1.44672400,generator.y+8.81843100,generator.z+1.24813200,false,false,false)
	CreateObject(`ex_Office_03b_Proxy_CeilingLight`,generator.x+3.33397300,generator.y-0.02675400,generator.z+3.68248700,false,false,false)
	CreateObject(`ex_Office_03b_ToiletSkirting`,generator.x+1.13302800,generator.y+11.37978000,generator.z+0.05000000,false,false,false)
	CreateObject(`ex_Office_03b_Toilet`,generator.x+1.08040800,generator.y+12.24717000,generator.z+0.48479800,false,false,false)

	CreateObject(`ex_Office_03b_ToiletArt`,generator.x+1.13303000,generator.y+12.73267000,generator.z+1.33258700,false,false,false)
	CreateObject(`prop_toilet_roll_02`,generator.x+0.56858000,generator.y+12.57573000,generator.z+0.58252000,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x+0.03584800,generator.y+12.02357000,generator.z+0.00000000,false,false,false)
	CreateObject(`prop_towel_rail_02`,generator.x-0.12948900,generator.y+11.68217000,generator.z+0.70703100,false,false,false)
	CreateObject(`v_res_tre_washbasket`,generator.x+2.09027800,generator.y+10.48882000,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_office_03b_sinks001`,generator.x+0.28737900,generator.y+11.64389000,generator.z+1.19806000,false,false,false)
	CreateObject(`ex_Office_03b_ToiletTaps`,generator.x+0.01130900,generator.y+11.10180000,generator.z+1.01921500,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Toilet`,generator.x+0.38847900,generator.y+11.50150000,generator.z+2.69625500,false,false,false)
	CreateObject(`ex_p_mp_door_apart_doorbrown01`,generator.x+2.47054500,generator.y+10.99843000,generator.z+1.15000000,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+14.20325000,generator.y+10.73750000,generator.z+0.80564200,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+14.08056000,generator.y+0.25372600,generator.z+0.45519900,false,false,false)
	CreateObject(`prop_beer_stzopen`,generator.x+8.70215000,generator.y-5.71030500,generator.z+0.80369400,false,false,false)
	CreateObject(`ex_office_03b_room_blocker`,generator.x+6.21348800,generator.y+6.43969200,generator.z-0.29498500,false,false,false)

	

	CreateObject(`ex_prop_offchair_exec_01`,generator.x+14.25161000,generator.y+12.47272000,generator.z+0.02015500,false,false,false)

	local chair4 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+16.08929000,generator.y-8.70579200,generator.z+0.09623700,false,false,false)
	local chair5 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+5.29666500,generator.y-6.65300000,generator.z+0.09600000,false,false,false)
	local chair6 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+6.82119500,generator.y-6.65300000,generator.z+0.09600000,false,false,false)
	local chair7 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+8.34572400,generator.y-6.65300000,generator.z+0.09600000,false,false,false)

	local chair1 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+14.92358000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	local chair2 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+13.73376000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	local chair3 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+12.53418000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+12.56676000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+13.73958000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+14.95615000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)


	SetEntityHeading(chair1,GetEntityHeading(chair1)+180)
	SetEntityHeading(chair2,GetEntityHeading(chair2)+180)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+180)
	SetEntityHeading(chair4,GetEntityHeading(chair4)-90)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+180)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+180)
	SetEntityHeading(chair7,GetEntityHeading(chair7)+180)
	FreezeEntityPosition(building,true)
  	
	SetEntityCoords( PlayerPedId(), -1897.12, 2058.89, 62.49 )
	SetEntityHeading( PlayerPedId(), 262.72 )

end


function CleanUpArea()
	local playerped = PlayerPedId()
	local plycoords = GetEntityCoords(playerped)
	local handle, ObjectFound = FindFirstObject()
	local success
	repeat
			local pos = GetEntityCoords(ObjectFound)
			local distance = #(plycoords - pos)
			if distance < 50.0 and ObjectFound ~= playerped then
				if IsEntityAPed(ObjectFound) then
					if IsPedAPlayer(ObjectFound) then
					else
						SetEntityAsNoLongerNeeded(Objectfound)
						DeleteObject(ObjectFound)

					end
				else
					if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
						DeleteObject(ObjectFound)
					end
				end            
			end
			success, ObjectFound = FindNextObject(handle)
	until not success
	EndFindObject(handle)
	TriggerEvent("inhotel",false)
end
