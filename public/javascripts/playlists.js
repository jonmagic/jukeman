$(document).ready(function(){
  
  // Highlight the correct sidebar item
  var highlight = $("#songs").attr('highlight');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("highlight") == highlight) {
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
      var playlist_id = $(this).attr('playlist_id');
      var song_id = ui.draggable.attr('song_id');
      $.post('/items','item[playlist_id]='+playlist_id+'&item[song_id]='+song_id);
    }
  });
  
  // make the trash button clickable
  $("div#trash_dialog").dialog({
    title: "Trash Can",
    autoOpen: false,
    width: 700,
    modal: true,
    buttons: { "Ok": function() { $(this).dialog("close"); } }
  });
  $("a#trash").bind('click', function(){
    $("div#trash_dialog").dialog('open');
  });
  
});
