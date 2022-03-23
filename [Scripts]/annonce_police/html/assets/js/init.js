$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var message    = event.data.message;
      //var name = event.data.array['name'];
        $('#id-card').css('background', 'url(assets/images/wanted.png)');
        $('#message').text(message);
        $('#id-card').show();

    } else if (event.data.action == 'close') {
      $('#id-card').hide();
      $('#message').html('');
    }
  });
});
