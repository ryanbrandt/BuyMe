<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		
		st.executeUpdate("DELETE FROM Bids WHERE bid_id = " + request.getParameter("bidId") +";" );
		// update highest bid field, if the removed bid was a highest bid
		st.executeUpdate("UPDATE Auctions SET highest_bid = (SELECT bid_id FROM Bids WHERE for_auction = + " + request.getParameter("auctionId") + " AND amount = (SELECT MAX(amount) FROM Bids WHERE for_auction = " + request.getParameter("auctionId") + ")) WHERE auction_id = " + request.getParameter("auctionId"));

		con.close();
		st.close();
	
	}catch(Exception e){
	
	}
	
%>