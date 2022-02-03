$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) { // Escape key
			e.preventDefault();
		}
	};
	
	$("#register").submit(function(e) {
		//e.preventDefault(); // Prevent form from submitting
		
		// Verify date
		firstnam= $("#firstname").val(),
		lastnam= $("#lastname").val(),
		se= $("#sex").val(),
		heigh= $("#height").val()
		var date = $("#dateofbirth").val();
		var dateCheck = new Date($("#dateofbirth").val());
		if (dateCheck == "Invalid Date") {
			date == "invalid";
		}
		//date = moment($("#dateofbirth").val()).format('dddd, D MMMM YYYY');
		$.post('http://esx_identity/register', JSON.stringify({
			firstname: firstnam.trim(),
			lastname: lastnam.trim(),
			dateofbirth: date,
			sex: se.trim(),
			height: heigh.trim()
		}));
	});
});
