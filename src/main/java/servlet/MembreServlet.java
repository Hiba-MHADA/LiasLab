package servlet;
import dao.MembreDAO;
import dao.HistoriqueAffiliationDAO;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Date;
import java.util.List;
@WebServlet("/membres")
public class MembreServlet extends HttpServlet {
    private MembreDAO dao = new MembreDAO();
    private HistoriqueAffiliationDAO histDao = new HistoriqueAffiliationDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Vérifier session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "liste";
        switch (action) {
            case "nouveau":
                request.getRequestDispatcher("/WEB-INF/views/membres/form.jsp").forward(request, response);
                break;
            case "modifier":
                int id = Integer.parseInt(request.getParameter("id"));
                Membre m = dao.getMembreById(id);
                request.setAttribute("membre", m);
                request.getRequestDispatcher("/WEB-INF/views/membres/form.jsp").forward(request, response);
                break;
            case "detail":
                int idDetail = Integer.parseInt(request.getParameter("id"));
                Membre membreDetail = dao.getMembreById(idDetail);
                request.setAttribute("membre", membreDetail);
                request.setAttribute("historiqueAffiliation", histDao.getByMembre(idDetail));
                request.getRequestDispatcher("/WEB-INF/views/membres/detail.jsp").forward(request, response);
                break;
            case "desactiver":
                int idDes = Integer.parseInt(request.getParameter("id"));
                dao.desactiverMembre(idDes);
                // Clôturer la période d'affiliation en cours (départ)
                histDao.cloturerPeriodeEnCours(idDes, new Date(), "Désactivation du compte");
                response.sendRedirect(request.getContextPath() + "/membres");
                break;
            case "reactiver":
                int idReact = Integer.parseInt(request.getParameter("id"));
                dao.reactiverMembre(idReact);
                // Ouvrir une nouvelle période d'affiliation (retour)
                histDao.ouvrirPeriode(idReact, new Date());
                response.sendRedirect(request.getContextPath() + "/membres");
                break;
            default:
                List<Membre> membres = dao.getAllMembres();
                request.setAttribute("membres", membres);
                request.getRequestDispatcher("/WEB-INF/views/membres/liste.jsp").forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Membre m = new Membre();
        m.setNom(request.getParameter("nom"));
        m.setNom(request.getParameter("nom"));
        m.setPrenom(request.getParameter("prenom"));
        m.setEmail(request.getParameter("email"));
        m.setStatut(request.getParameter("statut"));
        m.setEtablissement(request.getParameter("etablissement"));
        m.setLaboratoireOrigine(request.getParameter("laboratoireOrigine"));
        m.setBiographie(request.getParameter("biographie"));
        m.setCentresInteret(request.getParameter("centresInteret"));
        if ("nouveau".equals(action)) {
            m.setMotDePasse(request.getParameter("motDePasse"));
            Date dateAffiliation = new Date();
            m.setDateAffiliation(dateAffiliation);
            int nouvelId = dao.addMembre(m);
            if (nouvelId > 0) {
                // Ouvrir la première période d'affiliation pour ce nouveau membre
                histDao.ouvrirPeriode(nouvelId, dateAffiliation);
            }
        } else if ("modifier".equals(action)) {
            m.setId(Integer.parseInt(request.getParameter("id")));
            dao.updateMembre(m);
        }
        response.sendRedirect(request.getContextPath() + "/membres");
    }
}