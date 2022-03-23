$(document).ready(function () {
	// LUA listener
	window.addEventListener('message', function (event) {
		if (event.data.action == 'open') {
			var type = event.data.type;
			var property = event.data.array['property']
			if (property == undefined || property == null) {
				property = "//"
			}
			var userData = event.data.array['user'][0];
			var licenseData = event.data.array['licenses'];
			var sex = userData.sex;

			if (type == 'driver' || type == null) {
				$('img').show();

				if (sex.toLowerCase() == 'm') {
					$('img').attr('src', 'assets/images/male.png');
				} else {
					$('img').attr('src', 'assets/images/female.png');

				}
				$('#name').text(userData.firstname + ' ' + userData.lastname);
				$('#sex').text(sex.toLowerCase() == 'm' ? 'h' : 'f');
				$('#dob').text(userData.dateofbirth);
				$('#height').text(userData.height);
				$('#signature').text(userData.firstname + ' ' + userData.lastname);
				if (type == 'driver') {
					$('#licenses0').text("");
					$('#point0').text("");
					$('#licenses1').text("");
					$('#point1').text("");
					$('#licenses2').text("");
					$('#point2').text("");
					$('#licenses3').text("");
					$('#point3').text("");
					$('#licenses4').text("");
					$('#point4').text("");
					$('#licenses5').text("");
					$('#point5').text("");
					if (licenseData != null) {
						Object.keys(licenseData).forEach(function (key) {
							var point = licenseData[key].point
							var label = ""
							var showPoints = false;
							switch (licenseData[key].type) {
								case 'bike':
									label = "Moto";
									showPoints = true;
									break;
								case 'truck':
									label = "Camion";
									showPoints = true;
									break;
								case 'drive':
									label = "Voiture";
									showPoints = true;
									break;
								case 'PPA':
									label = 'PPA';
									break;
								case 'hunting':
									label = 'Chasse';
									break;
								case 'fishing':
									label = 'Pêche';
									break;
							}
							$('#licenses' + key).text(label);
							if (showPoints) {
								$('#point' + key).text(point + "pts");
							}
						});
					}

					$('#id-card').css('background', 'url(assets/images/license.png)');
				} else {
					$('#id-card').css('background', 'url(assets/images/idcard.png)');
					$('#job').text(userData.jobLabel);
					$('#address').text(property);
				}
			} else if (type == 'weapon') {
				$('img').hide();
				$('#name').css('color', '#d9d9d9');
				$('#name').text(userData.firstname + ' ' + userData.lastname);
				$('#dob').text(userData.dateofbirth);
				$('#signature').text(userData.firstname + ' ' + userData.lastname);

				$('#id-card').css('background', 'url(assets/images/firearm.png)');
			}

			$('#id-card').show();
		} else if (event.data.action == 'close') {
			$('#name').text('');
			$('#dob').text('');
			$('#height').text('');
			$('#signature').text('');
			$('#sex').text('');
			$('#id-card').hide();
			$('#licenses0').text("");
			$('#point0').text("");
			$('#licenses1').text("");
			$('#point1').text("");
			$('#licenses2').text("");
			$('#point2').text("");
			$('#licenses3').text("");
			$('#point3').text("");
			$('#licenses4').text("");
			$('#point4').text("");
			$('#licenses5').text("");
			$('#point5').text("");
			$('#job').text("");
			$('#address').text("");

		}
	});
});
