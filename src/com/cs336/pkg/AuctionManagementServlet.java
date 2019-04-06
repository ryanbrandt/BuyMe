package com.cs336.pkg;

import java.io.IOException;

import java.util.Enumeration;
import java.util.ArrayList;
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
    
    /* dynamically builds an insert query since not all form parameters required; parameters at first index, values at second */
    public String[] buildInsert(HttpServletRequest request) {
    	String[] insertQuery = {"", ""}; 
    	Enumeration params = request.getParameterNames();
		while(params.hasMoreElements()) {
			String el = (String) params.nextElement();
			String val = request.getParameter(el);
			
			if((el != null && !el.equals("action")) && !val.equals("")) {
				insertQuery[0] += "`" +  el + "`" + ",";
				insertQuery[1] += "'" + val + "'" + ",";
			}
		}
		insertQuery[0] = insertQuery[0].substring(0, insertQuery[0].length()-1);
		insertQuery[1] = insertQuery[1].substring(0, insertQuery[1].length()-1);
		return insertQuery;
    }
    
    /* dynamically builds an update query since not all form parameters required; parameters at first index, values at second */
    public String[] buildUpdate(HttpServletRequest request) {
    	//TODO
    	return null;
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
			switch(request.getParameter("action")) {
			
			// create new clothing record
			case "c":
				// insert new clothing tuple, get its primary key and save it as a session attribute for the next steps
				String[] insertQuery = buildInsert(request);
				st.executeUpdate("INSERT INTO BuyMe.Clothing("+insertQuery[0]+")VALUES("+insertQuery[1]+")", Statement.RETURN_GENERATED_KEYS);
				ResultSet s = st.getGeneratedKeys();
				
				if(s.next()) {
					request.getSession().setAttribute("new_prod_id", s.getInt(1));
				}
				// create associated type tuple, save its type as a session attribute for next steps
				switch(request.getParameter("type")) {
				
				case "shirts":
					st.executeUpdate("INSERT INTO BuyMe.Shirts(shirt_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "s");
					break;
					
				case "pants":
					st.executeUpdate("INSERT INTO BuyMe.Pants(pants_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "p");
					break;
					
				case "jackets":
					st.executeUpdate("INSERT INTO BuyMe.Jacket(jacket_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "j");
					
				}
			
			//TODO add fields from type-specific form, if any added
			case "t":
				
				switch((String) request.getSession().getAttribute("new_prod_type")) {
				
				case "s":
					
					break;
					
				case "j":
					
					break;
					
				case "p":
					
				
				}
				break;
				
			//TODO edit an already existing auction/clothing/type 
			case "e":
				
			}
		}
		catch(Exception e) {
			System.out.println(e);
		}
	}

}
