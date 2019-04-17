$('#input1').on('change', function(){
	switch($("#input1 option:selected").val()){
		case "2":
			$('#buttonCol1').hide();
			$('#row2').show();
			$('#input2Select').show();
			$('#input2Text').hide();
			$('#buttonCol2').show();
			$('#row3').hide();
			break;
		case "3":
			$('#buttonCol1').hide();
			$('#row2').show();
			$('#input2Select').show();
			$('#input2Text').hide();
			$('#buttonCol2').hide();
			$('#row3').show();
			break;
		case "4":
			$('#buttonCol1').hide();
			$('#row2').show();
			$('#input2Select').hide();
			$('#input2Text').show();
			$('#buttonCol2').show();
			$('#row3').hide();
			break;
		default:
			$('#buttonCol1').show();
			$('#row2').hide();
			$('#row3').hide();
			break;
	}
});

$('#registerForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "validate_form.jsp",
		method: "POST",
		data: {'isCSRep': true, 'isLogin': false, 'email': $('#registerEmail').val(), 'password': $('#registerPassword').val(), 'displayName': $('#displayName').val()},
		
		success: function(data){
			alert('New customer representative account sucessfully added.');
			location.reload();
		}		
	})
});

$('#displayName').change(function(){
	$.ajax({
		url: "check_registration_credentials.jsp",
		method: "POST",
		data: {'isEmail': false, 'data': $(this).val()},
			
		success: function(data){
			// if data not empty, unavailable, throw alert and clear input
			if($.trim(data)){
				alert('Display name already exists. Please choose another.');
				$('#displayName').val('');
			} 
		}
	
	})
});

$('#registerEmail').change(function(){
	$.ajax({
		url: "check_registration_credentials.jsp",
		method: "POST",
		data: {'isEmail': true, 'data': $(this).val()},
			
		success: function(data){
			// if data not empty, unavailable, throw alert and clear input
			if($.trim(data)){
				alert('Email already exists. Please choose another.');
				$('#registerEmail').val('');
			} 
		}
	})
});



$('.generateButton').on('click', function(){
	
	$.ajax({
		url: "generateSalesReport.jsp",
		method: "POST",
		data: {'input1':$("#input1 option:selected").val(),
				'input2Select':$("#input2Select option:selected").val(),
				'input2Text':$("#input2Text").val(),
				'input3_1':$("#input3_1 option:selected").val(),
				'input3_2':$("#input3_2").val(),
				'input3_3':$("#input3_3").val(),
				'input3_4':$("#input3_4").val(),
			},
		
		success: function(data){
			var arr = data.split("|")
			$("#result").show();
			
			var displayType = $("#input1 option:selected").val();
			if( displayType == 5 || displayType == 6){
				$("#heading").text(arr[2]);
				$("#heading").show();
			}else{
				$("#heading").hide();
			}
			
			$("#tSold").text(arr[0]);
			var truncated = ((arr[1] * Math.pow(10, 2)) | 0) / Math.pow(10, 2);
			$("#tAmount").text( "$"+truncated );
		}		
	})
});
	