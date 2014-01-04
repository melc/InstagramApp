$(document).ready(function() {

    $('#news_div').animate({'scrollTop' : $(window).height()}, 
        {
            duration: 20000,
            complete: function(){
                $('#news_div').animate({'scrollTop' : 0}, 8000);
            }
        }
    )

	$('#news_div').mouseover(function() {
        $('#news_div').stop(); 
    })

	$('#news_div').mouseout(function() {
        $('#news_div').animate({'scrollTop' : $(window).height()}, 20000); 
    })

    $('.bxslider').bxSlider({
        auto: true,
        speed: 2000,
        pause: 8000,
        autoHover: true,
        controls: false
    });

	// $('#btnPopular').on('click', function() {
 //    	var uri = "https://api.instagram.com/v1/media/popular?access_token=" + <%= @photostreams[0].access_token %>
 //        alert(uri); 
 //  	})

	// $('#btnSearch').on('click', function() {
 //    	alert('search');
 //  	})
    


})
