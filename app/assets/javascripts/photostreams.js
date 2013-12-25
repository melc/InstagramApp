var scrollspeed = 1;		// SET SCROLLER SPEED 1 = SLOWEST
var speedjump   = 30;		// ADJUST SCROLL JUMPING = RANGE 20 TO 40
var startdelay  = 2; 		// START SCROLLING DELAY IN SECONDS
var nextdelay   = 0; 		// SECOND SCROLL DELAY IN SECONDS 0 = QUICKEST
var topspace    = 0;		// TOP SPACING FIRST TIME SCROLLING
var frameheight = 55;		// IF YOU RESIZE THE WINDOW EDIT THIS HEIGHT TO MATCH


current = (scrollspeed);

function HeightData() {
    AreaHeight = dataobj.offsetHeight;
    if (AreaHeight === 0) {
	setTimeout("HeightData()", (startdelay * 1500));
    } else {
	ScrollNewsDiv();
    }
}

function NewsScrollStart() {
    dataobj = document.all ? document.all.news_div : document.getElementById("news_div");
    dataobj.style.top = topspace + 'px';
    setTimeout("HeightData()", (startdelay * 1000));
}

function ScrollNewsDiv() {
    dataobj.style.top = parseInt(dataobj.style.top) - scrollspeed + 'px';
    if (parseInt(dataobj.style.top) < AreaHeight * (-1)) {
	dataobj.style.top = frameheight + 'px';
	setTimeout("ScrollNewsDiv()", (nextdelay * 1000));
    } else {
	setTimeout("ScrollNewsDiv()", speedjump);
    }
}

$(document).ready(function() {


	$('#news_div').mouseover(function() {
		scrollspeed=0;
	})

	$('#news_div').mouseout(function() {
		scrollspeed=current;
	})

	NewsScrollStart();

})
