package servlet;

import dao.MessageDAO;
import dao.MembreDAO;
import model.Message;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/communication")
public class CommunicationServlet extends HttpServlet {

    private MessageDAO dao    = new MessageDAO();
    private MembreDAO  memDao = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); return;
        }
        Membre connecte = (Membre) session.getAttribute("membreConnecte");
        String tab = request.getParameter("tab");
        if (tab == null) tab = "recus";

        request.setAttribute("tab",      tab);
        request.setAttribute("recus",    dao.getMessagesRecus(connecte.getId()));
        request.setAttribute("envoyes",  dao.getMessagesEnvoyes(connecte.getId()));
        request.setAttribute("membres",  memDao.getAllMembres());
        request.getRequestDispatcher("/WEB-INF/views/communication.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Membre connecte = (Membre) session.getAttribute("membreConnecte");
        if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Message m = new Message();
        m.setExpediteurId(connecte.getId());
        String destStr = request.getParameter("destinataireId");
        if (destStr != null && !destStr.isEmpty()) m.setDestinataireId(Integer.parseInt(destStr));
        m.setContenu(request.getParameter("contenu"));
        dao.envoyer(m);
        response.sendRedirect(request.getContextPath() + "/communication?tab=envoyes");
    }
}