local showdeathmenu = true

Citizen.CreateThread(function ()
	while true do
        Wait(0)
        local player = PlayerId()
        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()
		    if IsPedFatallyInjured(ped) and Menu.hidden then
				exports.spawnmanager:setAutoSpawnCallback(function()
			        if spawnLock then
				        return
			        end
			        spawnLock = false
		        end)
				if showdeathmenu then
					NameOfMenu()
					Menu.hidden = false
					showdeathmenu = false
				end
			end
		end
		Menu.renderGUI()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1),  true)
		if DoesEntityExist(ped) and not IsEntityDead(ped) then
			if (showdeathmenu == false) then
				Menu.hidden = true
				showdeathmenu = true
			end
		else
			--
		end
	end
end)

RegisterNetEvent('gabs:rpdhopital_cl')
AddEventHandler('gabs:rpdhopital_cl', function(x, y, z)
    exports.spawnmanager:spawnPlayer({x = x, y = y, z = z})
end)

RegisterNetEvent("gabs:rpdheal")
AddEventHandler('gabs:rpdheal', function()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1),  true)
	if DoesEntityExist(ped) and IsEntityDead(ped) then
		NetworkResurrectLocalPlayer(pos, true, true, false)
		SetEntityHealth(ped, 200)
		ragdol = 0
		TriggerServerEvent('gabs:addcustomneeds', 10, 10, 10)
	end
end)

RegisterNetEvent('gabs:kill')
AddEventHandler('gabs:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

Menu = {}
Menu.GUI = {}
Menu.TitleGUI = {}
Menu.buttonCount = 0
Menu.titleCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"

-------------------
posXMenu = 0.1
posYMenu = 0.05
width = 0.15
height = 0.05

posXMenuTitle = 0.1
posYMenuTitle = 0.05
widthMenuTitle = 0.1
heightMenuTitle = 0.05
-------------------

function Menu.addTitle(name)

	local yoffset = 0.3
	local xoffset = 0
	
	local xmin = posXMenuTitle
	local ymin = posYMenuTitle
	local xmax = widthMenuTitle
	local ymax = heightMenuTitle

	
	Menu.TitleGUI[Menu.titleCount +1] = {}
	Menu.TitleGUI[Menu.titleCount +1]["name"] = name
	Menu.TitleGUI[Menu.titleCount+1]["xmin"] = xmin + xoffset
	Menu.TitleGUI[Menu.titleCount+1]["ymin"] = ymin * (Menu.titleCount + 0.01) +yoffset
	Menu.TitleGUI[Menu.titleCount+1]["xmax"] = xmax 
	Menu.TitleGUI[Menu.titleCount+1]["ymax"] = ymax 
	Menu.titleCount = Menu.titleCount+1
end

function Menu.addButton(name, func,args)

	local yoffset = 0.3
	local xoffset = 0
	
	local xmin = posXMenu
	local ymin = posYMenu
	local xmax = width
	local ymax = height

	
	Menu.GUI[Menu.buttonCount +1] = {}
	Menu.GUI[Menu.buttonCount +1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin + xoffset
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax 
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax 
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection() 
	if IsControlJustPressed(1, 8)  then 
		if(Menu.selection < Menu.buttonCount -1  )then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end
	elseif IsControlJustPressed(1, 32) then
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end
	elseif IsControlJustPressed(1, 201)  then
			MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderGUI()
	if not Menu.hidden then
		Menu.renderTitle()
		Menu.renderButtons()
		Menu.updateSelection()
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu.renderTitle()
	local yoffset = 0.3
	local xoffset = 0

	local xmin = posXMenuTitle
	local ymin = posYMenuTitle
	local xmax = widthMenuTitle
	local ymax = heightMenuTitle
	for id, settings in pairs(Menu.TitleGUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
--		boxColor = {20,30,10,255}
		boxColor = {0,0,0,128}

		SetTextFont(0)
		SetTextScale(0.0,0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING") 
		AddTextComponentString(string.upper(settings["name"]))
		DrawText(settings["xmin"], (settings["ymin"] - heightMenuTitle - 0.0125))
		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"] - heightMenuTitle, settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	end	
end

function Menu.renderButtons()
		
	for id, settings in pairs(Menu.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
--		boxColor = {42,63,17,255}
		boxColor = {128,128,128,128}
		
		if(settings["active"]) then
--			boxColor = {107,158,44,255}
			boxColor = {38,38,38,255}
		end
		SetTextFont(0)
		SetTextScale(0.0,0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING") 
		AddTextComponentString(settings["name"])
		DrawText(settings["xmin"], (settings["ymin"] - 0.0125 )) 
		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	 end     
end


--------------------------------------------------------------------------------------------------------------------

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.titleCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end

--------------------------------------------------------------------------------------------------------------------
function NameOfMenu()
	ClearMenu()
	Menu.addTitle("Mort")
	Menu.addButton("Hopital","hopitalfunc",nil)	
	Menu.addButton("Appel de détresse","callhelpfunc",nil)
	Menu.addButton("Utiliser un haricot magique","itemfunc",nil)
	Menu.addButton("Mort RP","rpdeathfunc",nil)
	-- ...
end

function hopitalfunc()
	TriggerServerEvent('gabs:rpdhopital_sv')
--	TriggerServerEvent('gabs:setdefaultneeds')
end

function callhelpfunc()
	drawNotification("~g~Les médecins ont reçu votre appel")
	-- TriggerServerEvent('gabs:blablabla')
end

function itemfunc()
	TriggerServerEvent('gabs:rpduseitem_sv')
end

function rpdeathfunc()
	drawNotification("~g~Suppression du joueur de la base de données...")
	-- TriggerServerEvent('gabs:blablabla')
end