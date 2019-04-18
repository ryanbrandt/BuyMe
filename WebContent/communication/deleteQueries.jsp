<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		
 		String deleteFrom = "";
 		
 		if("1".equals(request.getParameter("isInbox"))){
 			deleteFrom =  "deletedReceiver";
 		}else{
 			deleteFrom = "deletedSender";
 		}
 		
 		String query = "";
 		switch(Integer.parseInt(request.getParameter("deleteFrom"))){
 			case 1: //inbox
 				query= "UPDATE Emails SET deletedReceiver='1' WHERE email_id='"+request.getParameter("id")+"'"; break;
 			case 2: //sent box
 				query= "UPDATE Emails SET deletedSender='1' WHERE email_id='"+request.getParameter("id")+"'"; break;
 			case 3: //unanswered question
 				query= "DELETE FROM Questions WHERE question_id='"+request.getParameter("id")+"'"; break;
 		}
 		
		st.executeUpdate(query);
		
		con.close();
		st.close();

	}catch(Exception e){
		System.out.println("ERROR");
	}
	
%>