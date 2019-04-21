<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 
	/* Check registation credentials are available (e.g. no duplicate emails or display names) */
	try{
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		 
		Statement st = con.createStatement();
		
		// get parameters 
		boolean isEmail = Boolean.parseBoolean(request.getParameter("isEmail"));
		String data = request.getParameter("data");
		ResultSet q;
		// do query, check email availability if isEmail, else check display name
		if(isEmail){
			q = st.executeQuery("SELECT * FROM Users WHERE email = '" + data + "'");
					
		} else {
			q = st.executeQuery("SELECT * FROM Users WHERE display_name = '" + data + "'");
					
		}
		// if q.next(), tuple exists with this credential, pass f back to AJAX to signal unavailable
		if(q.next()){
			out.println("f");
			out.flush();
		}
		q.close();
		st.close();
		con.close();
	}
	catch(Exception e){
		// send error to ajax
		out.println("Error: " + e);
		out.flush();
	}
	
%>
