//http://www.sohtanaka.com/web-design/simple-tabs-w-css-jquery/
$(function(){
	//When page loads...	
	$(".tab_content").hide(); //Hide all content
	
	if(location.hash != "") {
		$(location.hash).show();
		$("ul.simple-tabs li:has(a[href='"+ location.hash+ "'])").addClass("active").show(); //Activate first tab
	} else {
		$("ul.simple-tabs li:first").addClass("active").show(); //Activate first tab
		$(".tab_content:first").show(); //Show first tab content		
	}	
	
	$("ul.simple-tabs li").click(function() {
        var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content

        if($(activeTab).is(':visible')) {
            return false;
        }

		$("ul.simple-tabs li").removeClass("active"); //Remove any "active" class
		$(this).addClass("active"); //Add "active" class to selected tab
		$(".tab_content").hide(); //Hide all tab content
		

		$(activeTab).fadeIn(); //Fade in the active ID content
		return false;		
	});
});
