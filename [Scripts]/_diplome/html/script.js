
var toggleShow = false;
var activeform = {};
var id_count = 0;
var label

function QuestionElement(_questionAnswer, _can_be_empty, _can_be_edited) {
	this.question = _questionAnswer.question;
	this.value = "";
	this.can_be_empty = _can_be_empty;
	this.can_be_edited = _can_be_edited;
	this.answer = _questionAnswer.answer;
	let _id = "_m" + String(id_count);
	id_count++;
	this.elementid = _id;

	this.getHTML = function (_editable) {

		let _html = "<div class=\"submit_input\">";
		_html += "<p class=\"input_label\">" + this.question + "</p>";
		_html += "<input type=\"radio\" id=\"" + this.elementid + "\" name=\"" + this.elementid + "\" class=\"" + this.elementid + "\" value=\"vrai\"/><label class=\"radio_label " + this.elementid + "\">Vrai</label>";
		_html += "<input type=\"radio\" id=\"" + this.elementid + 1 + "\" name=\"" + this.elementid + "\" class=\"" + this.elementid + "\" value=\"faux\"/><label class=\"radio_label " + this.elementid + "\">Faux</label>";
		_html += "</div>";
		return _html;
	}
}

function Form(_title, _subtitle, _elements, _submittable) {
	this.headerTitle = _title;
	this.headerSubtitle = _subtitle;
	this.headerFirstName = "";
	this.headerLastName = "";
	this.elements = _elements;
	this.submittable = _submittable || false;
	this.questionsAnswers = [];
	this.diplomaName = "";
	this.diplomaLabel = "";
	this.headerDateCreated = "";

	this.loadFromJson = function (obj) {

		this.headerTitle = obj.headerTitle;
		this.headerSubtitle = obj.headerSubtitle;
		this.headerFirstName = obj.headerFirstName;
		this.headerLastName = obj.headerLastName;
		this.diplomaName = obj.diplomaName;
		this.diplomaLabel = obj.diplomaLabel;
		for (const diplomaQuestions of obj.diplomaQuestions) {
			this.questionsAnswers.push(diplomaQuestions)
		}
		let tmp_elements = []
		for (let i = 0; i < 10; i++) {
			let tmpIE = new QuestionElement(this.questionsAnswers[i], false, true)
			tmp_elements.push(tmpIE);
		}
		this.elements = tmp_elements;

	}

	this.submit = function () {
		for (let i = 0; i < 10; i++) {
			$("label." + activeform.elements[i].elementid).removeClass("must_fill");
		}
		activeform.headerDateCreated = getCreationDate();

		let can_submit = true;

		for (let i = 0; i < 10; i++) {
			activeform.elements[i].value = String($("." + activeform.elements[i].elementid + ":checked").val());
			if (!activeform.elements[i].can_be_empty && (activeform.elements[i].value == "" || activeform.elements[i].value == "undefined")) {
				can_submit = false;
				$("label." + activeform.elements[i].elementid).addClass("must_fill");
			}
		}

		var json_string = JSON.stringify(activeform);

		if (can_submit) {
			$.post('https://diplome/form_submit', json_string);
			activeform.close();
		}

	}

	this.printExam = function () {

		/* Create Header */

		html_header = "<div id=\"section_header\">";
		html_header += "<div id=\"button_close\">X</div>";
		html_header += "<div id=\"header_title\">" + this.headerTitle + "</div>";
		html_header += "<div id=\"header_seal\"></div>";
		html_header += "<div id=\"header_details\"><h2>" + this.headerSubtitle + "</h2>";
		html_header += "<h4>Étudiant : " + this.headerFirstName + " " + this.headerLastName + "</h4>";
		html_header += "<h4>Date : " + getCreationDate(false) + "</h4>";
		html_header += "</div>";
		html_header += "</div>";
		html_header += "</div>";
		html_header += "<div id=\"section_block\">Répondez aux questions suivantes</div>";
		$("#main_container").append(html_header);

		/* Create main body */

		$("#main_container").append("<div id=\"section_input\"></div>");

		let count = 0;

		for (let i = 0; i < this.elements.length; i++) {
			$("#main_container").append(this.elements[i].getHTML());
			if (this.elements[i].can_be_edited == false) $("#" + this.elements[i].elementid).prop('readonly', true);
			count++;
		}

		/* Create footer */

		html_footer = "<div id=\"section_footer\">";

		/*  Cancel & Submit button */

		if (this.submittable) {
			html_footer += "<button id=\"button_cancel\" type=\"button\">Annuler</button>";
			html_footer += "<button id=\"button_submit\" type=\"button\">Envoyer</button>";
		}

		html_footer += "</div>";

		$("#main_container").append(html_footer);

		html_script = "<script>\
		$(\"#button_submit\").on( \"click\", function() { activeform.submit(); }); \
		$(\"#button_close\").on( \"click\", function() { activeform.close(); }); \
		$(\"#button_cancel\").on( \"click\", function() { activeform.close(); }); \
		</script>";

		$("#main_container").append(html_script);
	}

	this.close = function () {
		$("#main_container").html("");
		$("#main_container").css({ display: 'none' });
		$.post('https://diplome/form_close', JSON.stringify({ label: label }));
	}
}

$(document).keyup(function (e) {
	if (e.keyCode === 27) activeform.close();
});
window.addEventListener('message', function (event) {
	var edata = event.data;
	if (edata.type == "createNewForm") {
		activeform = new Form();
		activeform.loadFromJson(edata.data);
		activeform.submittable = true;
		activeform.printExam();
		$("#main_container").css({
			display: 'block'
		});
	}
	else if (edata.type == "openDiplomas") {

		var data = edata.data;
		$("#diplomas").css({
			display: 'block'
		});
		$("#name").append(data.user.firstname + " " + data.user.lastname)

		for (let i = 0; i < data.diplomas.length; i++) {
			const diploma = data.diplomas[i];
			var coma = i != data.diplomas.length - 1 ? ", " : ""
			$("#diplomasList").append(diploma + coma)
		}
		setTimeout(() => {
			$("#diplomas").css({ display: 'none' });
			$("#diplomasList").text("")
			$("#name").text("Diplôme(s) de ")
		}, 30000)
	}
	else if (edata.type == "closeDiplomas") {
		$("#diplomas").css({ display: 'none' });
		$("#diplomasList").text("")
		$("#name").text("Diplôme(s) de ")
	}

});


function getCreationDate(fulltime = true) {
	let d = new Date();

	let month = d.getMonth() + 1;
	let day = d.getDate();
	let hours = d.getHours();
	let minutes = d.getMinutes();
	let seconds = d.getSeconds();
	let output = (('' + day).length < 2 ? '0' : '') + day + '/' + (('' + month).length < 2 ? '0' : '') + month + '/' + d.getFullYear();

	if (fulltime) {
		output += " " + hours + ":" + minutes + ":" + seconds
	}

	return output
}

