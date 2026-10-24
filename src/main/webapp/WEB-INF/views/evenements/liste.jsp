<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, model.Evenement, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    boolean canManage = "admin".equals(role) || "directeur".equals(role) || "chef_equipe".equals(role) || "membre".equals(role);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Événements</title>
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
        .btn-new { padding: 10px 20px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.85rem; font-weight: 700; text-decoration: none; box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s; }
        .btn-new:hover { transform: translateY(-1px); }

        .stats-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 14px; margin-bottom: 22px; }
        .stat-mini { background: white; border-radius: 14px; padding: 16px 18px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); display: flex; align-items: center; gap: 12px; }
        .sm-ico { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .smi1 { background: #ccfbf1; }
        .smi3 { background: #ede9fe; }
        .smi4 { background: #fef3c7; }
        .sm-num { font-size: 1.4rem; font-weight: 800; color: #0f172a; }
        .sm-lbl { font-size: 0.7rem; color: #94a3b8; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .filters { display: flex; gap: 10px; margin-bottom: 18px; flex-wrap: wrap; }
        .search-box { display: flex; align-items: center; gap: 8px; padding: 9px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; background: #f8fafc; flex: 1; transition: all 0.2s; }
        .search-box:focus-within { border-color: #0d9488; background: white; }
        .search-box input { border: none; background: transparent; outline: none; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; flex: 1; }
        .filter-select { padding: 9px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.85rem; font-family: 'Outfit', sans-serif; color: #374151; background: #f8fafc; outline: none; }
        .filter-select:focus { border-color: #0d9488; }

        .evt-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px,1fr)); gap: 16px; }
        .evt-card { background: #f8fafc; border-radius: 14px; padding: 20px; border: 1px solid #e8ecf0; transition: all 0.2s; position: relative; overflow: hidden; }
        .evt-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(13,148,136,0.1); }
        .evt-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
        .evt-conference::before { background: linear-gradient(90deg, #0d9488, #0891b2); }
        .evt-seminaire::before  { background: linear-gradient(90deg, #7c3aed, #6366f1); }
        .evt-workshop::before   { background: linear-gradient(90deg, #d97706, #f59e0b); }

        .evt-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .evt-type { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; }
        .type-conference { background: #ccfbf1; color: #0d9488; }
        .type-seminaire  { background: #ede9fe; color: #6d28d9; }
        .type-workshop   { background: #fef3c7; color: #b45309; }
        .evt-edition { font-size: 0.68rem; color: #94a3b8; font-weight: 600; }
        .evt-titre { font-size: 0.95rem; font-weight: 700; color: #0f172a; margin-bottom: 10px; line-height: 1.4; }
        .evt-meta { display: flex; flex-direction: column; gap: 5px; margin-bottom: 12px; }
        .evt-meta-item { display: flex; align-items: center; gap: 7px; font-size: 0.78rem; color: #64748b; }
        .evt-desc { font-size: 0.78rem; color: #94a3b8; margin-bottom: 14px; line-height: 1.5; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .evt-footer { display: flex; justify-content: flex-end; gap: 6px; }
        .btn-sm { padding: 5px 10px; border-radius: 7px; font-size: 0.72rem; font-weight: 700; cursor: pointer; text-decoration: none; border: none; font-family: 'Outfit', sans-serif; transition: all 0.15s; }
        .btn-edit { background: #f0fdf4; color: #0d9488; border: 1px solid #a7f3d0; }
        .btn-del  { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }
        .btn-edit:hover { background: #ccfbf1; }
        .btn-del:hover  { background: #ffe4e6; }

        .empty { text-align: center; padding: 60px; color: #94a3b8; }
        .empty .e-ico { font-size: 3.5rem; margin-bottom: 16px; }
        .empty h3 { font-size: 1rem; margin-bottom: 8px; color: #64748b; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="evenements" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>📅 Événements</h1>
            <p>Conférences, séminaires et workshops du laboratoire</p>
        </div>
        <% if (canManage) { %>
        <a href="<%= request.getContextPath() %>/evenements?action=nouveau" class="btn-new">+ Nouvel événement</a>
        <% } %>
    </div>

    <%
        int total = evenements != null ? evenements.size() : 0;
        int conferences = 0, seminaires = 0, workshops = 0;
        if (evenements != null) for (Evenement e : evenements) {
            if ("conference".equals(e.getType())) conferences++;
            else if ("seminaire".equals(e.getType())) seminaires++;
            else if ("workshop".equals(e.getType())) workshops++;
        }
    %>
    <div class="stats-row">
        <div class="stat-mini"><div class="sm-ico smi1">📅</div><div><div class="sm-num"><%= total %></div><div class="sm-lbl">Total</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi1">🎤</div><div><div class="sm-num"><%= conferences %></div><div class="sm-lbl">Conférences</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi3">📖</div><div><div class="sm-num"><%= seminaires %></div><div class="sm-lbl">Séminaires</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi4">🔧</div><div><div class="sm-num"><%= workshops %></div><div class="sm-lbl">Workshops</div></div></div>
    </div>

    <div class="card">
        <div class="filters">
            <div class="search-box">🔍 <input type="text" id="searchInput" placeholder="Rechercher..." onkeyup="filterEvts()" /></div>
            <select class="filter-select" id="typeFilter" onchange="filterEvts()">
                <option value="">Tous les types</option>
                <option value="conference">Conférence</option>
                <option value="seminaire">Séminaire</option>
                <option value="workshop">Workshop</option>
            </select>
        </div>

        <% if (evenements == null || evenements.isEmpty()) { %>
            <div class="empty">
                <div class="e-ico">📅</div>
                <h3>Aucun événement pour le moment</h3>
                <p>Cliquez sur "+ Nouvel événement" pour commencer</p>
            </div>
        <% } else { %>
        <div class="evt-grid" id="evtGrid">
            <% for (Evenement e : evenements) {
                String typeClass  = "conference".equals(e.getType()) ? "evt-conference" : "seminaire".equals(e.getType()) ? "evt-seminaire" : "evt-workshop";
                String badgeClass = "conference".equals(e.getType()) ? "type-conference" : "seminaire".equals(e.getType()) ? "type-seminaire" : "type-workshop";
                String typeLabel  = "conference".equals(e.getType()) ? "🎤 Conférence" : "seminaire".equals(e.getType()) ? "📖 Séminaire" : "🔧 Workshop";
            %>
            <div class="evt-card <%= typeClass %>" data-type="<%= e.getType() %>" data-search="<%= e.getTitre()!=null?e.getTitre():"" %>">
                <div class="evt-header">
                    <span class="evt-type <%= badgeClass %>"><%= typeLabel %></span>
                    <% if (e.getEdition() > 0) { %><span class="evt-edition">Éd. <%= e.getEdition() %></span><% } %>
                </div>
                <div class="evt-titre"><%= e.getTitre() != null ? e.getTitre() : "-" %></div>
                <div class="evt-meta">
                    <% if (e.getDateDebut() != null) { %>
                    <div class="evt-meta-item">📅 <%= sdf.format(e.getDateDebut()) %><% if (e.getDateFin() != null) { %> → <%= sdf.format(e.getDateFin()) %><% } %></div>
                    <% } %>
                    <% if (e.getLieu() != null && !e.getLieu().isEmpty()) { %>
                    <div class="evt-meta-item">📍 <%= e.getLieu() %></div>
                    <% } %>
                </div>
                <% if (e.getDescription() != null && !e.getDescription().isEmpty()) { %>
                <div class="evt-desc"><%= e.getDescription() %></div>
                <% } %>
                <div class="evt-footer">
                    <a href="<%= request.getContextPath() %>/evenements?action=detail&id=<%= e.getId() %>" class="btn-sm btn-edit">👥 Organisateurs</a>
                    <% if (canManage) { %>
                    <a href="<%= request.getContextPath() %>/evenements?action=modifier&id=<%= e.getId() %>" class="btn-sm btn-edit">✏️ Modifier</a>
                    <a href="<%= request.getContextPath() %>/evenements?action=supprimer&id=<%= e.getId() %>" class="btn-sm btn-del" onclick="return confirm('Supprimer cet événement ?')">🗑️</a>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>
<script>
function filterEvts() {
    const q    = document.getElementById('searchInput').value.toLowerCase();
    const type = document.getElementById('typeFilter').value;
    document.querySelectorAll('.evt-card').forEach(card => {
        const matchQ    = card.dataset.search.toLowerCase().includes(q);
        const matchType = type === '' || card.dataset.type === type;
        card.style.display = matchQ && matchType ? '' : 'none';
    });
}
</script>
</body>
</html>