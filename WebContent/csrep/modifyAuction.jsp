<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	try{
		//System.out.println("modify");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		
		String query = 
				"UPDATE Auctions a JOIN Clothing c ON a.item_is=c.product_id "+
				"SET "+
					"c.name= '" +request.getParameter("name")+"', "+
				    "c.condition= '" +request.getParameter("condition")+"', "+
				    "c.brand= '" +request.getParameter("brand")+"', "+
				    "c.material= '" +request.getParameter("material")+"', "+
				   	"c.color= '" +request.getParameter("color")+"', "+
				    "a.end_time= '" +request.getParameter("endtime")+"' "+
				"WHERE auction_id = '" +request.getParameter("auctionID")+"'";

		//System.out.println(query);
		
		st.executeUpdate(query);
		con.close();
		st.close();
		
	
	}catch(Exception e){
		System.out.println("broken");
	}	
%>