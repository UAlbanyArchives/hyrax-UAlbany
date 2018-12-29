$(document).ready(function(){
	if ($(".arclightBreadcrumbs")[0]) {
		if ($(".arclightRecord")[0]) {
			$arclightURI = $(".arclightRecord").children("a").attr("href") + "?format=json";
			$.ajax({
			  type: "GET",
			  dataType: 'json',
			  url: $arclightURI,
			  success: function(data) {
			  	/*alert(data['response']['document']['normalized_title_ssm']);*/
			  	for (i = 0; i < data['response']['document']['parent_ssm'].length; i++) {
			  		$query = '.arclightReify:eq(' + String(i) + ')';
			  		$parentLink = $('.arclightBreadcrumbs').children($query);
		  			$urlRoot = $parentLink.children("a").attr("href").split("aspace_")[0];
		  			if ( i == 0 ) {
						$parentLink.children("a").attr("href", $urlRoot)
					} else {
						$parentLink.children("a").attr("href", $urlRoot + data['response']['document']['parent_ssm'][i])
		  			}
		  			$parentLink.children("a").text(data['response']['document']['parent_unittitles_ssm'][i])
			  	}
				$(".arclightRecord").children("a").text(data['response']['document']['normalized_title_ssm'][0]);
			  }
			});
			$('.parent_context').each(function (index, element) {
				$reverseCount = $(".arclightBreadcrumbs").children(".arclightReify").length - index - 1;
				$contextQuery = '.arclightReify:eq(' + String($reverseCount) + ')';
				$correctElement = $(".arclightBreadcrumbs").children($contextQuery)
				$parentURI = $correctElement.children("a").attr("href") + "?format=json";
				$.ajax({
				  type: "GET",
				  dataType: 'json',
				  context: this,
				  url: $parentURI,
				  success: function(data) {
				  	parent = data['response']['document']
				  	$(this).children(".parent_title").children(".record_parent").text(parent['normalized_title_ssm'][0])
					if ('scopecontent_ssm' in parent) {
						for (i = 0; i < parent['scopecontent_ssm'].length; i++) {
				  			$(this).children(".parent_description").append("<p>" + parent['scopecontent_ssm'][i] + "</p>")
				  		}
				  		$(this).children(".parent_description").css("display", "block");
				  	}
				  }
				});
			});
		} else {
			$parentURI = $(".arclightReify").children("a").attr("href") + "?format=json";
			$.ajax({
			  type: "GET",
			  dataType: 'json',
			  url: $parentURI,
			  success: function(data) {
			  	/*alert(data['response']['document']['normalized_title_ssm']);*/
			  	$(".arclightReify").children("a").text(data['response']['document']['collection_ssm'][0])
			  }
			});
		}
	}
});

/*on the Search Results page, this will reify the parent id(s) with the correct titles using Arclight*/
$( document ).on('turbolinks:load', function() {
	if ($(".dl-horizontal")[0]) {
		$('dt').each(function (index, element) {
			if ($(this).text() == "Parent Record(s):") {
				$(this).next("dd").children("a").each(function (index, element) {
					$parentID = $(this).text();
					$collectionID = $(this).parent("dd").prev().prev().children("a").text().replace(".", "-");
					$uri = "https://archives.albany.edu/collections/catalog/" + $collectionID + "aspace_" + $parentID + "?format=json"
					$.ajax({
					  type: "GET",
					  dataType: 'json',
					  context: this,
					  url: $uri,
					  success: function(data) {
					  	$(this).text(data['response']['document']['title_ssm'][0]);
					  }
					});
				});
			}
		});
	}
});
