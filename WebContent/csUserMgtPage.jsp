<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>User Account Management</title>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<link rel="stylesheet" href="css/tabdisplay.css">
</head>
<body>
<div class="container" style="margin-top: 2em !important;">
	<div class="row">
		<div class="col-lg" align="center">
			<table style="margin-bottom: 0.5em;">
				<tr>
					<td><input style="margin-right:2px;" class="form-control" type="text" placeholder="display name or email" id="userLookup" required></td>
					<td><button style="margin-right:2px;" class="form-control" id="searchButton">Search</button></td>
					<td><button class="form-control" id="resetButton">Reset</button></td>
				</tr>
			</table>	
			<table>
				<tr>
			  	 	<td align="center"><strong>Display Name</strong></td>
			   		<td align="center"><strong>Email</strong></td>
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
				
				if(csTable.next()){
					do { %>
					 <tr>
			            <td><a class="btn btn-link" style="color: rgb(88, 142, 165);"onclick="$('#userLookup').val('<%=csTable.getString("display_name")%>'); $('#searchButton').click();"><%=csTable.getString("display_name")%></a></td>
			            <td align="center"><%=csTable.getString("email") %></td>
			        </tr>
					<% } while(csTable.next());
				} else {
					curSession.setAttribute("userLookupID", null);%>
					<tr><td>no users found</td></tr>
					
			  <%}
				csTable.close();
				con.close();
				st.close();
			} catch(Exception e){
				System.out.println(e);
			}%>
		</table>
		</div>
	</div>
</div>
<div>
<%if(curSession.getAttribute("userLookupID") != null ){%>
	<p>
	<button style="margin-left: 5px;"class="btn btn-danger" id="resetPassword">Reset Password</button>
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
		
			ResultSet auctionTable = st.executeQuery("SELECT a.auction_id, a.start_time, a.end_time, c.name FROM (Auctions AS a JOIN Clothing AS c ON a.item_is = c.product_id) WHERE a.seller_is = " + curSession.getAttribute("userLookupID") + " AND a.is_active = 1;");
			while(auctionTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td width=100>auction_id=<%=auctionTable.getString("auction_id")%></td>
					</tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td><button value="<%=auctionTable.getString("auction_id")%>" class="form-control removeAuction">Remove Auction</button></td></tr>
						<tr><td>Start Time: <%=auctionTable.getString("start_time")%></td></tr>
						<tr><td>End Time: <%=auctionTable.getString("end_time")%></td></tr>
						<tr><td>Name: <strong><%=auctionTable.getString("name")%></strong></td></tr>
					</table>
				</div>
				
			<%}
		auctionTable.close();
		con.close();
		st.close();
		}catch(Exception e){
			System.out.println(e);
		}%>
	</div>

	<div id="bids" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet bidItemTable = st.executeQuery("SELECT DISTINCT for_auction FROM Bids JOIN Auctions ON for_auction = auction_id WHERE from_user = '"+curSession.getAttribute("userLookupID")+"' AND is_active = 1;");

			while(bidItemTable.next()){ %>
				<button class="accordion">
					<table><tr> 
					 	<td id="<%=bidItemTable.getString("for_auction")%>">For AuctionID=<%=bidItemTable.getString("for_auction")%> </td>
					</tr></table>
				</button>
				<div class="panel">
					
					<%
					Statement st2 = con.createStatement();
					ResultSet bidTable = st.executeQuery("SELECT bid_id, amount, timestamp, auction_id FROM Bids JOIN Auctions ON for_auction = auction_id " +
										"WHERE from_user = '" +curSession.getAttribute("userLookupID")+ 
										"' AND for_auction = '" + bidItemTable.getString("for_auction") + "' AND is_active = 1 ORDER BY timestamp DESC;" );
					%>
					<table>
					<col width="33%">
					<col width="33%">
					<col width="33%">
					<%while(bidTable.next()){ %>
							<tr style="margin-bottom: 0.5em;">
								<td>Amount: <%=bidTable.getString("amount")%></td>
								<td>Timestamp: <%=bidTable.getString("timestamp")%></td>
								<td align="center"><button value="<%=bidTable.getString("bid_id") + "," + bidTable.getString("auction_id")%>" class="form-control removebid" style="width: 50%;">Remove Bid</button>
							</tr>
					<% } %>	
					</table>
				</div>
				
			<% }
		bidItemTable.close();
		con.close();
		st.close();
		} catch(Exception e){
			System.out.println(e);
		} %>
	</div>
<%}%>
</div>
<script src="js/csrep_scripts.js"></script>
<script src="js/tabdisplay_scripts.js"></script>
</body>
</html>