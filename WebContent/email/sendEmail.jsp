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
		String sender = (String) curSession.getAttribute("user");
		String recipient = request.getParameter("recipient");
		String subject = request.getParameter("subject");
		String email = request.getParameter("email");
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		
        
        q = st.executeQuery(
			"SELECT user_id FROM"
        );
        
        
        
        
		st.executeUpdate(
				"hello"
		);

		con.close();
		st.close();
	
	}catch(Exception e){
	
	}
	
%>