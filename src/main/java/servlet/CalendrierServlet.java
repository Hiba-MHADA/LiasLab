package servlet;

import dao.EvenementDAO;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/calendrier")
public class CalendrierServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }

        EvenementDAO dao = new EvenementDAO();
        request.setAttribute("evenements", dao.getAllEvenements());
        request.getRequestDispatcher("/WEB-INF/views/calendrier.jsp").forward(request, response);
    }
}