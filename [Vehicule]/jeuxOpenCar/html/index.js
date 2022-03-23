window.addEventListener('message', function (event) {
  var deg
  var activelockposition
    if (event.data.show == true) {
      vehicle = event.data.vehicle
      reset()
      $("body").show();
      $(document).on("mousemove", function (e) {
        deg = angle(
          $(".lock").position().left + $(".lock").width() / 2,
          $(".lock").position().top + $(".lock").height() / 2,
          e.pageX,
          e.pageY
        );
        $(".lock .lockpick").css("transform", "rotate(" + (deg + 90) + "deg)");
      
      });
      function angle(cx, cy, ex, ey) {
        var dy = ey - cy;
        var dx = ex - cx;
        var theta = Math.atan2(dy, dx);
        theta *= 180 / Math.PI;
        if (theta < 0) theta = 360 + theta;
        return theta;
      }
      function reset(){
        activelockposition = Math.floor(Math.random() * 359 +90);
        if ((46+90 > activelockposition) && (314+90 < activelockposition)){
          activelockposition = 180
        }
      }

      $(document).keydown(function(e) {
        if(e.key === "ArrowRight") {
          if (
            deg <= activelockposition + 45 &&
            deg >= activelockposition - 45
          ) {
            $(".serrure").css("animation","nogood90 3s");
            $(".serrure").on('animationend webkitAnimationEnd oAnimationEnd', function()
            {
            $.post('https://jeuxOpenCar/miniGame:reussite',JSON.stringify({vehicle: vehicle}));
            location.reload(true);
            $("body").hide();
            })
          }else if (
            deg <= activelockposition + 90 &&
            deg >= activelockposition - 90
          ) {
            $(".serrure").css("animation","nogood70 3s");
          }else if (
            deg <= activelockposition + 140 &&
            deg >= activelockposition - 140
          ) {
            $(".serrure").css("animation","nogood45 3s");
          }else if(
            deg <= activelockposition + 180 &&
            deg >= activelockposition - 180
          ){
            $(".serrure").css("animation","nogood 3s");
          }
        }
  
        if(e.key === "Escape") {
      $.post('https://jeuxOpenCar/miniGame:echec');
      location.reload(true);
      $("body").hide();
      event.preventDefault();
        }
        if (e.key === "Backspace"){
          $.post('https://jeuxOpenCar/miniGame:echec');
          location.reload(true);
          $("body").hide();
          event.preventDefault();
          }
      });
      
      
    }
  })