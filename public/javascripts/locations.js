$(document).ready(function(){
  // find the ip of the jukebox
  var location = $('div#center h2').attr('data-location-id');
  var url = '/locations/'+location+'/player';
  // highlight my sidebar item
  var highlight = $("div#center h2").attr('data-location-id');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("data-highlight") == highlight) {
      $(this).parent("li").addClass("selected");
      $(this).parent("li").removeClass("droppable_playlist");
    };
  });
  
  // update location information function
  function control_jukebox(url, data){
    $.ajax({
      url: url,
      type: 'POST',
      data: data,
      success: function(){
        $('div#playlists').dialog('close');
        update_location(url);
      }
    })
  }
  function update_location(url){
    $.ajax({
      url: url,
      timeout: 5000,
      dataType: 'jsonp',
      success: function(json){
        if(json['state'] != null){
          $('a#previous').show();
          $('a#next').show();
          if(json['state'] == 'play'){
            $('a#play').hide();
            $('a#stop').show();
          }else if(json['state'] == 'stop'){
            $('a#stop').hide();
            $('a#play').show();             
          };
        };
        if(json['current_song'] != null){
          $('div#screen').html("<p>"+json['current_song']+"</p>");
        };
        if(json['active_playlist'] != null){
          $('span#active_playlist').text(json['active_playlist']['name']);
        };
        if(json['playlists'] != null){
          $('div#playlists ul').empty();
          $.each(json['playlists'], function(i, playlist){
            $('div#playlists ul').append("<li><a href='javascript:void(0);' data-playlist-id='"+playlist['id']+"'>"+playlist['name']+"</a></li>");
          });
        };
        // setTimeout(function(){update_location(url);}, 3000);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        $('div#player').empty();
        $('div#player').append('<p>Failed to connect to jukebox...</p>');
      }
    });
  };
  update_location(url);
  setTimeout(function(){
    update_location(url);
  }, 3000);
  
  // select a playlist
  $('div#playlists').dialog({
    title: "Select a playlist",
    autoOpen: false,
    width: 500,
    modal: true
  });
  $('a.change_active_playlist').bind('click', function(){
    $('div#playlists').dialog('open');
  });
  $('div#playlists ul li a').live('click', function(){
    control_jukebox(url, "activate_playlist="+$(this).attr('data-playlist-id'));
  });
  // configure screen
  $("div#screen").show();
  // setup buttons
  $('div#header a').live('click', function(){
    control_jukebox(url, "player_action="+$(this).attr('data-action'));
  });
  // edit location
  $('a.edit_location').live('click', function(){
    var location_id = $("div#center h2").attr('data-location-id');
    $("#dialog").dialog('option', 'title', 'Edit Location');
    $('#dialog').load('/locations/'+location_id+'/edit');
    $('#dialog').dialog('open');
  });
  // bind my delete playlist button
  $('a.remove_location').live('click', function(){
    var location_id = $("div#center h2").attr('data-location-id');
    var answer = confirm("Are you sure you want to delete this location?");
    if (answer){
      $.ajax({
        url: '/locations/'+location_id,
        type: "POST",
        data: '_method=delete',
        success: function(){
          window.location.href="/"
        }
      });
    };
  });
});