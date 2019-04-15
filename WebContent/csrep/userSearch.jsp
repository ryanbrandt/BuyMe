<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	HttpSession curSession = request.getSession(false); 
	if( request.getParameter("isReset").equals("0")){
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		ResultSet userTable = st.executeQuery(
				"SELECT user_id "+
				"FROM Users " +
				"WHERE display_name = '" + request.getParameter("userLookup") 
					+"' OR email = '" + request.getParameter("userLookup") +"'");
		
		if( userTable.next()){
			curSession.setAttribute("userLookupID", userTable.getString("user_id"));
		}else{
			curSession.setAttribute("userLookupID", "-1");
		}
		
	}else{
		curSession.setAttribute("userLookupID", null);
	}
%>