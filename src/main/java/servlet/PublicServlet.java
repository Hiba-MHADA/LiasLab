package servlet;

import dao.PublicationDAO;
import dao.EvenementDAO;
import dao.EquipeDAO;
import dao.MembreDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/public")
public class PublicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PublicationDAO pubDao = new PublicationDAO();
        EvenementDAO evtDao   = new EvenementDAO();
        EquipeDAO eqDao       = new EquipeDAO();
        MembreDAO memDao      = new MembreDAO();

        request.setAttribute("publications", pubDao.getAllPublications());
        request.setAttribute("evenements",   evtDao.getAllEvenements());
        request.setAttribute("equipes",      eqDao.getAllEquipes());
        request.setAttribute("nbMembres",    memDao.countMembresActifs());

        request.getRequestDispatcher("/WEB-INF/views/public/index.jsp")
               .forward(request, response);
    }
}