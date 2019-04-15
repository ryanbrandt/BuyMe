<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Service Rep</title>

</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<link rel="stylesheet" href="css/tabdisplay.css">


<body>
<br><br>

<div>
	<table><tr>
		<td><input type="text" placeholder="display name or email" id="userLookup" required></td>
		<td><button id="searchButton">Search</button></td>
		<td><button id="resetButton">Reset</button></td>
	</tr></table>
</div>

<div>
<table>
	<tr>
	   <th>Display Name |</th>
	   <th>Email</th>
	</tr>
	<% 
	String user = (String) curSession.getAttribute("userLookupID");
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		ResultSet csTable;
		
		if(user == null){
			csTable = st.executeQuery( "SELECT display_name, email FROM Users");
		}else{
			csTable = st.executeQuery("SELECT display_name, email "+
									"FROM Users " +
									"WHERE user_id = '" + user + "'");
		}
		
		if( csTable.next()){
			do{%>
			 <tr>
	            <td><%=csTable.getString("display_name") %></td>
	            <td><%=csTable.getString("email") %></td>
	        </tr>
			<%}while(csTable.next());
		}else{
			curSession.setAttribute("userLookupID", null);%>
			<tr><td>no users found</td></tr>
			
		<%}
		con.close();
		st.close();
	}catch(Exception e){}%>

</table>
</div>


<div>
<%if( curSession.getAttribute("userLookupID") != null ){%>
	<p>
	<button id="resetPassword">Reset Password</button>
	</p>
	
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'auctions')">Auctions</button>
	  <button class="tablinks" onclick="openTab(event, 'bids')">Bids</button>
	</div>

	<div id="auctions" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet auctionTable = st.executeQuery("SELECT * FROM Auctions WHERE seller_is = '"+curSession.getAttribute("userLookupID")+"'");

			while(auctionTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td width=100 id=<%=auctionTable.getString("auction_id")%>>auction_id=<%=auctionTable.getString("auction_id")%></td>
					</tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td><button class="removeAuction">Remove Auction</button></td></tr>
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
		
			ResultSet bidItemTable = st.executeQuery("SELECT DISTINCT for_auction FROM Bids WHERE from_user = '"+curSession.getAttribute("userLookupID")+"'");

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
										"WHERE from_user = '" +curSession.getAttribute("userLookupID")+ 
										"' AND for_auction = '" + bidItemTable.getString("for_auction") + "'" );
					while(bidTable.next()){ %>
						<table>
							<tr id=<%=bidTable.getString("bid_id")%>>
								<td>amount: <%=bidTable.getString("amount")%></td>
								<td>timestamp: <%=bidTable.getString("timestamp")%></td>
								<td><button class=removebid>Remove bid</button>
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
<%}%>
</div>

<script src="js/csrep_scripts.js"></script>
<script src="js/tabdisplay_scripts.js"></script>

</body>
</html>

