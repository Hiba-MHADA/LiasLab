package servlet;
import dao.ReunionDAO;
import model.Reunion;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/reunions")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10 Mo max
public class ReunionServlet extends HttpServlet {
    private ReunionDAO dao = new ReunionDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        if ("supprimer".equals(request.getParameter("action"))) {
            dao.delete(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/reunions"); return;
        }
        request.setAttribute("reunions", dao.getAll());
        request.getRequestDispatcher("/WEB-INF/views/reunions/liste.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Reunion r = new Reunion();
        r.setTitre(request.getParameter("titre"));
        r.setOrdreJour(request.getParameter("ordreJour"));

        // Upload réel du fichier PV
        Part filePart = request.getPart("pvFichier");
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = filePart.getSubmittedFileName();
            String nomStocke = System.currentTimeMillis() + "_" + submittedFileName;

            String uploadDir = getServletContext().getRealPath("/uploads/pv");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            filePart.write(uploadDir + File.separator + nomStocke);
            r.setPvPath(nomStocke);
        }

        try {
            String d = request.getParameter("dateReunion");
            if (d != null && !d.isEmpty())
                r.setDateReunion(new SimpleDateFormat("yyyy-MM-dd").parse(d));
        } catch (Exception e) { e.printStackTrace(); }
        dao.add(r);
        response.sendRedirect(request.getContextPath() + "/reunions");
    }
}