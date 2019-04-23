/* JavaScript specific to create_auction.jsp */

/* after getting attributes for Clothing table, switch to type form and post Clothing data */
$('#newProductForm').on('submit', function(e){
	e.preventDefault();
	this.style.display = "none";
	var head = document.getElementById("formHead");
	// show form for specific product type
	switch($("#type").val()){
	
	case "Shirts":
		$('#shirtForm').slideDown("slow", function(){
		});
		head.innerHTML = "Shirt Details";
		break;
	case "Pants":
		$('#pantsForm').slideDown("slow", function(){
		});
		head.innerHTML = "Pants Details";
		break;
	case "Jackets":
		$('#jacketForm').slideDown("slow", function(){
		});
		head.innerHTML = "Jacket Details";
		
	}
	var reader  = new FileReader();
	console.log(document.getElementById("imageUpload").files.length == 0);
	if(document.getElementById("imageUpload").files.length > 0){
		reader.readAsDataURL(document.getElementById("imageUpload").files[0]);
		reader.onload = function () {
			//console.log(myencode(reader.result));
			$.ajax({
				url: "/BuyMe/AuctionManagementServlet",
				method: "POST",
				// send action=c for create new clothing tuple
				data: $('#newProductForm').serialize() + "&image=" + myencode(reader.result) + "&action=c",
				
				success: function(){
					console.log("success");
					//console.log($('#newProductForm').serialize());
				}
			})
		  }	
	}
	else{
		$.ajax({
			url: "/BuyMe/AuctionManagementServlet",
			method: "POST",
			// send action=c for create new clothing tuple
			data: $('#newProductForm').serialize() + "&image=" + myencode(reader.result) + "&action=c",
			
			success: function(){
				console.log("success");
				//console.log($('#newProductForm').serialize());
			}
		})
	}
});
function myencode(mystring){
	var thisString = "" + mystring;
	return (thisString.replace(new RegExp("\\+","g"),"*"));
}
/* on submit of any Clothing type form, show final auction form and post Clothing Type data */
$('.typeForm').on('submit', function(e){
	e.preventDefault();
	this.style.display = "none";
	$('#auctionForm').slideDown("slow", function(){
	});
	document.getElementById('formHead').innerHTML = "Additional Details";
	
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		// send action=t for adding fields to related type of clothing tuple created in newProductForm
		data: $(this).serialize() + "&action=t",
		
		success: function(){
			// do stuff
		}
	})
})

/* on submit of final auction form, do something */
$('#auctionForm').on('submit', function(e){
	e.preventDefault();
	$.ajax({
		url: "/BuyMe/AuctionManagementServlet",
		method: "POST",
		// send action=a for creating auction tuple associated with product and type
		data: $(this).serialize() + "&action=a",
		
		success: function(){
			// send to servlet with for redirect
			window.location.replace("AuctionManagementServlet?location=view");
			
		}
	})
});
/* make sure end_date after today and slide newProductForm */
window.onload = function(){
	$('#newProductForm').slideDown("slow", function(){
	});
	var d = new Date();
	var s = d.getFullYear() + '-' +
	('0' + (d.getMonth()+1)).slice(-2) + '-' +
	('0' + (d.getDate() + 1)).slice(-2);
	
	document.getElementById('dateTest').setAttribute('min', s);
}

/* TODO script to update image, if one exists */
