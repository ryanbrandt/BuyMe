$('#searchButton').on('click', function(){
	$.ajax({
		url: "communication/searchQuestion.jsp",
		method: "POST",
		data: {'isReset': "0", 'questionLookup': $('#questionLookup').val()},
	})
});


$('#resetButton').on('click', function(){
	$.ajax({
		url: "communication/searchQuestion.jsp",
		method: "POST",
		data: {'isReset': "1"},
		success: function(data){
			location.reload();
		}
	})
});


$('#questionForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "/BuyMe/communication/sendQuestion.jsp",
		method: "POST",
		data: {'subject': $('#subject').val(), 'content': $('#details').val() },
		
		success: function(data){
			window.location.href = "/BuyMe/NavigationServlet?location=qa";
			alert('Your question has been posted');
			
		}		
	})
});

$('#emailForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "communication/sendEmail.jsp",
		method: "POST",
		data:{'isQuestion': "-1", 'recipient': $('#recipient').val(), 'subject': $('#subject').val(), 'email':$('#email').val()},
		success: function(data){
			alert('Your email has been sent');
			window.location.reload();
		}	
	})
});

$('#recipient').change(function(e){ 
	e.preventDefault();
	$.ajax({
		url: "validation/validateUser.jsp",
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

$('.questionDelete').on('click', function(){
	$.ajax({
		url: "communication/deleteQueries.jsp",
		method: "POST",
		data:{'deleteFrom': "3", 'id': $(this).val()},
		
		success: function(data){
			alert("Question has been deleted.");
			location.reload();
		}	
	})
});


$('.answerButton').on('click', function(){

	var answer = $(this).closest('.panel').find('.answerText');

	$.ajax({
		url: "communication/postAnswer.jsp",
		method: "POST",
		data:{'questionID': $(this).val(), 'answer': answer.text()},
		success: function(data){
			location.reload();
			alert('Answer has been posted');
		}	
	})
	
});

$('.inboxDelete').on('click', function(){
	$.ajax({
		url: "communication/deleteQueries.jsp",
		method: "POST",
		data:{'deleteFrom': "1", 'id': $(this).val()},
		
		success: function(data){
			alert("Email has been deleted from inbox");
			location.reload();
		}	
	})
});

$('.sentDelete').on('click', function(){
	$.ajax({
	url: "communication/deleteQueries.jsp",
	method: "POST",
	data:{'deleteFrom': "2", 'id': $(this).val()},
	
	success: function(data){
		location.reload();
		alert("Email has been deleted from sent box.")
	}	
	})
});


$('.replyButton').on('click', function(){
	openTab(event, 'compose');
	var arr = $(this).val().split(",");
	document.getElementById('recipient').value = arr[0];
	document.getElementById('subject').value = "RE: " + arr[1];
	document.getElementById('email').value = "\"" + arr[2] + "\"" + "\n--\n";
});