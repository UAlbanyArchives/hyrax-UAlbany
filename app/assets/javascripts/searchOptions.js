$(function(){
	$('.searchOptions a').click(
	  function( event ){
	    event.preventDefault()

	    let data = $(this).attr('data')
	    $('.search-query-form').css("display", "none")
	    $('.' + data).css("display", "block")
	  }
	)
});