<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		ResultSet q;
		
		HttpSession curSession = request.getSession(false); 
		
		String answer = request.getParameter("answer");
		
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		
		st.executeUpdate("UPDATE Questions SET isAnswered = '1', answeredBy = '"+curSession.getAttribute("user")+"', answer = '"+answer+"' "+
					"WHERE (question_id = '"+ request.getParameter("questionID")+"')");			
		
		con.close();
		st.close();
		
	}catch(Exception e){
		System.out.println("ERROR");
	}
	
%>