<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, javax.sql.*, java.util.*"%>

<!-- JSP -->
<% 
	/* establish DB connection */
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://buyme.cbjugyhqgonx.us-east-2.rds.amazonaws.com:3306/BuyMe", "root", "password");
		Statement st = con.createStatement();
		
		/* check if the email/username is available */
		boolean isEmail = Boolean.parseBoolean(request.getParameter("isEmail"));
		String data = request.getParameter("data");
		ResultSet q;
		// do query
		if(isEmail){
			q = st.executeQuery("SELECT * FROM Users_End_Users WHERE email='"+data+"'");
		} else {
			q = st.executeQuery("SELECT * FROM Users_End_Users WHERE display_name='"+data+"'");
		}
		// if q.next(), is already taken, pass data back to AJAX to signal
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
