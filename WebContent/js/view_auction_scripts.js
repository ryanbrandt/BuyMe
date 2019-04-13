/* open bid form */
$('#bid').on('click', function(){
	$('#myModal').modal('show');
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
			document.getElementById('maxBid').innerHTML = "$" + bid;
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
