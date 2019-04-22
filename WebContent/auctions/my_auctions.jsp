<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> ownedAuctions = new HashMap<Integer, String>();
	Map<Integer, String> bidOnAuctions = new HashMap<Integer, String>();
	Map<Integer, String> wonAuctions = new HashMap<Integer, String>();
	Map<Integer, String> closedAuctions = new HashMap<Integer, String>();
	ArrayList<String> ownedType = new ArrayList<String>();
	ArrayList<String> wonType = new ArrayList<String>();
	ArrayList<String> bidOnType = new ArrayList<String>();
	ArrayList<String> closedType = new ArrayList<String>();
	try{  
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		// get all auctions user owns; auction_id is key, name is value
		ResultSet q = st.executeQuery("SELECT a.auction_id, c.name, c.type FROM BuyMe.Auctions AS a JOIN BuyMe.Clothing AS c WHERE seller_is = " + request.getSession().getAttribute("user") + " AND a.item_is = c.product_id AND a.is_active = 1");
		while(q.next()){
			ownedAuctions.put(q.getInt(1), q.getString(2));
			ownedType.add(q.getString(3));
		}
		// get all auctions user participating in; auction_id is key, name is value
		q = st.executeQuery("SELECT a.auction_id, c.name, c.type FROM Auctions AS a JOIN Clothing AS c ON a.item_is = c.product_id AND a.is_active = 1 AND a.auction_id IN(SELECT DISTINCT for_auction FROM Bids WHERE from_user = " + request.getSession().getAttribute("user") + " AND a.is_active = 1)");
		while(q.next()){
			bidOnAuctions.put(q.getInt(1), q.getString(2));
			bidOnType.add(q.getString(3));
		}
		// get all closed auctions user won
		q = st.executeQuery("SELECT a.auction_id, c.name, c.type FROM (Auctions AS a JOIN Clothing AS c ON a.item_is = c.product_id) WHERE a.is_active = 0 AND a.highest_bid IN(SELECT bid_id FROM Bids WHERE from_user = " + request.getSession().getAttribute("user") + ")");
		while(q.next()){
			wonAuctions.put(q.getInt(1), q.getString(2));
			wonType.add(q.getString(3));
		}
		// get all user's auctions that are closed
		q = st.executeQuery("SELECT a.auction_id, c.name, c.type FROM BuyMe.Auctions AS a JOIN BuyMe.Clothing AS c WHERE seller_is = " + request.getSession().getAttribute("user") + " AND a.item_is = c.product_id AND a.is_active = 0");
		while(q.next()){
			closedAuctions.put(q.getInt(1), q.getString(2));
			closedType.add(q.getString(3));
		}
		q.close();
		st.close();
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
<title>My Auctions</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Content -->
<body>   
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left"> 
			<!-- Owned Auctions List -->
			<h2>My Active Auctions</h2><hr><br/>
			<%= ownedAuctions.isEmpty()? "<small>Theres nothing here...</small>" : ""%>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				int j = 0;
				for(Map.Entry<Integer, String> entry : ownedAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card h-100" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">You're Selling</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue()%></h5>
								    <p class="card-text">Clothing: <%=ownedType.get(j)%></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
			<div class="container" align="center" style="margin-top: 2em !important;">
				<a class="btn btn-outline-success my-2 my-sm-0" href="NavigationServlet?location=createAuction">Create a New Auction</a>
			</div>
		</div>
	</div>
</div>
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left">
			<!-- Auctions Bid on List -->
			<h2>Active Auctions You Are Bidding On</h2><hr><br/>	
			<%= bidOnAuctions.isEmpty()? "<small>Theres nothing here...</small>" : ""%>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				i = 0;
				j = 0;
				for(Map.Entry<Integer, String> entry : bidOnAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card h-100" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">You Bid On</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue() %></h5>
								    <p class="card-text">Clothing: <%=bidOnType.get(j)%></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
		</div>
	</div>
</div>
<div class="container" style="margin-top: 2em !important;">
	<div class="row">
		<div class="col-lg" align="left">
		<!-- My Won Auctions list -->
			<h2>Auctions You Won</h2><hr><br/>
			<%= wonAuctions.isEmpty()? "<small>Theres nothing here...</small>" : ""%>	
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				i = 0;
				j = 0;
				for(Map.Entry<Integer, String> entry : wonAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card h-100" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">You Won</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue()%></h5>
								    <p class="card-text">Clothing: <%=wonType.get(j)%></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
		</div>
	</div>
</div>
<div class="container" style="margin-top: 2em !important; margin-bottom: 2em;">
	<div class="row">
		<div class="col-lg" align="left">
		<!-- My Won Auctions list -->
			<h2>Your Closed Auctions</h2><hr><br/>	
			<%= closedAuctions.isEmpty()? "<small>Theres nothing here...</small>" : ""%>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				i = 0;
				j = 0;
				for(Map.Entry<Integer, String> entry : closedAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card h-100" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">You Sold</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue()%></h5>
								    <p class="card-text">Clothing: <%=closedType.get(j)%></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
		</div>
	</div>
</div>
</body>
</html>