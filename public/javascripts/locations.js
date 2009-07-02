$(document).ready(function(){
  var highlight = $("#location").attr('highlight');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("highlight") == highlight) {
      $(this).parent("li").addClass("selected");
      $(this).parent("li").removeClass("droppable_playlist");
    };
  });

});
