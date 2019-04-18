<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
try{
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();	
	Statement st = con.createStatement();
	ResultSet result;
	String query="";
	
	int input1 = Integer.parseInt(request.getParameter("input1"));
	String target = "";
	String tAmount = "";
	String tSold = "";
	
	switch(input1){
	case 1: //Total
		query = "Select SUM(amount) as tAmount, COUNT(*) as tSold FROM Auctions a JOIN Bids b ON a.highest_bid=b.bid_id WHERE is_active='0'";
		target = "Total";
		break;
	case 5: //Bestselling
		query= 	"SELECT *, Count(*) as tSold, Sum(amount) as tAmount "+
				"FROM Auctions a JOIN Clothing c ON c.product_id=a.item_is JOIN Bids b ON b.bid_id=a.highest_bid "+
				"WHERE is_active='0' "+ 
				"GROUP BY material, brand, 'condition', color, 'type' "+
				"ORDER BY tSold DESC";
		break;
	case 6: //best buyers
		query =	"SELECT display_name, Count(*) as tSold, Sum(amount) as tAmount "+
				"FROM Auctions a JOIN Bids b ON a.highest_bid=b.bid_id JOIN Users u ON u.user_id=b.from_user "+
				"WHERE is_active='0' "+
				"GROUP BY user_id " +
				"ORDER BY tSold DESC";
		break;
	case 2: //earnings per item
		String itemType = request.getParameter("input2Select");
		
		query = "Select SUM(amount) as tAmount, COUNT(*) as tSold " +
						"FROM Auctions a JOIN "+itemType+" t ON a.item_is=t."+itemType+"_id JOIN Bids b ON a.highest_bid=b.bid_id "+
						"WHERE is_active='0'";
		
		target = itemType;
		break;
	case 4: //per end user
		String userId = request.getParameter("input2Text");
		query = "SELECT display_name, Count(*) as tSold, SUM(amount) as tAmount " +
				"FROM( " +
						"SELECT * "+
						"FROM Auctions a JOIN Bids b ON a.highest_bid=b.bid_id JOIN Users u ON u.user_id=b.from_user " +
						"WHERE is_active = '0' AND (display_name = '"+userId+"' OR email='"+userId+"') ) AS t1 "+
				"GROUP BY(display_name)";
		break;
	case 3: //per item type
		String item = request.getParameter("input2Select");
		String condition = request.getParameter("input3_text1");
		String brand = request.getParameter("input3_text2");
		String material = request.getParameter("input3_text3");
		String color = request.getParameter("input3_text4");
		query = "SELECT Count(*) as tSold, Sum(amount) as tAmount "+
				"FROM Auctions a JOIN Clothing c JOIN Bids b ON a.item_is=c.product_id AND b.bid_id=a.highest_bid "+
				"WHERE is_active='0' AND material='"+material+"' AND brand='"+brand+"' AND 'condition'='"+condition+"' AND color='"+color+"' AND 'type'='"+item+"'";
		
		target = item+condition+brand+material+color;
		break;
	}
	
	
	//System.out.println(query);
	
	
	result = st.executeQuery(query);
	if( result.next() ){
		tAmount= result.getString("tAmount");
		tSold = result.getString("tSold");
	
		switch(input1){
		case 5: //bestselling
			target = result.getString("type")+": Condition("+result.getString("condition")+"), Brand("+result.getString("brand")+"), Material("+result.getString("material")+"), Color("+result.getString("color")+")";
			break;
		case 6: //best buyers
			target = result.getString("display_name");
			break;
		case 4: //per end user
			target = result.getString("display_name");
			break;
		}
		
		response.getWriter().write(tSold+"|"+tAmount+"|"+target);
	}else{
		response.getWriter().write("0|0|No Sales");
	}
	
	st.close();
	con.close();
	
	
	
}catch(Exception e){
	
	System.out.println("Broken");
	
}
%>