var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;
var primary = true
function UpdateCursorPos() {
    cursor.style.left = cursorX;
    cursor.style.top = cursorY;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        }
    });

    $(document).mousemove(function (event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    document.onkeydown = function (data) {
        if (data.which === 27) { // Escape key
            $.post('https://ls-radio/escape', JSON.stringify({}));
        } else if (data.which === 114) {
            $.post('https://ls-radio/escape', JSON.stringify({}));
        }
    };

    $("#validateF1").submit(function (e) {
        e.preventDefault(); // Prevent form from submitting

        $.post('https://ls-radio/joinRadio', JSON.stringify({
            channel: $("#channel1").val(),
            volume: $("#volume").val(),
            primary: true
        }));
    });
    $("#validateF2").submit(function (e) {
        e.preventDefault(); // Prevent form from submitting

        $.post('https://ls-radio/joinRadio', JSON.stringify({
            channel: $("#channel2").val(),
            volume: $("#volume").val(),
            primary: false
        }));
    });

    $("#onoff").submit(function (e) {
        e.preventDefault(); // Prevent form from submitting
        $("#channel1").val(null);
        $("#channel2").val(null);
        $("#volume").val(null);
        $.post('https://ls-radio/leaveRadio', JSON.stringify({
        }));

    });
});