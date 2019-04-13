<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> ownedAuctions = new HashMap<Integer, String>();
	try{  
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		// get all auctions user owns; product_id is key, name is value
		ResultSet q = st.executeQuery("SELECT a.auction_id, c.name FROM BuyMe.Auctions AS a JOIN BuyMe.Clothing AS c WHERE seller_is = " + request.getSession().getAttribute("user") + " AND a.item_is = c.product_id");
		while(q.next()){
			ownedAuctions.put(q.getInt(1), q.getString(2));
		}
		 
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
			<h2>My Auctions</h2><hr><br/>
			<table>
			<col width="20%">
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				for(Map.Entry<Integer, String> entry : ownedAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">You're Selling</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue() %></h5>
								    <p class="card-text">description here</p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">Go There</a>
								 </div>
							</div>
						</td>
			<% i++; if(i > 4){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
			<div class="container" align="center" style="margin-top: 2em !important;">
				<a class="btn btn-outline-success my-2 my-sm-0" href="NavigationServlet?location=createAuction">Create a New Auction</a>
			</div>
				<!-- Auctions Bid on List -->
				<h2>Auctions You Are Bidding On</h2><hr><br/>
		</div>
	</div>
</div>
</body>
</html>