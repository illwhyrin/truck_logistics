--[[
   _____                                         _                _     _                __      __  _   _____             _____ 
  / ____|                                       | |              | |   | |               \ \    / / (_) |  __ \           / ____|
 | |        ___    _ __   __   __   ___   _ __  | |_    ___    __| |   | |__    _   _     \ \  / /   _  | |__) |  _   _  | (___  
 | |       / _ \  | '_ \  \ \ / /  / _ \ | '__| | __|  / _ \  / _` |   | '_ \  | | | |     \ \/ /   | | |  _  /  | | | |  \___ \ 
 | |____  | (_) | | | | |  \ V /  |  __/ | |    | |_  |  __/ | (_| |   | |_) | | |_| |      \  /    | | | | \ \  | |_| |  ____) |
  \_____|  \___/  |_| |_|   \_/    \___| |_|     \__|  \___|  \__,_|   |_.__/   \__, |       \/     |_| |_|  \_\  \__,_| |_____/ 
                                                                                 __/ |                                           
                                                                                |___/                                            
-- Converted by ViRuS for QBCore Framework - https://github.com/qbcore-framework --
]]
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local isOpen = {}
local debug_cooldown = {}
local vrp_ready = nil
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

-- Gera contratos
Citizen.CreateThread(function()
	local contract_type = 1
	Citizen.Wait(10000)
	while true do
		if contract_type == 0 then
			contract_type = 1
			bonus = Config.contratos.multiplicador_frete
		else
			contract_type = 0
			bonus = 1.0
		end
		local coords_index = math.random(1, #Config.locais_entrega)
		local price_per_km = math.random(Config.contratos.preco_por_km_min, Config.contratos.preco_por_km_max)
		
		local truck = Config.contratos.caminhoes[math.random(1, #Config.contratos.caminhoes)]
		
		local cargas = Config.contratos.cargas[math.random(1, #Config.contratos.cargas)]
		local contract_name = cargas.nome
		local trailer = cargas.carga
		local cargo_type = cargas.def[1]
		local fragile = cargas.def[2]
		local valuable = cargas.def[3]
		
		local carga_urgente = math.random(0,100)
		local fast = 0
		if carga_urgente <= Config.contratos.probabilidade_ser_carga_urgente then
			fast = 1
		end

		if contract_type == 1 then truck = nil end
	
		local sql = exports['ghmattimysql']:execute("SELECT COUNT(contract_id) as qtd FROM trucker_available_contracts", function(result)
		
			local count = result[1].qtd;
			
			if count >= Config.contratos.max_contratos_ativos then
				local sql = exports['ghmattimysql']:execute("SELECT MIN(contract_id) as min FROM trucker_available_contracts", function(sql2)
				local min = sql2[1].min;
				
				exports['ghmattimysql']:execute("DELETE FROM `trucker_available_contracts` WHERE contract_id = @contract_id;", {['@contract_id'] = min});
			
				end)
			end

			exports['ghmattimysql']:execute("INSERT INTO `trucker_available_contracts` (contract_type, contract_name, coords_index, price_per_km, cargo_type, fragile, valuable, fast, truck, trailer) VALUES (@contract_type, @contract_name, @coords_index, @price_per_km, @cargo_type, @fragile, @valuable, @fast, @truck, @trailer);", {['@contract_type'] = contract_type, ['@contract_name'] = contract_name, ['@coords_index'] = coords_index, ['@price_per_km'] = (price_per_km*bonus), ['@cargo_type'] = cargo_type, ['@fragile'] = fragile, ['@valuable'] = valuable, ['@fast'] = fast, ['@truck'] = truck, ['@trailer'] = trailer});
			
		end)

		local users = QBCore.Functions.GetPlayers()
		for k,v in pairs(users) do
			if isOpen[v] then
				openUI(v, true)
				Citizen.Wait(100)
			end
		end

		Citizen.Wait(Config.contratos.cooldown*1000*60)
	end
end)

-- Gera motoristas
Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do 
		local product_type = math.random(0, 6)
		local distance = math.random(0, 6)
		local fragile = math.random(0, 6)
		local valuable = math.random(0, 6)
		local fast = math.random(0, 6)
		if product_type+distance+fragile+valuable+fast > 15 then
			product_type = math.random(0, 6)
			distance = math.random(0, 6)
			fragile = math.random(0, 6)
			valuable = math.random(0, 6)
			fast = math.random(0, 6)
			if product_type+distance+fragile+valuable+fast > 20 then
				product_type = math.random(0, 6)
				distance = math.random(0, 6)
				fragile = math.random(0, 6)
				valuable = math.random(0, 6)
				fast = math.random(0, 6)
			end
		end
		
		local price = math.random(Config.motoristas.preco_min, Config.motoristas.preco_max)
		price = price + (product_type+distance+fragile+valuable+fast)*(price*(Config.motoristas.porcentagem_bonus_habilidades/100))
		local price_per_km = math.random(Config.motoristas.preco_por_km_min, Config.motoristas.preco_por_km_max)
		price_per_km = price_per_km + (product_type+distance+fragile+valuable+fast)*(price_per_km*(Config.motoristas.porcentagem_bonus_habilidades/100))
		
		local driver = Config.motoristas.nomes[math.random(1, #Config.motoristas.nomes)]
		local name = driver.nomes[math.random(1, #driver.nomes)]

		if contract_type == 1 then truck = nil end

			local sql = exports['ghmattimysql']:execute("SELECT COUNT(driver_id) as qtd FROM trucker_drivers WHERE user_id IS NULL", function (result)
				
				local count = result[1].qtd;
				
				if count >= Config.motoristas.max_motoristas_ativos then
					local sql = exports['ghmattimysql']:execute("SELECT MIN(driver_id) as min FROM trucker_drivers WHERE user_id IS NULL", function(sql)
					local min = sql[1].min;
					
				
					exports['ghmattimysql']:execute("DELETE FROM `trucker_drivers` WHERE driver_id = @driver_id;", {['@driver_id'] = min});
					end)
				end
			end)
		exports['ghmattimysql']:execute("INSERT INTO `trucker_drivers` (user_id, name, product_type, distance, fragile, valuable, fast, price, price_per_km, img) VALUES (NULL, @name, @product_type, @distance, @fragile, @valuable, @fast, @price, @price_per_km, @img);", {['@name'] = name, ['@product_type'] = product_type, ['@distance'] = distance, ['@fragile'] = fragile, ['@valuable'] = valuable, ['@fast'] = fast, ['@price'] = price, ['@price_per_km'] = price_per_km, ['@img'] = driver.img});
	
		local users = QBCore.Functions.GetPlayers()
		for k,v in pairs(users) do
			if isOpen[v] then
				openUI(v, true)
				Citizen.Wait(100)
			end
		end
		
		Citizen.Wait(Config.motoristas.cooldown*1000*60)
	end
end)

-- Gera trabalho para os motoristas
Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do 
		local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_drivers` ", function(result)

			local data = result
			for k,v in pairs(data) do
				local source = QBCore.Functions.GetPlayerByCitizenId(v.user_id)
				if Config.trabalhos.gera_dinheiro_offline or source then
					if tryGetTruckerMoney(v.user_id,v.price + v.price_per_km) then
						local amount = math.random(Config.trabalhos.valor_inicial_min,Config.trabalhos.valor_inicial_max)
						amount = amount + (v.product_type+v.distance+v.fragile+v.valuable+v.fast)*(amount*(Config.trabalhos.porcentagem_bonus_habilidades/100))
						giveTruckerMoney(v.user_id,amount)
					else
						exports['ghmattimysql']:execute("UPDATE `trucker_drivers` SET user_id = NULL WHERE driver_id = @driver_id", {['@driver_id'] = v.driver_id});
						
						exports['ghmattimysql']:execute("UPDATE `trucker_trucks` SET driver = NULL WHERE driver = @driver_id", {['@driver_id'] = v.driver_id});
						if source then
							TriggerClientEvent("QBCore:Notify", source, Lang[Config.lang]['driver_failed']:format(v.name), "error")
						end
					end
		
			
					if source then
						if isOpen[source] then
							openUI(source, true)
							Citizen.Wait(100)
						end
					end
				end
				Citizen.Wait(100)
			end
		end) -- END QUERY
		Citizen.Wait(Config.trabalhos.cooldown*1000*60)
	end
end)

