$.fn.liveUpdate = function(list){
	list = $(list);

	if ( list.length ) {
		var rows = list.children('li a'),
			cache = rows.map(function(){
				return this.innerHTML.toLowerCase();
			});
			
		this
			.keyup(filter).keyup()
			.parents('form').submit(function(){
				return false;
			});
	}
		
	return this;
		
	function filter(){
		var term = $.trim( $(this).val().toLowerCase() ), scores = [];
		
		if ( !term ) {
			rows.show();
		} else {
			rows.hide();

			cache.each(function(i){
				var score = this.score(term);
				if (score > 0) { scores.push([score, i]); }
			});

			$.each(scores.sort(function(a, b){return b[0] - a[0];}), function(){
				$(rows[ this[1] ]).show();
			});
		}
	}
};