$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var message    = event.data.message;
      //var name = event.data.array['name'];
       if ( type == 'WeazelBreaking') {

        $('#id-card').css('background', 'url(assets/images/wealzelbreaking.png)');
        $('#message').text(message);

      }else if ( type == 'WeazelInfo'){

        $('#id-card').css('background', 'url(assets/images/weazelinfo.png)');
        $('#message').text(message);

      }else if ( type == 'WeazelPub') {

        $('#id-card').css('background', 'url(assets/images/weazelPub.png)');
        $('#message').text(message);

      }else if ( type == 'WeazelAnonce') {

        $('#id-card').css('background', 'url(assets/images/weazelAnnonce.png)');
        $('#message').text(message);

      }


      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#id-card').hide();
      $('#message').html('');
    }
  });
});
