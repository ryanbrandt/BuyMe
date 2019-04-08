<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> queryAuctions = new HashMap<Integer, String>();
	try{ 
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		// do query based on user's search query; right now it just matches against a product title, maybe do against description too
		ResultSet q = st.executeQuery("SELECT auction_id," + "`" + "name" + "`, MATCH (" + "`" + "name" + "`) AGAINST ('" +request.getSession().getAttribute("search_query") + "') AS title_relevance FROM BuyMe.Clothing JOIN Auctions ON item_is = product_id WHERE MATCH (" + "`" + "name" + "`) AGAINST ('" + request.getSession().getAttribute("search_query") + "') ORDER BY title_relevance DESC");
		// auction_id as key, product name as value
		while(q.next()){
			queryAuctions.put(q.getInt(1), q.getString(2));
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
<title>Results for '<%=request.getSession().getAttribute("search_query") %>'</title>
</head>
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<!-- Content --> 
<body>
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left"> 
			<h2>Results for '<%=request.getSession().getAttribute("search_query") %>'</h2><br/>
			<table>
			<%
				for(Map.Entry<Integer, String> entry : queryAuctions.entrySet()){
			%>
					<tr class="attrTable">
						<td><a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>"><%=entry.getValue()%></a>
					</tr>
			<%
				}
			%>
		
			</table>
		</div>
	</div>
</div>


</body>
</html>