$(document).ready(function(){
    $("#arclight_record_lookup").click(function(){
    	$(this).empty()
    	$(this).append("<i class='fa fa-spinner fa-spin'></i>")
    	if ($("#dao_collection_number")[0]) {
    		$collection = $("#dao_collection_number").val()
			$aspaceID = $("#dao_archivesspace_record").val()
    	} else if ($("#image_collection_number")[0]) {
    		$collection = $("#image_collection_number").val()
    		$aspaceID = $("#image_archivesspace_record").val()
    	} else if ($("#av_collection_number")[0]) {
    		$collection = $("#av_collection_number").val()
    		$aspaceID = $("#av_archivesspace_record").val()
    	} else if ($("#sip_collection_number")[0]) {
    		$collection = $("#sip_collection_number").val()
    		$aspaceID = ""
    	}
    	if ($aspaceID.length < 1) {
    		$arclightURL = "https://archives.albany.edu/description/catalog/" + $collection.replace(".", "-") + "?format=json"
    	} else {
    		$arclightURL = "https://archives.albany.edu/description/catalog/" + $collection.replace(".", "-") + "aspace_" + $aspaceID + "?format=json"
    	}
        $collectionURL = "https://archives.albany.edu/description/catalog/" + $collection.replace(".", "-") + "?format=json"
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: $collectionURL,
          success: function(collectionData) {
            $("#dao_collection").val(collectionData['data']['attributes']['title_ssm']['attributes']['value'])
            $("#image_collection").val(collectionData['data']['attributes']['title_ssm']['attributes']['value'])
            $("#av_collection").val(collectionData['data']['attributes']['title_ssm']['attributes']['value'])
          },
          error: function(){
            $("#dao_collection").addClass("has-error")
            $("#image_collection").addClass("has-error")
            $("#av_collection").addClass("has-error")
          }
        });
		$.ajax({
		  type: "GET",
		  dataType: 'json',
		  url: $arclightURL,
		  success: function(data) {
		  	$(".dao_collection_number").removeClass("has-error")
			$(".dao_archivesspace_record").removeClass("has-error")
			$(".image_collection_number").removeClass("has-error")
			$(".image_archivesspace_record").removeClass("has-error")
			$(".av_collection_number").removeClass("has-error")
			$(".av_archivesspace_record").removeClass("has-error")
			$(".sip_collection_number").removeClass("has-error")
			if ('parent_ssim' in data['data']['attributes']) {
			  	for (i = 0; i < data['data']['attributes']['parent_ssim']['attributes']['value'].length; i++) {
			  		if (i == 0) {
                        
			  		} else if (i == 1) {
			  			$("#dao_record_parent").val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  			$("#image_record_parent").val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  			$("#av_record_parent").val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  		} else {
			  			$(".dao_record_parent").find(".add").click()
			  			$(".dao_record_parent").last().val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  			$(".image_record_parent").find(".add").click()
			  			$(".image_record_parent").last().val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  			$(".av_record_parent").find(".add").click()
			  			$(".av_record_parent").last().val(data['data']['attributes']['parent_ssim']['attributes']['value'][i].split("_")[1])
			  		}
			  	}
			} else {
				$("#dao_collection").val(data['data']['attributes']['collection_ssm']['attributes']['value'].split(",")[0])
			  	$("#image_collection").val(data['data']['attributes']['collection_ssm']['attributes']['value'].split(",")[0])
			  	$("#av_collection").val(data['data']['attributes']['collection_ssm']['attributes']['value'].split(",")[0])
			  	$("#sip_collection").val(data['data']['attributes']['collection_ssm']['attributes']['value'].split(",")[0])
			}
			$("#dao_collecting_area").val(data['data']['attributes']['repository_ssim']['attributes']['value'])
			$("#image_collecting_area").val(data['data']['attributes']['repository_ssim']['attributes']['value'])
			$("#av_collecting_area").val(data['data']['attributes']['repository_ssim']['attributes']['value'])
			$("#sip_collecting_area").val(data['data']['attributes']['repository_ssim']['attributes']['value'])
		  	$("#dao_date_created").val(data['data']['attributes']['normalized_date_ssm']['attributes']['value'])
		  	$("#dao_title").val($("<textarea />").html(data['data']['attributes']['title_ssm']['attributes']['value'].trim()).text())
                        $("#arclight_record_lookup").empty()
			$("#arclight_record_lookup").text("Load Record")
		  },
		  error: function(){
		  	$(".dao_collection_number").addClass("has-error")
    		$(".dao_archivesspace_record").addClass("has-error")
    		$(".image_collection_number").addClass("has-error")
    		$(".image_archivesspace_record").addClass("has-error")
    		$(".av_collection_number").addClass("has-error")
    		$(".av_archivesspace_record").addClass("has-error")
    		$(".sip_collection_number").addClass("has-error")
    		$("#arclight_record_lookup").empty()
			$("#arclight_record_lookup").text("Load Record")
		  }
		});
    });
});