-- Paga empréstimo
Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		local data = exports['ghmattimysql']:execute("SELECT * FROM trucker_loans", function(data)
			for k,v in pairs(data) do
				if v.timer + Config.emprestimos.cooldown < os.time() then
					local source = QBCore.Functions.GetPlayerByCitizenId(tonumber(v.user_id))
					if tryGetTruckerMoney(v.user_id,v.day_cost) then
						local new_loan = v.remaining_amount - v.taxes_on_day
						if new_loan > 0 then
							exports['ghmattimysql']:execute("UPDATE `trucker_loans` SET remaining_amount = @remaining_amount, timer = @timer WHERE id = @id", {['remaining_amount'] = new_loan, ['timer'] = os.time(), ['@id'] = v.id});
						else
							exports['ghmattimysql']:execute("DELETE FROM `trucker_loans` WHERE id = @id;", {['@id'] = v.id});
						end
					else
						if source then
							TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['no_loan_money'], "primary")
						else
							exports['ghmattimysql']:execute("UPDATE `trucker_users` SET loan_notify = 1 WHERE user_id = @user_id", {['@user_id'] = v.user_id});
						end
					end
					if source then
						if isOpen[source] then
							openUI(source, true)
							Citizen.Wait(100)
						end
					end
					Citizen.Wait(100)
				end
			end
		end)
		Citizen.Wait(10*1000*60)
	end
