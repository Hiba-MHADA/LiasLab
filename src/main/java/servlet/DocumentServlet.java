package servlet;

import dao.DocumentDAO;
import dao.EvenementDAO;
import model.Document;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.util.List;

@WebServlet("/documents")
@MultipartConfig(maxFileSize = 10485760)
public class DocumentServlet extends HttpServlet {

    private DocumentDAO dao = new DocumentDAO();
    private EvenementDAO evtDao = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        String action = request.getParameter("action");
        if ("supprimer".equals(action)) {
            dao.delete(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/documents");
            return;
        }
        request.setAttribute("documents", dao.getAllDocuments());
        request.setAttribute("evenements", evtDao.getAllEvenements());
        request.getRequestDispatcher("/WEB-INF/views/documents/liste.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }

        Part filePart = request.getPart("fichier");
        String fileName = filePart.getSubmittedFileName();

        // Dossier uploads
        String uploadDir = getServletContext().getRealPath("/uploads/documents");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // Sauvegarder le fichier
        String chemin = uploadDir + File.separator + System.currentTimeMillis() + "_" + fileName;
        filePart.write(chemin);

        Document d = new Document();
        d.setNom(request.getParameter("nom").isEmpty() ? fileName : request.getParameter("nom"));
        d.setType(request.getParameter("type"));
        d.setChemin(fileName);

        // --- BLOC REMPLACÉ ---
        String evtId = request.getParameter("evenementId");
        if (evtId != null && !evtId.isEmpty()) d.setEvenementId(Integer.parseInt(evtId));

        String convId = request.getParameter("conventionId");
        if (convId != null && !convId.isEmpty()) d.setConventionId(Integer.parseInt(convId));

        dao.add(d);

        // Notification interne à tous les membres actifs
        new dao.NotificationDAO().notifierTousMembres(
            "Nouveau document ajouté : " + d.getNom()
        );

        // Si on vient de la page détail d'une convention, on y retourne directement
        if (convId != null && !convId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/conventions?action=detail&id=" + convId);
        } else {
            response.sendRedirect(request.getContextPath() + "/documents");
        }
        // ---------------------
    }
}