<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> queryAuctions = new HashMap<Integer, String>();
	ArrayList<String> prodType = new ArrayList<String>();
	ArrayList<Integer> ordering = new ArrayList<Integer>();
	try{ 
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		ResultSet q;
		// do query based on user's search query; right now it just matches against a product title, maybe do against description too
		if(request.getSession().getAttribute("adv") != null){
			String query = 
					"SELECT a.auction_id, c.type," + "c.`" + "name" + "`, " + 
						"MATCH (" + "`" + "name" + "`) AGAINST ('" +
							request.getSession().getAttribute("search_query") + 
						"') AS title_relevance, a.item_is, a.seller_is, a.highest_bid, a.min_price, c.condition, if(b.amount is null,a.min_price,b.amount) " + 
					"FROM BuyMe.Clothing AS c " +
					"JOIN BuyMe.Auctions " +
						"AS a ON item_is = product_id " + 
					"LEFT JOIN BuyMe.Bids AS b ON bid_id = highest_bid "+
					"WHERE " + 
						"MATCH (" + "`" + "name" + "`) AGAINST ('" +
						request.getSession().getAttribute("search_query") + "') ";
			if(request.getSession().getAttribute("sortType") == null){
				query +="ORDER BY title_relevance DESC";
			}
			else{
				System.out.println("g");
				if(request.getSession().getAttribute("sortType").toString().equals("p")){
					query +="ORDER BY b.amount ";
					if(request.getSession().getAttribute("sortOrder").toString().equals("lo")){
						query += "ASC";
					}
					else{
						query += "DESC";
					}
				}
				else{
					query +="ORDER BY c.CONDITION ";
					if(request.getSession().getAttribute("sortOrder").toString().equals("lo")){
						query += "ASC";
					}
					else{
						query += "DESC";
					}
				}
			}
			System.out.println(query);
			q = st.executeQuery(query);
		}else{
			String query = 
					"SELECT a.auction_id, c.type," + "c.`" + "name" + "`, " + 
						"MATCH (" + "`" + "name" + "`) AGAINST ('" +
							request.getSession().getAttribute("search_query") + 
						"') AS title_relevance, a.item_is, a.seller_is, a.highest_bid, a.min_price, c.condition, if(b.amount is null,a.min_price,b.amount) " + 
					"FROM BuyMe.Clothing AS c " +
					"JOIN BuyMe.Auctions " +
						"AS a ON item_is = product_id " + 
					"LEFT JOIN BuyMe.Bids AS b ON bid_id = highest_bid "+
					"WHERE " + 
						"MATCH (" + "`" + "name" + "`) AGAINST ('" +
						request.getSession().getAttribute("search_query") + "') ";
			if(request.getSession().getAttribute("sortType") == null){
				query +="ORDER BY title_relevance DESC";
			}
			else{
				if(request.getSession().getAttribute("sortType").toString().equals("p")){
					query +="ORDER BY b.amount ";
					if(request.getSession().getAttribute("sortOrder").toString().equals("lo")){
						query += "ASC";
					}
					else{
						query += "DESC";
					}
				}
				else{
					query +="ORDER BY c.CONDITION ";
					if(request.getSession().getAttribute("sortOrder").toString().equals("lo")){
						query += "ASC";
					}
					else{
						query += "DESC";
					}
				}
			}
			
			System.out.println(query);
			q = st.executeQuery(query);
		}
		// auction_id as key, product name as value
		if(request.getSession().getAttribute("adv") != null){
			if(request.getSession().getAttribute("type").toString().contentEquals("j")){
				while(q.next()){
					Statement st2 = con.createStatement();
					ResultSet z;
					String water = request.getSession().getAttribute("water").equals("true") ? "1" : "0" ;
					String hood = request.getSession().getAttribute("hood").equals("true") ? "1" : "0" ;
					String insulated = request.getSession().getAttribute("insulated").equals("true") ? "1" : "0" ;
					String size = request.getSession().getAttribute("size").toString();
					String query = "SELECT j.jackets_id " +
									"FROM BuyMe.Jackets as j " +
									"WHERE j.jackets_id = " + q.getInt(5);
					if(water.equals("1"))
						query += " and j.water_resistant = " + water;
					if(hood.equals("1"))
						query += " and j.hood =" + hood;
					if(insulated.equals("1")) 
						query += " and j.insulated=" + insulated;
					switch(Integer.parseInt(size)){
					case 0: 
						query += " and (j.size=3 or j.size=1 or j.size=2 or j.size=4)";
						break;
					case 1:
						query += " and j.size=1";
						break;
					case 2:
						query += " and j.size=2";
						break;
					case 3:
						query += " and j.size=3";
						break;
					case 4:
						query += " and j.size=4";
						break;
					}
					z = st2.executeQuery(query);
					
					String query2 = "Select c.product_id " +
									"from BuyMe.Clothing as c " +
									"Where c.product_id = " + q.getInt(5)
									+ " and (c.brand like '" + request.getSession().getAttribute("brand") + "'";//add condition "new" "used" etc;
					if(request.getSession().getAttribute("brand").toString().contentEquals("%")){
						query2 += " or c.brand is null)";
					}
					else{
						query2 += ")";
					}
					Statement st3 = con.createStatement();
					ResultSet z2 = st3.executeQuery(query2);

					
					String query3 = "Select u.user_id " +
							"from BuyMe.Users as u " +
							"Where u.user_id = " + q.getInt(6)
							+ " and (u.display_name like '" + request.getSession().getAttribute("seller") + "'";
					if(request.getSession().getAttribute("seller").toString().contentEquals("%")){
						query3 += " or u.display_name is null)";
					}
					else{
						query3 += ")";
					}

					Statement st4 = con.createStatement();
					ResultSet z3 = st4.executeQuery(query3);
					
					boolean priceCheck = false;
					String priceString = request.getSession().getAttribute("price").toString();
					for(String price: priceString.split(",")){
						if(priceCheck == true) break;
						int itemPrice = q.getInt(7) != 0 ? q.getInt(7) : q.getInt(8);
						int p = Integer.parseInt(price);
						switch(p){
						case 0:
							priceCheck = true;
							break;
						case 1:
							if(itemPrice < 25) priceCheck = true;
							break;
						case 2:
							if(itemPrice >= 25 && itemPrice < 50) priceCheck = true;
							break;
						case 3:
							if(itemPrice >= 50 && itemPrice < 100) priceCheck = true;
							break;
						case 4:
							if(itemPrice >= 100 && itemPrice < 200) priceCheck = true;
							break;
						case 5:
							if(itemPrice >= 200 && itemPrice < 500) priceCheck = true;
							break;
						case 6:
							if(itemPrice >= 500) priceCheck = true;
							break;
						}
					}
					
					
					boolean conditionCheck = false;
					String conditionString = request.getSession().getAttribute("condition").toString();
					for(String condition: conditionString.split(",")){
						if(conditionCheck == true) break;
						int c = Integer.parseInt(condition);
						Statement conditionSt = con.createStatement();
						String conditionQuery = "SELECT c.product_id "+
												"from BuyMe.Clothing as c " +
												"WHERE c.product_id="+q.getInt(5);
						switch(c){
						//numbers are reversed here due to enum staging on database vs this code, sorry :(
						case 0:
							break;
						case 1:
							conditionQuery += " and c.condition = 4";
							break;
						case 2:
							conditionQuery += " and c.condition = 3";
							break;
						case 3:
							conditionQuery += " and c.condition = 2";
							break;
						case 4:
							conditionQuery += " and c.condition = 1";
							break;
						}
						System.out.println(conditionQuery);
						ResultSet conditionSet = conditionSt.executeQuery(conditionQuery);
						if(conditionSet.next()) conditionCheck = true;
					}
					
					if(z.next() && z2.next() && z3.next() && priceCheck && conditionCheck){
						queryAuctions.put(q.getInt(1), q.getString(3));
						prodType.add(q.getString(2));
						ordering.add(q.getInt(1));
					}
					st2.close();
					st3.close();
					st4.close();
				}
			}
			else if (request.getSession().getAttribute("type").toString().contentEquals("a")){
				while(q.next()){
					System.out.println(q.getInt(5) + request.getSession().getAttribute("brand").toString());
					String query2 = "Select c.product_id " +
									"from BuyMe.Clothing as c " +
									"Where c.product_id = " + q.getInt(5)
									+ " and (c.brand like '" + request.getSession().getAttribute("brand") + "'";//add condition "new" "used" etc;
					if(request.getSession().getAttribute("brand").toString().contentEquals("%")){
						query2 += " or c.brand is null)";
					}
					else{
						query2 += ")";
					}
					Statement st3 = con.createStatement();
					ResultSet z2 = st3.executeQuery(query2);

					
					String query3 = "Select u.user_id " +
							"from BuyMe.Users as u " +
							"Where u.user_id = " + q.getInt(6)
							+ " and (u.display_name like '" + request.getSession().getAttribute("seller") + "'";
					if(request.getSession().getAttribute("seller").toString().contentEquals("%")){
						query3 += " or u.display_name is null)";
					}
					else{
						query3 += ")";
					}

					Statement st4 = con.createStatement();
					ResultSet z3 = st4.executeQuery(query3);
					
					boolean priceCheck = false;
					String priceString = request.getSession().getAttribute("price").toString();
					for(String price: priceString.split(",")){
						if(priceCheck == true) break;
						int itemPrice = q.getInt(7) != 0 ? q.getInt(7) : q.getInt(8);
						int p = Integer.parseInt(price);
						switch(p){
						case 0:
							priceCheck = true;
							break;
						case 1:
							if(itemPrice < 25) priceCheck = true;
							break;
						case 2:
							if(itemPrice >= 25 && itemPrice < 50) priceCheck = true;
							break;
						case 3:
							if(itemPrice >= 50 && itemPrice < 100) priceCheck = true;
							break;
						case 4:
							if(itemPrice >= 100 && itemPrice < 200) priceCheck = true;
							break;
						case 5:
							if(itemPrice >= 200 && itemPrice < 500) priceCheck = true;
							break;
						case 6:
							if(itemPrice >= 500) priceCheck = true;
							break;
						}
					}
					
					boolean conditionCheck = false;
					String conditionString = request.getSession().getAttribute("condition").toString();
					for(String condition: conditionString.split(",")){
						if(conditionCheck == true) break;
						int c = Integer.parseInt(condition);
						Statement conditionSt = con.createStatement();
						String conditionQuery = "SELECT c.product_id "+
												"from BuyMe.Clothing as c " +
												"WHERE c.product_id="+q.getInt(5);
						switch(c){
						//numbers are reversed here due to enum staging on database vs this code, sorry :(
						case 0:
							break;
						case 1:
							conditionQuery += " and c.condition = 4";
							break;
						case 2:
							conditionQuery += " and c.condition = 3";
							break;
						case 3:
							conditionQuery += " and c.condition = 2";
							break;
						case 4:
							conditionQuery += " and c.condition = 1";
							break;
						}
						System.out.println(conditionQuery);
						ResultSet conditionSet = conditionSt.executeQuery(conditionQuery);
						if(conditionSet.next()) conditionCheck = true;
					}
					
					if(z2.next() && z3.next() && priceCheck && conditionCheck){
						ordering.add(q.getInt(1));
						queryAuctions.put(q.getInt(1), q.getString(3));
						prodType.add(q.getString(2));
					}
					
					st3.close();
					st4.close();
					
				}
			}
			else if (request.getSession().getAttribute("type").toString().contentEquals("s")){
				while(q.next()){
					Statement st2 = con.createStatement();
					ResultSet z;
					System.out.println("b:" + request.getSession().getAttribute("buttons"));
					String buttons = request.getSession().getAttribute("buttons").equals("true") ? "1" : "0" ;
					String sleeve = "";
					if(request.getSession().getAttribute("longsleeve").equals("true") && request.getSession().getAttribute("shortsleeve").equals("true")){
						sleeve = "both";
					}
					else if (request.getSession().getAttribute("longsleeve").equals("true")){
						sleeve = "ls";
					}
					else if (request.getSession().getAttribute("shortsleeve").equals("true")){
						sleeve = "ss";
					}
					else{
						sleeve = "none";
					}
					String collar = request.getSession().getAttribute("collar").equals("true") ? "1" : "0" ;
					String size = request.getSession().getAttribute("size").toString();
					String query = "SELECT s.shirts_id " +
									"FROM BuyMe.Shirts as s " +
									"WHERE s.shirts_id = " + q.getInt(5);
					if(buttons.equals("1"))
						query += " and s.buttons = " + buttons;
					if(sleeve.contentEquals("none"))
						query += " and s.long_sleeve = 1 and s.long_sleeve = 0";
					else if(sleeve.contentEquals("ls"))
						query += " and s.long_sleeve = 1";
					else if(sleeve.contentEquals("ss"))
						query += " and s.long_sleeve = 0";
					if(collar.equals("1")) 
						query += " and s.collar=" + collar;
					switch(Integer.parseInt(size)){
					case 0: 
						query += " and (s.size=3 or s.size=1 or s.size=2 or s.size=4)";
						break;
					case 1:
						query += " and s.size=1";
						break;
					case 2:
						query += " and s.size=2";
						break;
					case 3:
						query += " and s.size=3";
						break;
					case 4:
						query += " and s.size=4";
						break;
					}
					z = st2.executeQuery(query);
					
					String query2 = "Select c.product_id " +
									"from BuyMe.Clothing as c " +
									"Where c.product_id = " + q.getInt(5)
									+ " and (c.brand like '" + request.getSession().getAttribute("brand") + "'";//add condition "new" "used" etc;
					if(request.getSession().getAttribute("brand").toString().contentEquals("%")){
						query2 += " or c.brand is null)";
					}
					else{
						query2 += ")";
					}
					Statement st3 = con.createStatement();
					ResultSet z2 = st3.executeQuery(query2);

					
					String query3 = "Select u.user_id " +
							"from BuyMe.Users as u " +
							"Where u.user_id = " + q.getInt(6)
							+ " and (u.display_name like '" + request.getSession().getAttribute("seller") + "'";
					if(request.getSession().getAttribute("seller").toString().contentEquals("%")){
						query3 += " or u.display_name is null)";
					}
					else{
						query3 += ")";
					}

					Statement st4 = con.createStatement();
					ResultSet z3 = st4.executeQuery(query3);
					
					boolean priceCheck = false;
					String priceString = request.getSession().getAttribute("price").toString();
					for(String price: priceString.split(",")){
						if(priceCheck == true) break;
						int itemPrice = q.getInt(7) != 0 ? q.getInt(7) : q.getInt(8);
						int p = Integer.parseInt(price);
						switch(p){
						case 0:
							priceCheck = true;
							break;
						case 1:
							if(itemPrice < 25) priceCheck = true;
							break;
						case 2:
							if(itemPrice >= 25 && itemPrice < 50) priceCheck = true;
							break;
						case 3:
							if(itemPrice >= 50 && itemPrice < 100) priceCheck = true;
							break;
						case 4:
							if(itemPrice >= 100 && itemPrice < 200) priceCheck = true;
							break;
						case 5:
							if(itemPrice >= 200 && itemPrice < 500) priceCheck = true;
							break;
						case 6:
							if(itemPrice >= 500) priceCheck = true;
							break;
						}
					}
					
					
					boolean conditionCheck = false;
					String conditionString = request.getSession().getAttribute("condition").toString();
					for(String condition: conditionString.split(",")){
						if(conditionCheck == true) break;
						int c = Integer.parseInt(condition);
						Statement conditionSt = con.createStatement();
						String conditionQuery = "SELECT c.product_id "+
												"from BuyMe.Clothing as c " +
												"WHERE c.product_id="+q.getInt(5);
						switch(c){
						//numbers are reversed here due to enum staging on database vs this code, sorry :(
						case 0:
							break;
						case 1:
							conditionQuery += " and c.condition = 4";
							break;
						case 2:
							conditionQuery += " and c.condition = 3";
							break;
						case 3:
							conditionQuery += " and c.condition = 2";
							break;
						case 4:
							conditionQuery += " and c.condition = 1";
							break;
						}
						System.out.println(conditionQuery);
						ResultSet conditionSet = conditionSt.executeQuery(conditionQuery);
						if(conditionSet.next()) conditionCheck = true;
					}
					
					if(z.next() && z2.next() && z3.next() && priceCheck && conditionCheck){
						ordering.add(q.getInt(1));
						queryAuctions.put(q.getInt(1), q.getString(3));
						prodType.add(q.getString(2));
					}
					st2.close();
					st3.close();
					st4.close();
				}
			}
			else if (request.getSession().getAttribute("type").toString().equals("p")){
				while(q.next()){
					Statement st2 = con.createStatement();
					ResultSet z;
					String belt = request.getSession().getAttribute("belt").equals("true") ? "1" : "0" ;
					String length = request.getSession().getAttribute("length").toString();
					String waist = request.getSession().getAttribute("waist").toString();
					String fit = request.getSession().getAttribute("fit").toString();
					String query = "SELECT p.pants_id " +
									"FROM BuyMe.Pants as p " +
									"WHERE p.pants_id = " + q.getInt(5);
					if(belt.equals("1"))
						query += " and p.has_belt_loops=1";
					if(!length.equals("%"))
						query += " and p.length = " + length;
					if(!waist.equals("%"))
						query += " and p.waist = " + waist;
					switch(Integer.parseInt(fit)){
					case 0: 
						query += " and (p.fit=3 or p.fit=1 or p.fit=2 or p.fit=4)";
						break;
					case 1:
						query += " and p.fit=1";
						break;
					case 2:
						query += " and p.fit=2";
						break;
					case 3:
						query += " and p.fit=3";
						break;
					case 4:
						query += " and p.fit=4";
						break;
					}
					z = st2.executeQuery(query);
					
					String query2 = "Select c.product_id " +
									"from BuyMe.Clothing as c " +
									"Where c.product_id = " + q.getInt(5)
									+ " and (c.brand like '" + request.getSession().getAttribute("brand") + "'";//add condition "new" "used" etc;
					if(request.getSession().getAttribute("brand").toString().contentEquals("%")){
						query2 += " or c.brand is null)";
					}
					else{
						query2 += ")";
					}
					Statement st3 = con.createStatement();
					ResultSet z2 = st3.executeQuery(query2);

					
					String query3 = "Select u.user_id " +
							"from BuyMe.Users as u " +
							"Where u.user_id = " + q.getInt(6)
							+ " and (u.display_name like '" + request.getSession().getAttribute("seller") + "'";
					if(request.getSession().getAttribute("seller").toString().contentEquals("%")){
						query3 += " or u.display_name is null)";
					}
					else{
						query3 += ")";
					}

					Statement st4 = con.createStatement();
					ResultSet z3 = st4.executeQuery(query3);
					
					boolean priceCheck = false;
					String priceString = request.getSession().getAttribute("price").toString();
					for(String price: priceString.split(",")){
						if(priceCheck == true) break;
						int itemPrice = q.getInt(7) != 0 ? q.getInt(7) : q.getInt(8);
						int p = Integer.parseInt(price);
						switch(p){
						case 0:
							priceCheck = true;
							break;
						case 1:
							if(itemPrice < 25) priceCheck = true;
							break;
						case 2:
							if(itemPrice >= 25 && itemPrice < 50) priceCheck = true;
							break;
						case 3:
							if(itemPrice >= 50 && itemPrice < 100) priceCheck = true;
							break;
						case 4:
							if(itemPrice >= 100 && itemPrice < 200) priceCheck = true;
							break;
						case 5:
							if(itemPrice >= 200 && itemPrice < 500) priceCheck = true;
							break;
						case 6:
							if(itemPrice >= 500) priceCheck = true;
							break;
						}
					}
					
					
					boolean conditionCheck = false;
					String conditionString = request.getSession().getAttribute("condition").toString();
					for(String condition: conditionString.split(",")){
						if(conditionCheck == true) break;
						int c = Integer.parseInt(condition);
						Statement conditionSt = con.createStatement();
						String conditionQuery = "SELECT c.product_id "+
												"from BuyMe.Clothing as c " +
												"WHERE c.product_id="+q.getInt(5);
						switch(c){
						//numbers are reversed here due to enum staging on database vs this code, sorry :(
						case 0:
							break;
						case 1:
							conditionQuery += " and c.condition = 4";
							break;
						case 2:
							conditionQuery += " and c.condition = 3";
							break;
						case 3:
							conditionQuery += " and c.condition = 2";
							break;
						case 4:
							conditionQuery += " and c.condition = 1";
							break;
						}
						ResultSet conditionSet = conditionSt.executeQuery(conditionQuery);
						if(conditionSet.next()) conditionCheck = true;
					}
					
					if(z.next() && z2.next() && z3.next() && priceCheck && conditionCheck){
						ordering.add(q.getInt(1));
						queryAuctions.put(q.getInt(1), q.getString(3));
						prodType.add(q.getString(2));
					}
					st2.close();
					st3.close();
					st4.close();
				}
			}
		}
		else{
			while(q.next()){
				queryAuctions.put(q.getInt(1), q.getString(3));
				prodType.add(q.getString(2));
				ordering.add(q.getInt(1));
			}
		}
		System.out.println(ordering);
		
		st.close();
		con.close();
	}
	catch(Exception e){
		System.out.println("Exception: " + e);
	}
	boolean advanced = request.getSession().getAttribute("adv") != null;
	
