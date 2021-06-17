Config = {}

Config.webhook = "SEU_WEBHOOK"					-- Webhook to send logs to discord
Config.lang = "en"								-- Set the file language [en/br]

Config.formatacao = {
	['moeda'] = 'USD',			-- This is the format of the currency, so that your currency sign appears correctly [Examples: BRL, USD]
	['location'] = 'en-US'		-- This is the location of your country, to format the decimal places according to your standard [Examples: pt-BR, en-US]
}

-- Here are the places where the person can open the trucker menu
-- You can add as many locations as you like, just use the location already created as an example
Config.empresas = {
	["trucker_1"] = {															-- ID
		['nome'] = "Port",														-- Name
		['coordenada'] = {1208.7689208984,-3114.9829101562,5.5403342247009},	-- Coordinate to open the menu
		['coordenada_garagem'] = {												-- Garage coordinates, where the trucks will spawn (coordinates composed of x, y, z, h)
			{1250.55,-3162.4,5.88,270.00},
			{1250.76,-3168.05,5.86,270.00},
			{1245.91,-3135.67,5.62,270.00},
			{1246.07,-3142.42,5.63,270.00},
			{1245.93,-3149.04,5.62,270.00},
			{1245.69,-3155.94,5.6,270.00},
		},
		['coordenada_cargas'] = {												-- Trailer coordinates, where the trailers will spawn (coordinates composed of x, y, z, h)
			{1274.21,-3186.43,5.91,90.00},
			{1272.53,-3097.32,5.91,90.00},
			{1273.55,-3088.39,5.91,90.00},
			{1273.47,-3123.78,5.91,90.00},
			{1272.68,-3159.19,5.91,90.00},
			{1275.37,-3174.52,5.91,90.00},
			{1275.04,-3168.83,5.91,90.00},
		}
	}
}