end)

RegisterServerEvent("truck_logistics:getData")
AddEventHandler("truck_logistics:getData",function()

		local source = source
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			isOpen[source] = true
			openUI(source,false)
		end
end)

RegisterServerEvent("truck_logistics:closeUI")
AddEventHandler("truck_logistics:closeUI",function()
	isOpen[source] = false
end)

RegisterServerEvent("truck_logistics:startContract")
AddEventHandler("truck_logistics:startContract",function(data)
	local id = data.id
	local distance = data.distance
	local reward = data.reward

	local source = source
	if debug_cooldown[source] == nil then
		debug_cooldown[source] = true
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			local query = exports['ghmattimysql']:execute("SELECT * FROM `trucker_available_contracts` WHERE contract_id = @id",{['@id'] = id}, function(query)
				if query and query[1] then
					query_users = exports['ghmattimysql']:execute("SELECT * FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(query_users)
						if query_users and query_users[1] then
							if tonumber(query_users[1].product_type) >= tonumber(query[1].cargo_type) then
								if tonumber(query_users[1].fragile) >= tonumber(query[1].fragile) then
									if tonumber(query_users[1].valuable) >= tonumber(query[1].valuable) then
										if tonumber(query_users[1].fast) >= tonumber(query[1].fast) then
											if Config.habilidade_distancia[tonumber(query_users[1].distance)] >= tonumber(distance) then
												if tonumber(query[1].contract_type) == 0 then
													-- Inicia o trabalho
													TriggerClientEvent("truck_logistics:startContract",source,query[1],distance,reward,{})
												else
													-- Checa se tem caminhão
													query_truck = exports['ghmattimysql']:execute("SELECT * FROM `trucker_trucks` WHERE driver = 0 AND user_id = @user_id", {['@user_id'] = user_id}, function(query_truck)
														if query_truck and query_truck[1] then
															TriggerClientEvent("truck_logistics:startContract",source,query[1],distance,reward,query_truck[1])
														else
															TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['own_truck'], "error")
														end
													end)
												end
											else
												TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['no_skill_1'], "error")
											end
										else
											TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['no_skill_2'], "error")
										end
									else
										TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['no_skill_3'], "error")
									end
								else
									TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['no_skill_4'], "error")
								end
							else
								TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['no_skill_5'], "error")
							end
						end
					end)
				else
					TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['job_already_started'], "error")
				end
			end)
		end
		debug_cooldown[source] = nil
	end
end)