%>
	<!DOCTYPE html>
	<html>
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/viewAuction.css">
<link rel="stylesheet" href= "css/search.css">
<title>Results for '<%=request.getSession().getAttribute("search_query") %>'</title>
</head>
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<!-- Content --> 
<body>
<!------ Include the above in your HEAD tag ---------->

<div class="container" style="margin-top: 2em !important;">   
	<div class="row">
		<div class="col-md-12">
            <div class="input-group" id="adv-search">
                <input type="text" class="form-control" id = "regSearch" value = "<%=request.getSession().getAttribute("search_query")%>" placeholder="Search for auctions" />
                <div class="input-group-btn">
                    <div class="btn-group" role="group">
                        <div class="dropdown dropdown-lg">
                            <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret">Options</span></button>
                            <div class="dropdown-menu dropdown-menu-right" role="menu">
                                <form class="form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="productType">Product Type</label>
                                    <select id = "productType" class="form-control" onclick="formSpecs();">
                                        <option value="All" <% if(request.getSession().getAttribute("type").toString().equals("a")){ %> selected <%}%> >All Products</option>
                                        <option value="Jackets" <% if(request.getSession().getAttribute("type").toString().equals("j")){ %> selected <%}%> >Jackets</option>
                                        <option value="Shirts" <% if(request.getSession().getAttribute("type").toString().equals("s")){ %> selected <%}%> >Shirts</option>
                                        <option value="Pants" <% if(request.getSession().getAttribute("type").toString().equals("p")){ %> selected <%}%> >Pants</option>
                                    </select>
                                  </div>
                                  <div id = "specifics"></div>
                                  <div class="form-group">
                                    <label for="priceRange">Price Range</label>
                                    <select multiple class="form-control" id = "priceRange">
                                        <option value="0" <% if(!advanced || request.getSession().getAttribute("price").toString().contains("0")){ %> selected <%}%> >Any Price</option>
                                        <option value="1" <% if(advanced && request.getSession().getAttribute("price").toString().contains("1")){ %> selected <%}%> >Below $25</option>
                                        <option value="2" <% if(advanced && request.getSession().getAttribute("price").toString().contains("2")){ %> selected <%}%> >$25-$49.99</option>
                                        <option value="3" <% if(advanced && request.getSession().getAttribute("price").toString().contains("3")){ %> selected <%}%> >$50-$99.99</option>
                                        <option value="4" <% if(advanced && request.getSession().getAttribute("price").toString().contains("4")){ %> selected <%}%> >$100-$199.99</option>
                                        <option value="5" <% if(advanced && request.getSession().getAttribute("price").toString().contains("5")){ %> selected <%}%> >$200-$499.99</option>
                                        <option value="6" <% if(advanced && request.getSession().getAttribute("price").toString().contains("6")){ %> selected <%}%> >$500+</option>
                                    </select>
                                  </div>
                                  <div class="form-group">
                                    <label for="seller">Seller Name</label>
                                    <input class="form-control" id="seller" type="text" value = "<%=(!advanced || request.getSession().getAttribute("seller").toString().equals("%")) ? "" : request.getSession().getAttribute("seller").toString() %>"/>
                                  </div>
                                  <div class="form-group">
                                    <label for="contain">Brand Name</label>
                                    <input class="form-control" id="brand" type="text" value = "<%=(!advanced || request.getSession().getAttribute("brand").toString().equals("%")) ? "" : request.getSession().getAttribute("brand").toString() %>"/>
                                  </div>
                                  <div class="form-group">
                                    <label for="condition">Condition</label>
                                    <select multiple class="form-control" id = "condition">
                                        <option value="0" selected>Any Condition</option>
                                        <option value="1">New</option>
                                        <option value="2">Like New</option>
                                        <option value="3">Good</option>
                                        <option value="4">Acceptable</option>
                                    </select>
                                  </div>
                                  <button type="button" class="btn btn-primary" onclick="advSearch();">Advanced Search</button>
                                </form>
                            </div>
                        </div>
                        <button type="button" class="btn btn-primary" onclick ="regSearch();">Search</button>
                    </div>
                </div>
            </div>
          </div>
        </div>
	</div>
