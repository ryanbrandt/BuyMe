package com.cs336.pkg;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** 
 * Servlet implementation class NavigationServlet
 * 
 * Servlet to redirect users to submodules (e.g. auctions module, admin module, alerts module etc) that can't be accessed directly
 * 
 */
@WebServlet("/NavigationServlet")
public class NavigationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L; 
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NavigationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// figure out where to redirect user based on parameter location
		RequestDispatcher dispatcher;
		
		String page = request.getParameter("location");
		//System.out.println("page: " + page);
		
		switch(request.getParameter("location")){
		// to my auctions list page
		case "auctions":
			dispatcher = getServletContext().getRequestDispatcher("/auctions/my_auctions.jsp");
			dispatcher.forward(request, response);
			break;
		// to create new auction page
		case "createAuction":
			dispatcher = getServletContext().getRequestDispatcher("/auctions/create_auction.jsp");
			dispatcher.forward(request, response);
			break;
		// to profile view
		case "profile":
			dispatcher = getServletContext().getRequestDispatcher("/user/profile.jsp");
			dispatcher.forward(request, response);
			break;
		// to view an auction page
		case "view":
			// set auction id
			request.getSession().setAttribute("auction_id", request.getParameter("id"));
			dispatcher = getServletContext().getRequestDispatcher("/auctions/view_auction.jsp");
			dispatcher.forward(request, response);
			break;
		// to auction search page
		case "search":
			// set search_query attribute 
			request.getSession().setAttribute("adv",null); //ensure we're just doing a normal search, even if we did advanced services previously in the session
			request.getSession().setAttribute("search_query", request.getParameter("q"));
			request.getSession().setAttribute("type","a"); //ensure we default to all
			dispatcher = getServletContext().getRequestDispatcher("/auctions/search_auctions.jsp");
			dispatcher.forward(request, response);
			break;
		// to email page
		case "email":
			dispatcher = getServletContext().getRequestDispatcher("/communication/email_inbox.jsp");
			dispatcher.forward(request, response);
			break;
		// to question page
		case "qa":
			dispatcher = getServletContext().getRequestDispatcher("/qa/qaPage.jsp");
			dispatcher.forward(request, response);
			break;
		// to user settings
		case "settings":
			dispatcher = getServletContext().getRequestDispatcher("/user/settings.jsp");
			dispatcher.forward(request, response);
			break;
		// to user alerts
		case "alerts":
			dispatcher = getServletContext().getRequestDispatcher("/user/view_alerts.jsp");
			dispatcher.forward(request, response);
			break;
		// to admin page
		case "admin":
			dispatcher = getServletContext().getRequestDispatcher("/admin/adminPage.jsp");
			dispatcher.forward(request, response);
		// to sales report
		case "report":
			dispatcher = getServletContext().getRequestDispatcher("/admin/salesReportPage.jsp");
			dispatcher.forward(request, response);
		// to cs rep page
		case "cs":
			dispatcher = getServletContext().getRequestDispatcher("/csrep/csUserMgtPage.jsp");
			dispatcher.forward(request, response);
		case "advSearch":
			request.getSession().setAttribute("search_query", request.getParameter("q"));
			request.getSession().setAttribute("adv", true);
			request.getSession().setAttribute("type", request.getParameter("t"));
			request.getSession().setAttribute("price", request.getParameter("p"));
			request.getSession().setAttribute("condition", request.getParameter("condition"));
			if(request.getParameter("t").contentEquals("j")) {
				String water = request.getParameter("w").contentEquals("") ? "%" : request.getParameter("w");
				String hood = request.getParameter("h").contentEquals("") ? "%" : request.getParameter("h");
				String insulated = request.getParameter("i").contentEquals("") ? "%" : request.getParameter("i");
				request.getSession().setAttribute("size", request.getParameter("sz"));
				request.getSession().setAttribute("water", water);
				request.getSession().setAttribute("hood", hood);
				request.getSession().setAttribute("insulated", insulated);
			}
			else if(request.getParameter("t").contentEquals("p")) {
				request.getSession().setAttribute("belt", request.getParameter("b"));
				String length =  request.getParameter("l").contentEquals("") ? "%" : request.getParameter("l");
				String waist =  request.getParameter("w").contentEquals("") ? "%" :  request.getParameter("w");
				String fit =  request.getParameter("f").contentEquals("") ? "-1" :  request.getParameter("f");
				request.getSession().setAttribute("length",length);
				request.getSession().setAttribute("waist", waist);
				request.getSession().setAttribute("fit", fit);
			}
			else if(request.getParameter("t").contentEquals("s")) {
				request.getSession().setAttribute("buttons", request.getParameter("b"));
				request.getSession().setAttribute("longsleeve", request.getParameter("ls"));
				request.getSession().setAttribute("shortsleeve", request.getParameter("ss"));
				request.getSession().setAttribute("collar", request.getParameter("c"));
				request.getSession().setAttribute("size", request.getParameter("sz"));	
			}
			String seller = request.getParameter("s").contentEquals("") ? "%" : request.getParameter("s");
			request.getSession().setAttribute("seller",seller);
			String brand = request.getParameter("brand").contentEquals("") ? "%" : request.getParameter("brand");
			request.getSession().setAttribute("brand",brand);
			dispatcher = getServletContext().getRequestDispatcher("/auctions/search_auctions.jsp");
			dispatcher.forward(request, response);
			//TODO: set adv settings
			break;
			//TODO rest of cases as modules created

		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
