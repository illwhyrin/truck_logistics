RegisterNetEvent("Notify")
AddEventHandler("Notify", function(type,msg)
	-- Você pode mudar a notificação como desejar
	prefix = ""
	if type == "negado" then
		prefix = "~r~"
    elseif type == "importante" then
		prefix = "~y~"
    elseif type == "sucesso" then
        prefix = "~g~"
    end
	SetNotificationTextEntry("STRING")
	AddTextComponentString(prefix..msg)
	DrawNotification(false, false)
end)

function DrawText3D2(x, y, z, text, scale)
	if text then
		local onScreen, _x, _y = World3dToScreen2d(x, y, z)
		local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
		SetTextScale(scale, scale) SetTextFont(4)
		SetTextProportional(1)
		SetTextEntry("STRING")
		SetTextCentre(true)
		SetTextColour(255, 255, 255, 215) AddTextComponentString(text)
		DrawText(_x, _y)
		local factor = (string.len(text)) / 700
		DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100)
	end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function spawnVehicle(name,x,y,z,h,vehbody,vehengine,vehtransmission,vehwheels,blip_sprite,blip_color,blip_name)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		nveh = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
		local netveh = VehToNet(nveh)

		Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
		SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
		SetModelAsNoLongerNeeded(mhash)
		SetVehicleDoorsLocked(nveh,1)
		SetVehicleDoorsLocked(NetToVeh(netveh),1)
		SetVehicleNumberPlateText(NetToVeh(netveh),Lang[Config.lang]['truck_plate'])

		if (vehwheels < 400) then
			local arr = {0,1,2,3,4,5,45,47}
			for k,v in pairs(arr) do
				SetVehicleTyreBurst(nveh,v,true,1000)
			end
		end

		SetVehicleEngineHealth(nveh,vehengine+0.0)
		SetVehicleBodyHealth(nveh,vehbody+0.0)
		SetVehicleFuelLevel(nveh,100.0)
		DecorSetFloat(nveh, "_FUEL_LEVEL", GetVehicleFuelLevel(nveh))
	
		blip = AddBlipForEntity(nveh)
		SetBlipSprite(blip,blip_sprite)
		SetBlipColour(blip,blip_color)
		SetBlipAsShortRange(blip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blip_name)
		EndTextCommandSetBlipName(blip)
	end
	return nveh,blip
end