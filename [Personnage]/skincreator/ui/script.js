$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  //var cursor = $('#cursorPointer');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;

  //function UpdateCursorPos() {
  //  $('#cursorPointer').css('left', cursorX);
  //  $('#cursorPointer').css('top', cursorY);
 // }

  function triggerClick(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
    return true;
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Open Skin Creator
    if(event.data.openSkinCreator == true){
      $(".skinCreator").css("display","block");
      //$("#cursorPointer").css("display","block");
      $("#rotation").css("display","block");
    }
    // Close Skin Creator
    if(event.data.openSkinCreator == false){
      $(".skinCreator").css("display","none");
      //$("#cursorPointer").css("display","none");
      $("#rotation").css("display","none");
    }

    // Click
    if (event.data.type == "click") {
      triggerClick(cursorX - 1, cursorY - 1);
    }
  });

  // Mousemove
  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    //UpdateCursorPos();
  });

  // Form update
  $('input').change(function(){
    $.post('https://skincreator/updateSkin', JSON.stringify({
      value: false,
      // Face
      sex : $('input[name=sex]:checked', '#formSkinCreator').val(),
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
      nose1:$('.nose1').val(),
      nose2:$('.nose2').val(),
      nose3:$('.nose3').val(),
      nose4:$('.nose4').val(),
      nose5:$('.nose5').val(),
      nose6:$('.nose6').val(),
      bodyb_1:$('.bodyb_1').val(),
      makeup_3:$('.makeup_3').val(),
      lipstick_3:$('.lipstick_3').val(),
      bodyb_3:$('.bodyb_3').val(),
      chest_1:$('.chest_1').val(),
      makeup_1:$('.makeup_1').val(),
      lipstick_1:$('.lipstick_1').val(),
      eyebrows_5:$('.eyebrows_5').val(),
      eyebrows_6:$('.eyebrows_6').val(),
      cheeks_1:$('.cheeks_1').val(),
      cheeks_2:$('.cheeks_2').val(),
      cheeks_3:$('.cheeks_3').val(),
      eye_squint:$('.eye_squint').val(),
      lip_thickness:$('.lip_thickness').val(),
      jaw_1:$('.jaw_1').val(),
      jaw_2:$('.jaw_2').val(),
      chin_1:$('.chin_1').val(),
      chin_2:$('.chin_2').val(),
      chin_3:$('.chin_3').val(),
      chin_4:$('.chin_4').val(),
      neck_thickness:$('.neck_thickness').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      acne: $('.acne').val(),
      skinproblem: $('.pbpeau').val(),
      freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

    }));
  });
  $('.arrow').on('click', function(e){
    e.preventDefault();
    $.post('https://skincreator/updateSkin', JSON.stringify({
      value: false,
      // Face
      sex : $('input[name=sex]:checked', '#formSkinCreator').val(),
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
      nose1:$('.nose1').val(),
      nose2:$('.nose2').val(),
      nose3:$('.nose3').val(),
      nose4:$('.nose4').val(),
      nose5:$('.nose5').val(),
      nose6:$('.nose6').val(),
      chest_1:$('.chest_1').val(),
      bodyb_1:$('.bodyb_1').val(),
      makeup_3:$('.makeup_3').val(),
      lipstick_3:$('.lipstick_3').val(),
      bodyb_3:$('.bodyb_3').val(),
      makeup_1:$('.makeup_1').val(),
      lipstick_1:$('.lipstick_1').val(),
      eyebrows_5:$('.eyebrows_5').val(),
      eyebrows_6:$('.eyebrows_6').val(),
      cheeks_1:$('.cheeks_1').val(),
      cheeks_2:$('.cheeks_2').val(),
      cheeks_3:$('.cheeks_3').val(),
      eye_squint:$('.eye_squint').val(),
      lip_thickness:$('.lip_thickness').val(),
      jaw_1:$('.jaw_1').val(),
      jaw_2:$('.jaw_2').val(),
      chin_1:$('.chin_1').val(),
      chin_2:$('.chin_2').val(),
      chin_3:$('.chin_3').val(),
      chin_4:$('.chin_4').val(),
      neck_thickness:$('.neck_thickness').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      acne: $('.acne').val(),
      skinproblem: $('.pbpeau').val(),
      freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

    }));
  });

  // Form submited
  $('.yes').on('click', function(e){
    e.preventDefault();
    $.post('https://skincreator/updateSkin', JSON.stringify({
      value: true,
      // Face
      sex : $('input[name=sex]:checked', '#formSkinCreator').val(),
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
      nose1:$('.nose1').val(),
      nose2:$('.nose2').val(),
      nose3:$('.nose3').val(),
      nose4:$('.nose4').val(),
      nose5:$('.nose5').val(),
      nose6:$('.nose6').val(),
      chest_1:$('.chest_1').val(),
      bodyb_1:$('.bodyb_1').val(),
      makeup_3:$('.makeup_3').val(),
      lipstick_3:$('.lipstick_3').val(),
      bodyb_3:$('.bodyb_3').val(),
      makeup_1:$('.makeup_1').val(),
      lipstick_1:$('.lipstick_1').val(),
      eyebrows_5:$('.eyebrows_5').val(),
      eyebrows_6:$('.eyebrows_6').val(),
      cheeks_1:$('.cheeks_1').val(),
      cheeks_2:$('.cheeks_2').val(),
      cheeks_3:$('.cheeks_3').val(),
      eye_squint:$('.eye_squint').val(),
      lip_thickness:$('.lip_thickness').val(),
      jaw_1:$('.jaw_1').val(),
      jaw_2:$('.jaw_2').val(),
      chin_1:$('.chin_1').val(),
      chin_2:$('.chin_2').val(),
      chin_3:$('.chin_3').val(),
      chin_4:$('.chin_4').val(),
      neck_thickness:$('.neck_thickness').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      acne: $('.acne').val(),
      skinproblem: $('.pbpeau').val(),
      freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

    }));
  }); 
  // Rotate player
  $(document).keypress(function(e) {
    if(e.which == 97){ // A pressed
      $.post('https://skincreator/rotaterightheading', JSON.stringify({
        value: 10
      }));
    }
    if(e.which == 101){ // E pressed
      $.post('https://skincreator/rotateleftheading', JSON.stringify({
        value: 10
      }));
    }
  });

  // Zoom out camera for clothes
  $('.tab a').on('click', function(e){
    $.post('https://skincreator/zoom', JSON.stringify({
      zoom: $(this).attr('data-link')
    }));
  });

  // Test value
  var xTriggered = 0;
  $(document).keypress(function(e){
    e.preventDefault();
    xTriggered++;
    if(e.which == 13){

      $.post('https://skincreator/test', JSON.stringify({
        value: xTriggered
      }));
    }
  });

});
