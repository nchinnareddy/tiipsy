// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function remove_field(element, item) {
  element.up(item).remove();
}



$(window).bind("load", function() {
	var footerHeight = 0,
           footerTop = 0,
             $footer = $("#footer");
			 
    positionFooter();
    $('#flash').delay(30000).fadeOut();

	
	function positionFooter(){
		footerHeight = $footer.height();
		footerTop = ($(window).scrollTop()+$(window).height()-footerHeight)+"px";
		
		if (($(document.body).height() + footerHeight) < $(window).height()) {
			$footer.css({
				position: "absolute"
            });
		} else {
			$footer.css({
				position: "static"
            });
		}
	}
	
	//$(window).scroll(positionFooter).resize(positionFooter);		 
 
});