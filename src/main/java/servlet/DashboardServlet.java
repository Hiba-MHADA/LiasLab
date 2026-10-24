package servlet;

import dao.*;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Membre membre = (Membre) session.getAttribute("membreConnecte");
        request.setAttribute("membre", membre);

        // Stats réelles depuis la DB
        MembreDAO      memDao = new MembreDAO();
        PublicationDAO pubDao = new PublicationDAO();
        EvenementDAO   evtDao = new EvenementDAO();
        AdhesionDAO    adhDao = new AdhesionDAO();

        request.setAttribute("nbMembres",    memDao.countMembresActifs());
        request.setAttribute("nbPubs",       pubDao.count());
        request.setAttribute("nbEvts",       evtDao.count());
        request.setAttribute("nbAdhesions",  adhDao.countEnAttente());

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
               .forward(request, response);
    }
}