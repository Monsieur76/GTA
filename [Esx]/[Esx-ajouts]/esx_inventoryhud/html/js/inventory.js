var type = "normal";
var inventoryName = ""
var disabled = false;
var disabledFunction = null;

window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        type = event.data.type
        inventoryName = event.data.inventoryName
        disabled = false;
        if (type === "normal") {
            $(".info-div").hide();
        } else if (type === "trunk") {
            $(".info-div").show();
            $(".controls-div").show();
        } else if (type === "coffre_appartement") {
            $(".info-div").show();
            $(".controls-div").show();
        } else if (type === "coffreFort_appartement") {
            $(".info-div").show();
            $(".controls-div").show();
        } else if (type === "frigo") {
            $(".info-div").show();
            $(".controls-div").show();
        } else if (type === "vault") {
            $(".info-div").show();
            $(".controls-div").show();
        } else if (type === "armory") {
            $(".info-div").show();
            $(".controls-div").hide();
        } else if (type === "confiscation") {
            $(".info-div").show();
            $(".controls-div").show();
        }

        $(".ui").fadeIn();
    } else if (event.data.action == "hide") {
        $("#dialog").dialog("close");
        $("#etiquette").css({ "display": "none" });
        $("#etiquette input").val("")
        $(".ui").fadeOut();
        $(".item").remove();
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList);
        $drag_counter = $("#event-drag")
        counts = [0, 0, 0]
        $('.slot').draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
            cursor: "move",
            cursorAt: { top: 25, left: 175 },
            start: function (event, ui) {
                if (disabled) {
                    $(this).stop();
                    return;
                }
            }
        });
    } else if (event.data.action == "setSecondInventoryItems") {
        secondInventorySetup(event.data.itemList);
    } else if (event.data.action == "setInfoText") {
        $(".info-div").html(event.data.text);
        $("#playerInventoryCapacity").html("Capacité : " + event.data.playerUsedWeight + "kg / " + event.data.playerTotalWeight + "kg")
        $("#otherInventoryCapacity").html(event.data.textCapacity)
    }
});

function closeInventory() {
    $.post("https://esx_inventoryhud/NUIFocusOff", JSON.stringify({ type: type, inventoryName: inventoryName }));  
}

function inventorySetup(items) {
    $("#playerInventory").html("");
    $.each(items, function (index, item) {
        count = setCount(item);

        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" >' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });
}

function secondInventorySetup(items) {
    $("#otherInventory").html("");
    $.each(items, function (index, item) {
        count = setCount(item);

        var itemEtiquette = (item.etiquette != "" && item.etiquette != " " && item.etiquette != null ? ' - ' + item.etiquette : "")
        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" >' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + itemEtiquette + '</div> </div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function setCount(item) {
    count = item.count

    if (item.limit > 0) {
        count = item.count + " / " + item.limit
    }

    if (item.type === "item_weapon") {
        if (count == 0) {
            count = "";
        } else {
            count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.count;
        }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count);
    }

    return count;
}

function setCost(item) {
    cost = item.price

    if (item.price == 0) {
        cost = "$" + item.price
    }
    if (item.price > 0) {
        cost = "$" + item.price
    }
    return cost;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });

    $('#playerInventory').droppable({
        drop: function (event, ui) {
            itemData = $('> .item', ui.draggable).data("item");
            itemInventory = $('> .item', ui.draggable).data("inventory");

            if (type === "trunk" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromTrunk", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "coffre_appartement" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromCoffreAppartement", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "frigo" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromFrigo", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "vault" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromVault", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "confiscation" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromConfiscation", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "armory" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromArmory", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "coffreFort_appartement" && itemInventory === "second") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/TakeFromCoffreFortAppartement", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });
    $('#otherInventory').droppable({
        drop: function (event, ui) {
            itemData = $('> .item', ui.draggable).data("item");
            itemInventory = $('> .item', ui.draggable).data("inventory");

            if (type === "trunk" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type == "item_weapon") {

                    $("#etiquetteTrunk").css({ "display": "block" });
                    $("#etiquetteTrunk input").focus()
                    var number = 0
                    $("#etiquetteTrunk input").on('keyup', function (e) {
                        if (e.which == 13) {
                            if (number == 0){
                                number = 1
                            $.post("https://esx_inventoryhud/PutIntoTrunk", JSON.stringify({
                                item: itemData,
                                number: parseInt($("#count").val()),
                                etiquette: $("#etiquetteTrunk input").val()
                            }));
                            $("#etiquetteTrunk").css({ "display": "none" });
                            $("#etiquetteTrunk input").val("")
                            }
                        }
                    });
                }
                else {
                    $.post("https://esx_inventoryhud/PutIntoTrunk", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                }
            } else if (type === "coffre_appartement" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type == "item_weapon") {
                    $("#etiquetteAppart").css({ "display": "block" });
                    $("#etiquetteAppart input").focus()
                    var number = 0
                    $("#etiquetteAppart input").on('keyup', function (e) {
                        if (e.which == 13) {
                            if (number == 0){
                                number = 1
                            $.post("https://esx_inventoryhud/PutIntoCoffreAppartement", JSON.stringify({
                                item: itemData,
                                number: parseInt($("#count").val()),
                                etiquette: $("#etiquetteAppart input").val()
                            }));
                            $("#etiquetteAppart").css({ "display": "none" });
                            $("#etiquetteAppart input").val("")
                            }
                        }
                    });
                }
                else {
                    $.post("https://esx_inventoryhud/PutIntoCoffreAppartement", JSON.stringify({
                        item: itemData,
                        number: parseInt($("#count").val())
                    }));
                }
            } else if (type === "frigo" && itemInventory === "main") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/PutIntoFrigo", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "vault" && itemInventory === "main") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/PutIntoVault", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "armory" && itemInventory === "main") {
                disableInventory(500);
                $("#etiquette").css({ "display": "block" });
                $("#etiquette input").focus()
                $("#etiquette input").on('keyup', function (e) {
                    if (e.which == 13) {
                        $.post("https://esx_inventoryhud/PutIntoArmory", JSON.stringify({
                            item: itemData,
                            number: parseInt($("#count").val()),
                            etiquette: $("#etiquette input").val()
                        }));
                        $("#etiquette").css({ "display": "none" });
                        $("#etiquette input").val("")
                    }
                });
            } else if (type === "confiscation" && itemInventory === "main") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/PutIntoConfiscation", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "coffreFort_appartement" && itemInventory === "main") {
                disableInventory(500);
                $.post("https://esx_inventoryhud/PutIntoCoffreFortAppartement", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });

    $("#count").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function () {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});