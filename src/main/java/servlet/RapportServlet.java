package servlet;
import dao.*;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Calendar;
@WebServlet("/rapport")
public class RapportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        String role = membre.getRole() != null ? membre.getRole() : "membre";
        if (!"admin".equals(role) && !"directeur".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard"); return;
        }
        String anneeParam = request.getParameter("annee");
        int annee = anneeParam != null ? Integer.parseInt(anneeParam) : Calendar.getInstance().get(Calendar.YEAR);
        PublicationDAO pubDao = new PublicationDAO();
        EvenementDAO   evtDao = new EvenementDAO();
        MembreDAO      memDao = new MembreDAO();
        DocumentDAO    docDao = new DocumentDAO();
        ReunionDAO     reuDao = new ReunionDAO();
        request.setAttribute("annee",        annee);
        request.setAttribute("publications",  pubDao.getByAnnee(annee));
        request.setAttribute("evenements",    evtDao.getByAnnee(annee));
        request.setAttribute("nbMembres",     memDao.countMembresActifs());
        request.setAttribute("documents",     docDao.getByAnnee(annee));
        request.setAttribute("reunions",      reuDao.getByAnnee(annee));
        request.getRequestDispatcher("/WEB-INF/views/rapport.jsp").forward(request, response);
    }
}