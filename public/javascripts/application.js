// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function remove_field(element, item) {
  element.up(item).remove();
}

//for footer
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

//email validation
function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}

function rtrim(str, chars) {
    console.log(str);
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}

//validate email
function validateEmail(field) {
    var regex=/^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    return (regex.test(trim(field))) ? true : false;
}

function validateMultipleEmailsCommaSeparated(value) {
    var result = value.split(",");
    for(var i = 0;i < result.length;i++)
    if(!validateEmail(result[i]))
            return false;
    return true;
}