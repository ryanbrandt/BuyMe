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

var removeBidButton = document.getElementsByClassName("removebid");
for( i=0; removeBidButton.length; i++){
	removeBidButton[i].addEventListener("click", function(){
		var bidrow = this.parentElement.parentElement;
		$.ajax({
			url: "csrep/removeBid.jsp",
			method: "POST",
			data:{'bidID': bidrow.id},
			success: function(data){
				location.reload();
				alert('Bid has been removed');
			}	
		})
	});
}


var removeAuctionButton = document.getElementsByClassName("removeAuction");
for( i=0; removeAuctionButton.length; i++){
	removeAuctionButton[i].addEventListener("click", function(){
		var auctionrow = this.parentElement.parentElement;
		$.ajax({
			url: "csrep/removeAuction.jsp",
			method: "POST",
			data:{'auctionID': auctionrow.id},
			success: function(data){
				location.reload();
				alert('Auction has been removed');
			}	
		})
	});
}
