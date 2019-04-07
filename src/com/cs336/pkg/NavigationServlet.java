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
		switch(request.getParameter("location")) {
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
