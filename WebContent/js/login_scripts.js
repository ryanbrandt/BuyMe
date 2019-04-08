/* External JavaScript for login.jsp */


/* switch register -> login and vice versa */
function switchForms(isLogin){
	if(isLogin){
		document.getElementById("loginForm").style.display="none";
		$('#registerForm').slideDown("slow", function(){
		});
	} else {
		document.getElementById("registerForm").style.display="none";
		$('#loginForm').slideDown("slow", function(){
		});
	}
}

/* AJAX to check on the fly if a display name/email is already taken */
$('#registerEmail').change(function(){
	// disable join button until availability confirmed, just in case
	$('#joinNow').attr('disabled', 'disabled');
	$.ajax({
		url: "check_registration_credentials.jsp",
		method: "POST",
		data: {'isEmail': true, 'data': $(this).val()},
			
		success: function(data){
			$('joinNow').removeAttr('disabled');
			// if data not empty, unavailable, throw alert and clear input
			if($.trim(data)){
				alert('That email is already registered under an account. Log in instead?');
				$('#registerEmail').val('');
			} 
		}
	})
});
	
$('#displayName').change(function(){
	// disable join button until availability confirmed, just in case
	$('#joinNow').attr('disabled', 'disabled');
	$.ajax({
		url: "check_registration_credentials.jsp",
		method: "POST",
		data: {'isEmail': false, 'data': $(this).val()},
			
		success: function(data){
			$('#joinNow').removeAttr('disabled');
			// if data not empty, unavailable, throw alert and clear input
			if($.trim(data)){
				alert('That display name is already taken. Please choose another.');
				$('#displayName').val('');
			} 
		}
	
	})
});

/* AJAX to validate user login/registration credentials before redirecting */
$('#loginForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		
		url: "validate_form.jsp",
		method: "POST",
		data: {'isCSRep': false, 'isLogin': true, 'email': $('#loginEmail').val(), 'password': $('#loginPassword').val()},
		
		success: function(data){
			// if data not empty, invalid credentials, show user message and don't redirect
			if($.trim(data)){
				alert('Hmm, those credentials didnt match any accounts. Try again?');
			} else {
				window.location.href = 'profile.jsp';	
			}
		}		
	})	
});

$('#registerForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		
		url: "validate_form.jsp",
		method: "POST",
		data: {'isCSRep': false, 'isLogin': false, 'email': $('#registerEmail').val(), 'password': $('#registerPassword').val(), 'displayName': $('#displayName').val()},
		
		success: function(data){
			alert('Account successfully created! Log in below.');
			switchForms(false);
		}		
	})
});
