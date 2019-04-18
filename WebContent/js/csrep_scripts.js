$('#resetPassword').on('click', function(){
	$.ajax({
		url: "csrep/resetPassword.jsp",
		method: "POST",
		data: {},
		
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

$('.modifyAuction').on('click', function(){
	var table = $(this).closest('table');
	var name = table.find('.name').val();
	//var type = table.find('.type').val();
	var type = table.find('.type').text();
	//var condition = table.find('.condition').val();
	var condition = table.find('.condition').text();
	var brand = table.find('.brand').val();
	var material = table.find('.material').val();
	var color = table.find('.color').val();
	var endtime = table.find('.endtime').val();
	
	$.ajax({
		url: "csrep/modifyAuction.jsp",
		method: "POST",
		data:{'auctionID': $(this).val(), 'name': name, 'type': type, 'condition': condition, 'brand': brand, 'material': material, 'color': color, 'endtime': endtime },
		//, 'name': name, 'type': type, 'condition': condition, 'brand': brand, 'material': material, 'color': color, 'endtime': endtime
		success: function(data){
			location.reload();
			alert('Auction has been updated');
		}	
	})
	
	
});
