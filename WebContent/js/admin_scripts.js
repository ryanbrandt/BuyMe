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
	