RegisterServerEvent("truck_logistics:spawnTruck")
AddEventHandler("truck_logistics:spawnTruck",function(truck_id)
	local source = source
	if debug_cooldown[source] == nil then
		debug_cooldown[source] = true
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			exports['ghmattimysql']:execute("SELECT * FROM `trucker_trucks` WHERE truck_id = @truck_id" ,{['@truck_id'] = tonumber(truck_id)}, function(result)
				if result and result[1] then
					TriggerClientEvent("truck_logistics:spawnTruck",source, result[1])
				end
			end)
		end
		debug_cooldown[source] = nil
	end
end)

RegisterServerEvent("truck_logistics:upgradeSkill")
AddEventHandler("truck_logistics:upgradeSkill",function(data)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result)
			local query = result[1];
			if query.skill_points >= (data.value - query[data.id]) then
				exports['ghmattimysql']:execute("UPDATE `trucker_users` SET "..data.id.." = @value, skill_points = @skill_points WHERE user_id = @user_id", {['@user_id'] = user_id, ['@value'] = data.value, ['@skill_points'] = (query.skill_points - (data.value - query[data.id]))});
				TriggerClientEvent("QBCore:Notify", source, Lang[Config.lang]['upgraded_skill'], "success")
				openUI(source,true)
			else
				TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['insufficient_skill_points'], "error")
			end
		end)
	end
end)

RegisterServerEvent("truck_logistics:repairTruck")
AddEventHandler("truck_logistics:repairTruck",function(item)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_trucks` WHERE user_id = @user_id AND driver = 0", {['@user_id'] = user_id}, function(result)
			local query = result[1];
			if query then
				local amount = math.floor((100-(tonumber(query[item])/10)) * Config.valor_reparo[item])
				if amount > 0 then
					if tryGetTruckerMoney(user_id,amount) then
						exports['ghmattimysql']:execute("UPDATE `trucker_trucks` SET "..item.." = 1000 WHERE user_id = @user_id AND driver = 0", {['@user_id'] = user_id});
						TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['repaired'], "success")
						openUI(source,true)
					else
						TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['insufficiente_funds'], "error")
					end
				else
					TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['not_repaired'], "error")
				end
			else
				TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['have_no_truck'], "error")
			end
		end)
	end
end)

RegisterServerEvent("truck_logistics:buyTruck")
AddEventHandler("truck_logistics:buyTruck",function(data)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		if tryGetTruckerMoney(user_id,tonumber(data.price)) then
			exports['ghmattimysql']:execute("INSERT INTO `trucker_trucks` (user_id, truck_name, driver) VALUES (@user_id, @name, NULL);", {['@user_id'] = user_id, ['@name'] = data.truck_name});
			TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['bought'], "success")
			SendWebhookMessage(Config.webhook,Lang[Config.lang]['logs_buytruck']:format(data.truck_name,data.price,user_id..os.date("\n["..Lang[Config.lang]['logs_date'].."]: %d/%m/%Y ["..Lang[Config.lang]['logs_hour'].."]: %H:%M:%S")))
			openUI(source,true)
		else
			TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['insufficiente_funds'], "error")
		end
	end
end)

RegisterServerEvent("truck_logistics:sellTruck")
AddEventHandler("truck_logistics:sellTruck",function(data)
	local source = source
	if debug_cooldown[source] == nil then
		debug_cooldown[source] = true
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_trucks` WHERE truck_id = @truck_id", {['@truck_id'] = data.truck_id}, function(result)
				local query = result[1];
				if query then 
					exports['ghmattimysql']:execute("DELETE FROM `trucker_trucks` WHERE truck_id = @truck_id;", {['@truck_id'] = data.truck_id});
					local amount = math.floor(tonumber(Config.concessionaria[data.truck_name].price * Config.multiplicador_venda))
					giveTruckerMoney(user_id,amount)
					TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['sold'], "success")
					SendWebhookMessage(Config.webhook,Lang[Config.lang]['logs_selltruck']:format(data.truck_name,amount,user_id..os.date("\n["..Lang[Config.lang]['logs_date'].."]: %d/%m/%Y ["..Lang[Config.lang]['logs_hour'].."]: %H:%M:%S")))
					openUI(source,true)
				end
			end)
		end
		debug_cooldown[source] = nil
	end
