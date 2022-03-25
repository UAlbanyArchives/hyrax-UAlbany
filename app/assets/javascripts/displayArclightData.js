var decodeHTML = function (html) {
	var txt = document.createElement('textarea');
	txt.innerHTML = html;
	return txt.value;
};

$(document).ready(function(){
	if ($(".arclightBreadcrumbs")[0]) {
		if ($(".arclightRecord")[0]) {
			$arclightURI = $(".arclightRecord").children("a").attr("href") + "?format=json";
			$.ajax({
			  type: "GET",
			  dataType: 'json',
			  url: $arclightURI,
			  success: function(data) {
			  	/*alert(data['data']['attributes']['normalized_title_ssm']['attributes']['value'][0]);*/
			  	for (i = 0; i < data['data']['attributes']['parent_ssim']['attributes']['value'].length; i++) {
					$query = '.arclightReify:eq(' + String(i) + ')';
			  		$parentLink = $('.arclightBreadcrumbs').children($query);
		  			$urlRoot = $parentLink.children("a").attr("href").split("aspace_")[0];
		  			if ( i == 0 ) {
						$parentLink.children("a").attr("href", $urlRoot)
					} else {
						$parentLink.children("a").attr("href", $urlRoot + data['data']['attributes']['parent_ssim']['attributes']['value'][i])
		  			}
		  			$parentLink.children("a").text($("<textarea />").html(data['data']['attributes']['parent_unittitles_ssm']['attributes']['value'][i]).text())
					$("h5.collection-name").text($("<textarea />").html(data['data']['attributes']['collection_ssm']['attributes']['value'][0]).text())
			  	}
				$(".arclightRecord").children("a").text($("<textarea />").html(data['data']['attributes']['normalized_title_ssm']['attributes']['value'][0]).text());
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
				  	parent = data['data']['attributes']
				  	$(this).children(".parent_title").children(".record_parent").text(parent['normalized_title_ssm']['attributes']['value'][0])
					if ('scopecontent_ssm' in parent) {
						for (i = 0; i < parent['scopecontent_ssm']['attributes']['value'].length; i++) {
				  			$(this).children(".parent_description").append(decodeHTML(parent['scopecontent_ssm']['attributes']['value'][i]))
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
			  	/*alert(data['data']['attributes']['normalized_title_ssm']['attributes']['value']);*/
			  	$(".arclightReify").children("a").text(data['data']['attributes']['collection_ssm']['attributes']['value'][0]);
				$("h5.collection-name").text(data['data']['attributes']['collection_ssm']['attributes']['value'][0]);
			  }
			});
		}
	}
	if ($(".collection_title")[0]) {
		$collectionURI = $(".sidebar-collection-title").children("a").attr("href") + "?format=json";
		console.log($collectionURI);
		$.ajax({
                          type: "GET",
                          dataType: 'json',
                          url: $collectionURI,
                          success: function(data) {
                                /*alert(data['data']['attributes']['normalized_title_ssm']['attributes']['value']);*/
				if ('scopecontent_ssm' in data['data']['attributes']) {
                                        for (i = 0; i < data['data']['attributes']['scopecontent_ssm']['attributes']['value'].length; i++) {
                                        	$('.collection_context').children(".parent_description").append(decodeHTML(data['data']['attributes']['scopecontent_ssm']['attributes']['value'][i]))
                                        }
                                	$('.collection_context').children(".parent_description").css("display", "block");
                                }
                	}
        	});
	}
});

/*on the Search Results page, this will reify the parent id(s) with the correct titles using Arclight*/
$(document).ready(function(){
	if ($(".dl-horizontal")[0]) {
		$('dt').each(function (index, element) {
			if ($(this).text() == "Parent Record(s):") {
				$(this).next("dd").children("a").each(function (index, element) {
					$parentID = $(this).text();
					$collectionID = $(this).parent("dd").prev().prev().children("a").text().replace(".", "-");
					$uri = window.location.protocol + "//" + window.location.hostname + "/description/catalog/" + $collectionID + "aspace_" + $parentID + "?format=json"
					$.ajax({
					  type: "GET",
					  dataType: 'json',
					  context: this,
					  url: $uri,
					  success: function(data) {
					  	$(this).text(data['data']['attributes']['title_ssm']['attributes']['value'][0]);
					  }
					});
				});
			}
		});
	}
});
