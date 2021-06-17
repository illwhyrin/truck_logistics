window.addEventListener('message', function (event) {
	var item = event.data;
	var list_item = '';
	if (item.showmenu){
		var config = item.dados.config;
		var contracts = item.dados.trucker_available_contracts;
		var users = item.dados.trucker_users;
		var myTrucks = item.dados.trucker_trucks;
		var drivers = item.dados.trucker_drivers;
		var loans = item.dados.trucker_loans;
		if(item.update != true){
			$(".pages").css("display", "none");
			$("body").css("display", "");
			$(".main-page").css("display", "block");
			$('.sidebar-navigation ul li').removeClass('active');
			$('#sidebar-1').addClass('active');
			openPage(0);
		}

		$('#new-contracts-1').empty();
		$('#new-contracts-1').append('New contracts each ' + (config.cooldown*2) + ' min');
		$('#new-contracts-2').empty();
		$('#new-contracts-2').append('New contracts each ' + (config.cooldown*2) + ' min');
		
		$('#profile-money').empty();
		$('#profile-money').append(new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.money));
		$('#bank-money').empty();
		$('#bank-money').append(new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.money));
		
		$('#profile-money-earned').empty();
		$('#profile-money-earned').append(new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.total_earned));
		$('#profile-deliveries').empty();
		$('#profile-deliveries').append(users.finished_deliveries);
		$('#profile-exp-1').empty();
		$('#profile-exp-1').append(users.exp);
		$('#profile-exp-2').empty();
		var exp_r = 0
		if (users.exp >= config.exp_por_level[config.exp_por_level.length-1]){
			exp_r = 100;
		}else if (config.player_level == 0) {
			max = config.exp_por_level[config.player_level]
			exp = users.exp
			exp_r = Math.round((exp*100)/max);
		}else{
			for (const key in config.exp_por_level) {
				if(users.exp < config.exp_por_level[key]){
					max = config.exp_por_level[key] - config.exp_por_level[key-1]
					exp = users.exp - config.exp_por_level[key-1]
					exp_r = Math.round((exp*100)/max);
					if(exp_r >= 0){
						break;
					}
				}
			}
		}
		$('#profile-exp-2').append('<div class="progress-bar bg-amber accent-4" role="progressbar" style="width: ' + exp_r + '%" aria-valuenow="' + exp_r + '" aria-valuemin="0" aria-valuemax="100"></div>');
		$('#profile-distance-traveled').empty();
		$('#profile-distance-traveled').append(users.traveled_distance.toFixed(2) + 'km');
		$('#profile-skill-points').empty();
		$('#profile-skill-points').append(users.skill_points);
		$('#profile-trucks').empty();
		$('#profile-trucks').append(myTrucks.length);
		$('#profile-drivers').empty();
		var drivers_count = 0;
		for (const driver of drivers) {
			if(driver.user_id != null && driver.user_id != undefined){
				drivers_count++;
			}
		}
		$('#profile-drivers').append(drivers_count);
		
		

		$('#job-page-list').empty();
		$('#freight-page-list').empty();
		for (const contract of contracts) {
			list_item = `
			<ul class="list list-inline">
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><i class="fa fa-check-circle checkicon"></i>
						<div class="ml-2">
							<h6 class="mb-0">` + contract.contract_name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div><i class="fas fa-route"></i><span class="ml-2">Distance: ` + contract.distance + `km</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i><span class="ml-2">Reward: ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(contract.reward) + `</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<div class="d-flex flex-column mr-2">
							<div class="profile-image">
							`;
			if(contract.cargo_type == 1) {
				list_item += '<div data-tooltip="Explosives"><img class="rounded-circle" src="img/explosive-1.png" width="30"></div>';
			}else if(contract.cargo_type == 2) {
				list_item += '<div data-tooltip="Flammable Gases"><img class="rounded-circle" src="img/flamable-2.png" width="30"></div>';
			}else if(contract.cargo_type == 3) {
				list_item += '<div data-tooltip="Flammable liquids"><img class="rounded-circle" src="img/flamable-3.png" width="30"></div>';
			}else if(contract.cargo_type == 4) {
				list_item += '<div data-tooltip="Flammable solids"><img class="rounded-circle" src="img/flamable-4.png" width="30"></div>';
			}else if(contract.cargo_type == 5) {
				list_item += '<div data-tooltip="Toxic Substances"><img class="rounded-circle" src="img/toxic-6.png" width="30"></div>';
			}else if(contract.cargo_type == 6) {
				list_item += '<div data-tooltip="Corrosive substances"><img class="rounded-circle" src="img/corrosive-8.png" width="30"></div>';
			}
			if(contract.fragile == 1) {
				list_item += '<div data-tooltip="Fragile cargo"><img class="rounded-circle" src="img/fragile.png" width="30"></div>';
			}
			if(contract.valuable == 1) {
				list_item += '<div data-tooltip="Valuable cargo"><img class="rounded-circle" src="img/valuable.png" width="30"></div>';
			}
			if(contract.fast == 1) {
				list_item += '<div data-tooltip="Urgent cargo"><img class="rounded-circle" src="img/fast.png" width="30"></div>';
			}
			list_item += `
							</div>
						</div>
						<button onclick="startJob(` + contract.contract_id + `,` + contract.reward + `,` + contract.distance + `)" class="btn btn-blue btn-darken-2 white">Start Job</button>
					</div>
				</li>
			</ul>
			`;
			if(contract.contract_type == 0) {
				$('#job-page-list').append(list_item);
			}else{
				$('#freight-page-list').append(list_item);
			}
		}
		
		$('#skills-desc').empty();
		$('#skills-desc').append("Upgrade your skills to get better jobs (Skill points avaliable: " + users.skill_points + ")");
		setSkill('distance',users.distance);
		setSkill('product_type',users.product_type);
		setSkill('valuable',users.valuable);
		setSkill('fragile',users.fragile);
		setSkill('fast',users.fast);

		$('#dealership-page-list').empty();
		list_item = `
			<div class="col-12 mt-3 mb-1">
				<h4 class="text-uppercase">Dealership</h4>
				<p>Buy more trucks to you and your drivers</p>
			</div>`;

		for (const key in config.concessionaria) {
			truck = config.concessionaria[key];
			list_item += `
				<div class="card"> <img src="` + truck.img + `" class="card-img-top" width="100%">
					<div class="card-body pt-0 px-0">
						<div class="d-flex flex-row justify-content-between mb-0 mt-3 px-3"> <span class="text-muted">Truck</span>
							<h6>` + truck.name + `</h6>
						</div>
						<hr class="mt-2 mx-3">
						<div class="d-flex flex-row justify-content-between px-3 pb-4">
							<div class="d-flex flex-column"><span class="text-muted">Price</span></div>
							<div class="d-flex flex-column">
								<h5 class="mb-0">` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(truck.price) + `</h5>
							</div>
						</div>
						<div class="d-flex flex-row justify-content-between p-3 mid">
							<div class="d-flex flex-column"><small class="text-muted mb-1">ENGINE</small>
								<div class="d-flex flex-row"><img src="img/engine_icon.jpg" width="35px" height="25px">
									<div class="d-flex flex-column ml-1"><small class="ghj">` + truck.engine + `</small><small class="ghj">` + truck.transmission + `</small></div>
								</div>
							</div>
							<div class="d-flex flex-column"><small class="text-muted mb-2">HORSEPOWER</small>
								<div class="d-flex flex-row"><img src="img/power_icon.jpg">
									<h6 class="ml-1">` + truck.hp + ` hp</h6>
								</div>
							</div>
						</div>
						<div class="mx-3 mt-3 mb-2"><button onclick="buyTruck('` + key + `','` + truck.price + `')" type="button" class="btn btn-blue btn-darken-2 white btn-block"><small>BUY</small></button></div> <small class="d-flex justify-content-center text-muted">*Legal Disclaimer</small>
					</div>
				</div>
				`;
		}
		$('#dealership-page-list').append(list_item);

		$('#trucks-page-list').empty();
		$('#truck-name').empty();
		list_item = "";
		for (const truck of myTrucks) {
			truck.body = truck.body/10;
			truck.engine = truck.engine/10;
			truck.transmission = truck.transmission/10;
			truck.wheels = truck.wheels/10;
			if(truck.driver == 0){
				$('#truck-name').append('('+config.concessionaria[truck.truck_name].name+')');
				var color = "";
				
				if (truck.body > 80) {
					color = "success";
				}else if(truck.body > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-body').empty();
				$('#diagnostic-body').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.body + ` %</h3><span>Fix Body (` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format((100-truck.body)*config.valor_reparo.body) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.body + `%" aria-valuenow="` + truck.body + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.engine > 80) {
					color = "success";
				}else if(truck.engine > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-engine').empty();
				$('#diagnostic-engine').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.engine + ` %</h3><span>Fix Engine (` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format((100-truck.engine)*config.valor_reparo.engine) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.engine + `%" aria-valuenow="` + truck.engine + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.transmission > 80) {
					color = "success";
				}else if(truck.transmission > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-transmission').empty();
				$('#diagnostic-transmission').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.transmission + ` %</h3><span>Fix Transmission (` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format((100-truck.transmission)*config.valor_reparo.transmission) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.transmission + `%" aria-valuenow="` + truck.transmission + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.wheels > 80) {
					color = "success";
				}else if(truck.wheels > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-wheels').empty();
				$('#diagnostic-wheels').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.wheels + ` %</h3><span>Fix Wheels (` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format((100-truck.wheels)*config.valor_reparo.wheels) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.wheels + `%" aria-valuenow="` + truck.wheels + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
			}
			list_item += `
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><img src="` + config.concessionaria[truck.truck_name].img + `" class="img-radius img-width" alt="User-Profile-Image">
						<div class="ml-2">
							<h6 class="mb-0">` + config.concessionaria[truck.truck_name].name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div>
									<i class="fas fa-tools"></i><span class="ml-2">Body: ` + truck.body + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">Engine: ` + truck.engine + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">Transmission: ` + truck.transmission + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">Wheels: ` + truck.wheels + `%</span>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						` + getMyTruckHTML(truck) + `
						<button onclick="sellTruck('` + truck.truck_id + `','` + truck.truck_name + `')" class="btn btn-red btn-accent-4 white">Sell Truck</button>
					</div>
				</li>
				`;
		}
		$('#trucks-page-list').append(list_item);

		$('#recruitment-page-list').empty();
		$('#drivers-page-list').empty();
		list_item = `
			<div class="col-12 mt-3 mb-1">
				<h4 class="text-uppercase">Recruitment Agency</h4>
				<p>Recruit new drivers to work for your company</p>
			</div>
			`;
		for (const driver of drivers) {
			if (driver.user_id == null || driver.user_id == undefined){
				list_item += `
					<div class="card user-card">
						<div class="card-block">
							<div class="user-image">
								<img src="` + driver.img + `" class="img-radius" alt="User-Profile-Image">
							</div>
							<h6 class="m-t-25 m-b-10">` + driver.name + `</h6>
							<p class="text-muted">Price: ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(driver.price) + ` + ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(driver.price_per_km) + `/km</p>
							<hr>
							<p class="text-muted">Product Type</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.product_type) + `
							</ul>
							<p class="text-muted">Distance</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.distance) + `
							</ul>
							<p class="text-muted">Valuable Cargo</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.valuable) + `
							</ul>
							<p class="text-muted">Fragile Cargo</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fragile) + `
							</ul>
							<p class="text-muted">On-time delivery</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fast) + `
							</ul>
							<div onclick="hireDriver('` + driver.driver_id + `')" class="mx-3 mt-3 mb-2"><button type="button" class="btn btn-blue btn-darken-2 white btn-block"><small>HIRE</small></button></div>
						</div>
					</div>
					`;
			}else{
				$('#drivers-page-list').append(`
					<li class="d-flex justify-content-between">
						<div class="d-flex flex-row align-items-center">
							<img src="` + driver.img + `" class="img-radius img-width" alt="User-Profile-Image">
							<div class="ml-2">
								<h6 class="mb-0">` + driver.name + `</h6>
								<div class="d-flex flex-row mt-1 text-black-50 date-time">
									<div>
										<i class="fas fa-coins"></i><span class="ml-2">Price: ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(driver.price) + ` + ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(driver.price_per_km) + `/km</span>
									</div>
									<div class="ml-3">
										<i class="fas fa-medal"></i><span class="ml-2">Driver skills: Product Type (` + driver.product_type + `) Distance (` + driver.distance + `) Valuable Cargo (` + driver.valuable + `) Fragile Cargo (` + driver.fragile + `) On-time Delivery (` + driver.fast + `)</span>
									</div>
								</div>
							</div>
						</div>
						<div class="d-flex flex-row align-items-center">
							<div class="d-flex flex-column mr-2">
								<select id="select-truck" class="selectpicker form-control" onchange="setDriver(this.options[this.selectedIndex].getAttribute('driver_id'),this.options[this.selectedIndex].getAttribute('truck_id'));">
									` + getDriverAvailableTrucksHTML(myTrucks,driver,config) + `
								</select>
							</div> 
							<button onclick="fireDriver('` + driver.driver_id + `')" class="btn btn-red btn-accent-4 white">Fire Driver</button>
						</div>
					</li>
				`);
			}
		}
		$('#recruitment-page-list').append(list_item);

		$('#loan-title').empty();
		$('#loan-title').append('Get loans to invest in your company (Maximum active loans: ' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.max_emprestimo) + ')');
		
		$('#loan-1').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[0][0]) + '</h3><span>pay ' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[0][1]) + ' at day</span>';
		$('#loan-1').append(list_item);
		$('#loan-2').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[1][0]) + '</h3><span>pay ' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[1][1]) + ' at day</span>';
		$('#loan-2').append(list_item);
		$('#loan-3').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[2][0]) + '</h3><span>pay ' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[2][1]) + ' at day</span>';
		$('#loan-3').append(list_item);
		$('#loan-4').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[3][0]) + '</h3><span>pay ' + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(config.emprestimos[3][1]) + ' at day</span>';
		$('#loan-4').append(list_item);

		$('#loan-list').empty();
		for (const loan of loans) {
			list_item = `
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><i class="fa fa-check-circle checkicon"></i>
						<div class="ml-2">
							<h6 class="mb-0">` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(loan.loan) + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div><i class="fas fa-coins"></i></i><span class="ml-2">Remaining: ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(loan.remaining_amount) + `</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i></i><span class="ml-2">Daily cost: ` + new Intl.NumberFormat(config.formatacao.location, { style: 'currency', currency: config.formatacao.moeda }).format(loan.day_cost) + `</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<button onclick="payLoan('` + loan.id + `')" class="btn btn-red btn-accent-4 white">Pay Loan</button>
					</div>
				</li>
			`;
			$('#loan-list').append(list_item);
		}
	}
	if (item.hidemenu){
		$("body").css("display", "none");
	}
});

