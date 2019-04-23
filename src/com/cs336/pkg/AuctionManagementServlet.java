package com.cs336.pkg;

import java.awt.image.BufferedImage;
import java.lang.Object;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.sql.*;

import javax.imageio.ImageIO;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


/**
 * Servlet implementation class AuctionManagementServlet
 * 
 * Servlet for handling creating new auctions, bidding and editing existing auctions
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
			request.getSession().setAttribute("is_new_auction", 1);
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
			if(el.contentEquals("item_is") || el.contentEquals("seller_is") || el.contentEquals("min_price") || el.contentEquals("initial_price")) {
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
    
    /* dynamically builds an update query since not all form parameters required */
    public String buildUpdate(HttpServletRequest request, boolean allChar) {
    	String updateQuery = "";
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
    			updateQuery += isChar || allChar?  el + " = " + "'" + val + "'" + ",": el + " = " + Integer.parseInt(val) + ","; 
			}
    	}
    	if(updateQuery.length() > 0) {
    		updateQuery = updateQuery.substring(0, updateQuery.length()-1);
    	}
    	return updateQuery;
    }    
    
    /* handles executing auto bids */
    public void autoBid(Statement st, String auction_id) {
    	Map<Integer, Double> autoBids = new HashMap<Integer, Double>();
    	try {
    		double lastAmt = 0.00;
    		// get all associated active auto bids (is_exceeded = 0) into a map
    		ResultSet q = st.executeQuery("SELECT `user_id`, `limit` FROM BuyMe.Auto_Bids WHERE `auction_id` = " + auction_id + " AND `is_exceeded` = 0;");
    		while(q.next()) {
    			autoBids.put(q.getInt(1), q.getDouble(2));
    		}
    		if(autoBids.isEmpty()) { return; }
    		// base case, only one auto bid associated with this auction
    		int len = autoBids.size();
    		if(len == 1) {
    			int key = autoBids.keySet().iterator().next();
    			// if auto bid user == auction highest_bid user, return, else bid on their behalf
    			q = st.executeQuery("SELECT from_user, amount FROM BuyMe.Bids WHERE bid_id = (SELECT highest_bid FROM BuyMe.Auctions WHERE auction_id = " + auction_id + ");");
    			q.next();
    			if(q.getInt(1) == key) {
    				return;
    			} else {
    				lastAmt = q.getDouble(2) + 0.25 > autoBids.get(key) ? autoBids.get(key) : q.getDouble(2) + 0.25;
    				st.executeUpdate("INSERT INTO BuyMe.Bids(`from_user`, `for_auction`, `amount`)VALUES(" + key + "," + auction_id + "," + lastAmt + ");");
    			}
    		// if len > 1, build the query iteratively simulating auto bidding but really inserting all the bids at once
    		} else {
    			String bidVals = "";
    			int lastUser = 0;
    			Map<Integer, Double> exceeded = new HashMap<Integer, Double>();
    			while(len > 1) {
    				for(Map.Entry<Integer, Double> entry : autoBids.entrySet()) {
    					if(!exceeded.containsKey(entry.getKey())) {
    						if(entry.getValue() >= (lastAmt + 0.25)) {
	    						bidVals += "(" + entry.getKey() + "," + auction_id + "," + (lastAmt + 0.25) + "),";
	    						lastUser = entry.getKey();
	    						lastAmt += 0.25;
    						} else {
    							exceeded.put(entry.getKey(), entry.getValue());
    							len--;
    						}
    					}
    				}
    			}
    			// find the set difference between exceeded and autoBids (get the last, not yet exceeded auto bid)
    			int lastAutoUser = 0;
    			for(Map.Entry<Integer, Double> entry : autoBids.entrySet()) {
    				if(!exceeded.containsKey(entry.getKey())) {
    					lastAutoUser = entry.getKey();
    					break;
    				}
    			}
    			// make sure this auto bid gets the last bid so it is leader
    			if(lastUser != lastAutoUser) {
    				bidVals += "(" + lastAutoUser + "," + auction_id + ",";
    				// since they are last auto bid user, give them 25c higher or their limit
    				bidVals += autoBids.get(lastAutoUser) >= (lastAmt + 0.25) ? (lastAmt + 0.25) + ")," : autoBids.get(lastAutoUser) + "),";
    				lastAmt = autoBids.get(lastAutoUser) >= (lastAmt + 0.25) ? lastAmt + 0.25 : autoBids.get(lastAutoUser);
    			}
    			// do inserts all at once with bidVals
    			bidVals = bidVals.substring(0, bidVals.length()-1);
    			System.out.println(bidVals);
    			st.executeUpdate("INSERT INTO BuyMe.Bids(`from_user`, `for_auction` ,`amount`) VALUES " + bidVals + ";");
    			
    		}
    		// finally, set is_exceeded for all auto bids that were exceeded in this event
    		st.executeUpdate("UPDATE BuyMe.Auto_Bids SET `is_exceeded` = 1 WHERE `limit` <= " + lastAmt);
    		
    	
    	} catch(Exception e) {
    		System.out.println("Auto Bid err: " + e);
    	}
    	
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
			// manage or create or bid based off action parameter
			switch(request.getParameter("action")) {
			// create new clothing record
			case "c":
				// insert new clothing tuple, get its primary key and save it as a session attribute for the next steps
				String[] insertQuery = buildInsert(request);
				//System.out.println(insertQuery[2]);
				st.executeUpdate("INSERT INTO BuyMe.Clothing("+insertQuery[0]+")VALUES("+insertQuery[1]+")", Statement.RETURN_GENERATED_KEYS);
				ResultSet s = st.getGeneratedKeys();
				
				if(s.next()) {
					request.getSession().setAttribute("new_prod_id", s.getInt(1));
				}
				// do picture insert
				String myImage = request.getParameter("image");
				if(myImage != null && !myImage.contentEquals("null") && !myImage.contentEquals("")) {
					try {
						myImage = myImage.replaceAll("\\*", "\\+");
						System.out.println("pic found");
						String query = "UPDATE BuyMe.Clothing SET `image` = '" + myImage + "' WHERE product_id = " + request.getSession().getAttribute("new_prod_id");
						st.executeUpdate(query);
					}
					catch (Exception e) {
						System.out.println("PicError: " + e);
					}
				}
				else {
					//
				}
				// create associated type tuple, save its type as a session attribute for next steps
				switch(request.getParameter("type")) {
				
				case "Shirts":
					st.executeUpdate("INSERT INTO BuyMe.Shirts(shirts_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "s");
					break;
					
				case "Pants":
					st.executeUpdate("INSERT INTO BuyMe.Pants(pants_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "p");
					break;
					
				case "Jackets":
					st.executeUpdate("INSERT INTO BuyMe.Jackets(jackets_id)VALUES("+request.getSession().getAttribute("new_prod_id")+")");
					request.getSession().setAttribute("new_prod_type", "j");
					
				}
				break;
			
			// add attributes from type-specific form, if any added
			case "t":
				
				String updateQuery = buildUpdate(request, false);
				switch((String) request.getSession().getAttribute("new_prod_type")) {
				
				case "s":
					st.executeUpdate("UPDATE BuyMe.Shirts SET "+updateQuery+" WHERE shirts_id = "+request.getSession().getAttribute("new_prod_id")+";");
					break;
					
				case "j":
					st.executeUpdate("UPDATE BuyMe.Jackets SET "+updateQuery+" WHERE jackets_id = "+request.getSession().getAttribute("new_prod_id")+";");
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
				st.executeUpdate(q, Statement.RETURN_GENERATED_KEYS);
				// set auction_id since user gets redirected to their new auction; this can be updated whenever a user clicks on an auction to view
				ResultSet auctionKey = st.getGeneratedKeys();
				if(auctionKey.next()) {
					request.getSession().setAttribute("auction_id", auctionKey.getInt(1));
				}
				
				break;
			// edit an already existing auction/clothing item 
			case "e":
				String editQuery = buildUpdate(request, true);
				if(!editQuery.isEmpty()) {
					st.executeUpdate("UPDATE BuyMe.Auctions JOIN BuyMe.Clothing ON item_is = product_id SET "+editQuery+" WHERE auction_id = "+request.getSession().getAttribute("auction_id")+";");
				}
				break; 
			// bid on an existing auction
			case "b":
				st.executeUpdate("INSERT INTO BuyMe.Bids(`from_user`, `for_auction`, `amount`)VALUES(" + request.getSession().getAttribute("user") + "," + request.getSession().getAttribute("auction_id") + "," + request.getParameter("amount") + ")");
				// handle auto bidding that this event triggers
				autoBid(st, (String) request.getSession().getAttribute("auction_id"));
				// send back amount bid to confirm
				response.getWriter().write(request.getParameter("amount"));	
				break;
			// configure auto-bidding on an existing auction
			case "ab":
				// if auto bid for user/auction already exists, just update it, else, create new
				ResultSet autoBid = st.executeQuery("SELECT * FROM BuyMe.Auto_Bids WHERE user_id = " + request.getSession().getAttribute("user") + " AND auction_id = " + request.getSession().getAttribute("auction_id") + ";");
				if(autoBid.next()) {
					st.executeUpdate("UPDATE BuyMe.Auto_Bids SET `limit` = " + request.getParameter("limit") + ", `is_exceeded` = 0 WHERE user_id = " + request.getSession().getAttribute("user") + " AND auction_id = " + request.getSession().getAttribute("auction_id") + ";");
				} else {
					st.executeUpdate("INSERT INTO BuyMe.Auto_Bids(`user_id`, `auction_id`, `limit`)VALUES(" + request.getSession().getAttribute("user") + "," + request.getSession().getAttribute("auction_id") + "," + request.getParameter("limit") + ");");
				}
				// after user configures auto bids, send in first bid
				autoBid = st.executeQuery("SELECT amount, from_user FROM BuyMe.Bids WHERE bid_id = (SELECT highest_bid FROM BuyMe.Auctions WHERE auction_id = " + request.getSession().getAttribute("auction_id") + ");");
				double newAmt = 0.00;
				double lim = Double.parseDouble(request.getParameter("limit"));
				// check if auction has a highest bid
				if(autoBid.next()) {
					newAmt = autoBid.getDouble(1) + 0.25 <= lim? autoBid.getDouble(1) + 0.25: lim;
					// if user not already the auction bid leader, bid on behalf
					if(autoBid.getInt(2) != (int) request.getSession().getAttribute("user")) {
						st.executeUpdate("INSERT INTO BuyMe.Bids(`from_user`, `for_auction`, `amount`)VALUES(" + request.getSession().getAttribute("user") + "," + request.getSession().getAttribute("auction_id") + "," + newAmt + ");");
					}
				// if not, bid on users behalf
				} else {
					autoBid = st.executeQuery("SELECT initial_price FROM BuyMe.Auctions WHERE auction_id = " + request.getSession().getAttribute("auction_id") + ";");
					if(autoBid.next()) {
						newAmt = autoBid.getDouble(1) + 0.25 <= lim? autoBid.getDouble(1) + 0.25: lim;
						// first bid on auction 
						st.executeUpdate("INSERT INTO BuyMe.Bids(`from_user`, `for_auction`, `amount`)VALUES(" + request.getSession().getAttribute("user") + "," + request.getSession().getAttribute("auction_id") + "," + newAmt + ");");
					}
				}
				// handle any auto bidding the new insert triggered
				autoBid(st, (String) request.getSession().getAttribute("auction_id"));
				
			}
			st.close();
			con.close();
		}
		catch(Exception e) {
			System.out.println(e);
		}
	}

}