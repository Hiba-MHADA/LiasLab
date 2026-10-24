package servlet;

import dao.NotificationDAO;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private NotificationDAO dao = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Membre membre = (Membre) session.getAttribute("membreConnecte");

        if ("tousLus".equals(request.getParameter("action"))) {
            dao.marquerTousLus(membre.getId());
            response.sendRedirect(request.getContextPath() + "/notifications"); return;
        }
        if ("lu".equals(request.getParameter("action"))) {
            dao.marquerLu(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/notifications"); return;
        }

        request.setAttribute("notifications", dao.getByMembre(membre.getId()));
        request.setAttribute("nbNonLus", dao.countNonLus(membre.getId()));
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }
}