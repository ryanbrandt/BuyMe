package com.cs336.pkg;

import java.io.IOException;

import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UserServlet
 * 
 * Handles user settings/profile updates
 * 
 */
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement st = con.createStatement();
			
			switch(request.getParameter("action")) {
			// verify password for settings
			case "c":
				ResultSet q = st.executeQuery("SELECT password FROM Users WHERE `user_id` = " + request.getSession().getAttribute("user"));
				// if there is a tuple, correct pass, send data back
				q.next();
				if(q.getString(1).contentEquals(request.getParameter("password"))) {
					response.getWriter().write("1");
				} 
				q.close();
				break;
			// delete user account
			case "d":
				st.executeUpdate("DELETE FROM Users WHERE `user_id` = " + request.getParameter("user_id"));
				break;
			// update user password
			case "u":
				st.executeUpdate("UPDATE Users SET `password` = '" + request.getParameter("pass") + "' WHERE `user_id` = " + request.getParameter("user_id"));
				break;
			// delete user alerts
			case "a":
				st.executeUpdate("DELETE FROM Alerts WHERE alert_for = " + request.getParameter("userId"));
				break;
			
			} 
			
			st.close();
			con.close();
			
		} catch(Exception e) {
			System.out.println(e);
		}
	}

}