function log(d){
	console.log(JSON.stringify(d));
}

function getDriverLevelHTML(value){
	var html = "";
	for (var i = 1; i <= 6; i++) {
		if(i <= value){
			html += '<li class="actived"></li>';
		}else{
			html += '<li></li>';
		}
	}
	return html;
}

function getDriverAvailableTrucksHTML(myTrucks,driver,config){
	var html = "";
	var i = 1;
	var has_truck = null;
	for (const truck of myTrucks) {
		if (truck.driver == driver.driver_id) {
			has_truck = truck.truck_id;
			html += '<option selected="selected">' + config.concessionaria[truck.truck_name].name +'</option>';
		}else{
			if (truck.driver == null){
				html += '<option truck_id="' + truck.truck_id + '" driver_id="' + driver.driver_id + '">' + config.concessionaria[truck.truck_name].name +'</option>';
			}
		}
	}
	if (has_truck == null) {
		html = '<option selected="selected">Select a Truck</option>' + html;
	}else{
		html = '<option driver_id="' + driver.driver_id + '">Select a Truck</option>' + html;
	}
	return html;
}

function getMyTruckHTML(truck){
	return truck.driver==0 ? `<button onclick="spawnTruck(` + truck.truck_id + `)" class="btn btn-blue btn-darken-2 white white mr-2">Spawn Truck</button> <button onclick="setDriver(null,'` + truck.truck_id + `')" class="btn btn-blue btn-darken-2 white white mr-2">Deselect</button>` : `<button onclick="setDriver('0','` + truck.truck_id + `')" class="btn btn-blue btn-darken-2 white white mr-2">Select Truck</button>`
}

