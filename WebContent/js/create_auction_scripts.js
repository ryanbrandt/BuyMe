/* JavaScript specific to create_auction.jsp */

/* after getting attributes for Clothing table, switch to type form and post Clothing data */
$('#newProductForm').on('submit', function(e){
	e.preventDefault();
	this.style.display = "none";
	var head = document.getElementById("formHead");
	// show form for specific product type
	switch($("#productType").val()){
	
	case "s":
		document.getElementById("shirtForm").style.display = "block";
		head.innerHTML = "Shirt Details";
		break;
	case "p":
		document.getElementById("pantsForm").style.display = "block";
		head.innerHTML = "Pants Details";
		break;
	case "j":
		head.innerHTML = "Jacket Details";
		document.getElementById("jacketForm").style.display = "block";
		
	}
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		// send c for create
		data: {"method": "c", "data": $(this).serializeArray()},
		
		success: function(){
			// do stuff
		}
	})
});

/* on submit of any Clothing type form, show final auction form and post Clothing Type data */
$('.typeForm').on('submit', function(e){
	e.preventDefault();
	this.style.display = "none";
	document.getElementById('auctionForm').style.display = "block";
	document.getElementById('formHead').innerHTML = "Additional Details";
	
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		// send m for manage? think will create all tuples on newProductForm submit and then manage them here
		data: {"method": "m", "data": $(this).serializeArray()},
		
		success: function(){
			// do stuff
		}
	})
})

/* on submit of final auction form, do something */
$('#auctionForm').on('submit', function(e){
	
});