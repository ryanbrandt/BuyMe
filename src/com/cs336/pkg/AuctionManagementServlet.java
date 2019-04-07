package com.cs336.pkg;

import java.io.IOException;

import java.util.Enumeration;
import java.util.ArrayList;
import java.sql.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jasper.tagplugins.jstl.core.Out;

/**
 * Servlet implementation class AuctionManagementServlet
 * 
 * Servlet for managing DB records for Auctions Module
 * Functions:
 * 1) Creating new auction records (Clothing, Clothing Type and Auction Tuples)
 * 2) Managing existing auction records
 * 3) Redirecting after one of these actions
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
	 * 
	 * This should just be used for any redirects related to auction actions (creating, editing auctions)
	 * All other general redirects to hidden resources should be handled with NavigationServlet
	 * 
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// figure out where to redirect user based on parameter location
		RequestDispatcher dispatcher;
		switch(request.getParameter("location")) {
		// after creating auction, redirect to view individual auction view for new auction
		case "view":
			// save new_prod_id in auction_id, since thats what will be used to populate information in this view
			request.getSession().setAttribute("auction_id", request.getSession().getAttribute("new_prod_id"));
			dispatcher = getServletContext().getRequestDispatcher("/auctions/view_auction.jsp");
			dispatcher.forward(request, response);
			break;
	
		//more cases here, if needed
			
		}
	}
    
    /* dynamically builds an insert query since not all form parameters required; parameters at first index, values at second */
    public String[] buildInsert(HttpServletRequest request) {
    	String[] insertQuery = {"", ""}; 
    	Enumeration params = request.getParameterNames();
		while(params.hasMoreElements()) {
			boolean isNum = false;
			String el = (String) params.nextElement();
			String val = request.getParameter(el);
			// if a int attribute need to do query without ''
			if(el.contentEquals("item_is") || el.contentEquals("seller_is")) {
				isNum = true;
			} 
			
			if((el != null && !el.equals("action")) && !val.equals("")) {
				insertQuery[0] += "`" +  el + "`" + ",";
				insertQuery[1] += !isNum? "'" + val + "'" + "," : val + ",";
			}
		}
		insertQuery[0] = insertQuery[0].substring(0, insertQuery[0].length()-1);
		insertQuery[1] = insertQuery[1].substring(0, insertQuery[1].length()-1);
		return insertQuery;
    }
    
    /* dynamically builds an update query since not all form parameters required; parameters at first index, values at second */
    public String buildUpdate(HttpServletRequest request) {
    	String updateQuery = "";
    	String[] charAttributes = {"size", "fit"};
    	Enumeration params = request.getParameterNames();
    	while(params.hasMoreElements()) {
    		boolean isChar = false;
    		String el = (String) params.nextElement();
    		String val = request.getParameter(el);
    		// if a char attribute need to do query with ''
    		if(el.contentEquals("size") || el.contentEquals("fit")) {
    			isChar = true;
    		} 
    		if((el != null && !el.equals("action")) && !val.equals("")) {
    			updateQuery += isChar?  el + " = " + "'" + val + "'" + ",": el + " = " + Integer.parseInt(val) + ","; 
			}
    	}
    	updateQuery = updateQuery.substring(0, updateQuery.length()-1);
    	return updateQuery;
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
					st.executeUpdate("INSERT INTO BuyMe.Jackets(jacket_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "j");
					
				}
				break;
			
			// add attributes from type-specific form, if any added
			case "t":
				
				String updateQuery = buildUpdate(request);
				switch((String) request.getSession().getAttribute("new_prod_type")) {
				
				case "s":
					st.executeUpdate("UPDATE BuyMe.Shirts SET "+updateQuery+" WHERE shirt_id = "+request.getSession().getAttribute("new_prod_id")+";");
					break;
					
				case "j":
					st.executeUpdate("UPDATE BuyMe.Jackets SET "+updateQuery+" WHERE jacket_id = "+request.getSession().getAttribute("new_prod_id")+";");
					break;
					
				case "p":
					st.executeUpdate("UPDATE BuyMe.Pants SET "+updateQuery+" WHERE pants_id = "+request.getSession().getAttribute("new_prod_id")+";");
				
				}
				break;
				
			// finally, create associated auction tuple 
			case "a":
				String[] auctionQuery = buildInsert(request);
				String q = "INSERT INTO BuyMe.Auctions(`item_is`, `seller_is`";
				q += auctionQuery[0].isEmpty() ? ")VALUES(" + request.getSession().getAttribute("new_prod_id") + "," + request.getSession().getAttribute("user") + ")"
						: "," + auctionQuery[0] + ")VALUES(" + request.getSession().getAttribute("new_prod_id") + "," + request.getSession().getAttribute("user") + "," + auctionQuery[1] + ")";
				st.executeUpdate(q);
				
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