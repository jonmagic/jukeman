$(document).ready(function(){
  var highlight = $("#location").attr('data-highlight');
  $("#sidebar ul li a").each(function(){
    if ($(this).attr("data-highlight") == highlight) {
      $(this).parent("li").addClass("selected");
      $(this).parent("li").removeClass("droppable_playlist");
    };
  });
  
  // 

});