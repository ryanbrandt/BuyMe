<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, javax.sql.*, java.util.*"%>

<% 
	/* Check registation credentials are available (e.g. no duplicate emails or display names) */
	try{
		// establish DB connection
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://buyme.cbjugyhqgonx.us-east-2.rds.amazonaws.com:3306/BuyMe", "root", "password");
		Statement st = con.createStatement();
		
		// get parameters 
		boolean isEmail = Boolean.parseBoolean(request.getParameter("isEmail"));
		String data = request.getParameter("data");
		ResultSet q;
		// do query, check email availability if isEmail, else check display name
		if(isEmail){
			q = st.executeQuery("SELECT * FROM Users_End_Users WHERE email='"+data+"'");
		} else {
			q = st.executeQuery("SELECT * FROM Users_End_Users WHERE display_name='"+data+"'");
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
