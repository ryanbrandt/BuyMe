/* open bid form */
$('#bid').on('click', function(){
	$('#bidModal').modal('show');
});

/* pass new bid to servlet to register */
$('#bidForm').on('submit', function(e){
	e.preventDefault();
	// show loader 
	document.getElementById('load').style.display = "block";
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		data: $(this).serialize() + "&action=b",
		
		success: function(bid){
			// close modal, reset modal, show success message, update maxBid
			document.getElementById('maxBid').innerHTML = "$" + bid + " From You"; 
			var amount = $('#amount');
			amount.val('');
			amount.attr('placeholder', 'Min: $' + (parseFloat(bid)+0.01));
			amount.attr('min', (parseFloat(bid)+0.01));
			document.getElementById('load').style.display = "none";
			$('#close').click();
			alert('Success! You Bid $' + bid);
		}
	})
});

/* open edit form */
$('#edit').on('click', function(){
	$('#editModal').modal('show');
});

/* submit edit form */
$('#editForm').on('submit', function(e){
	e.preventDefault();
	// show loader
	document.getElementById('editLoad').style.display = "block";
	// make json for changed fields
	var data ="?&";
	$('.changed').each(function(){
		data = data + $(this).attr("name") + "=" + $(this).val() + "&";
	})
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		data: data + "action=e",
		
		success: function(json){ 
			document.getElementById('editLoad').style.display = "none";
			$('#editClose').click();
			alert('Successfully Updated!');
			window.location.reload();
		}
	})
});

/* this marks if a form field has been changed so we only update changes */
$('input, textarea').on('change', function(){
	$(this).addClass('changed');
});