end)

RegisterServerEvent("truck_logistics:hireDriver")
AddEventHandler("truck_logistics:hireDriver",function(driver_id)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local sql = exports['ghmattimysql']:execute("SELECT COUNT(driver_id) as qtd FROM trucker_drivers WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result)
			local count = result[1].qtd;
		
			if count <= Config.motoristas.max_motoristas_por_player then
				local sql = exports['ghmattimysql']:execute("SELECT price FROM trucker_drivers WHERE driver_id = @driver_id", {['@driver_id'] = driver_id}, function(result2)
					local query = result2[1];
					if tryGetTruckerMoney(user_id,query.price) then
						exports['ghmattimysql']:execute("UPDATE `trucker_drivers` SET user_id = @user_id WHERE driver_id = @driver_id", {['@user_id'] = user_id, ['@driver_id'] = driver_id});
						TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['hired'], "success")
						openUI(source,true)
					else
						TriggerClientEvent("QBCore:Notify",source,"Dinero insuficiente", "error")
					end
				end)
			else
				TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['max_drivers'], "error")
			end
		end)
	end
end)

RegisterServerEvent("truck_logistics:fireDriver")
AddEventHandler("truck_logistics:fireDriver",function(driver_id)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		exports['ghmattimysql']:execute("UPDATE `trucker_drivers` SET user_id = NULL WHERE driver_id = @driver_id", {['@driver_id'] = driver_id});
		exports['ghmattimysql']:execute("UPDATE `trucker_trucks` SET driver = NULL WHERE driver = @driver_id", {['@driver_id'] = driver_id});
		TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['fired'], "success")
		openUI(source,true)
	end
end)

RegisterServerEvent("truck_logistics:setDriver")
AddEventHandler("truck_logistics:setDriver",function(data)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		if tonumber(data.driver_id) ~= 0 then
		exports['ghmattimysql']:execute("UPDATE `trucker_trucks` SET driver = NULL WHERE driver = @driver_id", {['@driver_id'] = data.driver_id});
		end
		exports['ghmattimysql']:execute("UPDATE `trucker_trucks` SET driver = @driver_id WHERE truck_id = @truck_id", {['@driver_id'] = data.driver_id, ['@truck_id'] = data.truck_id});
		openUI(source,true)
	end
end)

RegisterServerEvent("truck_logistics:withdrawMoney")
AddEventHandler("truck_logistics:withdrawMoney",function()
	local source = source
	if debug_cooldown[source] == nil then
		debug_cooldown[source] = true
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_loans` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(sql)
				local query = sql[1];
				if not query or not query.remaining_amount or query.remaining_amount <= 0 then
					local sql = exports['ghmattimysql']:execute("SELECT money FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(sql2)
						local query = sql2[1];
						local amount = tonumber(query.money)
						if amount and amount > 0 then
							local sql = "UPDATE `trucker_users` SET money = 0 WHERE user_id = @user_id";
							exports['ghmattimysql']:execute(sql, {['@user_id'] = user_id});
							xPlayer.Functions.AddMoney('bank', amount)
							TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['money_withdrawn'], "success")
							openUI(source,true)
						else
							TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['insufficiente_money'], "error")
						end
					end)
				else
					TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['pay_loans'], "error")
				end
			end)
		end
		debug_cooldown[source] = nil
	end
end)

RegisterServerEvent("truck_logistics:depositMoney")
AddEventHandler("truck_logistics:depositMoney",function(data)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local amount = tonumber(data.amount)
		if amount and amount > 0 then
			money = xPlayer.PlayerData.money.bank
			if money >= amount then
				xPlayer.Functions.RemoveMoney('bank', amount)
				giveTruckerMoney(user_id,amount)
				TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['money_deposited'], "success")
				openUI(source,true)
			else
				TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['insufficiente_money'], "error")
			end
		else
			TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['invalid_value'], "error")
		end
	end
end)

RegisterServerEvent("truck_logistics:loan")
AddEventHandler("truck_logistics:loan",function(data)
	local source = source
	if debug_cooldown[source] == nil then
		debug_cooldown[source] = true
		local xPlayer = QBCore.Functions.GetPlayer(source)
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_loans` WHERE user_id = @user_id", {['@user_id'] = user_id}, function (result)
			local query = result
			local amount_loans = 0;
			for k,v in pairs(query) do
				amount_loans = amount_loans + tonumber(v.loan)
			end
			
			if amount_loans + Config.emprestimos.valores[data.loan_id][1] <= getMaxEmprestimo(user_id) then
				local sql = "INSERT INTO `trucker_loans` (user_id,loan,remaining_amount,day_cost,taxes_on_day) VALUES (@user_id,@loan,@remaining_amount,@day_cost,@taxes_on_day);";
				exports['ghmattimysql']:execute(sql, {['@user_id'] = user_id, ['@loan'] = Config.emprestimos.valores[data.loan_id][1], ['@remaining_amount'] = Config.emprestimos.valores[data.loan_id][1], ['@day_cost'] = Config.emprestimos.valores[data.loan_id][2], ['@taxes_on_day'] = Config.emprestimos.valores[data.loan_id][3]});
				giveTruckerMoney(user_id,Config.emprestimos.valores[data.loan_id][1])
				TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['loan'], "success")
				openUI(source,true)
			else
				TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['no_loan'], "error")
			end
		end)
		end
		debug_cooldown[source] = nil
	end
