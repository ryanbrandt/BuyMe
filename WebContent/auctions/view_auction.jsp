<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*, java.util.Map"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%!
	// helper to put query data into a Map; puts all not null query data into map sans the pk column since already have
	public void dbToMap(ResultSet names, ResultSet vals, Map<String,String> map, String idCol){
		try{
			if(vals.next()){
				int i = 1; 
				while(names.next()){
					if(vals.getString(i) != null && !names.getString(1).contentEquals(idCol)){
						map.put(names.getString(1), vals.getString(i));
					} 
					i++;
				}
			} else {
				System.out.println("Query error grabbing attributes in view_auction.dbToMap");
			}
			names.close();
			vals.close();
			
		}
		catch(Exception e){
			System.out.println("Exception in view_auction.dbToMap: " + e);
		}

	}
%>
<%
	// get necessary data to populate page 
	Map<String, String> auctionData = new HashMap<String, String>();
	double lead_bid = 0.00;
	try{ 
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		Statement stTwo = con.createStatement();
		// get Auction data into map
		ResultSet names = st.executeQuery("DESCRIBE BuyMe.Auctions");
		ResultSet vals = stTwo.executeQuery("SELECT * FROM BuyMe.Auctions WHERE auction_id = " + request.getSession().getAttribute("auction_id"));
		dbToMap(names, vals, auctionData, "auction_id");
		// get Clothing data into map
		names = st.executeQuery("DESCRIBE BuyMe.Clothing");
		vals = stTwo.executeQuery("SELECT * FROM BuyMe.Clothing WHERE product_id = " + auctionData.get("item_is"));
		dbToMap(names, vals, auctionData, "item_is");
		// get type data into map
		names = st.executeQuery("DESCRIBE BuyMe." + auctionData.get("type"));
		String q = "SELECT * FROM BuyMe." + 
					auctionData.get("type") + " WHERE "; 
		q += auctionData.get("type").contentEquals("Pants") ? auctionData.get("type").toLowerCase() + "_id = " + auctionData.get("item_is") : 
					auctionData.get("type").toLowerCase().substring(0, auctionData.get("type").length()-1) + "_id = " + auctionData.get("item_is");
		vals = stTwo.executeQuery(q);
		dbToMap(names, vals, auctionData, auctionData.get("type").toLowerCase() + "_id");
		// get current leading bid to display minimum user can bid
		names = st.executeQuery("SELECT MAX(amount) FROM BuyMe.Bids WHERE for_auction = " + request.getSession().getAttribute("auction_id"));
		if(names.next()){
			lead_bid = names.getString(1) != null? (double) Math.round(names.getDouble(1)*100)/100 : 0.00;
		}
		// get seller display_name into map
		names = st.executeQuery("SELECT display_name FROM Users WHERE user_id = " + auctionData.get("seller_is"));
		if(names.next()){
			auctionData.put("seller_name", names.getString(1));
		}
		names.close();
		st.close();
		stTwo.close();
		con.close();
	}
	catch(Exception e){
		System.out.println("Exception: " + e);
	}
