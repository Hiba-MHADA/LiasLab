<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    String roleUser   = connecte != null && connecte.getRole() != null ? connecte.getRole() : "membre";
    String statutUser = connecte != null && connecte.getStatut() != null ? connecte.getStatut() : "permanent";
    boolean sIsAdmin     = "admin".equals(roleUser);
    boolean sIsDirecteur = "directeur".equals(roleUser) || "vice_directeur".equals(roleUser);
    boolean sIsChef      = "chef_equipe".equals(roleUser);
    boolean sIsDoctorant = "doctorant".equals(statutUser);
    boolean sIsAssocie   = "associe".equals(statutUser);
    String currentPage   = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
%>
<div class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-box">🔬</div>
        <div class="logo-txt">
            <h2>LIAS Lab</h2>
            <p>Faculté Ben M'Sik</p>
        </div>
    </div>

    <div class="sidebar-menu">
        <% if (sIsAdmin) { %>
            <div class="role-chip rc-admin">⚙️ Administrateur</div>
        <% } else if (sIsDirecteur) { %>
            <div class="role-chip rc-directeur">🎓 <%= "vice_directeur".equals(roleUser) ? "Vice-Directeur" : "Directeur" %></div>
        <% } else if (sIsChef) { %>
            <div class="role-chip rc-chef">🏛️ Chef d'équipe</div>
        <% } else if (sIsDoctorant) { %>
            <div class="role-chip rc-doctorant">📖 Doctorant</div>
        <% } else if (sIsAssocie) { %>
            <div class="role-chip rc-associe">🤝 Associé</div>
        <% } else { %>
            <div class="role-chip rc-membre">👤 Membre</div>
        <% } %>

        <div class="menu-label">Principal</div>
        <a href="<%= request.getContextPath() %>/dashboard" class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🏠</span> Tableau de bord
        </a>
        <% if (sIsAdmin || sIsDirecteur) { %>
        <a href="<%= request.getContextPath() %>/membres" class="<%= "membres".equals(currentPage) ? "active" : "" %>">
            <span class="ico">👥</span> Membres
        </a>
        <a href="<%= request.getContextPath() %>/adhesions" class="<%= "adhesions".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📋</span> Demandes d'adhésion
        </a>
        <% } %>

        <div class="menu-label">Scientifique</div>
        <a href="<%= request.getContextPath() %>/publications" class="<%= "publications".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📚</span> Publications
        </a>
        <% if (!sIsDoctorant) { %>
        <a href="<%= request.getContextPath() %>/evenements" class="<%= "evenements".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📅</span> Événements
        </a>
        <a href="<%= request.getContextPath() %>/equipes" class="<%= "equipes".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🏛️</span> Équipes & Rôles
        </a>
        <% } %>
        <% if (sIsAdmin || sIsDirecteur) { %>
        <a href="<%= request.getContextPath() %>/mandats" class="<%= "mandats".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🎓</span> Mandats
        </a>
        <% } %>

        <% if (!sIsDoctorant && !sIsAssocie) { %>
        <div class="menu-label">Administratif</div>
        <a href="<%= request.getContextPath() %>/documents" class="<%= "documents".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📁</span> Documents
        </a>
        <a href="<%= request.getContextPath() %>/materiel" class="<%= "materiel".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🖥️</span> Matériel
        </a>
        <% if (sIsAdmin || sIsDirecteur) { %>
        <a href="<%= request.getContextPath() %>/conventions" class="<%= "conventions".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🤝</span> Conventions
        </a>
        <% } %>
        <a href="<%= request.getContextPath() %>/reunions" class="<%= "reunions".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📋</span> PV Réunions
        </a>
        <% } %>

        <div class="menu-label">Autre</div>
        <a href="<%= request.getContextPath() %>/communication" class="<%= "communication".equals(currentPage) ? "active" : "" %>">
            <span class="ico">💬</span> Communication
        </a>
        <a href="<%= request.getContextPath() %>/calendrier" class="<%= "calendrier".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🗓️</span> Calendrier
        </a>
        <a href="<%= request.getContextPath() %>/notifications" class="<%= "notifications".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🔔</span> Notifications
        </a>
        <a href="<%= request.getContextPath() %>/recherche" class="<%= "recherche".equals(currentPage) ? "active" : "" %>">
            <span class="ico">🔍</span> Recherche
        </a>
        <% if (sIsAdmin || sIsDirecteur) { %>
        <a href="<%= request.getContextPath() %>/rapport" class="<%= "rapport".equals(currentPage) ? "active" : "" %>">
            <span class="ico">📊</span> Rapport annuel
        </a>
        <% } %>

        <div class="menu-label">Compte</div>
        <a href="<%= request.getContextPath() %>/profil" class="<%= "profil".equals(currentPage) ? "active" : "" %>">
            <span class="ico">👤</span> Mon profil
        </a>
        <a href="<%= request.getContextPath() %>/logout">
            <span class="ico">🚪</span> Déconnexion
        </a>
    </div>

    <% if (connecte != null) { %>
    <div class="sidebar-footer">
        <div class="s-avatar">
            <%= connecte.getPrenom().charAt(0) %><%= connecte.getNom().charAt(0) %>
        </div>
        <div class="s-info">
            <div class="s-name"><%= connecte.getPrenom() %> <%= connecte.getNom() %></div>
            <div class="s-role"><%= roleUser %></div>
        </div>
    </div>
    <% } %>
</div>