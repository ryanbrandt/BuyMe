<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, javax.sql.*, java.util.*"%>

<%
	/* Validate login or registration info */
	try{
		// establish DB connection
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://buyme.cbjugyhqgonx.us-east-2.rds.amazonaws.com:3306/BuyMe", "root", "password");
		Statement st = con.createStatement();
		
		// get shared parameters from login/register form
		boolean isLogin = Boolean.parseBoolean(request.getParameter("isLogin"));
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		ResultSet q;
		
		// validate information if log in, insert user into DB if registration
		if(isLogin){
			q = st.executeQuery("SELECT * FROM Users_End_Users WHERE email='"+email+"' AND password='"+pass+"'");
			// q must be nonempty if information is correct, set session attribute user to current user's email
			if(q.next()){
				// this unlocks navbar buttons in navigation.jsp and will probably be useful in other contexts, should use user_id instead probably
				request.getSession().setAttribute("user", email);
			} else {
				// send data back to AJAX so we know invalid credentials
				out.print("f");
				out.flush();
			}
		} else {
			String displayName = request.getParameter("displayName");
			st.executeUpdate("INSERT INTO Users_End_Users(email, password, display_name)VALUES('"+email+"', '"+pass+"', '"+displayName+"')");
		}
		
	}
	catch(Exception e){
		// console.log(data) in login.jsp if you need to debug
		out.println("Error: " + e);
		out.flush();
	}


%>
