package servlet;

import dao.RechercheDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/recherche")
public class RechercheServlet extends HttpServlet {

    private RechercheDAO dao = new RechercheDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String terme = request.getParameter("terme");
        if (terme != null && !terme.trim().isEmpty()) {
            request.setAttribute("terme", terme);
            request.setAttribute("membres", dao.rechercherMembres(terme));
            request.setAttribute("documents", dao.rechercherDocuments(terme));
            request.setAttribute("evenements", dao.rechercherEvenements(terme));
            request.setAttribute("publications", dao.rechercherPublications(terme));
        }

        request.getRequestDispatcher("/WEB-INF/views/recherche.jsp").forward(request, response);
    }
}