%>
<!DOCTYPE html>  
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/viewAuction.css"> 
<title>Auction for '<%= auctionData.get("name") %>'</title>
</head> 
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<!-- Content --> 
<body>
<div class="container" style="margin-top: 2em !important;">   
	<div class="row">    
		<div class="col-lg" align="left">
			<h1 style="display: inline-block;"><%= auctionData.get("name") %></h1><button id="bid" class="btn btn-outline-success my-2 my-sm-0" style="float: right;">Bid Now</button><br/>
			<table>
				<tr>
					<td style="width: 50%;"><img class="img-thumbnail img-fluid" src="${pageContext.request.contextPath}/images/no-image-icon-23494.png" alt="" style="width: 400px; height: 400px; object-fit: contain;"></img></td>
					<td style="text-align: center; float: right; width: 50%;">
						<table>
							<col width = "50%;">
							<col width = "50%;">
							<tr>
								<td><h3>Seller</h3><hr></td>
							</tr>
							<tr class="subTable">
								<td><strong><%=auctionData.get("seller_name")%></strong></td>
							</tr>
							<tr>
								<td><h3>Highest Bid</h3><hr></td>
							</tr>
							<tr class="subTable">
								<td><strong id="maxBid">$<%=lead_bid%></strong></td>
							</tr>
							<tr> 
								<td><h3>Ends On</h3><hr></td>
							</tr>
							<tr class="subTable">
								<td><strong><%=auctionData.get("end_time")%></strong></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table>
				<tr>
					<td><strong>Condition</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("condition")%></td>
				</tr>
				
				<tr>
					<td><strong>Description</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("additional_comments") != null?"<p>" + auctionData.get("additional_comments") + "</p>" :"<small style=font-style:italic;>" + "There's nothing here..." + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Additional Condition Remarks</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("condition_remarks") != null?"<p>" + auctionData.get("condition_remarks") + "</p>" :"<small style=font-style:italic;>" + "There's nothing here..." + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Material</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("material") != null? auctionData.get("material") :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>	
				
				<tr>
					<td><strong>Brand</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("brand") != null? auctionData.get("brand") :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Color</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("color") != null? auctionData.get("color") :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
			</table>	
			<!-- Display if type Pants -->
			<table id="pantsTable" style="display: none;">
				<tr> 
					<td><strong>Waist</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("waist")%> inches</td>
				</tr>
				
				<tr>
					<td><strong>Length</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("length")%> inches</td>
				</tr>
				
				<tr>
					<td><strong>Fit</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("fit") != null? auctionData.get("fit")  : "<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Has Belt Loops?</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("has_belt_loops") != null? auctionData.get("has_belt_loops").contentEquals("1")? "Yes" : "No" : "<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
			</table>
			<!-- Display if type Shirts -->
			<table id="shirtsTable" style="display:none;">
				<tr>
					<td><strong>Size</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("size")%></td>
				</tr>
				
				<tr>
					<td><strong>Sleeve Type</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("long_sleeve") != null? auctionData.get("long_sleeve").contentEquals("1") ? "Long Sleeves"  : "Short Sleeves" : "<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Collared?</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("collar") != null? auctionData.get("collar").contentEquals("1") ? "Yes" : "No" :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Has Buttons?</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("buttons") != null? auctionData.get("buttons").contentEquals("1") ? "Yes" : "No" :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
			</table>
			<!-- Display if type Jackets -->
			<table id="jacketsTable" style="display: none;">
				<tr>
					<td><strong>Size</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("size")%></td>
				</tr>
				
				<tr>
					<td><strong>Water Resistant</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("water_resistant") != null? auctionData.get("water_resistant").contentEquals("1") ? "Yes"  : "No" : "<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Has a Hood?</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("hood") != null? auctionData.get("hood").contentEquals("1") ? "Yes" : "No" :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
				
				<tr>
					<td><strong>Insulated?</strong></td>
				</tr>
				<tr class="attrTable">
					<td><%=auctionData.get("insulated") != null? auctionData.get("insulated").contentEquals("1") ? "Yes" : "No" :"<small style=font-style:italic;>" + "N/A" + "</small>" %></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<!-- Bid Popup -->
<div class="modal" tabindex="-1" role="dialog" id="myModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Bid on <%=auctionData.get("name")%></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <!-- Bid Form -->
      <form id="bidForm">
      <div class="modal-body">
        <table id="bidTable">
        	<tr class="isRequired">
        		<td><label for="amount">Your Bid</label></td>
        	</tr>
        	<tr class="inputItems">
        		<td><input class="textInput" type="number" min="<%= (double) Math.round((lead_bid + 0.01)*100)/100 %>" step="0.01" placeholder="Min: $<%= (double) Math.round((lead_bid + 0.01)*100)/100  %>" name="amount" id="amount"></td>
        	</tr>
        </table>
        <!-- Loader -->
        <div class="d-flex justify-content-center">
      		<div class="spinner-border text-success" style="color: #28a745; display: none;" role="status" id="load">
  				<span class="sr-only">Loading...</span>
			</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-outline-success my-2 my-sm-0">Bid Now</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id ="close">Cancel</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- JavaScript -->
<% if(request.getSession().getAttribute("is_new_auction") != null){ if((int)request.getSession().getAttribute("is_new_auction")==1){%> <script>alert("Success! Welcome to your new auction! Click edit to change details");</script> <% request.getSession().setAttribute("is_new_auction", 0);}}%>
</body>
<script src="js/view_auction_scripts.js"></script>
<script>
window.onload = function(){
	/* if seller = user, make edit button instead of bid */
	var user = <%= request.getSession().getAttribute("user")%>;
	var seller = <%= auctionData.get("seller_is")%>;
	if(user == seller){
		var button = document.getElementById("bid");
		button.className = "btn btn-outline-info my-2 my-sm-0";
		button.innerHTML = "Edit";
		button.id = "edit";
		button.setAttribute.href = ""; // edit page TODO 
	}
	/* show attributes based on type */
	var type = "<%= auctionData.get("type") %>";
	switch(type){
	
	case "Shirts":
		document.getElementById("shirtsTable").style.display = "block";
		break;
	case "Pants":
		document.getElementById("pantsTable").style.display = "block";
		break;
	case "Jackets":
		document.getElementById("jacketsTable").style.display = "block";
	
	}

}
</script>
</html>