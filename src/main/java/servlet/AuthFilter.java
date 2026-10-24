package servlet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Membre;
import java.io.IOException;
@WebFilter("/*")
public class AuthFilter implements Filter {
    // Pages accessibles sans connexion
	private static final String[] PUBLIC_URLS = {
		    "/login", "/public", "/adhesion", "/logout"
		};
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request   = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path = request.getServletPath();
        // Laisser passer les URLs publiques et ressources statiques
        for (String url : PUBLIC_URLS) {
            if (path.startsWith(url)) {
                chain.doFilter(req, res); return;
            }
        }
        if (path.startsWith("/assets") || path.startsWith("/css") || path.startsWith("/js")) {
            chain.doFilter(req, res); return;
        }
        // Vérifier session
        HttpSession session = request.getSession(false);
        Membre membre = (session != null) ? (Membre) session.getAttribute("membreConnecte") : null;
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Rôle de gouvernance (admin, directeur, vice_directeur, chef_equipe, membre)
        String role = membre.getRole() != null ? membre.getRole() : "membre";
        // Statut au laboratoire (permanent, associe, doctorant, retraite, ancien)
        String statut = membre.getStatut() != null ? membre.getStatut() : "permanent";

        // Retraités et anciens → aucun accès (basé sur le STATUT, pas le rôle)
        if ("retraite".equals(statut) || "ancien".equals(statut)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Pages réservées admin seulement
        if (path.startsWith("/admin") && !"admin".equals(role)) {
            request.setAttribute("erreurAcces", "Accès réservé à l'administrateur.");
            request.getRequestDispatcher("/WEB-INF/views/acces-refuse.jsp").forward(request, response);
            return;
        }
        // Pages réservées directeur + admin
        if (path.startsWith("/adhesions") || path.startsWith("/mandats")) {
            if (!"admin".equals(role) && !"directeur".equals(role)) {
                request.setAttribute("erreurAcces", "Accès réservé au directeur.");
                request.getRequestDispatcher("/WEB-INF/views/acces-refuse.jsp").forward(request, response);
                return;
            }
        }
        // Doctorants → seulement publications et profil (basé sur le STATUT)
        if ("doctorant".equals(statut)) {
        	if (!path.startsWith("/publications") && !path.startsWith("/dashboard") && !path.startsWith("/profil") && !path.startsWith("/recherche")) {
                request.setAttribute("erreurAcces", "Accès limité pour les doctorants.");
                request.getRequestDispatcher("/WEB-INF/views/acces-refuse.jsp").forward(request, response);
                return;
            }
        }
        // Associés → pas accès aux modules internes (basé sur le STATUT)
        if ("associe".equals(statut)) {
            if (path.startsWith("/membres") || path.startsWith("/mandats") || path.startsWith("/materiel")) {
                request.setAttribute("erreurAcces", "Accès limité pour les membres associés.");
                request.getRequestDispatcher("/WEB-INF/views/acces-refuse.jsp").forward(request, response);
                return;
            }
        }
        chain.doFilter(req, res);
    }
}