package servlet;
import dao.ConventionDAO;
import dao.DocumentDAO;
import model.Convention;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {
    private ConventionDAO dao = new ConventionDAO();
    private DocumentDAO docDao = new DocumentDAO();
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
            response.sendRedirect(request.getContextPath() + "/conventions"); return;
        }

        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Convention c = dao.getById(id);
            request.setAttribute("convention", c);
            request.setAttribute("documents", docDao.getByConvention(id));
            request.getRequestDispatcher("/WEB-INF/views/conventions/detail.jsp").forward(request, response);
            return;
        }

        request.setAttribute("conventions", dao.getAll());
        request.getRequestDispatcher("/WEB-INF/views/conventions/liste.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Convention c = new Convention();
        c.setPartenaire(request.getParameter("partenaire"));
        c.setDescription(request.getParameter("description"));
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String dd = request.getParameter("dateDebut");
            String df = request.getParameter("dateFin");
            if (dd != null && !dd.isEmpty()) c.setDateDebut(sdf.parse(dd));
            if (df != null && !df.isEmpty()) c.setDateFin(sdf.parse(df));
        } catch (Exception e) { e.printStackTrace(); }
        dao.add(c);
        response.sendRedirect(request.getContextPath() + "/conventions");
    }
}