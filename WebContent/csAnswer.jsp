<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Questions Center</title>
</head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/email.css"> 
</head>   
<!-- Navigation Bar -->  
<%@ include file='WEB-INF/navigation.jsp' %>  

<body>

<div class = "container">	
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'unanswered')">Unanswered</button>
	  <button class="tablinks" onclick="openTab(event, 'answered')">Answered</button>
	</div>

	<div id="unanswered" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet questionTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 0");
						
			while(questionTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+questionTable.getString("asked_by")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
			%>
				<button class="accordion">
					 	<table><tr> 
						 	<td width=100 id=<%=questionTable.getString("question_id")%>><%=fromUser%></td>
						 	<td width=100><%=questionTable.getString("question_subject")%></td>
						 	<td width=400><%=questionTable.getString("timestamp")%></td>
						 </tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>
							"<%=questionTable.getString("question_text")%>"
						</td></tr>
						<tr><td>
							<textarea rows="4" cols="60" id="answerText"></textarea><br>
						</td></tr>
						<tr><td>
							<button class="answerButton" id="answerButton">Answer</button>
						</td></tr>
					</table>
				</div>
				
		<%	}
		con.close();
		st.close();
		}catch(Exception e){
			System.out.println("something broke");
		}%>
	</div>

	<div id="answered" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet answeredTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 1");
						
			while(answeredTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+answeredTable.getString("asked_by")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
				Statement st3 = con.createStatement();
				ResultSet answeredByTable = st3.executeQuery("SELECT display_name FROM Users WHERE user_id = '" + answeredTable.getString("answeredBy")+"'");
				String answeredBy = "(deleted user)";
				if(answeredByTable.next()){
					answeredBy = answeredByTable.getString("display_name");
				}
				
			%>
				<button class="accordion">
					 	<table><tr> 
						 	<td width=100 id=<%=answeredTable.getString("question_id")%>><%=fromUser%></td>
						 	<td width=100><%=answeredTable.getString("question_subject")%></td>
						 	<td width=400><%=answeredTable.getString("timestamp")%></td>
						 </tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>
							&emsp;"<%=answeredTable.getString("question_text")%>"
						</td></tr>
						<tr><td>
							<b>Answered By: <%=answeredBy%></b> <br>
							&emsp;<%=answeredTable.getString("answer")%>							 
						</td></tr>
					</table>
				</div>
				
		<%	}
		}catch(Exception e){
		}%>
	</div>
</div>
</body>


<script>
	var acc = document.getElementsByClassName("accordion");
	var i;

	for (i = 0; i < acc.length; i++) {
  		acc[i].addEventListener("click", function() {
    		this.classList.toggle("active");
    		var panel = this.nextElementSibling;
    		if (panel.style.display === "block") {
      			panel.style.display = "none";
    		} else {
      			panel.style.display = "block";
    		}
  		});
	}
</script>

<script> 
	function openTab(evt, tabname) {
	  var i, tabcontent, tablinks;
	  tabcontent = document.getElementsByClassName("tabcontent");
	  for (i = 0; i < tabcontent.length; i++) {
	    tabcontent[i].style.display = "none";
	  }
	  tablinks = document.getElementsByClassName("tablinks");
	  for (i = 0; i < tablinks.length; i++) {
	    tablinks[i].className = tablinks[i].className.replace(" active", "");
	  }
	  document.getElementById(tabname).style.display = "block";
	  evt.currentTarget.className += " active";
	}
</script>

<script src="js/email_scripts.js"></script>


</html>