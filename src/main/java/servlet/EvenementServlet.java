package servlet;
import dao.EvenementDAO;
import model.Evenement;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
@WebServlet("/evenements")
public class EvenementServlet extends HttpServlet {
    private EvenementDAO dao = new EvenementDAO();
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
                request.getRequestDispatcher("/WEB-INF/views/evenements/form.jsp")
                       .forward(request, response);
                break;
            case "modifier":
                Evenement e = dao.getById(Integer.parseInt(request.getParameter("id")));
                request.setAttribute("evenement", e);
                request.getRequestDispatcher("/WEB-INF/views/evenements/form.jsp")
                       .forward(request, response);
                break;
            case "supprimer":
                dao.delete(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/evenements");
                break;
            case "detail":
                int id = Integer.parseInt(request.getParameter("id"));
                Evenement evt = dao.getById(id);
                request.setAttribute("evenement", evt);
                request.setAttribute("organisateurs", dao.getOrganisateurs(id));
                request.setAttribute("membresDisponibles", dao.getMembresNonOrganisateurs(id));
                request.getRequestDispatcher("/WEB-INF/views/evenements/detail.jsp")
                       .forward(request, response);
                break;
            case "ajouterOrganisateur":
                int evtId1 = Integer.parseInt(request.getParameter("evenementId"));
                int membreId1 = Integer.parseInt(request.getParameter("membreId"));
                dao.ajouterOrganisateur(evtId1, membreId1);
                response.sendRedirect(request.getContextPath() + "/evenements?action=detail&id=" + evtId1);
                break;
            case "retirerOrganisateur":
                int evtId2 = Integer.parseInt(request.getParameter("evenementId"));
                int membreId2 = Integer.parseInt(request.getParameter("membreId"));
                dao.retirerOrganisateur(evtId2, membreId2);
                response.sendRedirect(request.getContextPath() + "/evenements?action=detail&id=" + evtId2);
                break;
            default:
                List<Evenement> list = dao.getAllEvenements();
                request.setAttribute("evenements", list);
                request.getRequestDispatcher("/WEB-INF/views/evenements/liste.jsp")
                       .forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Evenement e = new Evenement();
        e.setTitre(request.getParameter("titre"));
        e.setType(request.getParameter("type"));
        e.setLieu(request.getParameter("lieu"));
        e.setDescription(request.getParameter("description"));
        String editionStr = request.getParameter("edition");
        e.setEdition(editionStr != null && !editionStr.isEmpty() ? Integer.parseInt(editionStr) : 1);
        try {
            String dd = request.getParameter("dateDebut");
            String df = request.getParameter("dateFin");
            if (dd != null && !dd.isEmpty()) e.setDateDebut(sdf.parse(dd));
            if (df != null && !df.isEmpty()) e.setDateFin(sdf.parse(df));
        } catch (Exception ex) { ex.printStackTrace(); }
        if ("nouveau".equals(action)) {
            dao.add(e);
            new dao.NotificationDAO().notifierTousMembres(
                "Nouvel événement : " + e.getTitre() + " (" + e.getType() + ")"
            );
        } else if ("modifier".equals(action)) {
            e.setId(Integer.parseInt(request.getParameter("id")));
            dao.update(e);
        }
        response.sendRedirect(request.getContextPath() + "/evenements");
    }
}