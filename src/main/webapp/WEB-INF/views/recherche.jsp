<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    String terme = (String) request.getAttribute("terme");
    List<Membre> rMembres = (List<Membre>) request.getAttribute("membres");
    List<Document> rDocs = (List<Document>) request.getAttribute("documents");
    List<Evenement> rEvts = (List<Evenement>) request.getAttribute("evenements");
    List<Publication> rPubs = (List<Publication>) request.getAttribute("publications");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Recherche</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f5f7fa; display: flex; min-height: 100vh; }
        .sidebar { width: 255px; background: white; border-right: 1px solid #e8ecf0; position: fixed; height: 100vh; display: flex; flex-direction: column; box-shadow: 2px 0 16px rgba(0,0,0,0.04); }
        .sidebar-logo { padding: 22px 20px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; gap: 12px; }
        .logo-box { width: 42px; height: 42px; border-radius: 12px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .logo-txt h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .logo-txt p  { font-size: 0.65rem; color: #94a3b8; }
        .sidebar-menu { padding: 16px 0; flex: 1; overflow-y: auto; }
        .menu-label { padding: 10px 20px 4px; font-size: 0.58rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; color: #cbd5e1; }
        .sidebar a { display: flex; align-items: center; gap: 10px; padding: 9px 16px; margin: 1px 8px; color: #64748b; text-decoration: none; font-size: 0.825rem; font-weight: 500; border-radius: 10px; transition: all 0.15s; }
        .sidebar a:hover { background: #f0fdf4; color: #0d9488; }
        .sidebar a.active { background: linear-gradient(135deg, #ccfbf1, #cffafe); color: #0d9488; font-weight: 700; }
        .sidebar a .ico { font-size: 1rem; width: 20px; text-align: center; }
        .role-chip { margin: 4px 12px 8px; padding: 6px 12px; border-radius: 8px; font-size: 0.68rem; font-weight: 700; text-align: center; text-transform: uppercase; letter-spacing: 0.5px; }
        .rc-admin     { background: #fef3c7; color: #b45309; }
        .rc-directeur { background: #dbeafe; color: #1d4ed8; }
        .rc-chef      { background: #dcfce7; color: #166534; }
        .rc-membre    { background: #f0fdf4; color: #0d9488; }
        .rc-doctorant { background: #ede9fe; color: #6d28d9; }
        .rc-associe   { background: #fce7f3; color: #9d174d; }
        .sidebar-footer { padding: 14px 16px; border-top: 1px solid #f0f2f5; display: flex; align-items: center; gap: 10px; }
        .s-avatar { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.8rem; color: white; flex-shrink: 0; }
        .s-info .s-name { font-size: 0.82rem; font-weight: 700; color: #0f172a; }
        .s-info .s-role { font-size: 0.67rem; color: #94a3b8; }

        .main { margin-left: 255px; padding: 28px 32px; flex: 1; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .topbar h1 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; color: #0f172a; }
        .topbar p  { font-size: 0.85rem; color: #94a3b8; margin-top: 3px; }

        .search-card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); margin-bottom: 22px; }
        .search-form { display: flex; gap: 10px; }
        .search-form input { flex: 1; padding: 12px 16px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .search-form input:focus { border-color: #0d9488; background: white; }
        .btn-save { padding: 12px 24px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.9rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }

        .results-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; justify-content: space-between; }
        .count-badge { background: #ccfbf1; color: #0d9488; font-size: 0.72rem; font-weight: 800; padding: 2px 10px; border-radius: 20px; }

        .result-item { padding: 11px 0; border-bottom: 1px solid #f8fafc; font-size: 0.85rem; color: #334155; }
        .result-item:last-child { border-bottom: none; }
        .result-item strong { color: #0f172a; }
        .result-sub { color: #94a3b8; font-size: 0.78rem; margin-top: 2px; }
        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }
        .empty-all { text-align: center; padding: 60px; color: #94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="recherche" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🔍 Recherche globale</h1>
            <p>Recherchez parmi les membres, documents, événements et publications</p>
        </div>
    </div>

    <div class="search-card">
        <form method="get" action="<%= request.getContextPath() %>/recherche" class="search-form">
            <input type="text" name="terme" placeholder="Rechercher un nom, un titre, un document..."
                   value="<%= terme != null ? terme : "" %>" />
            <button type="submit" class="btn-save">🔍 Rechercher</button>
        </form>
    </div>

    <% if (terme == null || terme.trim().isEmpty()) { %>
        <div class="card"><div class="empty-all">🔍 Saisissez un terme pour lancer une recherche</div></div>
    <% } else { %>

    <div class="results-grid">
        <div class="card">
            <div class="card-title">
                👥 Membres
                <span class="count-badge"><%= rMembres != null ? rMembres.size() : 0 %></span>
            </div>
            <% if (rMembres == null || rMembres.isEmpty()) { %>
                <div class="empty">Aucun résultat</div>
            <% } else { %>
                <% for (Membre m : rMembres) { %>
                <div class="result-item">
                    <strong><%= m.getPrenom() %> <%= m.getNom() %></strong>
                    <div class="result-sub"><%= m.getEmail() %> · <%= m.getStatut() != null ? m.getStatut() : "membre" %></div>
                </div>
                <% } %>
            <% } %>
        </div>

        <div class="card">
            <div class="card-title">
                📁 Documents
                <span class="count-badge"><%= rDocs != null ? rDocs.size() : 0 %></span>
            </div>
            <% if (rDocs == null || rDocs.isEmpty()) { %>
                <div class="empty">Aucun résultat</div>
            <% } else { %>
                <% for (Document d : rDocs) { %>
                <div class="result-item">
                    <strong><%= d.getNom() %></strong>
                    <div class="result-sub"><%= d.getType() %><%= d.getNomEvenement() != null ? " · " + d.getNomEvenement() : "" %></div>
                </div>
                <% } %>
            <% } %>
        </div>

        <div class="card">
            <div class="card-title">
                📅 Événements
                <span class="count-badge"><%= rEvts != null ? rEvts.size() : 0 %></span>
            </div>
            <% if (rEvts == null || rEvts.isEmpty()) { %>
                <div class="empty">Aucun résultat</div>
            <% } else { %>
                <% for (Evenement e : rEvts) { %>
                <div class="result-item">
                    <strong><%= e.getTitre() %></strong>
                    <div class="result-sub"><%= e.getType() %><%= e.getLieu() != null ? " · " + e.getLieu() : "" %></div>
                </div>
                <% } %>
            <% } %>
        </div>

        <div class="card">
            <div class="card-title">
                📚 Publications
                <span class="count-badge"><%= rPubs != null ? rPubs.size() : 0 %></span>
            </div>
            <% if (rPubs == null || rPubs.isEmpty()) { %>
                <div class="empty">Aucun résultat</div>
            <% } else { %>
                <% for (Publication p : rPubs) { %>
                <div class="result-item">
                    <strong><%= p.getTitre() %></strong>
                    <div class="result-sub"><%= p.getAnnee() %><%= p.getAuteurs() != null ? " · " + p.getAuteurs() : "" %></div>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>