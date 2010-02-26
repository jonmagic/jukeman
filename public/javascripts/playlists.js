function song_array(){
  var array = [];
  $('#songs tbody tr').each(function(){
    array.push($(this).attr('data-song-id'));
  });
  return array;
};

$(document).ready(function(){
  
  // Highlight the correct sidebar item
  var highlight = $("#songs").attr('data-highlight');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("data-highlight") == highlight) {
      $(this).parent("li").addClass("selected");
      $(this).parent("li").removeClass("droppable_playlist");
    };
  });

  // make my playlists droppable
  $(".droppable_playlist").droppable({
    accept: '.song',
    over: function(){
      $(this).addClass('selected');
    },
    out: function(){
      $(this).removeClass('selected');
    },
    drop: function(event, ui) {
      $(this).removeClass('selected');
      var playlist_id = $(this).attr('data-playlist-id');
      var song_id = ui.draggable.attr('data-song-id');
      $.post('/playlists/'+playlist_id+'/add/'+song_id);
    }
  });
  
  // add search to table
  $('table#songs tbody tr').quicksearch({
    position: 'before',
    attached: 'table#songs',
    formId: 'content_search',
    stripeRowClass: ['odd', 'even'],
    labelText: 'Search Songs',
    focusOnLoad: true
  });

  // add tablesorting
  $("table#songs").tablesorter();
  
  $('#new_song').bind('click', function(){
    $('#dialog').empty();
    $('#dialog').dialog('option', 'title', 'New Song');
    $('#dialog').load('/songs/new');
    $('#dialog').dialog('open');
  });
  // edit playlist
  $('a.edit_playlist').live('click', function(){
    var playlist_id = $("#songs").attr('data-playlist-id');
    $("#dialog").dialog('option', 'title', 'Edit Playlist');
    $('#dialog').load('/playlists/'+playlist_id+'/edit');
    $('#dialog').dialog('open');
  });
  // bind my delete playlist button
  $('a.remove_playlist').live('click', function(){
    var playlist_id = $("#songs").attr('data-playlist-id');
    var answer = confirm("Are you sure you want to delete this playlist?");
    if (answer){
      $.ajax({
        url: '/playlists/'+playlist_id,
        type: "POST",
        data: '_method=delete',
        success: function(){
          window.location.href="/"
        }
      });
    };
  });

});