</div>
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left"> 
			<h2>Results for '<%=request.getSession().getAttribute("search_query") %>' 
				<button type="button" style="float:right; margin:1px;" class="btn btn-secondary" onclick="sortSearch('c','lo');">Condition (Used First)</button> 
				<button type="button" style="float:right; margin:1px;" class="btn btn-secondary" onclick="sortSearch('c','hi');">Condition (New First)</button> 
				<button type="button" style="float:right; margin:1px;" class="btn btn-secondary" onclick="sortSearch('p','hi');">Price ($$ - $)</button> 
				<button type="button" style="float:right; margin:1px;" class="btn btn-secondary" onclick="sortSearch('p','lo');">Price ($ - $$)</button> 
				<div class="inline" style="float:right;text-align:center;height:100%"><h3>Sort By: </h2></div>
			</h2><hr><br/>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				int j = 0;
				for(Integer index : ordering){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">Active Auction</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=queryAuctions.get(index)%></h5>
								    <p class="card-text">Clothing: <%=prodType.get(j) %></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=index%>" class="btn btn-primary">View Now</a>
								 </div>
							</div>
						</td>
			<% i++; j++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
		</div>
	</div>
</div>
<script>
	<%
	if(request.getSession().getAttribute("type").toString().equals("j")){%> 
		showJackets();
	<%}%>
	<%
	if(request.getSession().getAttribute("type").toString().equals("p")){%> 
		showPants();
	<%}%>
	<%
	if(request.getSession().getAttribute("type").toString().equals("s")){%> 
		showShirts();
	<%}%>
	function showJackets(){		
		/*
		var jackets = 
		<div class="form-group visible">
        <div class="checkbox">
			<label><input type="checkbox" id="hood" value=""> Hood Only</label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" id="water" value=""> Water-resistant Only</label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" id="insulated" value=""> Insulated Only</label>
		</div>
        <select class="form-control" id="size">
            <option value="0" selected>All Sizes</option>
            <option value="1">Small</option>
            <option value="2">Medium</option>
            <option value="3">Large</option>
        </select>
      </div>
      */
      <% if (request.getSession().getAttribute("adv") != null && request.getSession().getAttribute("type").toString().equals("j")) {%>
	  var jackets = '<div class="form-group visible"> <div class="checkbox"> <label><input type="checkbox" id="hood" value="" '+ <% if(request.getSession().getAttribute("hood").toString().equals("true")){ %> 'checked' + <%}%>
	  '> Hood Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="water" value="" ' + <% if(request.getSession().getAttribute("water").toString().equals("true")){ %> 'checked' + <%}%>
	  '> Water-resistant Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="insulated" value="" ' + <% if(request.getSession().getAttribute("insulated").toString().equals("true")){ %> 'checked' + <%}%> 
	  '> Insulated Only</label> </div> <select class="form-control" id = "size"> <option value="0" ' + <% if(request.getSession().getAttribute("size").toString().equals("0")){ %> 'selected' 
		  + <%}%> '>All Sizes</option> <option value="1" ' + <% if(request.getSession().getAttribute("size").toString().equals("1")){ %> 'selected' + 
		  <%}%>'>Small</option> <option value="2" '+ <% if(request.getSession().getAttribute("size").toString().equals("2")){ %> 'selected' + <%}%>
		  '>Medium</option> <option value="3" '+ <% if(request.getSession().getAttribute("size").toString().equals("3")){ %> 'selected' + <%}%>
		  '>Large</option> <option value="4" '+ <% if(request.getSession().getAttribute("size").toString().equals("4")){ %> 'selected' + <%}%>
		  '>XL</option> </select> </div>';
      <%}
      else{
      %>
      var jackets = '<div class="form-group visible"> <div class="checkbox"> <label><input type="checkbox" id="hood" value="" ' +
	  '> Hood Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="water" value="" ' +
	  '> Water-resistant Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="insulated" value="" ' + 
	  '> Insulated Only</label> </div> <select class="form-control" id = "size"> <option value="0" ' +
		  '>All Sizes</option> <option value="1" ' + '>Small</option> <option value="2" '+
		  '>Medium</option> <option value="3" '+ 
		  '>Large</option> <option value="4" '+
		  '>XL</option> </select> </div>';
		<%}%>
      document.getElementById("specifics").innerHTML = jackets;
	}
	
	function showPants(){
		<% if (request.getSession().getAttribute("adv") != null && request.getSession().getAttribute("type").toString().equals("p")) {%>
		 var pants = '<div class="form-group visible"> '+
						'<div class="checkbox"> <label><input type="checkbox" value="" id = "belt" ' + <% if(request.getSession().getAttribute("belt").toString().equals("true")){ %> 'checked' + <%}%>'> Belt Loops Only</label> '+
					  	'</div> '+	
						'<select class="form-control" id="fit"> <option value="0" selected>All Fits</option> <option value="1">Relaxed</option> <option value="2">Regular</option> <option value="3">Slim</option> <option value="3">skinny</option> </select> </div>' +
						'<label for="seller" >Length</label> <input class="form-control" id="length" type="text" value = "' + <% if(!request.getSession().getAttribute("length").toString().equals("%")){ %>  <%=request.getSession().getAttribute("length").toString()%> + <%}%> '" />' +
						'<label for="seller" >Length</label> <input class="form-control" id="waist" type="text" value = "' + <% if(!request.getSession().getAttribute("waist").toString().equals("%")){ %>  <%=request.getSession().getAttribute("waist").toString()%> + <%}%> '" />';
			<%}
		else{ %>
      var pants = '	<div class="form-group visible"> '+
      					'<div class="checkbox"> <label><input type="checkbox" value="" id = "belt"> Belt Loops Only</label> '+
      			  	'</div> '+	
      				'<select class="form-control" id="fit"> <option value="0" selected>All Fits</option> <option value="1">Relaxed</option> <option value="2">Regular</option> <option value="3">Slim</option> <option value="3">skinny</option> </select> </div>' +
      				'<label for="seller" >Length</label> <input class="form-control" id="length" type="text" value = "" />' +
      				'<label for="seller">Waist</label> <input class="form-control" id="waist" type="text" value = "" />';
      <%}%>
      document.getElementById("specifics").innerHTML = pants;
	}
	
	function showShirts(){
	<% if (request.getSession().getAttribute("adv") == null || !request.getSession().getAttribute("type").toString().equals("s")){ %>
	  var shirts = '<div class="form-group visible"> '+
	  					'<div class="checkbox"> <label><input type="checkbox" value="" id="button"> Buttoned Only</label> </div> ' +
	  					'<div class="checkbox"> <label><input type="checkbox" value="" id="longsleeve" checked> Long-Sleeved </label> </div> ' + 
	  					'<div class="checkbox"> <label><input type="checkbox" value="" id="shortsleeve" checked> Short-Sleeved </label> </div>' + 
	  					'<div class="checkbox"> <label><input type="checkbox" value="" id="collar"> Collared Only</label> </div>' + 
	  					'<select class="form-control" id="size"> <option value="0" selected>All Sizes</option> <option value="1">Small</option> <option value="2">Medium</option> <option value="3">Large</option> <option value="4">XL</option> </select> ' + 
	  				'</div>';
	  <% } 
	else { %>
	  var shirts = '<div class="form-group visible"> '+
						'<div class="checkbox"> <label><input type="checkbox" value="" id="button" '+ <% if(request.getSession().getAttribute("buttons").toString().equals("true")){ %> 'checked' + <%}%> '> Buttoned Only</label> </div> ' +
						'<div class="checkbox"> <label><input type="checkbox" value="" id="longsleeve" '+ <% if(request.getSession().getAttribute("longsleeve").toString().equals("true")){ %> 'checked' + <%}%> '> Long-Sleeved </label> </div> ' + 
						'<div class="checkbox"> <label><input type="checkbox" value="" id="shortsleeve" '+ <% if(request.getSession().getAttribute("shortsleeve").toString().equals("true")){ %> 'checked' + <%}%> '> Short-Sleeved </label> </div>' + 
						'<div class="checkbox"> <label><input type="checkbox" value="" id="collar"'+ <% if(request.getSession().getAttribute("collar").toString().equals("true")){ %> 'checked' + <%}%> '> Collared Only</label> </div>' + 
						'<select class="form-control" id="size"> <option value="0" ' + <% if(request.getSession().getAttribute("size").toString().equals("0")){ %> 'selected' + <%}%>'>All Sizes</option> '+
							'<option value="1" ' + <% if(request.getSession().getAttribute("size").toString().equals("1")){ %> 'selected' + <%}%>'>Small</option> '+
							'<option value="2"' + <% if(request.getSession().getAttribute("size").toString().equals("2")){ %> 'selected' + <%}%>'>Medium</option>'+
							'<option value="3"' + <% if(request.getSession().getAttribute("size").toString().equals("3")){ %> 'selected' + <%}%>'>Large</option> '+
							'<option value="4"' + <% if(request.getSession().getAttribute("size").toString().equals("4")){ %> 'selected' + <%}%>'>XL</option> </select> ' + 
					'</div>';
					<%}%>
      document.getElementById("specifics").innerHTML = shirts;
	}
	
	function clearSpecs(){
		document.getElementById("specifics").innerHTML = "";
	}
	
	function formSpecs(){
		switch($("#productType").val()){
		case "Jackets":
			showJackets();
			break;
		case "Shirts":
			showShirts();
			break;
		case "All":
			clearSpecs();
			break;
		case "Pants":
			showPants();
			break;
		}
	}
	function regSearch(){
		var args = "&q=" + $('#regSearch').val();
		var dest = "NavigationServlet?location=search" + args;
		window.location.href = dest;
	}
	
	function sortSearch(sortType,sortOrder){
		var args = "&sortType="+sortType+"&sortOrder="+sortOrder;
		var lochref = "" +  window.location.href;
		if(lochref.includes("&sortType")){
			window.location.href = lochref.substring(0, window.location.href.length-24) + args;
		}
		else{
			window.location.href = window.location.href + args;
		}
	}
		
	function advSearch(){
		var args = "&q=" + $('#regSearch').val();
		switch($("#productType").val()){
		case "Jackets":
			args += "&t=j"; //type = jackets
			args += "&h="+ document.querySelector('#hood').checked;
			args += "&w="+ document.querySelector('#water').checked;
			args += "&i="+ document.querySelector('#insulated').checked;
			args += "&sz="+ document.querySelector('#size').value;
			break;
		case "Pants":
			args += "&t=p"; //type = pants
			args += "&f=" + document.querySelector('#fit').value;
			args += "&b=" + document.querySelector('#belt').checked;
			args += "&l=" + document.querySelector('#length').value;
			args += "&w=" + document.querySelector('#waist').value;
			break;
		case "All":
			args += "&t=a"; //type = all
			break;
		case "Shirts":
			args += "&t=s"; //type = shirts
			args += "&b="+ document.querySelector('#button').checked;
			args += "&ls="+ document.querySelector('#longsleeve').checked;
			args += "&ss="+ document.querySelector('#shortsleeve').checked;
			args += "&c="+ document.querySelector('#collar').checked;
			args += "&sz=" + document.querySelector('#size').value;
			break;
		}
		args += "&p=" + $("#priceRange").val();
		args += "&brand=" + $("#brand").val();
		args += "&s=" + $("#seller").val();
		args += "&q=" + $('#regSearch').val();
		args += "&condition=" + $('#condition').val();
		//args += "&s="
		var dest = "NavigationServlet?location=advSearch" + args;
		console.log(args);
		window.location.href = dest;
	}
</script>

</body>
</html>