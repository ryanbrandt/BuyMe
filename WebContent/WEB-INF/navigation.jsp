<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*"%>
<% HttpSession curSession = request.getSession(false); %>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
	<!-- JS function needs to be in head for JSP to call below -->
	<script>
		/* disable navigation items, hide logout button if user not logged in */
		function disableNavigation(){
			document.getElementById("profile").className += " disabled";
			document.getElementById("navbarDropdown").className += " disabled";
			document.getElementById("cart").className += " disabled";
			document.getElementById("logout").style.visibility = "hidden";	
		}
	</script>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<!-- Navigation Bar -->
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">BuyMe</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="profile">My Profile</a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Auctions
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="#">My Bids</a>
          <a class="dropdown-item" href="NavigationServlet?location=auctions">My Auctions</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#">My Alerts</a>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="cart">My Cart</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#" id="logout" onclick=logOut()>Logout</a>
      </li>        

    </ul>
    <form class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" required>
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
  </div>
</nav>
<!-- JSP -->
<%	
	/* get current session, if user not logged in, disable user-oriented navigation bar buttons, else, leave enabled */
	if(curSession.getAttribute("user") == null){
%>		
		<script>
		disableNavigation();
		</script>
<% 
	}
%>
<!-- Bootstrap Required JS -->
<script src="http://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script>
	/* log user out on click of logout button */
	function logOut(){
		if(confirm('Are you sure?')){
			window.location.href = "logout.jsp";
		} else {
			return false;
		}
	}
</script>
</body>
</html>