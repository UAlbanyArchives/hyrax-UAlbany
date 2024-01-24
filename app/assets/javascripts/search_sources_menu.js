document.addEventListener("DOMContentLoaded", function(){
	var pathnameEncoded = window.location.pathname.toLowerCase() + window.location.search.toLowerCase();
	var pathname = decodeURI(pathnameEncoded);
	#console.log(pathname);
	var sourcesMenu = document.getElementById("search-sources-menu");
	if (sourcesMenu) {

		var alreadyActives = sourcesMenu.getElementsByClassName("active");
		for (var i = 0; i < alreadyActives.length; i++) {
		    alreadyActives[0].className = alreadyActives[0].className.replace(" active", "");
		} 

		var searchLabel = document.getElementsByClassName("search-intro");
		#console.log(pathname);
		#console.log(pathname.startsWith("/books"));
		if (pathname.startsWith("/search")) {
			var target = sourcesMenu.getElementsByClassName("search");
		} else if (pathname.startsWith("/description")) {
			var target = sourcesMenu.getElementsByClassName("description");
		} else if (pathname.startsWith("/catalog") || pathname.startsWith("/concern")) {
			var target = sourcesMenu.getElementsByClassName("catalog");
		} else if (pathname.startsWith("/history")) {
			var target = sourcesMenu.getElementsByClassName("history");
		} else if (pathname.includes("f[collecting_area_ssim][]=mathes+childrens+literature")) {
			var target = sourcesMenu.getElementsByClassName("mathes");
			searchLabel[0].innerHTML = "Mathes Childrens Literature";
		} else if (pathname.includes("f[collecting_area_ssim][]=political+pamphlets")) {
			var target = sourcesMenu.getElementsByClassName("pamphlets");
			searchLabel[0].innerHTML = "Political Pamphlets";
		} else if (pathname.startsWith("/books")) {
			var target = sourcesMenu.getElementsByClassName("books");
		}
		target[0].className += " active";
	}
});

