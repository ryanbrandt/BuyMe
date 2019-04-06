$('#lookupForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "validate_form.jsp",
		method: "POST",
		data: { 'userLookup': $('userLookup').val()},
		
		success: function(data){
			//return result table
			location.reload();
		}		
	})
});