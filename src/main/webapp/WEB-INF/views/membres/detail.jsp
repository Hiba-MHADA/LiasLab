<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("membreConnecte") == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
    Membre m = (Membre) request.getAttribute("membre");
    List<HistoriqueAffiliation> historique = (List<HistoriqueAffiliation>) request.getAttribute("historiqueAffiliation");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Affiliation</title>
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
        .btn-back { padding: 8px 16px; border-radius: 10px; background: #f0fdf4; color: #0d9488; border: 1px solid #ccfbf1; font-size: 0.82rem; font-weight: 600; text-decoration: none; }

        .profile-header {
            background: white; border-radius: 16px; padding: 24px 28px;
            border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            display: flex; align-items: center; gap: 20px; margin-bottom: 22px;
        }
        .ph-avatar { width: 64px; height: 64px; border-radius: 16px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.5rem; color: white; flex-shrink: 0; }
        .ph-info h2 { font-family: 'DM Serif Display', serif; font-size: 1.3rem; color: #0f172a; margin-bottom: 4px; }
        .ph-info p { color: #94a3b8; font-size: 0.85rem; }
        .ph-badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 0.72rem; font-weight: 700; background: #ccfbf1; color: #0d9488; margin-top: 8px; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        .timeline { position: relative; padding-left: 28px; }
        .timeline::before { content: ''; position: absolute; left: 8px; top: 6px; bottom: 6px; width: 2px; background: #e8ecf0; }
        .tl-item { position: relative; padding-bottom: 22px; }
        .tl-item:last-child { padding-bottom: 0; }
        .tl-dot { position: absolute; left: -28px; top: 2px; width: 18px; height: 18px; border-radius: 50%; background: #0d9488; border: 3px solid white; box-shadow: 0 0 0 2px #0d9488; }
        .tl-dot.tl-active { background: #16a34a; box-shadow: 0 0 0 2px #16a34a; }
        .tl-period { font-weight: 700; font-size: 0.875rem; color: #0f172a; margin-bottom: 4px; }
        .tl-status { display: inline-block; padding: 2px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; margin-left: 8px; }
        .tl-status.tl-en-cours { background: #dcfce7; color: #166534; }
        .tl-status.tl-termine { background: #f1f5f9; color: #64748b; }
        .tl-motif { font-size: 0.78rem; color: #94a3b8; margin-top: 3px; }
        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="membres" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>📅 Historique d'affiliation</h1>
            <p>Périodes d'appartenance au laboratoire</p>
        </div>
        <a href="<%= request.getContextPath() %>/membres" class="btn-back">← Retour à la liste</a>
    </div>

    <% if (m == null) { %>
        <div class="card"><div class="empty">⚠️ Membre introuvable</div></div>
    <% } else { %>

    <div class="profile-header">
        <div class="ph-avatar"><%= m.getPrenom().charAt(0) %><%= m.getNom().charAt(0) %></div>
        <div class="ph-info">
            <h2><%= m.getPrenom() %> <%= m.getNom() %></h2>
            <p><%= m.getEmail() %></p>
            <span class="ph-badge"><%= m.getStatut() != null ? m.getStatut() : "-" %></span>
        </div>
    </div>

    <div class="card">
        <div class="card-title">🕒 Périodes d'affiliation au laboratoire</div>
        <% if (historique == null || historique.isEmpty()) { %>
            <div class="empty">Aucune période d'affiliation enregistrée</div>
        <% } else { %>
        <div class="timeline">
            <% for (HistoriqueAffiliation h : historique) {
                boolean enCours = (h.getDateFin() == null);
            %>
            <div class="tl-item">
                <div class="tl-dot <%= enCours ? "tl-active" : "" %>"></div>
                <div class="tl-period">
                    <%= sdf.format(h.getDateDebut()) %> → <%= enCours ? "Aujourd'hui" : sdf.format(h.getDateFin()) %>
                    <span class="tl-status <%= enCours ? "tl-en-cours" : "tl-termine" %>"><%= enCours ? "✅ En cours" : "⏹️ Terminée" %></span>
                </div>
                <% if (h.getMotif() != null && !h.getMotif().isEmpty()) { %>
                <div class="tl-motif">📌 <%= h.getMotif() %></div>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>