<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	/* Validate login or registration info */
	try{
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		
		// get shared parameters from login/register form
		boolean isLogin = Boolean.parseBoolean(request.getParameter("isLogin"));
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		ResultSet q;
		
		// validate information if log in, insert user into DB if registration
		if(isLogin){
			q = st.executeQuery("SELECT * FROM Users_End_Users UNION SELECT * FROM Users_Admin UNION SELECT * FROM Users_CS_Rep WHERE email='"+email+"' AND password='"+pass+"'");
			// q must be nonempty if information is correct, set session attribute user to current user's email
			if(q.next()){
				// this unlocks navbar buttons in navigation.jsp and will probably be useful in other contexts, should use user_id instead probably
				request.getSession().setAttribute("user", email);		
				
				request.getSession().setAttribute("userType", "end_user");
				ResultSet userType = st.executeQuery("SELECT * FROM Users_Admin WHERE email='"+email);
				if(userType.next()){
					request.getSession().setAttribute("userType", "admin");
				}else{
					userType = st.executeQuery("SELECT * FROM Users_CS_Rep WHERE email='"+email);
					if(userType.next()){
						request.getSession().setAttribute("userType", "cs_rep");
					}
				}
				
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
