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
			<h2 id="formHead">My Auctions</h2><br/>
			<table>
			<%
				for(Map.Entry<Integer, String> entry : ownedAuctions.entrySet()){
			%>
					<tr class="attrTable">
						<td><a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>"><%=entry.getValue()%></a>
					</tr>
			<%
				}
			%>
			</table>
				<a class="btn btn-outline-success my-2 my-sm-0" href="NavigationServlet?location=createAuction">Create a New Auction</a>
				<!-- Add list for auctions started and auctions bid on -->
		</div>
	</div>
</div>
</body>
</html>