end)

RegisterServerEvent("truck_logistics:payLoan")
AddEventHandler("truck_logistics:payLoan",function(data)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_loans` WHERE id = @id",{['@id'] = data.loan_id}, function(result)
			local query = result[1]
				if tryGetTruckerMoney(user_id, query.remaining_amount) then
					local sql = "DELETE FROM `trucker_loans` WHERE id = @id;";
					exports['ghmattimysql']:execute(sql, {['@id'] = data.loan_id});
					TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['loan_paid'], "success")
					openUI(source,true)
				else
					TriggerClientEvent("QBCore:Notify",source,Lang[Config.lang]['insufficiente_funds'], "error")
				end
		end)
	end
end)

RegisterServerEvent("truck_logistics:finishJob")
AddEventHandler("truck_logistics:finishJob",function(data,distance,reward,truck_data,truck_engine,truck_body,trailer_body)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		trailer_body = trailer_body/1000
		local exp_amount = reward*(Config.exp/100)
		local bonus = 0
		local bonus_exp = 0
		local level = getPlayerLevel(user_id)
		local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result)
			local query = result[1]
				if data.fragile > 0 then
					bonus = bonus + reward*(Config.bonus['fragile']['dinheiro'][query.fragile]/100)
					bonus_exp = bonus_exp + exp_amount*(Config.bonus['fragile']['exp'][query.fragile]/100)
				end
				if data.valuable > 0 then
					bonus = bonus + reward*(Config.bonus['valuable']['dinheiro'][query.valuable]/100)
					bonus_exp = bonus_exp + exp_amount*(Config.bonus['valuable']['exp'][query.valuable]/100)
				end
				if data.fast > 0 then
					bonus = bonus + reward*(Config.bonus['fast']['dinheiro'][query.fast]/100)
					bonus_exp = bonus_exp + exp_amount*(Config.bonus['fast']['exp'][query.fast]/100)
				end
				if distance > Config.habilidade_distancia[0] then
					if Config.bonus['distance']['dinheiro'][query.distance] then
						bonus = bonus + reward*(Config.bonus['distance']['dinheiro'][query.distance]/100)
						bonus_exp = bonus_exp + exp_amount*(Config.bonus['distance']['exp'][query.distance]/100)
					end
				end
		end)
		local received_amount = math.floor((reward+bonus)*trailer_body)
		local received_xp = math.floor((exp_amount+bonus_exp)*trailer_body)

		if truck_data.truck_id then
			local sql = "UPDATE `trucker_trucks` SET engine = @engine, transmission = @transmission, body = @body, wheels = wheels - @wheels WHERE truck_id = @truck_id";
			exports['ghmattimysql']:execute(sql, {['@engine'] = truck_engine, ['@body'] = truck_body, ['@transmission'] = math.floor((truck_engine + truck_body)/2), ['@wheels'] = tonumber(string.format("%.2f", distance))*10, ['@truck_id'] = truck_data.truck_id});
		end
		local sql = "UPDATE `trucker_users` SET total_earned = total_earned + @reward, finished_deliveries = finished_deliveries + 1, traveled_distance = traveled_distance + @distance, exp = exp + @exp_amount WHERE user_id = @user_id";
		exports['ghmattimysql']:execute(sql, {['@reward'] = received_amount, ['@distance'] = tonumber(string.format("%.2f", distance)), ['@exp_amount'] = received_xp, ['@user_id'] = user_id});

		giveTruckerMoney(user_id,received_amount)
		TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['reward']:format(tostring(received_amount),tostring(trailer_body*100),tostring(received_xp)), "success")
		local level2 = getPlayerLevel(user_id)
		if level2 - level > 0 then
			local sql = "UPDATE `trucker_users` SET skill_points = skill_points + @skill WHERE user_id = @user_id";
			exports['ghmattimysql']:execute(sql, {['@skill'] = (level2 - level), ['@user_id'] = user_id});
			SendWebhookMessage(Config.webhook,Lang[Config.lang]['logs_skill']:format((level2 - level),user_id..os.date("\n["..Lang[Config.lang]['logs_date'].."]: %d/%m/%Y ["..Lang[Config.lang]['logs_hour'].."]: %H:%M:%S")))
		end
		SendWebhookMessage(Config.webhook,Lang[Config.lang]['logs_finish']:format(tostring(received_amount),tostring(received_xp),user_id..os.date("\n["..Lang[Config.lang]['logs_date'].."]: %d/%m/%Y ["..Lang[Config.lang]['logs_hour'].."]: %H:%M:%S")))
	end
end)

RegisterServerEvent("truck_logistics:updateTruckStatus")
AddEventHandler("truck_logistics:updateTruckStatus",function(truck_data,truck_engine,truck_body)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		if truck_data.truck_id then
			local sql = "UPDATE `trucker_trucks` SET engine = @engine, transmission = @transmission, body = @body WHERE truck_id = @truck_id";
			exports['ghmattimysql']:execute(sql, {['@engine'] = truck_engine, ['@body'] = truck_body, ['@transmission'] = math.floor((truck_engine + truck_body)/2), ['@truck_id'] = truck_data.truck_id});
		end
	end
end)

RegisterServerEvent("truck_logistics:deleteContract")
AddEventHandler("truck_logistics:deleteContract",function(id)
	local source = source
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local user_id = xPlayer.PlayerData.citizenid
	if user_id then
		local sql = "DELETE FROM `trucker_available_contracts` WHERE contract_id = @id;";
		exports['ghmattimysql']:execute(sql, {['@id'] = id});
		local users = QBCore.Functions.GetPlayers()
		for k,v in pairs(users) do
			if isOpen[v] then
				openUI(v,true)
			end
		end
	end
end)

function giveTruckerMoney(user_id,amount)
	local sql = "UPDATE `trucker_users` SET money = money + @amount WHERE user_id = @user_id";
	exports['ghmattimysql']:execute(sql, {['@amount'] = amount, ['@user_id'] = user_id});
end


function tryGetTruckerMoney(user_id,amount)
	local queryMoney
	local sql = exports['ghmattimysql']:execute("SELECT money FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result)
		queryMoney = result[1]; end)
		Wait(250) -- Esperamos 250ms segundo para que se actualize la variable, si no dara error de nil value
		if tonumber(queryMoney.money) >= amount then
			local sql = "UPDATE `trucker_users` SET money = @amount WHERE user_id = @user_id";
			exports['ghmattimysql']:execute(sql, {['@amount'] = (tonumber(queryMoney.money) - amount), ['@user_id'] = user_id});
			return true
		else
			return false
		end
end

function getMaxEmprestimo(user_id)
	local max_emprestimo = 0;
	local level = getPlayerLevel(user_id)
	for k,v in pairs(Config.max_emprestimo_por_level) do
		if k <= level then
			max_emprestimo = v
		end
	end
	return max_emprestimo
end

function getPlayerLevel(user_id)
	local queryLevel
	local sql = exports['ghmattimysql']:execute("SELECT exp FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function (result)
	queryLevel = result[1]; end)
	Wait(250) -- Esperamos 250ms segundo para que se actualize la variable, si no dara error de nil value
	local level = 0
		if queryLevel then
			for k,v in pairs(Config.exp_por_level) do
				if tonumber(queryLevel.exp) >= v then
					level = k
				else
					return level
				end
			end
		end
	
		return level
	
end

function openUI(source, reset)
	local query = {}
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer then
		local user_id = xPlayer.PlayerData.citizenid
		if user_id then
			-- Busca os dados do usuário
			local sql = "SELECT * FROM `trucker_users` WHERE user_id = '" .. user_id .. "'";
			users_data = exports['ghmattimysql']:execute(sql,{}, function(users_data)
            query.trucker_users = users_data[1] or nil
				if query.trucker_users == nil then
					local sql = "INSERT INTO `trucker_users` (user_id) VALUES (@user_id);";
					exports['ghmattimysql']:execute(sql, {['@user_id'] = user_id});
					local sql2 = exports['ghmattimysql']:execute("SELECT * FROM `trucker_users` WHERE user_id = @user_id", {['@user_id'] = user_id}, function (sql2);
					query.trucker_users = sql2[1];
					end)
				else
					if query.trucker_users.loan_notify == 1 then
						local sql = "UPDATE `trucker_users` SET loan_notify = 0 WHERE user_id = @user_id";
						exports['ghmattimysql']:execute(sql, {['@user_id'] = user_id});
						TriggerClientEvent("QBCore:Notify",source, Lang[Config.lang]['no_loan_money'], "primary")
					end
				end
			end)
			-- Busca os contratos
			local sql = exports['ghmattimysql']:execute("SELECT * FROM `trucker_available_contracts`", function(result)
			query.trucker_available_contracts = result
			
			-- Busca os caminhões
			local sql2 = exports['ghmattimysql']:execute("SELECT * FROM `trucker_trucks` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result2);
			query.trucker_trucks = result2
			
			-- Busca os motoristas
			local sql3 =  exports['ghmattimysql']:execute("SELECT * FROM `trucker_drivers` WHERE user_id = @user_id OR user_id IS NULL", {['@user_id'] = user_id}, function(result3)
			query.trucker_drivers = result3
			
			-- Busca os emprestimos
			local sql4 = exports['ghmattimysql']:execute("SELECT * FROM `trucker_loans` WHERE user_id = @user_id", {['@user_id'] = user_id}, function(result4)
			query.trucker_loans = result4
			
			-- Busca as configs necessárias
			query.config = {}
			query.config.concessionaria = deepcopy(Config.concessionaria)
			query.config.formatacao = deepcopy(Config.formatacao)
			query.config.valor_reparo = deepcopy(Config.valor_reparo)
			query.config.exp_por_level = deepcopy(Config.exp_por_level)
			query.config.max_emprestimo_por_level = deepcopy(Config.max_emprestimo_por_level)
			query.config.emprestimos = deepcopy(Config.emprestimos.valores)
			query.config.cooldown = Config.contratos.cooldown

			-- Busca outras variaveis
			query.config.max_emprestimo = getMaxEmprestimo(user_id)
			query.config.player_level = getPlayerLevel(user_id)

			-- Envia pro front-end
			TriggerClientEvent("truck_logistics:open",source, query, reset)
		end)
	end)
end)
end)
		end
	end
end


RegisterServerEvent("truck_logistics:vehicleLock")
AddEventHandler("truck_logistics:vehicleLock",function()
	local source = source
	TriggerClientEvent("truck_logistics:vehicleClientLock",source)
end)


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end
 
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"
 
    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end
 
        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then
               
                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end
 
                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""
               
                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end
 
                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end
 
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end
 
            cur_index = cur_index + 1
        end
 
        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end
 
    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)
   
    print(output_str)
end