<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	// get necessary data to populate page 
	Map<Integer, String> queryAuctions = new HashMap<Integer, String>();
	ArrayList<String> prodType = new ArrayList<String>();
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
								"') AS title_relevance " + 
							"FROM BuyMe.Clothing AS c J" +
							"JOIN Auctions " +
								"AS a ON item_is = product_id " + 
							"WHERE " + 
								"MATCH (" + "`" + "name" + "`) AGAINST ('" +
								request.getSession().getAttribute("search_query") + "') " + 
							"ORDER BY title_relevance DESC";
			
			q = st.executeQuery(query);
		}else{
			q = st.executeQuery("SELECT a.auction_id, c.type," + "c.`" + "name" + "`, MATCH (" + "`" + "name" + "`) AGAINST ('" +request.getSession().getAttribute("search_query") + "') AS title_relevance FROM BuyMe.Clothing AS c JOIN Auctions AS a ON item_is = product_id WHERE MATCH (" + "`" + "name" + "`) AGAINST ('" + request.getSession().getAttribute("search_query") + "') ORDER BY title_relevance DESC");
		}
		// auction_id as key, product name as value
		while(q.next()){
			queryAuctions.put(q.getInt(1), q.getString(3));
			prodType.add(q.getString(2));
		}
		
		
		st.close();
		con.close();
	}
	catch(Exception e){
		System.out.println("Exception: " + e);
	}
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
                                        <option value="All" selected>All Products</option>
                                        <option value="Jackets">Jackets</option>
                                        <option value="Shirts">Shirts</option>
                                        <option value="Pants">Pants</option>
                                    </select>
                                  </div>
                                  <div id = "specifics"></div>
                                  <div class="form-group">
                                    <label for="priceRange">Price Range</label>
                                    <select multiple class="form-control" id = "priceRange">
                                        <option value="0" selected>Any Price</option>
                                        <option value="1">Below $25</option>
                                        <option value="2">$25-$49.99</option>
                                        <option value="3">$50-$99.99</option>
                                        <option value="4">$100-$199.99</option>
                                        <option value="5">$200-$499.99</option>
                                        <option value="6">$500+</option>
                                    </select>
                                  </div>
                                  <div class="form-group">
                                    <label for="seller">Seller Name</label>
                                    <input class="form-control" id="seller" type="text" />
                                  </div>
                                  <div class="form-group">
                                    <label for="contain">Brand Name</label>
                                    <input class="form-control" id="brand" type="text" />
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
			<h2>Results for '<%=request.getSession().getAttribute("search_query") %>'</h2><hr><br/>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				int j = 0;
				for(Map.Entry<Integer, String> entry : queryAuctions.entrySet()){ 
			%>
			<%		if(i == 0){ %>
					<tr class="attrTable" align="center">
			<%		} %>
						<td>
							<div class="card" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">Active Auction</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=entry.getValue() %></h5>
								    <p class="card-text">Clothing: <%=prodType.get(j) %></p>
								    <a href="/BuyMe/NavigationServlet?location=view&id=<%=entry.getKey()%>" class="btn btn-primary">View Now</a>
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
	function showJackets(){
		/*
		var jackets = 
		<div class="form-group visible">
        <div class="checkbox">
			<label><input type="checkbox" id="zipper" value=""> Zipper Only</label>
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
	  var jackets = '<div class="form-group visible"> <div class="checkbox"> <label><input type="checkbox" id="zipper" value=""> Zipper Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="water" value=""> Water-resistant Only</label> </div> <div class="checkbox"> <label><input type="checkbox" id="insulated" value=""> Insulated Only</label> </div> <select class="form-control"> <option value="0" selected>All Sizes</option> <option value="1">Small</option> <option value="2">Medium</option> <option value="3">Large</option> </select> </div>';
      document.getElementById("specifics").innerHTML = jackets;
	}
	
	function showPants(){
		/*
		var jackets = 
		<div class="form-group visible">
        <div class="checkbox">
			<label><input type="checkbox" value="" id="belt"> Belt loops</label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" value="" id="belt"> Water-resistant Only</label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" value=""> Insulated Only</label>
		</div>
        <select class="form-control" id="size">
            <option value="0" selected>All Sizes</option>
            <option value="1">Small</option>
            <option value="2">Medium</option>
            <option value="3">Large</option>
        </select>
      </div>
      */
      var pants = '<div class="form-group visible"> <div class="checkbox"> <label><input type="checkbox" value=""> Zipper Only</label> </div> <div class="checkbox"> <label><input type="checkbox" value=""> Water-resistant Only</label> </div> <div class="checkbox"> <label><input type="checkbox" value=""> Insulated Only</label> </div> <select class="form-control"> <option value="0" selected>All Sizes</option> <option value="1">Small</option> <option value="2">Medium</option> <option value="3">Large</option> </select> </div>';
      document.getElementById("specifics").innerHTML = pants;
	}
	
	function showShirts(){
		/*
		var shirts = 
		<div class="form-group visible">
        <div class="checkbox">
			<label><input type="checkbox" value="" id="button"> Buttoned </label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" value="" id="longsleeve"> Long-Sleeved </label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" value="" id="shortsleeve"> Short-Sleeved </label>
		</div>
		<div class="checkbox">
			<label><input type="checkbox" value="" id="collar"> Collared </label>
		</div>
        <select class="form-control" id="size">
            <option value="0" selected>All Sizes</option>
            <option value="1">Small</option>
            <option value="2">Medium</option>
            <option value="3">Large</option>
            <option value="4">XL</option>
        </select>
      </div>
      */
	  var shirts = '<div class="form-group visible"> <div class="checkbox"> <label><input type="checkbox" value="" id="button"> Buttoned </label> </div> <div class="checkbox"> <label><input type="checkbox" value="" id="longsleeve"> Long-Sleeved </label> </div> <div class="checkbox"> <label><input type="checkbox" value="" id="shortsleeve"> Short-Sleeved </label> </div> <div class="checkbox"> <label><input type="checkbox" value="" id="collar"> Collared </label> </div> <select class="form-control" id="size"> <option value="0" selected>All Sizes</option> <option value="1">Small</option> <option value="2">Medium</option> <option value="3">Large</option> <option value="4">XL</option> </select> </div>';
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
	
	function advSearch(){
		var args = "&q=" + $('#regSearch').val();
		switch($("#productType").val()){
		case "Jackets":
			args += "&t=j"; //type = jackets
			args += "&z="+ document.querySelector('#zipper').checked;
			args += "&w="+ document.querySelector('#water').checked;
			args += "&i="+ document.querySelector('#insulated').checked;
			break;
		case "Pants":
			break;
		case "All":
			break;
		case "Shirts":
			args += "&t=s"; //type = shirts
			args += "&b="+ document.querySelector('#button').checked;
			args += "&ls="+ document.querySelector('#longsleeve').checked;
			args += "&ss="+ document.querySelector('#shortsleeve').checked;
			args += "&c="+ document.querySelector('#collar').checked;
			break;
		}
		args += "&p=" + $("#priceRange").val();
		args += "&brand=" + $("#brand").val();
		args += "&s=" + $("#seller").val();
		args += "&q=" + $('#regSearch').val();
		//args += "&s="
		var dest = "NavigationServlet?location=advSearch" + args;
		console.log(args);
		//window.location.href = dest;
	}
</script>

</body>
</html>