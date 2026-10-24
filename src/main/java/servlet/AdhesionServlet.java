package servlet;
import dao.AdhesionDAO;
import model.DemandeAdhesion;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.util.List;
@WebServlet("/adhesions")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10 Mo max
public class AdhesionServlet extends HttpServlet {
    private AdhesionDAO dao = new AdhesionDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Membre membre = (session != null) ? (Membre) session.getAttribute("membreConnecte") : null;
        String action = request.getParameter("action");
        if (action == null) action = "liste";
        switch (action) {
            case "formulaire":
                // Page publique de soumission
                request.getRequestDispatcher("/WEB-INF/views/adhesions/formulaire.jsp")
                       .forward(request, response);
                break;
            case "accepter":
                if (membre != null && ("admin".equals(membre.getRole()) || "directeur".equals(membre.getRole()))) {
                    dao.accepter(Integer.parseInt(request.getParameter("id")));
                }
                response.sendRedirect(request.getContextPath() + "/adhesions");
                break;
            case "refuser":
                if (membre != null && ("admin".equals(membre.getRole()) || "directeur".equals(membre.getRole()))) {
                    dao.refuser(Integer.parseInt(request.getParameter("id")));
                }
                response.sendRedirect(request.getContextPath() + "/adhesions");
                break;
            default:
                if (membre == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                List<DemandeAdhesion> demandes = dao.getAllDemandes();
                request.setAttribute("demandes", demandes);
                request.getRequestDispatcher("/WEB-INF/views/adhesions/liste.jsp")
                       .forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("soumettre".equals(action)) {
            DemandeAdhesion d = new DemandeAdhesion();
            d.setNom(request.getParameter("nom"));
            d.setPrenom(request.getParameter("prenom"));
            d.setEmail(request.getParameter("email"));
            d.setMotivation(request.getParameter("motivation"));

            // Upload du CV
            Part filePart = request.getPart("cv");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                String nomStocke = System.currentTimeMillis() + "_" + submittedFileName;

                String uploadDir = getServletContext().getRealPath("/uploads/cv");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                filePart.write(uploadDir + File.separator + nomStocke);
                d.setCvPath(nomStocke);
            }

            boolean ok = dao.soumettre(d);
            if (ok) {
                request.setAttribute("success", "true");
            } else {
                request.setAttribute("erreur", "Une erreur est survenue lors de la soumission de votre demande.");
            }
            request.getRequestDispatcher("/WEB-INF/views/adhesions/formulaire.jsp")
                   .forward(request, response);
        }
    }
}