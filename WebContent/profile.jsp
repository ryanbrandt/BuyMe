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
<%@ include file='WEB-INF/navigation.jsp' %>
<%
	/* TODO overhaul this page to a 'user' folder and use a servlet to redirect */
	if(curSession.getAttribute("user") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!-- Content -->
<body>
	<div class="container" align="center" style="margin-top: 2em !important;">
		<div class="tab">
	  		<button class="tablinks" onclick="openTab(event, 'auctions')">My Auctions</button>
	  		<button class="tablinks" onclick="openTab(event, 'bids')">My Bids</button>
		</div>
		<div id="auctions" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet auctionTable = st.executeQuery("SELECT * FROM ((Auctions a LEFT OUTER JOIN Bids b ON a.highest_bid = b.bid_id) JOIN Clothing c ON a.item_is = c.product_id) WHERE a.seller_is = '"+curSession.getAttribute("user")+"'");

			while(auctionTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td width=100><b><%=auctionTable.getString("name")%></b></td>
					</tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>Name: <strong><%=auctionTable.getString("name")%></strong></td></tr>
						<tr><td>Item Type: <%=auctionTable.getString("type")%></td></tr>
						<tr><td>Condition: <%=auctionTable.getString("condition")%></td></tr>
						<tr><td>Brand: <%=auctionTable.getString("brand")%></td></tr>
						<tr><td>Material: <%=auctionTable.getString("material")%></td></tr>
						<tr><td>Color: <%=auctionTable.getString("color")%></td></tr>
						<tr><td>Start Time: <%=auctionTable.getString("start_time")%></td></tr>
						<tr><td>End Time: <%=auctionTable.getString("end_time")%></td></tr>
						<tr><td>Highest Bid: $<%=auctionTable.getString("amount")%></td></tr>
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
		
			ResultSet bidItemTable = st.executeQuery("SELECT DISTINCT for_auction FROM Bids WHERE from_user = '"+curSession.getAttribute("user")+"'");

			while(bidItemTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td id=<%=bidItemTable.getString("for_auction")%>>For AuctionID=<%=bidItemTable.getString("for_auction")%> </td>
					</tr></table>
				</button>
				<div class="panel">
					
					<%
					Statement st2 = con.createStatement();
					ResultSet bidTable = st.executeQuery("SELECT * FROM Bids " +
										"WHERE from_user = '" +curSession.getAttribute("user")+ 
										"' AND for_auction = '" + bidItemTable.getString("for_auction") + "'" );
					while(bidTable.next()){ %>
						<table>
							<tr id=<%=bidTable.getString("bid_id")%>>
								<td>amount: <%=bidTable.getString("amount")%></td>
								<td>timestamp: <%=bidTable.getString("timestamp")%></td>
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
</body>

<script src="js/tabdisplay_scripts.js"></script>

</html>

