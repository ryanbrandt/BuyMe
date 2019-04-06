<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		
		String userLookup = request.getParameter("userLookup");
		
		ResultSet q = st.executeQuery(
					"SELECT display_name, email FROM( " +
						"SELECT display_name, email " +
						"FROM BuyMe.Users_End_Users " +
								"UNION " +
						"SELECT display_name, email " + 
						"FROM BuyMe.Users_Admin " +
							"UNION " +
						"SELECT display_name, email " + 
						"FROM BuyMe.Users_CS_Rep) AS tempTable " +
				"WHERE display_name = '" + userLookup + "' OR email = '" + userLookup + "'" 
		);
				
	}catch(Exception e){
		
	}
%>