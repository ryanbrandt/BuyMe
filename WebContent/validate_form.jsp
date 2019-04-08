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
		boolean isCSRep = Boolean.parseBoolean(request.getParameter("isCSRep"));
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		ResultSet q;
		// validate information if log in, insert user into DB if registration
		if(isLogin){
			q = st.executeQuery(  
						"SELECT email, password FROM( " +
							"SELECT email, password " +
							"FROM BuyMe.Users_End_Users " +
								"UNION " +
							"SELECT email, password " + 
							"FROM BuyMe.Users_Admin " +
								"UNION " +
							"SELECT email, password " + 
							"FROM BuyMe.Users_CS_Rep) AS AllUsers " +
						"WHERE email = '" + email + "' AND password = '" + pass + "'" );
			if(q.next()){
				// assume end user, identify end users by user_id	
				ResultSet userType = st.executeQuery("SELECT user_id FROM Users_End_Users WHERE email = " + "'" + email + "'");
				if(userType.next()){
					request.getSession().setAttribute("user", userType.getInt(1));
					request.getSession().setAttribute("userType", "end_user");
				// else check if admin, identify by admin_id
				} else {
					userType = st.executeQuery("SELECT admin_id FROM Users_Admin WHERE email='" +email+ "'");
					if(userType.next()){
						request.getSession().setAttribute("user", userType.getInt(1));
						request.getSession().setAttribute("userType", "admin");
					// else check if cs rep, identify by cs_rep_id
					}else{
						userType = st.executeQuery("SELECT cs_rep_id FROM Users_CS_Rep WHERE email='"+email+ "'");
						if(userType.next()){
							request.getSession().setAttribute("user", userType.getInt(1));
							request.getSession().setAttribute("userType", "cs_rep");
						}
					}
				}
				
				} else {
				// send random data back to AJAX so we know invalid credentials
				out.print("f");
				out.flush();
			}
		} else {
			String displayName = request.getParameter("displayName");
			if(isCSRep){
				st.executeUpdate("INSERT INTO Users_CS_Rep(email, password, display_name)VALUES('"+email+"', '"+pass+"', '"+displayName+"')");
			}else{
				st.executeUpdate("INSERT INTO Users_End_Users(email, password, display_name)VALUES('"+email+"', '"+pass+"', '"+displayName+"')");
			}
		}
		
	}
	catch(Exception e){
		// console.log(data) in login.jsp if you need to debug
		out.println("Error: " + e);
		out.flush();
	}


%>
