<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		
		HttpSession curSession = request.getSession(false); 
		String user = (String) curSession.getAttribute("userLookup");
		
		//System.out.println("16" + user);
		
		st.executeUpdate(
				"UPDATE Users " +
				"SET password = 'password' " +
				"WHERE email = '" + user + "' OR display_name =" + "'" +user+ "'"
				
		);

		con.close();
		st.close();
	
	}catch(Exception e){
	
	}
	
%>