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

});
