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
			q = st.executeQuery(
					"SELECT * FROM( " +
							"SELECT email " +
							"FROM BuyMe.Users_End_Users " +
								"UNION " +
							"SELECT email " + 
							"FROM BuyMe.Users_Admin " +
								"UNION " +
							"SELECT email " + 
							"FROM BuyMe.Users_CS_Rep) AS AllUsers " +
						"WHERE email = '" + data + "'");
					
					//"SELECT * FROM Users_End_Users WHERE email='"+data+"'");
		} else {
			q = st.executeQuery(
					"SELECT * FROM( " +
							"SELECT display_name  " +
							"FROM BuyMe.Users_End_Users " +
								"UNION " +
							"SELECT display_name " + 
							"FROM BuyMe.Users_Admin " +
								"UNION " +
							"SELECT display_name " + 
							"FROM BuyMe.Users_CS_Rep) AS AllUsers " +
						"WHERE display_name = '" + data + "'");
					
					//"SELECT * FROM Users_End_Users WHERE display_name='"+data+"'");
		}
		// if q.next(), tuple exists with this credential, pass f back to AJAX to signal unavailable
		if(q.next()){
			out.println("f");
			out.flush();
		}
		
	}
	catch(Exception e){
		// console.log(data) in login.jsp if you need to debug
		out.println("Error: " + e);
		out.flush();
	}
	
%>
