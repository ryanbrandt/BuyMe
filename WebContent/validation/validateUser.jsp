<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		
		boolean isEmail = Boolean.parseBoolean(request.getParameter("isEmail"));
		String data = request.getParameter("data");
		ResultSet q = st.executeQuery("SELECT * FROM Users WHERE display_name = '" + data + "' OR email = '" + data + "'");
					
		if(q.next()){
			out.println("f");
			out.flush();
		}
		q.close();
		st.close();
		con.close();
	}
	catch(Exception e){
		out.println("Error: " + e);
		out.flush();
	}
%>
