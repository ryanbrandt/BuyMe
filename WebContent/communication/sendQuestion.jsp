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
		
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		
 		String query =  "INSERT INTO BuyMe.Questions(asked_by, question_text, question_subject, timestamp) " +
				"VALUES ( '"+curSession.getAttribute("user")+ "', '"+ content + "', '"+subject+ "', '"+timestamp+"' )";
 		
		st.executeUpdate(query);
		
		con.close();
		st.close();
		
	}catch(Exception e){
		System.out.println("ERROR");
	}
	
%>