-- Here is the definition of the contracts that are generated for the players to deliver
Config.contratos = {
	['cancel_contrato'] = 167,					-- Key to cancel the active job (167 = F6) [Hold key 2 seconds]
	['cooldown'] = 1, 							-- Cooldown time (in minutes) to generate a new contract
	['preco_por_km_min'] = 1400,				-- Minimum price per kilometer of the contract
	['preco_por_km_max'] = 2000,				-- Maximum price per kilometer of the contract
	['multiplicador_frete'] = 1.2,				-- Multiplier applied when generating FREIGHT loads
	['probabilidade_ser_carga_urgente'] = 10,	-- The urgent load is generated randomly, here you can configure the probability (%)
	['max_contratos_ativos'] = 60,				-- Maximum of contracts that can be active, this means that when generating a contact that exceeds this number, the oldest contract will be deleted
	['caminhoes'] = {							-- List of trucks that are generated in contracts
		"actros","man","daf","vnl780"
	},
	['cargas'] = {
		--[[ 
			List of loads that are generated in the contracts.
			carga: is the trailer spawn name
			nome: is the name that will appear in the list for the player to select
			def: are the load definitions, to configure if it is an ADR certificate, fragile or valuable load
			Def is composed of 3 values
			def = {
				0, [First value]:  Type of ADR certificate. 0 = None, 1 = Explosives, 2 = Flammable gases, 3 = Flammable liquids, 4 = Flammable solids, 5 = Toxic substances, 6 = Corrosive substances
				0, [Second value]: Fragile load: 0 = Not fragile, 1 = It is fragile
				0  [Third value]:  Valuable cargo: 0 = Not valuable, 1 = It is valuable
			}
		]]
		{ carga = "armytanker", nome = "Army fuel tank", def = {3,0,0}},
		{ carga = "armytanker", nome = "Army water supply", def = {0,0,0}},
		{ carga = "armytanker", nome = "Army Corrosive Materials Tank", def = {6,0,1}},
		{ carga = "armytanker", nome = "Army flammable gas tank", def = {2,0,0}},
		{ carga = "armytanker", nome = "Army toxic gas tank", def = {5,0,0}},
		{ carga = "armytanker", nome = "Army secret materials", def = {0,0,1}},

		{ carga = "liquide1", nome = "Potassium hydroxide", def = {6,0,0}},
		{ carga = "liquide1", nome = "Nitrogen", def = {2,0,1}},
		{ carga = "liquide1", nome = "Potassium chloride", def = {5,0,0}},
		{ carga = "liquide1", nome = "Poison", def = {5,0,0}},
		{ carga = "liquide1", nome = "Pesticide", def = {5,0,0}},

		{ carga = "armytrailer", nome = "empty army trailer", def = {0,0,0}},

		{ carga = "armytrailer2", nome = "Heavy machinery transport", def = {0,1,1}},
		{ carga = "armytrailer2", nome = "Tunneling machine transport", def = {0,1,1}},
		
		{ carga = "docktrailer", nome = "Furniture transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Refrigerator transport", def = {0,1,0}},
		{ carga = "docktrailer", nome = "Brick transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Transport of imported products", def = {0,0,1}},
		{ carga = "docktrailer", nome = "Transport of plastics", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Clothing transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Chair transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Appliance transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Transport of cleaning supplies", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Refined timber transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Stone transport", def = {0,0,0}},
		{ carga = "docktrailer", nome = "Transport of jewels", def = {0,1,1}},
		{ carga = "docktrailer", nome = "Glass transport", def = {0,1,0}},
		{ carga = "docktrailer", nome = "Ammo transport", def = {1,0,0}},
		
		{ carga = "freighttrailer", nome = "Trailer empty", def = {0,0,0}},

		{ carga = "tr2", nome = "Car trailer empty", def = {0,0,0}},
		
		{ carga = "trailers4", nome = "Naval articles trailer", def = {0,0,0}},
		{ carga = "trailers4", nome = "Boat trailer", def = {0,1,1}},
		
		{ carga = "tr4", nome = "Stork", def = {0,1,1}},
		
		{ carga = "tvtrailer", nome = "Transport of materials for shows", def = {0,0,1}},
		{ carga = "tvtrailer", nome = "Transport of event materials", def = {0,1,1}},
		
		{ carga = "tanker", nome = "Fuel tank with additives", def = {3,0,0}},
		{ carga = "tanker2", nome = "Common fuel tank", def = {3,0,0}},
		{ carga = "tanker2", nome = "Kerosene tank", def = {3,0,0}},
		{ carga = "tanker2", nome = "Oil tank", def = {3,0,0}},
		
		{ carga = "docktrailer", nome = "Transport of exotic materials", def = {0,1,1}},
		{ carga = "docktrailer", nome = "Transport of rare materials", def = {0,1,1}},
		{ carga = "docktrailer", nome = "Transport of armaments", def = {0,0,1}},
		
		{ carga = "trailerlogs", nome = "Log transportation", def = {0,0,0}},
		
		{ carga = "trailers", nome = "Transport of construction materials", def = {0,0,0}},
		{ carga = "trailers", nome = "Rubber transport", def = {0,0,0}},
		{ carga = "trailers", nome = "Appliance transportation", def = {0,1,0}},
		{ carga = "trailers", nome = "Transport of vaccines", def = {0,1,0}},
		{ carga = "trailers", nome = "Transport of explosives", def = {1,1,0}},
		{ carga = "trailers", nome = "Sawdust transport", def = {0,0,0}},

		{ carga = "trailers2", nome = "Grape transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Pork transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Transport of beef", def = {0,0,0}},
		{ carga = "trailers2", nome = "Carrot transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Potato transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Milk transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Transport of canned goods", def = {0,0,0}},
		{ carga = "trailers2", nome = "Frozen meat transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Bean transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Vinegar transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Lemonade transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Bottled water transport", def = {0,0,0}},
		{ carga = "trailers2", nome = "Cheese transport", def = {0,0,0}},

		{ carga = "trailers3", nome = "Tile transport", def = {0,0,0}},
		{ carga = "trailers3", nome = "Rail transport", def = {0,0,0}},
		{ carga = "trailers3", nome = "Transport of used packaging", def = {0,0,0}},
		{ carga = "trailers3", nome = "Floor plate transport", def = {0,0,0}},
		{ carga = "trailers3", nome = "Ceramic transport", def = {0,1,0}},
		{ carga = "trailers3", nome = "Scrap transport", def = {0,0,0}},

		{ carga = "trailers4", nome = "Transport of fireworks", def = {1,1,0}},
		{ carga = "trailers4", nome = "Transport of explosives", def = {1,1,0}},
		{ carga = "trailers4", nome = "Dynamite transport", def = {1,1,0}},
		{ carga = "trailers4", nome = "White phosphorus transport", def = {4,1,0}},

		{ carga = "heli1", nome = "Helicopter Transport", def = {0,1,1}},
		{ carga = "militaire1", nome = "Army vehicle transport", def = {0,1,1}},
	}
}

