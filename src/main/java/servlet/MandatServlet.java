package servlet;

import dao.MandatDAO;
import model.Mandat;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/mandats")
public class MandatServlet extends HttpServlet {

    private MandatDAO dao = new MandatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        if ("supprimer".equals(request.getParameter("action"))) {
            dao.delete(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/mandats"); return;
        }
        request.setAttribute("mandats",  dao.getAll());
        request.setAttribute("membres",  dao.getMembresActifs());
        request.getRequestDispatcher("/WEB-INF/views/mandats.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Mandat m = new Mandat();
        m.setDirecteurId(Integer.parseInt(request.getParameter("directeurId")));
        String vdStr = request.getParameter("viceDirecteurId");
        if (vdStr != null && !vdStr.isEmpty()) m.setViceDirecteurId(Integer.parseInt(vdStr));
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String dd = request.getParameter("dateDebut");
            String df = request.getParameter("dateFin");
            if (dd != null && !dd.isEmpty()) m.setDateDebut(sdf.parse(dd));
            if (df != null && !df.isEmpty()) m.setDateFin(sdf.parse(df));
        } catch (Exception e) { e.printStackTrace(); }
        dao.add(m);
        response.sendRedirect(request.getContextPath() + "/mandats");
    }
}