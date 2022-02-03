window.addEventListener('message', function (event) {
    if (event.data.pause == true) {
        $(".container-f").show();
    if (event.data.hud == true) {
        $(".container-f").show();
        if (event.data.armorDisplay == true) {
            $(".armor").show();
            $(".container-b").show();
        }else{
            $(".armor").hide();
            $(".container-b").hide();
        }
    //if (event.data.inVehicle == true) {
    //    $(".container-carro").slideUp();
    //    $(".container-f").slideDown();
    // else if(event.data.inVehicle == false) {
//    $(".container-f").slideUp();
   //     $(".container-carro").slideDown();
   // }
    switch (event.data.action) {
        
        case 'tick':

            $(".shield-b").css("width", event.data.armor + "%");
            $(".health-b").css("width", event.data.health + "%");
            $(".hunger-b").css("width", event.data.hunger + "%");
            $(".thirst-b").css("width", event.data.thirst + "%");

    break
        }
    }else{
        $(".container-f").hide();
    }
}else{
    $(".container-f").hide();
}
});