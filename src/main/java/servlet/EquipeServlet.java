package servlet;

import dao.EquipeDAO;
import model.Equipe;
import model.Membre;
import model.RoleMembre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/equipes")
public class EquipeServlet extends HttpServlet {

    private EquipeDAO dao = new EquipeDAO();

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
            case "detail":
                int id = Integer.parseInt(request.getParameter("id"));
                Equipe eq = dao.getEquipeById(id);
                List<RoleMembre> membres = dao.getMembresEquipe(id);
                List<Membre> tousMembers = dao.getMembresActifs();
                request.setAttribute("equipe", eq);
                request.setAttribute("membresEquipe", membres);
                request.setAttribute("tousMembers", tousMembers);
                request.getRequestDispatcher("/WEB-INF/views/equipes/detail.jsp")
                       .forward(request, response);
                break;
            case "supprimer":
                dao.deleteEquipe(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/equipes");
                break;
            case "retirer":
                dao.retirerMembre(Integer.parseInt(request.getParameter("roleId")));
                response.sendRedirect(request.getContextPath() + "/equipes?action=detail&id=" + request.getParameter("equipeId"));
                break;
            default:
                List<Equipe> equipes = dao.getAllEquipes();
                request.setAttribute("equipes", equipes);
                request.getRequestDispatcher("/WEB-INF/views/equipes/liste.jsp")
                       .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("ajouterEquipe".equals(action)) {
            Equipe e = new Equipe();
            e.setNom(request.getParameter("nom"));
            e.setDescription(request.getParameter("description"));
            dao.addEquipe(e);
            response.sendRedirect(request.getContextPath() + "/equipes");

        } else if ("modifierEquipe".equals(action)) {
            Equipe e = new Equipe();
            e.setId(Integer.parseInt(request.getParameter("id")));
            e.setNom(request.getParameter("nom"));
            e.setDescription(request.getParameter("description"));
            dao.updateEquipe(e);
            response.sendRedirect(request.getContextPath() + "/equipes");

        } else if ("affecterMembre".equals(action)) {
            int membreId = Integer.parseInt(request.getParameter("membreId"));
            int equipeId = Integer.parseInt(request.getParameter("equipeId"));
            String role  = request.getParameter("role");
            dao.affecterMembre(membreId, equipeId, role);
            response.sendRedirect(request.getContextPath() + "/equipes?action=detail&id=" + equipeId);
        }
    }
}