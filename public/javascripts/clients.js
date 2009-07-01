// load my sidebar, select the client we're showing, add an edit button
function populateClientList(data){
  data.sort(function(a,b){
    if (a.client.company == true){
      var x = a.client.name
    }else{
      var x = a.client.lastname
    }
    if (b.client.company == true){
      var y = b.client.name
    }else{
      var y = b.client.lastname
    }
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
  });
  $.each(data, function(i, object){
    // Setup my class so we can add an icon later
    if(object.client.company == true){
      var type = "company"
    }else{
      var type = "person"
    };
    // Create and then insert new list item, including values and classes
    var list_item = "<li alt='"+object.client.id+"'><a href='/clients/"+object.client.id+"' class='"+type+"'>"+object.client.lastfirst+"</a></li>";
    $("ul#clients").append(list_item);
  });
};

$(document).ready(function() {
  var search_timeout = undefined;
  $("input#srch_fld").bind('keyup', function() {
    if(search_timeout != undefined) {
            clearTimeout(search_timeout);
    }
    search_timeout = setTimeout(function() {
      search_timeout = undefined;
      $("ul#clients").empty();
      $.getJSON("/clients/search?q="+$("input#srch_fld").val(), function(data){
        populateClientList(data);
      });
    }, 500);
  });
  
});

// setup tabs
$(document).ready(function() {
  $("#client_content > ul").tabs();
  $("#center div.ui-tabs-panel table.itu").wrap("<div></div>").parent().addClass("ui-tabs-panel-padding");
});

$(document).ready(function() {
  $("input#srch_fld").liveUpdate('ul#clients').focus();
});