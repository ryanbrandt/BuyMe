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
				ResultSet q = st.executeQuery("SELECT * FROM Users WHERE user_id = " + request.getSession().getAttribute("user") + " AND password = " + request.getParameter("password"));
				// if there is a tuple, correct pass, send data back
				if(q.next()) {
					response.getWriter().write("1");
				} 
				break;
			// delete user account
			case "d":
				st.executeUpdate("DELETE FROM Users WHERE user_id = " + request.getParameter("user_id"));
				break;
			// update user password
			case "u":
				st.executeUpdate("UPDATE Users SET password = " + request.getParameter("pass") + " WHERE user_id = " + request.getParameter("user_id"));
				break;
			
			} 
			
		} catch(Exception e) {
			System.out.println(e);
		}
	}

}
