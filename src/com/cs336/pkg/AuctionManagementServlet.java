package com.cs336.pkg;

import java.io.IOException;

import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AuctionManagementServlet
 * 
 * Servlet for managing DB records for Auctions Module
 * Functions:
 * 1) Creating new auction records (Clothing, Clothing Type and Auction Tuples)
 * 2) Managing existing auction records
 * 
 */
@WebServlet("/AuctionManagementServlet")
public class AuctionManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuctionManagementServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
			// manage or create based off method parameter
			switch(request.getParameter("method")) {
			// create new record
			case "c":
				// do stuff
				break;
			// manage existing record
			case "m":
				// do stuff
				
			}
		}
		catch(Exception e) {
			
		}
	}

}