function setSkill(id,newValue){
	$('#'+id).empty();
	for (var i = 1; i <= 6; i++) {
		if(i <= newValue){
			if(i == 1){
				$('#'+id).append('<div class="steps"> <span><i class="fa fa-check"></i></span> </div>');
			}else{
				$('#'+id).append('<span class="line"></span><div class="steps"> <span><i class="fa fa-check"></i></span> </div>');
			}
		}else{
			if(i == 1){
				$('#'+id).append('<div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span> </div>');
			}else{
				$('#'+id).append('</div> <span class="redline"></span><div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span>');
			}
		}
	}
}

function openPage(pageN){
	if(pageN == 0){
		$(".pages").css("display", "none");
		$(".main-page").css("display", "block");
	}
	if(pageN == 1){
		$(".pages").css("display", "none");
		$(".job-page").css("display", "block");
	}
	if(pageN == 2){
		$(".pages").css("display", "none");
		$(".freight-page").css("display", "block");
	}
	if(pageN == 3){
		$(".pages").css("display", "none");
		$(".skills-page").css("display", "block");
	}
	if(pageN == 4){
		$(".pages").css("display", "none");
		$(".diagnostic-page").css("display", "block");
	}
	if(pageN == 5){
		$(".pages").css("display", "none");
		$(".dealership-page").css("display", "block");
	}
	if(pageN == 6){
		$(".pages").css("display", "none");
		$(".trucks-page").css("display", "block");
	}
	if(pageN == 7){
		$(".pages").css("display", "none");
		$(".recruitment-page").css("display", "block");
	}
	if(pageN == 8){
		$(".pages").css("display", "none");
		$(".drivers-page").css("display", "block");
	}
	if(pageN == 9){
		$(".pages").css("display", "none");
		$(".bank-page").css("display", "block");
	}
}