-- Here is the definition of the drivers that are generated for the players to hire
Config.motoristas = {
	['cooldown'] = 60,							-- Cooldown time (in minutes) to generate a new driver
	['preco_por_km_min'] = 500,					-- Minimum starting price per KM of the driver (at the end of each delivery)
	['preco_por_km_max'] = 600,					-- Maximum initial price per KM of the driver (at the end of each delivery)
	['preco_min'] = 10000,						-- Minimum initial price of the driver (at the end of each delivery)
	['preco_max'] = 11000,						-- Maximum initial price of the driver (at the end of each delivery)
	['porcentagem_bonus_habilidades'] = 5,		-- This is the cost in % that each skill will increase in the driver's salary. That is, for each ability he has, the starting price will increase by 5%
	['nomes'] = {
		-- List of drivers that are randomly generated to be hired
		{img = "https://bootdey.com/img/Content/avatar/avatar8.png", nomes = {"Pedro Aquino","Jorge Fernandes","Lucas Silva","Cochran Hicks","Shirley Austin","Grimes Williamson","Kirk Cook","Davis Guerrero","Rocha Good","Hatfield Clarke","Norton Anthony","Parks Dale","Ellison Harrison","Rojas Boyd","Moon Acevedo","Carole Rivas","Wells Wyatt","Beasley Griffith","Jordan Hyde","Holman Dixon","Holden Lynch","Mckenzie Wilkerson","Chapman Preston","Christian Green","Blake Stuart","Paulette Atkinson","Dollie Lane","Castaneda Browning","Baldwin Blankenship","Russell Bowen","Madge Boyle","Nanette Cummings","Brooke Spence","Whitfield Berg","Angie Gonzales","Johanna Mercer","Terrell Mcmillan","Gilmore Quinn","Kenya Pittman","Hurley Black","Shanna Ortega","Logan Sharpe","Mari Brady","Mendoza Wilkinson","Stacie Sanford","Polly Acosta","Stone Robinson","Claudette Bartlett","Young Hines","Potter Wagner","Reilly Callahan","Kerr Kemp","Goff Raymond"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar7.png", nomes = {"Ivan Noleto Sequeira","Kim Wolfe","Laura Logan","Bruce Craft","Compton Luna","Randolph Callahan","Mccray Brock","Sybil Miles","Hendricks Henry","Tina Compton","Phelps Hunter","Jones Russo","Esmeralda Banks","Reid Dean","Parrish Cole","Carlson Gilbert","Jackie Macias","Liza Morse","Mclean Warner","Winnie Lopez","Katheryn Valenzuela","Wade Mccoy","Acosta Mays","Valeria Witt","Elnora Howard","Bernadette Dawson","Rivera Casey","Little Sanford","Deanna Petty","Leonard Blackwell","Payne Leblanc","Tammy Murphy","Sargent Donaldson","Colon Carey","Janis Roth","Lidia Higgins","Lakisha Whitaker","Adrian Mcbride","Maria Forbes","Daisy Mason","Pittman Curtis","Ladonna Bryan","Gaines Hogan","Powers Rodriquez","Donna Hopper","Kristi Livingston","Chelsea Bauer","Gray Fleming","Contreras Mcdonald","Vilma Potts","Guadalupe Mullins"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar6.png", nomes = {"Kenya Mullen","Castaneda Colon","Judy Mckay","Taylor Kerr","Hurst Roy","Owens Vaughan","Vanessa Cline","Bertie Edwards","Flynn Frank","Burks Sutton","Randi Meadows","Tessa Gentry","Lowery Wooten","Acosta Harper","Georgette Cooley","Candice Patterson","Kirsten Daniels","Blake West","Alexandria Pope","Lena Forbes","Morton Snyder","Tara Bradford","Selena Sykes","Tameka Atkinson","Fowler Walker","Gena Ortega","Sheppard Navarro","Imelda Duncan","Christina Bowers","Aline Haynes","Benita Bright","Boyd Mccall","Sandra Weaver","Melissa Wells","Graham Gilmore","Katrina Oliver","Ginger Larson","Griffith Bishop","Barbara Washington","Iris Christensen","Bauer Gay","Hays Vega","Valarie Booth","Kitty Crane","Carmella Torres","Angelina Puckett","Stone Cabrera","Brock Humphrey","Hillary Houston","Callie Robles"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar5.png", nomes = {"Rocha Harrell","Gilliam Thomas","Osborne Blevins","Elba Chambers","Heath Price","Melinda Maynard","Ashlee Johns","Shelton Petty","Carey Mcclain","Blackwell Horne","Deborah Gonzalez","Buck Faulkner","Celina Chang","Kennedy Patrick","Atkinson Sherman","Janelle Tyson","Noelle Vincent","Leah Barron","Angeline Sellers","Trudy Murray","Contreras Hardy","Fletcher Todd","Benson Singleton","Sanford Dean","Hartman Wilkinson","Harriet Robinson","Vivian Osborn","Ida Simmons","Tamara Merrill","Esmeralda Baird","Maynard Oneal","Brianna Greene","Pat Stewart","Tate Wood","French Farrell","Jolene Calderon","Irene Roth","Dina Waller","Gonzalez Alvarez","Leigh Durham","Eve Moody","Lydia Hewitt","Price Summers","Duran Schultz","Rena Williamson","Meagan Shaffer","Angelique Dennis","Graham Love","Sheree Lynn","Church Golden"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar4.png", nomes = {"Cecelia Carson","Rivas Kelly","Green Johnson","Jill Buck","Maddox Leblanc","Hope Aguirre","Aguilar Diaz","Valerie Wiggins","Crystal Sweeney","Sharlene Davidson","Ruthie Valdez","Allyson Haney","Bridgett Wright","Cooke Vargas","Hopkins Neal","Deloris Curry","Alba Warren","Lynette Preston","Candace Britt","Phyllis Mayer","Bailey Stephenson","Meredith Harrell","Conner Heath","Kelly Lynch","Kelli Salinas","Tamara Tran","Boone Sosa","Cora Barrera","John Francis","Tammi Parsons","Natalie Travis","Ivy Mccoy","William Nash","Reba Dillon","Kimberley Whitney","Karen Ellis","Alison Padilla","Spencer Camacho","Blackwell Mccray","Mcgowan Castaneda","Kent Thomas","Lauri Wiley","Atkins Lowery","Janell Hancock","Mosley Carney","Mason Clay","Pat Mercer","Frances Oneal","Brandy Strong","Elvira Houston"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar3.png", nomes = {"Joice Campos","Mélanie Rebotim","Berenice Holanda","Maitê Lage","Eduarda Barbosa","Livia Martins","Melissa Fernandes","Isabela Castro","Leila Fernandes","Letícia Correia","Melissa Cunha","Gabriela Azevedo"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar2.png", nomes = {"Howell Dickerson","Carlson Kerr","Kitty Moody","Malinda Richards","Craig Watts","Alana Ratliff","Mindy Patton","Kelly Stone","Beasley Stark","Perez Mercer","Janell Norris","Angela Mayer","Opal Orr","Charity Lamb","Ford Castaneda","Mitzi Nelson","Corrine Morris","Nanette Cervantes","Evelyn Burton","Giles Fletcher","Franklin Hahn","Ruiz Simmons","Selena Murphy","Mccoy Clarke","Skinner Sanford","Lea Oneill","Williamson Rosales","Katharine Hendricks","Dillon Nguyen","Cannon Fulton","Sharp Mccray","Billie Schultz","Flora Griffith","Russell Beasley","Sampson Forbes","Duran Moore","Leach Todd","Henrietta Bowman","Margie Solomon","Mcdonald Collins","Willis Pratt","Britney Dixon","Mcleod Mejia","Salinas Albert","Padilla Lynn","Natalia Garrett","Lynnette Savage","Fleming Keith","Johnston Carrillo","Whitney Gomez"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar1.png", nomes = {"Bennett Stevens","Mcmillan Calhoun","Paula Blanchard","Roberson Holman","Frost Woods","Drake Boyd","Maricela Long","Hess Guerrero","Martha Adams","Simmons Ramsey","Medina Pitts","Hazel Tyson","Mia Nguyen","Clare Shannon","Kristy Dorsey","Hilda Cochran","Sandy Zimmerman","Petra Lowery","Opal Collier","Velez Terry","Mccormick Hewitt","Weeks Garner","Ashley Byers","Guzman Blackburn","Ramona Stanley","Delia Ratliff","Talley Rodriquez","Ochoa Hayden","Thelma Stout","Lloyd Clarke","Gordon Gould","Aida Noel","Corinne Richmond","Malone Walls","Shields Bowen","Howell Harper","Figueroa Schwartz","Rachel Delgado","Debora Chaney","Chen Avery","Kidd Fitzgerald","Aguirre Park","Combs Cruz","Huff Thompson","Munoz Crosby","Whitaker Mason","Oneil York","Francis Houston","Prince White","Cornelia Bell"}}
	},
	['max_motoristas_ativos'] = 20,				-- Maximum number of drivers that can be active, this means that when generating a driver that exceeds this number, the oldest driver will be deleted
	['max_motoristas_por_player'] = 5			-- Maximum number of drivers the player can hire
}

-- Here is the definition of the contracts that are generated for drivers to carry out
Config.trabalhos = {
	['cooldown'] = 30,						-- Cooldown time (in minutes) for drivers to make contracts and generate money for the company

	-- It is recommended to keep the initial profit and the percentage higher than the values ​​configured for drivers in the above config
	['valor_inicial_min'] = 10000,			-- Minimum initial contract profit
	['valor_inicial_max'] = 12000,			-- Maximum initial contract profit
	['porcentagem_bonus_habilidades'] = 7,	-- Percentage that will be generated from profit for each skill that the driver has
	['gera_dinheiro_offline'] = false 		-- true: drivers will generate money all the time / false: drivers will generate money only if the owner is online
}

Config.multiplicador_venda = 0.7	-- Value you receive when selling the used truck
Config.concessionaria = {			-- Truck dealership vehicles
	-- Here you can configure the vehicles of the dealership
	['actros'] = { 								-- This must be the vehicle's spawn name
		['name'] = 'Mercedes-Benz Actros',		-- Truck name
		['price'] = 310000,						-- Value
		['engine'] = "12.0 L MB OM 457 LA I6",	-- Engine configuration
		['transmission'] = "12-Speed",			-- Transmission configuration
		['hp'] = '450',							-- Horsepower
		['img'] = 'img/actros.jpg'				-- Vehicle image
	},
	-- The other vehicles follow the same pattern as the vehicle above
	['man'] = {
		['name'] = 'MAN TGX',
		['price'] = 270000,
		['engine'] = "16.2 L D2868 V8",
		['transmission'] = "12-Speed",
		['hp'] = '401',
		['img'] = 'img/man.jpg'
	},
	['daf'] = {
		['name'] = 'DAF XF Euro 6',
		['price'] = 330000,
		['engine'] = "12.9 PACCAR MX-13 I6",
		['transmission'] = "12-Speed",
		['hp'] = '480',
		['img'] = 'img/daf.jpg'
	},
	['t680'] = {
		['name'] = 'Kenworth T680',
		['price'] = 600000,
		['engine'] = "12.9 PACCAR MX-13 I6",
		['transmission'] = "10-Speed",
		['hp'] = '550',
		['img'] = 'img/t680.jpg'
	},
	['w900'] = {
		['name'] = 'Kenworth W900 6x2',
		['price'] = 650000,
		['engine'] = "15.0 Cummins ISX I6",
		['transmission'] = "18-Speed",
		['hp'] = '590',
		['img'] = 'img/w900.jpg'
	},
	['vnl780'] = {
		['name'] = 'Volvo VNL 780',
		['price'] = 500000,
		['engine'] = "13.0 D13TC I6",
		['transmission'] = "12-Speed",
		['hp'] = '535',
		['img'] = 'img/vnl780.jpg'
	}
}
Config.valor_reparo = { -- Value to repair 1% of each part (Example: if 40% of the part is damaged, the value to repair will be multiplied by 40)
	['engine'] = 250,
	['body'] = 150,
	['transmission'] = 200,
	['wheels'] = 100
}

--[[
	Amount of exp you need to reach each level
	Example:
	[1] = 100,
	[2] = 200,
	This means that to reach level 1 you need 100 EXP, to reach level 2 you need 200 EXP
	When leveling up, the player receives 1 skill point
	Level 30 is the maximum
]]
Config.exp_por_level = {
	[1] = 1000,
	[2] = 2000,
	[3] = 3000,
	[4] = 4000,
	[5] = 5000,
	[6] = 6000,
	[7] = 7000,
	[8] = 8000,
	[9] = 9000,
	[10] = 10000,
	[11] = 11000,
	[12] = 12000,
	[13] = 13000,
	[14] = 14000,
	[15] = 16000,
	[16] = 18000,
	[17] = 20000,
	[18] = 22000,
	[19] = 24000,
	[20] = 26000,
	[21] = 28000,
	[22] = 30000,
	[23] = 35000,
	[24] = 40000,
	[25] = 45000,
	[26] = 50000,
	[27] = 55000,
	[28] = 60000,
	[29] = 65000,
	[30] = 100000 -- Max
}

--[[
	Maximum loan amount a person can take per level (the higher the level, the bigger the loan)
	Example:
	[0] = 20000,
	[10] = 50000,
	[20] = 200000
	This means that at level 0 to level 10, you can get a loan of 20 thousand. From level 10 to 20, you can take a maximum of 50 thousand ....
]]
Config.max_emprestimo_por_level = {
	[0] = 40000,
	[10] = 100000,
	[20] = 250000,
	[30] = 600000
}

-- Loan amounts and amount that is charged per day
Config.emprestimos = {
	['cooldown'] = 86400, -- Time (in seconds) that the loan will be charged to the player (86400 = 24 hours)
	['valores'] = {
		--[[
			It is possible to configure 4 loan values ​​and each loan has its own settings
			Example:
			[1] = {
				20000,	[Loan amount]: 20,000
				240, 	[Amount that the player pays each day]: This amount must be greater than the amount below, so in this case, when finalizing the payment of all installments, the player will pay 24 thousand (4 thousand of interest)
				200 	[Base amount to calculate interest]: The above value subtracted from this (240 - 200) will be the amount of interest: 40 interest per day
			},
		]]
		[1] = {20000,400,200},
		[2] = {50000,950,500},
		[3] = {100000,1800,1000},
		[4] = {400000,7000,4000}
	}
}

--[[
	Skill level and kms you can travel at each level
	Example:
	[0] = 4,
	[1] = 5,
	This means that at level 0 the player can initiate contracts of a maximum of 4 km, at level 1, he can take contracts of 5 km
	Level 6 is the maximum
]]
Config.habilidade_distancia = {
	[0] = 6,
	[1] = 6.5,
	[2] = 7,
	[3] = 7.5,
	[4] = 8,
	[5] = 8.5,
	[6] = 99 -- Max
}

--[[
	EXP gain in %
	XP is calculated based on the value of the delivery, so if he receive 1000 in one delivery, he will earn 50 XP
	This XP will be increased based on the bonuses configured below
]]
Config.exp = 1

-- EXP bonuses and money each skill gives
Config.bonus = {
	-- This bonus will be applied according to the level and requirements of the load. Then, when transporting a fragile cargo, he will receive the fragile cargo bonus (these values ​​are in%)
	['distance'] = {
		['dinheiro'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp'] = {
			[1] = 5,
			[2] = 5,
			[3] = 5,
			[4] = 5,
			[5] = 5,
			[6] = 5
		}
	},
	['valuable'] = {
		['dinheiro'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fragile'] = {
		['dinheiro'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fast'] = {
		['dinheiro'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	}
}

-- Cargo delivery locations
Config.locais_entrega = {
	{-758.14,5540.96,33.49,110.53},
	{-3046.19,143.27,11.6,11.14},
	{-1153.01,2672.99,18.1,312.25},
	{622.67,110.27,92.59,340.75},
	{-574.62,-1147.27,22.18,177.7},
	{376.31,2638.97,44.5,286.38},
	{1738.32,3283.89,41.13,16.24},
	{1419.98,3618.63,34.91,195.33},
	{1452.67,6552.02,14.89,138.69},
	{3472.4,3681.97,33.79,76.44},
	{2485.73,4116.13,38.07,66.71},
	{65.02,6345.89,31.22,206.64},
	{-303.28,6118.17,31.5,135.24},
	{-63.41,-2015.25,18.02,299.48},
	{-46.35,-2112.38,16.71,290.84},
	{-746.6,-1496.67,5.01,28.08},
	{369.54,272.07,103.11,247.94},
	{907.61,-44.12,78.77,323.08},
	{-1517.31,-428.29,35.45,55.77},
	{235.04,-1520.18,29.15,316.76},
	{34.8,-1730.13,29.31,226.06},
	{350.4,-2466.9,6.4,169.38},
	{1213.97,-1229.01,35.35,270.74},
	{1395.7,-2061.38,52.0,135.81},
	{729.09,-2023.63,29.31,268.75},
	{840.72,-1952.59,28.85,81.46},
	{551.76,-1840.26,25.34,40.72},
	{723.78,-1372.08,26.29,106.65},
	{-339.92,-1284.25,31.32,89.06},
	{1137.23,-1285.05,34.6,189.65},
	{466.93,-1231.55,29.95,267.14},
	{442.28,-584.28,28.5,252.12},
	{1560.52,888.69,77.46,19.02},
	{2561.78,426.67,108.46,301.57},
	{569.21,2730.83,42.07,91.35},
	{2665.4,1700.63,24.49,269.33},
	{1120.1,2652.5,38.0,181.77},
	{2004.23,3071.87,47.06,237.58},
	{2038.78,3175.7,45.09,140.47},
	{1635.54,3562.84,35.23,296.61},
	{2744.55,3412.43,56.57,247.48},
	{1972.17,3839.16,32.0,304.36},
	{1980.59,3754.65,32.18,211.64},
	{1716.0,4706.41,42.69,91.44},
	{1691.36,4918.42,42.08,57.29},
	{1970.3,5177.39,47.83,318.89},
	{1908.78,4932.06,48.97,340.08},
	{140.79,-1077.85,29.2,262.4},
	{-323.98,-1522.86,27.55,258.59},
	{-1060.53,-221.7,37.84,299.01},
	{2471.47,4463.07,35.3,277.56},
	{2699.47,3444.81,55.8,153.49},
	{-1060.53,-221.7,37.84,299.01},
	{2655.38,3281.01,55.24,63.99},
	{2730.39,2778.2,36.01,134.51},
	{-2966.68,363.37,14.77,359.8},
	{2788.89,2816.49,41.72,296.22},
	{-604.45,-1212.24,14.95,227.43},
	{2534.83,2589.08,37.95,2.48},
	{-143.31,205.88,92.12,86.41},
	{2347.04,2633.25,46.67,30.15},
	{860.47,-896.87,25.53,181.8},
	{973.34,-1038.19,40.84,272.3},
	{-409.04,1200.44,325.65,164.59},
	{-1617.77,3068.17,32.27,94.64},
	{-71.8,-1089.98,26.56,339.06},
	{-409.04,1200.44,325.65,164.59},
	{-1617.77,3068.17,32.27,94.64},
	{1246.34,1860.78,79.47,315.78},
	{-1777.63,3082.36,32.81,236.17},
	{-1775.87,3088.13,32.81,239.97},
	{-1827.5,2934.11,32.82,59.53},
	{-2123.69,3270.14,32.82,145.14},
	{-2444.59,2981.63,32.82,283.55},
	{-2448.59,2962.8,32.82,333.19},
	{-2277.86,3176.57,32.81,236.61},
	{-2969.0,366.46,14.77,292.99},
	{-1637.61,-814.53,10.17,139.15},
	{-1494.72,-891.67,10.11,73.06},
	{-902.27,-1528.42,5.03,106.23},
	{-1173.93,-1749.87,3.97,211.53},
	{-1087.8,-2047.55,13.23,314.93},
	{-1133.74,-2035.99,13.21,314.41},
	{-1234.4,-2092.3,13.93,173.93},
	{-1025.97,-2223.62,8.99,224.96},
	{850.42,2197.69,51.93,243.19},
	{42.61,2803.45,57.88,145.49},
	{-1193.54,-2155.4,13.2,138.82},
	{-1184.37,-2185.67,13.2,336.13},
	{2041.76,3172.26,44.98,155.2},
	{-465.48,-2169.09,10.01,9.47},
	{-3150.77,1086.55,20.7,339.24},
	{-433.69,-2277.29,7.61,268.97},
	{-395.18,-2182.97,10.29,94.54},
	{-3029.7,591.68,7.79,199.33},
	{-3029.7,591.68,7.79,199.33},
	{-1007.29,-3021.72,13.95,65.31},
	{-61.32,-1832.75,26.8,227.87},
	{822.72,-2134.28,29.29,349.36},
	{942.22,-2487.76,28.34,89.41},
	{729.29,-2086.53,29.3,89.29},
	{783.08,-2523.98,20.51,5.67},
	{717.8,-2111.18,29.22,272.62},
	{787.05,-1612.38,31.17,48.33},
	{913.52,-1556.87,30.74,272.14},
	{777.64,-2529.46,20.13,96.09},
	{846.71,-2496.12,28.34,81.07},
	{711.79,-1395.19,26.35,103.31},
	{723.38,-1286.3,26.3,90.13},
	{983.0,-1230.77,25.38,121.4},
	{818.01,-2422.85,23.6,174.28},
	{885.53,-1166.38,24.99,94.77},
	{700.85,-1106.93,22.47,163.11},
	{882.26,-2384.1,28.0,179.16},
	{1003.55,-1860.27,30.89,268.33},
	{-1138.73,-759.77,18.87,234.36},
	{938.71,-1154.36,25.38,178.46},
	{973.0,-1156.18,25.43,267.36},
	{689.41,-963.48,23.49,178.61},
	{140.72,-375.29,43.26,336.19},
	{-497.09,-62.13,39.96,353.27},
	{-606.34,187.43,70.01,270.65},
	{117.12,-356.15,42.59,252.09},
	{53.91,-1571.07,29.47,137.1},
	
	{1528.1,1719.32,109.97,34.6},
	{1411.29,1060.33,114.34,269.14},
	{1145.76,-287.73,68.96,284.29},
	{1117.71,-488.25,65.25,166.07},
	{874.28,-949.16,26.29,358.46},
	{829.28,-874.08,25.26,270.18},
	{725.37,-874.53,24.67,265.96},
	{693.66,-1090.43,22.45,174.62},
	{977.51,-1013.67,41.32,270.83},
	{901.89,-1129.9,24.08,86.26},
	{911.7,-1258.04,25.58,33.69},
	{847.06,-1397.72,26.14,151.79},
	{830.67,-1409.13,26.16,334.64},
	{130.47,-1066.12,29.2,160.09},
	{-52.79,-1078.65,26.93,67.2},
	{-131.74,-1097.38,21.69,335.25},
	{-621.47,-1106.05,22.18,1.07},
	{-668.65,-1182.07,10.62,208.79},
	{-111.84,-956.71,27.27,339.83},
	{-1323.51,-1165.11,4.73,359.27},
	{-1314.65,-1254.96,4.58,19.95},
	{-1169.18,-1768.78,3.87,306.82},
	{-1343.38,-744.02,22.28,309.26},
	{-1532.84,-578.16,33.63,304.2},
	{-1461.4,-362.39,43.89,219.06},
	{-1457.25,-384.15,38.51,114.12},
	{-1544.42,-411.45,41.99,226.04},
	{-1432.72,-250.32,46.37,130.83},
	{-1040.24,-499.88,36.07,118.78},
	{346.43,-1107.19,29.41,177.11},
	{523.99,-2112.7,5.99,182.08},
	{977.19,-2539.34,28.31,353.75,357.42},
	{1101.01,-2405.39,30.76,259.61},
	{1591.9,-1714.0,88.16,120.75},
	{1693.41,-1497.45,113.05,66.92},
	{1029.44,-2501.31,28.43,149.34},
	{2492.55,-320.89,93.0,82.83},
	{2846.31,1463.1,24.56,74.93},
	{3631.05,3768.61,28.52,320.0},
	{3572.5,3665.53,33.9,75.93},
	{2919.03,4337.85,50.31,203.77},
	{2521.47,4203.47,39.95,327.93},
	{2926.2,4627.28,48.55,143.26},
	{3808.59,4463.22,4.37,87.61},
	{3323.71,5161.1,18.4,147.02},
	{2133.06,4789.57,40.98,26.62},
	{1900.83,4913.82,48.87,154.21},
	{381.06,3591.37,33.3,82.49},
	{642.8,3502.47,34.09,95.04},
	{277.33,2884.71,43.61,296.91},
	{-60.3,1961.45,190.19,294.86},
	{225.63,1244.33,225.46,194.24},
	{-1136.15,4925.14,220.01,262.73},
	{-519.96,5243.84,79.95,72.76},
	{-602.87,5326.63,70.46,168.65},
	{-797.95,5400.61,34.24,86.78},
	{-776.0,5579.11,33.49,167.58},
	{-704.2,5772.55,17.34,68.44},
	{-299.24,6300.27,31.5,134.2},
	{402.52,6619.61,28.26,357.71},
	{-247.72,6205.46,31.49,45.5},
	{-267.5,6043.45,31.78,50.59},
	{-16.29,6452.44,31.4,226.65},
	{2204.73,5574.04,53.74,351.31},
	{1638.98,4840.41,42.03,185.92},
	{1961.26,4640.93,40.71,293.6},
	{1776.61,4584.67,37.65,181.45},
	{137.29,281.73,109.98,335.6},
	{607.49,165.2,98.24,341.06},
	{199.8,2788.78,45.66,276.37},
	{708.58,-295.1,59.19,277.93},
	{581.28,2799.43,42.1,1.52},
	{1296.73,1424.35,100.45,178.89},
	{955.85,-22.89,78.77,147.51}
}

Config.blips = {
	{1208.7109375,-3114.9431152344,5.7480750083923,478,4,"Trucker Logistics",0.5 },
}