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
		
			ResultSet auctionTable = st.executeQuery("SELECT * FROM Auctions WHERE seller_is = '"+curSession.getAttribute("user")+"'");

			while(auctionTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td width=100 id=<%=auctionTable.getString("auction_id")%>>auction_id=<%=auctionTable.getString("auction_id")%></td>
					</tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>Start Time: </td></tr>
						<tr><td>End Time: </td></tr>
						<tr><td>Highest Bid: </td></tr>
						<tr><td>Details..</td></tr>
						
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

