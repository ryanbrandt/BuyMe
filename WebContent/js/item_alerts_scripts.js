$('#new').on('click', function(){
	$('#newAlertModal').modal('show');
});

/* pass new alert to servlet to register */
$('#alertForm').on('submit', function(e){
	e.preventDefault();
	// show loader 
	document.getElementById('alertLoad').style.display = "block";
	$.ajax({
		url: "/BuyMe/UserServlet",
		method: "POST",
		data: $(this).serialize() + "&action=ca",
		
		success: function(){
			document.getElementById('alertLoad').style.display = "none";
			$('#alertClose').click();
			alert('Success! Your alert has been created. You will now be alerted of any relevant new listings.');
			window.location.reload();
		}
	})
});

/* delete existing item alert */
$('.del').on('click', function(e){
	e.preventDefault();
	if(confirm('Are you sure?')){
		$.ajax({
			url: "/BuyMe/UserServlet?action=da",
			method: "POST",
			// alert id is button value
			data: "&id=" + $(this).val(),
		
			success: function(){
				window.location.reload();
			}
		})
	}
})