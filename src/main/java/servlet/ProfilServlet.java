package servlet;

import dao.MembreDAO;
import model.Membre;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import dao.HistoriqueProfilDAO;
@WebServlet("/profil")
public class ProfilServlet extends HttpServlet {

    private MembreDAO dao = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        HistoriqueProfilDAO histDao = new HistoriqueProfilDAO();
        request.setAttribute("historique", histDao.getByMembre(membre.getId()));
        request.getRequestDispatcher("/WEB-INF/views/profil.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        String action = request.getParameter("action");

        if ("changerMdp".equals(action)) {
            String ancienMdp  = request.getParameter("ancienMdp");
            String nouveauMdp = request.getParameter("nouveauMdp");
            String confirmMdp = request.getParameter("confirmMdp");

            if (!nouveauMdp.equals(confirmMdp)) {
                request.setAttribute("erreurMdp", "Les mots de passe ne correspondent pas !");
            } else if (nouveauMdp.length() < 6) {
                request.setAttribute("erreurMdp", "Minimum 6 caractères !");
            } else {
                boolean ok = dao.changerMotDePasse(membre.getId(), ancienMdp, nouveauMdp);
                if (ok) {
                    request.setAttribute("successMdp", "✅ Mot de passe changé avec succès !");
                } else {
                    request.setAttribute("erreurMdp", "Ancien mot de passe incorrect !");
                }
            }

        } else if ("modifierProfil".equals(action)) {
            HistoriqueProfilDAO histDao = new HistoriqueProfilDAO();

            // Sauvegarder les anciennes valeurs avant modification
            String ancienNom = membre.getNom();
            String ancienPrenom = membre.getPrenom();
            String ancienEtablissement = membre.getEtablissement();
            String ancienneBio = membre.getBiographie();
            String ancienCentresInteret = membre.getCentresInteret();

            String nouveauNom = request.getParameter("nom");
            String nouveauPrenom = request.getParameter("prenom");
            String nouvelEtablissement = request.getParameter("etablissement");
            String nouvelleBio = request.getParameter("biographie");
            String nouveauxCentresInteret = request.getParameter("centresInteret");

            membre.setNom(nouveauNom);
            membre.setPrenom(nouveauPrenom);
            membre.setEtablissement(nouvelEtablissement);
            membre.setBiographie(nouvelleBio);
            membre.setCentresInteret(nouveauxCentresInteret);

            boolean ok = dao.updateMembre(membre);
            if (ok) {
                // Historiser chaque champ modifié
            	histDao.enregistrer(membre.getId(), "nom", ancienNom, nouveauNom);
            	histDao.enregistrer(membre.getId(), "prenom", ancienPrenom, nouveauPrenom);
            	histDao.enregistrer(membre.getId(), "etablissement", ancienEtablissement, nouvelEtablissement);
            	histDao.enregistrer(membre.getId(), "biographie", ancienneBio, nouvelleBio);
            	histDao.enregistrer(membre.getId(), "centres d'intérêt", ancienCentresInteret, nouveauxCentresInteret);

                session.setAttribute("membreConnecte", membre);
                request.setAttribute("successProfil", "✅ Profil mis à jour !");
            } else {
                request.setAttribute("erreurProfil", "Erreur lors de la mise à jour !");
            }
        }

        HistoriqueProfilDAO histDaoFinal = new HistoriqueProfilDAO();
        request.setAttribute("historique", histDaoFinal.getByMembre(membre.getId()));
        request.getRequestDispatcher("/WEB-INF/views/profil.jsp").forward(request, response);
    }
}