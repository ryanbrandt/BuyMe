<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*, com.cs336.pkg.*, java.util.Map, java.util.Date, java.text.SimpleDateFormat"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<% HttpSession curSession = request.getSession(false); %>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<!-- Navigation Bar -->
<body>
<%
String unreads;
	try{
		ApplicationDB aDB = new ApplicationDB();	
		Connection aCon = aDB.getConnection();	
		Statement aSt = aCon.createStatement();

		ResultSet aInboxTable = aSt.executeQuery("SELECT COUNT(*) as unreads FROM Alerts WHERE alert_for = '" + curSession.getAttribute("user") + "' and alert_read = '0'");
		aInboxTable.next();
		unreads = aInboxTable.getInt("unreads") == 0 ? "" : Integer.toString(aInboxTable.getInt("unreads"));
		aCon.close();
	}
	catch(Exception e){
		unreads = "";
		System.out.println(curSession.getAttribute("user"));
	}
%>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">BuyMe</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item">
        <a class="nav-link" href="/BuyMe/NavigationServlet?location=auctions" id="home">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/BuyMe/NavigationServlet?location=profile" id="profile">My Profile</a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="auctionDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Auctions
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=createAuction">Create an Auction</a>
          <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=auctions">My Auctions</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=itemAlerts">Set Item Alerts</a>
     	</div>
      </li>
      <li class="nav-item">
        <a class="nav-link" id="alerts" href="/BuyMe/NavigationServlet?location=alerts">My Alerts<div class="text-danger" style="display:inline; s"><sup><%=curSession.getAttribute("user") != null ? unreads : ""%></sup></div></a>
      </li>    
	<li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="actionsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Actions
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=email">Email</a>
          <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=qa">Q&A</a>
          <div class="dropdown-divider"></div>
          	<a class="dropdown-item" href="/BuyMe/NavigationServlet?location=settings">Settings</a>
          	<a class="dropdown-item" href="#" id="logout" onclick=logOut()>Logout</a>  
     	</div>
     </li>
     
     <% if( "admin".equals((curSession.getAttribute("userType"))) ){ %>
     	   <li class="nav-item dropdown">
             <a class="nav-link dropdown-toggle" href="#" id="actionsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
               Admin Center
             </a>
             <div class="dropdown-menu" aria-labelledby="navbarDropdown">
               <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=admin">CS Account Management</a>
               <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=report">Generate Sales Report</a>
          	</div>
           </li> 
     		
     <% }else if( "cs_rep".equals((curSession.getAttribute("userType"))) ){ %>
     	   <li class="nav-item dropdown">
             <a class="nav-link dropdown-toggle" href="#" id="actionsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
               Customer Support Center
             </a>
             <div class="dropdown-menu" aria-labelledby="navbarDropdown">
               <a class="dropdown-item" href="/BuyMe/NavigationServlet?location=cs">User Account Management</a>
          	</div>
          </li> 
     <%} %>
      
  
      
    </ul>
    <form class="form-inline my-2 my-lg-0" id="searchForm">
      <input class="form-control mr-sm-2" type="search" placeholder="Search Auctions" aria-label="Search" id="q" required>
      <button class="btn btn-outline-success my-2 my-sm-0" id="searchSubmit">Search</button>
    </form>
  </div>
</nav>
<!-- Bootstrap Required JS -->
<script src="http://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script>
	/* log user out on click of logout button */
	function logOut(){
		if(confirm('Are you sure?')){
			window.location.href = "logout.jsp";
		} else {
			return false;
		}
	}
	function sanitize(inputString){
	    var d = inputString;
	    while(d.includes("'"))
	    	d = d.replace("'","");
	    return d;
	}
	/* on submit go to search page with search query */
	$('#searchForm').on('submit', function(e){
		e.preventDefault();
		var args = "&q=" + sanitize($('#q').val());
		var dest = "NavigationServlet?location=search" + args;
		window.location.href = dest;
	});
	/* if user not logged in disable navbar functionality */
	window.onload = function(){
		var user = <%=curSession.getAttribute("user")%>;
		if(user == null){
			document.getElementById("profile").className += " disabled";
			document.getElementById("home").className += " disabled";
			document.getElementById("auctionDropdown").className += " disabled";
			document.getElementById("actionsDropdown").className += " disabled";
			document.getElementById("alerts").className += " disabled"; 
			$('#searchSubmit').attr('disabled', 'disabled');	
		}
	}
</script>
</body>
</html>