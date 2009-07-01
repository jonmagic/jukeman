$(document).ready(function(){
  // make my songs draggable
  $(".song").draggable({
    helper: 'clone'
  });
  // make my playlists droppable
  $(".droppable_playlist").droppable({
    accept: '.song',
    drop: function(event, ui) {
      var playlist_id = $(this).attr('playlist_id');
      var song_id = ui.draggable.attr('song_id');
      $.post('/items','item[playlist_id]='+playlist_id+'&item[song_id]='+song_id);
    }
  });
  // make my playlist songs sortable
  $('table#songs').sortable({items:'.sortable', containment:'parent', axis:'y', update: function() {
    $.post('/items/sort', $(this).sortable('serialize'));
  }});
  // Highlight the correct sidebar item
  var highlight = $("#songs").attr('highlight');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("highlight") == highlight) {
      $(this).parent("li").addClass("selected");
    };
  });
});
