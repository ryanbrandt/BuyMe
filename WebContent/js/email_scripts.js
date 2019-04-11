/*
$('#questionForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "sendEmail.jsp",
		method: "POST",
		data: {'subject': $('#subject').val(), 'content': $('content').val(), 'recipient': "csrep"},
		
		success: function(data){
			alert('Your question has been submitted to a customer service representative');
		}		
	})
});
*/

$('#emailForm').on('submit', function(){
	$.ajax({
		url: "sendEmail.jsp",
		method: "POST",
		data:{'recipient': $('#recipient').val(), 'subject': $('#subject').val(), 'email':$('#email').val()},
	})
});



$('#recipient').change(function(){
	$.ajax({
		url: "check_registration_credentials.jsp",
		method: "POST",
		data: {'isEmail': false, 'data': $(this).val()},
		success: function(data){
			// if data not empty, unavailable, throw alert and clear input
			if($.trim(data)){

			}else{
				alert('User does not exist');
				$('#recipient').val('');
			} 
		}
	})
});

