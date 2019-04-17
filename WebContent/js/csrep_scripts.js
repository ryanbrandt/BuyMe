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

$('#searchButton').on('click', function(){
	$.ajax({
		url: "csrep/userSearch.jsp",
		method: "POST",
		data: {'isReset': "0", 'userLookup': $('#userLookup').val()},
		success: function(data){
			location.reload();
		}
	})
});

$('#resetButton').on('click', function(){
	$.ajax({
		url: "csrep/userSearch.jsp",
		method: "POST",
		data: {'isReset': "1"},
		success: function(data){
			location.reload();
		}
	})
});
$('.removebid').on('click', function(){
	var arr = $(this).val().split(',');
	$.ajax({
		url: "csrep/removeBid.jsp",
		method: "POST",
		data:{'bidId': arr[0], 'auctionId': arr[1]},
		
		success: function(data){
			location.reload();
			alert('Bid has been removed');
		}	
	})
});

$('.removeAuction').on('click', function(){
	var auctionId = $(this).val();
	console.log(auctionId);
	$.ajax({
		url: "csrep/removeAuction.jsp",
		method: "POST",
		data:{'auctionID': auctionId},
		success: function(data){
			location.reload();
			alert('Auction has been removed');
		}	
	})
});