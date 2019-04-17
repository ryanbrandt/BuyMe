/* JS for user settings functionality */

/* validate user password */
$('#confirmPass').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "/BuyMe/UserServlet?action=c",
		method: "POST",
		data: {'password': $('#pass').val()},
		
		success: function(data){
			// valid password
			if(data){
				document.getElementById('confirmPass').style.display = "none";
				document.getElementById('head').innerHTML = "Actions";
				$('#actionsTable').slideDown("slow", function(){});
			} else {
				alert('Sorry, those credentials are not valid');
				$('#pass').val('');
			}
		}
	})
})

/* delete user account */
$('#deleteAct').on('click', function(){
	if(confirm('Are you sure?')){
		$.ajax({
			url: "UserServlet?action=d",
			method: "POST",
			data: {"user_id": $(this).val()},
			
			success: function(data){
				alert('Your account has been successfully deleted');
				window.location.href = "logout.jsp";
			}
			
		})
	} 
});

/* update password */
$('#passUpdate').on('click', function(){
	$.ajax({
		url: "UserServlet?action=u",
		method: "POST",
		data: {"user_id": $(this).val(), "pass": $('#changePass').val()},
		
		success: function(){
			alert('Your password was successfully updated!');
		}
	})
})