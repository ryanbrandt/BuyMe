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
			document.getElementById('load').style.display = "none";
			$('#bidClose').click();
			alert('Success! You Bid $' + bid);
			window.location.reload();
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
	// serialize changed fields
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

/* open bid history modal */
$('#openHistory').on('click', function(){
	$('#historyModal').modal('show');
});
/* switch between auto-bid and regular bid modals */
$('#autoBid').on('click', function(){
	$('#bidClose').click();
	$('#autoBidModal').modal('show');
});
$('#regBid').on('click', function(){
	$('#autoBidClose').click();
	$('#bidModal').modal('show');
});

/* pass new auto bid to servlet to process */
$('#autoBidForm').on('submit', function(e){
	e.preventDefault();
	// show loader 
	document.getElementById('autoLoad').style.display = "block";
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		data: $(this).serialize() + "&action=ab",
		
		success: function(){
			document.getElementById('autoLoad').style.display = "none";
			$('#autoBidClose').click();
			alert('Auto Bidding Successfully Configured!');
			window.location.reload();
		}
	})
});
