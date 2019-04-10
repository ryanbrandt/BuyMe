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

$('#emailForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "sendEmail.jsp",
		method: "POST",
		data: {'subject': $('#subject').val(), 'content': $('content').val(), 'recipient': $('recipient')},
		
		success: function(data){
			alert('Your email has been sent');
		}		
	})
});