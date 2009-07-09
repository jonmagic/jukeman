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
  
  // add import_from_folder support
  $("div#importing_from_folder_dialog").dialog({
    title: "Importing songs from folder...",
    autoOpen: false,
    width: 250,
    resizable: false,
    draggable: false,
    height: 100,
    modal: true
  });
  $("div#imported_from_folder").dialog({
    title: "Imported from folder...",
    autoOpen: false,
    width: 300,
    resizable: false,
    draggable: false,
    height: 200,
    modal: true,
    buttons: { "Ok": function() { 
      $(this).dialog("close"); 
      window.location.href="/"; 
    } }
  });
  $("a#import_from_folder").bind('click', function(){
    $("div#importing_from_folder_dialog").dialog('open');
    $.ajax({
      url: '/songs/import_from_folder',
      type: "GET",
      success: function(msg){
        $("div#importing_from_folder_dialog").dialog('close');
        $("div#imported_from_folder").append("<p>Imported "+msg+" song(s).")
        $("div#imported_from_folder").dialog('open');
      }
    });
  });
  
});
