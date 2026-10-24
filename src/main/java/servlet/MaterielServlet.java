package servlet;

import dao.MaterielDAO;
import model.Materiel;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/materiel")
public class MaterielServlet extends HttpServlet {

    private MaterielDAO dao = new MaterielDAO();

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
            response.sendRedirect(request.getContextPath() + "/materiel"); return;
        }
        if ("retourner".equals(action)) {
            dao.retourner(Integer.parseInt(request.getParameter("attributionId")));
            response.sendRedirect(request.getContextPath() + "/materiel"); return;
        }

        request.setAttribute("materiels",  dao.getAll());
        request.setAttribute("historique", dao.getHistorique());
        request.setAttribute("membres",    dao.getMembresActifs());
        request.getRequestDispatcher("/WEB-INF/views/materiel/liste.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }

        String action = request.getParameter("action");

        if ("ajouter".equals(action)) {
            Materiel m = new Materiel();
            m.setDesignation(request.getParameter("designation"));
            m.setQuantite(Integer.parseInt(request.getParameter("quantite")));
            try {
                String d = request.getParameter("dateArrivee");
                if (d != null && !d.isEmpty())
                    m.setDateArrivee(new SimpleDateFormat("yyyy-MM-dd").parse(d));
            } catch (Exception e) { e.printStackTrace(); }
            dao.add(m);

        } else if ("attribuer".equals(action)) {
            int materielId = Integer.parseInt(request.getParameter("materielId"));
            int membreId   = Integer.parseInt(request.getParameter("membreId"));
            int quantite   = Integer.parseInt(request.getParameter("quantite"));
            java.util.Date dateRetour = null;
            try {
                String dr = request.getParameter("dateRetourPrevue");
                if (dr != null && !dr.isEmpty())
                    dateRetour = new SimpleDateFormat("yyyy-MM-dd").parse(dr);
            } catch (Exception e) { e.printStackTrace(); }
            dao.attribuer(materielId, membreId, quantite, dateRetour);
        }

        response.sendRedirect(request.getContextPath() + "/materiel");
    }
}