function closeUI(){
	post("close","")
}
function startJob(contract_id,reward,distance){
	post("startJob",{id:contract_id,reward:reward,distance:distance})
}
function sellTruck(truck_id,truck_name){
	post("sellTruck",{truck_id:truck_id,truck_name:truck_name})
}
function buyTruck(truck_name,price){
	post("buyTruck",{truck_name:truck_name,price:price})
}
function spawnTruck(truck_id){
	post("spawnTruck",{truck_id:truck_id})
}
function fireDriver(driver_id){
	post("fireDriver",{driver_id:driver_id})
}
function hireDriver(driver_id){
	post("hireDriver",{driver_id:driver_id})
}
function upgradeSkill(id,i){
	post("upgradeSkill",{id:id,value:i})
}
function repairTruck(id){
	post("repairTruck",{id:id})
}
function setDriver(driver_id,truck_id){
	post("setDriver",{driver_id:driver_id,truck_id:truck_id})
}
function loan(loan_id){
	post("loan",{loan_id:loan_id})
}
function payLoan(loan_id){
	post("payLoan",{loan_id:loan_id})
}
function depositMoney(){
	var amount = document.getElementById('input-deposit-money').value;
	document.getElementById('input-deposit-money').value = null;
	post("depositMoney",{amount:amount})
}
function withdrawMoney(){
	post("withdrawMoney",{})
}

document.onkeyup = function(data){
	if (data.which == 27){
		if ($("body").is(":visible")){
			post("close","")
		}
	}
};

$('.sidebar-navigation ul li').on('click', function() {
	$('li').removeClass('active');
	$(this).addClass('active');
});

var coll = document.getElementsByClassName("collapsible");
var i;
for (i = 0; i < coll.length; i++) {
	coll[i].addEventListener("click", function() {
		this.classList.toggle("active");
		var content = this.nextElementSibling;
		if (content.style.display === "block") {
			content.style.display = "none";
		} else {
			content.style.display = "block";
		}
	});
}

function post(name,data){
	$.post("https://truck_logistics/"+name,JSON.stringify(data),function(datab){
		if (datab != "ok"){
			console.log(datab);
		}
	});
}