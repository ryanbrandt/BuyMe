<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		Statement st = con.createStatement();
		ResultSet q;
		
		HttpSession curSession = request.getSession(false); 
		
		String recipient = request.getParameter("recipient");
		String receiverid="";
		
		q = st.executeQuery("SELECT user_id FROM Users WHERE email = '"+recipient+"' OR display_name= '"+recipient+"'");
		if(q.next()){
			receiverid = q.getString("user_id");
		}
		//System.out.println(receiverid);
		
		String subject = request.getParameter("subject");
		
		//System.out.println(subject);
		
		String email = request.getParameter("email");
		
		//System.out.println(email);
		
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		
 		String query =  "INSERT INTO BuyMe.Emails (sender_id, receiver_id, email_subject, email_text, time_stamp) " +
				"VALUES ( '"+curSession.getAttribute("user")+ "', '"+ receiverid+ "', '"+subject+ "', '"+email+ "', '"+timestamp+"' )";
 		
		st.executeUpdate(query);
		
		
		if( Integer.parseInt(request.getParameter("isQuestion")) >= 0 ){
			st.executeUpdate("UPDATE Questions SET isAnswered = '1' WHERE (question_id = '"+ request.getParameter("isQuestion")+"')");			
		}
		
		
		con.close();
		st.close();
		
	}catch(Exception e){
		System.out.println("ERROR");
	}
	
%>