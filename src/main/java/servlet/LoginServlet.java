package servlet;

import dao.MembreDAO;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        MembreDAO dao = new MembreDAO();
        Membre membre = dao.login(email, motDePasse);

        if (membre != null) {
            HttpSession session = request.getSession();
            session.setAttribute("membreConnecte", membre);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("erreur", "Email ou mot de passe incorrect !");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}