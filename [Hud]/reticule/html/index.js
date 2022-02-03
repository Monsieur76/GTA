window.addEventListener('message', function (event) {
    if (event.data.hud == true) {
        $(".container-f").show();
}else{
    $(".container-f").hide();
}
});