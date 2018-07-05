$(function(){
	if ($(this).scrollTop() < 57){
		 $('.navbar-top').removeClass("fixHalf");
		 $('.withSpacer').removeClass("content-spacer");
		 $('.logo').removeClass("logoHide");
		 $('.ualbany').removeClass("logoHide");
		 $('.smallLogo').removeClass("logoShow");
		 $('.side-nav').css({"top":52-$(this).scrollTop()});
		 $('#browseNav').css({"top":52-$(this).scrollTop()});
	  } else {
		 $('.navbar-top').addClass("fixHalf");
		 $('.withSpacer').addClass("content-spacer");
		 $('.logo').addClass("logoHide");
		 $('.ualbany').addClass("logoHide");
		 $('.smallLogo').addClass("logoShow");
		 $('.side-nav').css({"top": "-5px"});
		 $('#browseNav').css({"top": "-5px"});
	  }
  $(window).scroll(function(){
	  if ($(this).scrollTop() < 57){
		 $('.navbar-top').removeClass("fixHalf");
		 $('.withSpacer').removeClass("content-spacer");
		 $('.logo').removeClass("logoHide");
		 $('.ualbany').removeClass("logoHide");
		 $('.smallLogo').removeClass("logoShow");
		 $('.side-nav').css({"top":52-$(this).scrollTop()});
		 $('#browseNav').css({"top":52-$(this).scrollTop()});
	  } else {
		 $('.navbar-top').addClass("fixHalf");
		 $('.withSpacer').addClass("content-spacer");
		 $('.logo').addClass("logoHide");
		 $('.ualbany').addClass("logoHide");
		 $('.smallLogo').addClass("logoShow");
		 $('.side-nav').css({"top": "-5px"});
		  $('#browseNav').css({"top": "-5px"});
	  }
  });
});

/*
$(document).ready(function(){    
	$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        $(this).toggleClass("slideRight");
    });
});

//mobile nav close when link is clicked
$(function(){
	$("#browseNav .list-group-item").on('click', function(){
		$("#wrapper").removeClass("toggled");
		$("#menu-toggle").removeClass("slideRight");
	});	
});	*/