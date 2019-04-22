<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link type="stylesheet" href="css/master.css">
<link rel="stylesheet" href="css/tabdisplay.css"> 
<title>My Profile</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<%
	/* TODO overhaul this page to a 'user' folder and use a servlet to redirect */
	if(curSession.getAttribute("user") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!-- Content -->
<body>
	<div class="container" align="center" style="margin-top: 2em !important;">
		
		<% 
			try{
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();	
				Statement st = con.createStatement();
				
				ResultSet userTable;
				
				if(curSession.getAttribute("userLookupID") == null){
					curSession.setAttribute("userLookupID", curSession.getAttribute("user"));
				}
				userTable = st.executeQuery("Select display_name From Users Where user_id = '"+curSession.getAttribute("userLookupID")+"'");
				if(userTable.next()){%>
					<strong> User: 
						<%=userTable.getString("display_name")%> 
					</strong>
				<%}
			}catch(Exception e){
			}%>
	

		<table style="margin-bottom: 0.5em;">
			<tr>
				<td><input style="margin-right:2px;" class="form-control" type="text" placeholder="display name or email" id="userLookup" required></td>
				<td><button style="margin-right:2px;" class="form-control" id="searchButton">Search</button></td>
				<td><button class="form-control" id="resetButton">Reset</button></td>
			</tr>
		</table>

		<div class="tab">
	  		<button class="tablinks" onclick="openTab(event, 'auctions')">Auctions</button>
	  		<button class="tablinks" onclick="openTab(event, 'bids')">Bids</button>
		</div>
		<div id="auctions" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet auctionTable = st.executeQuery("SELECT * FROM ((Auctions a LEFT OUTER JOIN Bids b ON a.highest_bid = b.bid_id) JOIN Clothing c ON a.item_is = c.product_id) WHERE a.seller_is = '"+curSession.getAttribute("userLookupID")+"'");

			while(auctionTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td width=100><strong><%=auctionTable.getString("name")%></strong></td>
					</tr></table>
				</button>
				<div class="panel" align="left">
					<table>
						<tr><td>Name: <strong><%=auctionTable.getString("name")%></strong></td></tr>
						<tr><td>Item Type: <%=auctionTable.getString("type")%></td></tr>
						<tr><td>Condition: <%=auctionTable.getString("condition")%></td></tr>
						<tr><td>Brand: <%=auctionTable.getString("brand")%></td></tr>
						<tr><td>Material: <%=auctionTable.getString("material")%></td></tr>
						<tr><td>Color: <%=auctionTable.getString("color")%></td></tr>
						<tr><td>Start Time: <%=auctionTable.getString("start_time")%></td></tr>
						<tr><td>End Time: <%=auctionTable.getString("end_time")%></td></tr>
						<tr><td>Highest Bid: <%=auctionTable.getString("amount") != null ? "$" + auctionTable.getString("amount") : "No bids yet" %></td></tr>
						<tr><td><a class="btn btn-primary" href="NavigationServlet?location=view&id=<%=auctionTable.getInt("auction_id")%>">Go There</a></td></tr>
					</table>
				</div>
			<%}
		con.close();
		st.close();
		}catch(Exception e){
		}%>
	</div>

	<div id="bids" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet bidItemTable = st.executeQuery("SELECT DISTINCT for_auction, name FROM Auctions a JOIN Bids b ON b.for_auction=a.auction_id JOIN Clothing c ON c.product_id=a.item_is WHERE from_user = '"+curSession.getAttribute("userLookupID")+"'");

			while(bidItemTable.next()){ %>
				<button class="accordion" id=<%=bidItemTable.getString("for_auction")%>>
					<table><tr> 
					 	<td width="500"><strong><%=bidItemTable.getString("name")%></strong></td>
					 	<td>(auction#<%=bidItemTable.getString("for_auction")%>)</td>
					</tr></table>
				</button>
				<div class="panel">
					<a style="margin-bottom: 1em;" class="btn btn-primary" href="NavigationServlet?location=view&id=<%=bidItemTable.getInt("for_auction")%>">Go There</a>
					<%
					Statement st2 = con.createStatement();
					ResultSet bidTable = st.executeQuery("SELECT * FROM Bids " +
										"WHERE from_user = '" +curSession.getAttribute("userLookupID")+ 
										"' AND for_auction = '" + bidItemTable.getString("for_auction") + "' ORDER BY timestamp DESC" );
					while(bidTable.next()){ %>
						<table>
							<tr id=<%=bidTable.getString("bid_id")%>>
								<td width="300"><strong>Time</strong>: <%=bidTable.getString("timestamp")%></td>
								<td width="200"><strong>Amount</strong>: $<%=bidTable.getString("amount")%></td>
							</tr>
						</table>
					<% }%>	
				</div>
				
			<%}
		con.close();
		st.close();
		}catch(Exception e){
		}%>
	</div>
</div>
<script src="js/tabdisplay_scripts.js"></script>
<script src="js/csrep_scripts.js"></script>
<script>
	window.onload = function(){
		openTab(event, 'auctions');
	}
</script>
</body>
</html>