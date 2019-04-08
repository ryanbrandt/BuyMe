$('#resetPassword').on('click', function(){
	$.ajax({
		url: "resetPassword.jsp",
		method: "POST",
		data: {'user': $('#userLookup').val()},
		
		success: function(data){
			alert('Password reset to \'password\'');
		}		
	})
});