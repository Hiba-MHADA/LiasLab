package servlet;
import dao.PublicationDAO;
import dao.EquipeDAO;
import model.Membre;
import model.Publication;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
@WebServlet("/publications")
public class PublicationServlet extends HttpServlet {
    private PublicationDAO dao = new PublicationDAO();
    private EquipeDAO equipeDao = new EquipeDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "liste";
        switch (action) {
            case "nouveau":
                request.setAttribute("equipes", equipeDao.getAllEquipes());
                request.getRequestDispatcher("/WEB-INF/views/publications/form.jsp")
                       .forward(request, response);
                break;
            case "modifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Publication p = dao.getById(id);
                request.setAttribute("publication", p);
                request.setAttribute("equipes", equipeDao.getAllEquipes());
                request.getRequestDispatcher("/WEB-INF/views/publications/form.jsp")
                       .forward(request, response);
                break;
            case "supprimer":
                dao.delete(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/publications");
                break;
            default:
                List<Publication> list = dao.getAllPublications();
                request.setAttribute("publications", list);
                request.getRequestDispatcher("/WEB-INF/views/publications/liste.jsp")
                       .forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        String action = request.getParameter("action");
        Publication p = new Publication();
        p.setTitre(request.getParameter("titre"));
        p.setAuteurs(request.getParameter("auteurs"));
        p.setAnnee(Integer.parseInt(request.getParameter("annee")));
        p.setRevue(request.getParameter("revue"));
        p.setLien(request.getParameter("lien"));
        p.setMembreId(membre.getId());
        String equipeIdParam = request.getParameter("equipeId");
        p.setEquipeId(equipeIdParam != null && !equipeIdParam.isEmpty() ? Integer.parseInt(equipeIdParam) : 0);
        if ("nouveau".equals(action)) {
            dao.add(p);
        } else if ("modifier".equals(action)) {
            p.setId(Integer.parseInt(request.getParameter("id")));
            dao.update(p);
        }
        response.sendRedirect(request.getContextPath() + "/publications");
    }
}