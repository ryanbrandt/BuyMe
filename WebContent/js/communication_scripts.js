
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
		url: "communication/sendQuestion.jsp",
		method: "POST",
		data: {'subject': $('#subject').val(), 'content': $('#details').val() },
		
		success: function(data){
			window.location.href = "qaPage.jsp";
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

var answer = document.getElementsByClassName("answerButton");
var i;
for( i=0; answer.length; i++){
	answer[i].addEventListener("click", function(){
		var arr = $(this).val().split(",");
		
		var answer = this.parentElement.parentElement.previousElementSibling.firstElementChild;
		
		$.ajax({
			url: "communication/postAnswer.jsp",
			method: "POST",
			data:{'questionID': arr[0], 'answer': answer.innerText},
			success: function(data){
				location.reload();
				alert('Answer has been posted');
			}	
		})
		
	});
}


