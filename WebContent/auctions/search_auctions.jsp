<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> queryAuctions = new HashMap<Integer, String>();
	ArrayList<String> prodType = new ArrayList<String>();
	try{ 
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		// do query based on user's search query; right now it just matches against a product title, maybe do against description too
		ResultSet q = st.executeQuery("SELECT a.auction_id, c.type," + "c.`" + "name" + "`, MATCH (" + "`" + "name" + "`) AGAINST ('" +request.getSession().getAttribute("search_query") + "') AS title_relevance FROM BuyMe.Clothing AS c JOIN Auctions AS a ON item_is = product_id WHERE MATCH (" + "`" + "name" + "`) AGAINST ('" + request.getSession().getAttribute("search_query") + "') ORDER BY title_relevance DESC");
		// auction_id as key, product name as value
		while(q.next()){
			queryAuctions.put(q.getInt(1), q.getString(3));
			prodType.add(q.getString(2));
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
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/viewAuction.css">
<title>Results for '<%=request.getSession().getAttribute("search_query") %>'</title>
</head>
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<!-- Content --> 
<body>
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left"> 
			<h2>Results for '<%=request.getSession().getAttribute("search_query") %>'</h2><hr><br/>
			<table>
				<col width="20%">
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				int j = 0;
				for(Map.Entry<Integer, String> entry : queryAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">Active Auction</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue() %></h5>
								    <p class="card-text">Clothing: <%=prodType.get(j) %></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View Now</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 4){ %>
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