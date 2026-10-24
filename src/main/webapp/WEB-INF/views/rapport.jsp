<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";

    Integer anneeObj = (Integer) request.getAttribute("annee");
    int annee = anneeObj != null ? anneeObj : java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);

    Integer nbMembresObj = (Integer) request.getAttribute("nbMembres");
    int nbMembres = nbMembresObj != null ? nbMembresObj : 0;

    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
    List<Evenement>   evenements   = (List<Evenement>)   request.getAttribute("evenements");
    List<Document>    documents    = (List<Document>)     request.getAttribute("documents");
    List<Reunion>     reunions     = (List<Reunion>)      request.getAttribute("reunions");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    // Filtrer par année
    int pubAnnee = 0, evtAnnee = 0, docAnnee = 0, reuAnnee = 0;
    if (publications != null) for (Publication p : publications) if (p.getAnnee() == annee) pubAnnee++;
    if (evenements   != null) for (Evenement e : evenements) {
        if (e.getDateDebut() != null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(e.getDateDebut());
            if (cal.get(java.util.Calendar.YEAR) == annee) evtAnnee++;
        }
    }
    if (documents != null) for (Document d : documents) {
        if (d.getDateUpload() != null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(d.getDateUpload());
            if (cal.get(java.util.Calendar.YEAR) == annee) docAnnee++;
        }
    }
    if (reunions != null) for (Reunion r : reunions) {
        if (r.getDateReunion() != null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(r.getDateReunion());
            if (cal.get(java.util.Calendar.YEAR) == annee) reuAnnee++;
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Rapport annuel <%= annee %></title>
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

        .rapport-header {
            background: linear-gradient(135deg, #0f172a, #1e3a5f, #0d9488);
            border-radius: 18px; padding: 36px 40px;
            color: white; margin-bottom: 28px;
            display: flex; justify-content: space-between; align-items: center;
            position: relative; overflow: hidden;
        }
        .rapport-header::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background-image: radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px);
            background-size: 24px 24px;
        }
        .rh-content { position: relative; z-index: 1; }
        .rh-tag { display: inline-block; padding: 4px 12px; border-radius: 20px; background: rgba(13,148,136,0.3); color: #5eead4; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 12px; }
        .rh-content h1 { font-family: 'DM Serif Display', serif; font-size: 2rem; margin-bottom: 6px; }
        .rh-content p  { opacity: 0.7; font-size: 0.875rem; }
        .rh-actions { position: relative; z-index: 1; display: flex; gap: 10px; }
        .btn-print { padding: 10px 20px; border-radius: 10px; background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.2); color: white; font-size: 0.85rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-print:hover { background: rgba(255,255,255,0.25); }

        .year-selector {
            display: flex; align-items: center; gap: 12px; margin-bottom: 24px;
        }
        .year-selector label { font-size: 0.85rem; font-weight: 600; color: #64748b; }
        .year-selector select { padding: 8px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; outline: none; background: white; color: #0f172a; }
        .year-selector select:focus { border-color: #0d9488; }
        .btn-filter { padding: 8px 18px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.85rem; font-weight: 700; cursor: pointer; font-family: 'Outfit', sans-serif; }

        .stat-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: white; border-radius: 16px; padding: 20px 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); position: relative; overflow: hidden; }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
        .sc1::before { background: linear-gradient(90deg, #0d9488, #0891b2); }
        .sc2::before { background: linear-gradient(90deg, #7c3aed, #6366f1); }
        .sc3::before { background: linear-gradient(90deg, #d97706, #f59e0b); }
        .sc4::before { background: linear-gradient(90deg, #0369a1, #0284c7); }
        .sc-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; margin-bottom: 12px; }
        .sc1 .sc-icon { background: #ccfbf1; }
        .sc2 .sc-icon { background: #ede9fe; }
        .sc3 .sc-icon { background: #fef3c7; }
        .sc4 .sc-icon { background: #e0f2fe; }
        .sc-num { font-size: 2rem; font-weight: 800; color: #0f172a; line-height: 1; }
        .sc-lbl { font-size: 0.78rem; color: #94a3b8; margin-top: 5px; }
        .sc-total { font-size: 0.72rem; color: #94a3b8; margin-top: 3px; }

        .section-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; gap: 8px; }

        .rapport-item { padding: 10px 0; border-bottom: 1px solid #f8fafc; font-size: 0.85rem; }
        .rapport-item:last-child { border-bottom: none; }
        .rapport-item strong { color: #0f172a; display: block; margin-bottom: 3px; }
        .rapport-item span   { color: #94a3b8; font-size: 0.78rem; }
        .badge { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; margin-left: 6px; }
        .badge-teal { background: #ccfbf1; color: #0d9488; }
        .badge-purple { background: #ede9fe; color: #6d28d9; }

        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }

        @media print {
            .sidebar, .year-selector, .rh-actions, .btn-print { display: none !important; }
            .main { margin-left: 0 !important; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="rapport" />
</jsp:include>

<div class="main">

    <!-- Header -->
    <div class="rapport-header">
        <div class="rh-content">
            <div class="rh-tag">📊 Rapport d'activité</div>
            <h1>Rapport Annuel <%= annee %></h1>
            <p>Laboratoire LIAS — Faculté des Sciences Ben M'Sik — Université Hassan II de Casablanca</p>
        </div>
        <div class="rh-actions">
            <button class="btn-print" onclick="window.print()">🖨️ Imprimer</button>
        </div>
    </div>

    <!-- Sélecteur d'année -->
    <div class="year-selector">
        <label>Année du rapport :</label>
        <form method="get" action="<%= request.getContextPath() %>/rapport" style="display:flex;gap:10px;">
            <select name="annee">
                <% for (int y = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR); y >= 2020; y--) { %>
                <option value="<%= y %>" <%= y == annee ? "selected" : "" %>><%= y %></option>
                <% } %>
            </select>
            <button type="submit" class="btn-filter">Générer</button>
        </form>
    </div>

    <!-- Stats année -->
    <div class="stat-grid">
        <div class="stat-card sc1">
            <div class="sc-icon">📚</div>
            <div class="sc-num"><%= pubAnnee %></div>
            <div class="sc-lbl">Publications en <%= annee %></div>
            <div class="sc-total">Total : <%= publications != null ? publications.size() : 0 %></div>
        </div>
        <div class="stat-card sc2">
            <div class="sc-icon">📅</div>
            <div class="sc-num"><%= evtAnnee %></div>
            <div class="sc-lbl">Événements en <%= annee %></div>
            <div class="sc-total">Total : <%= evenements != null ? evenements.size() : 0 %></div>
        </div>
        <div class="stat-card sc3">
            <div class="sc-icon">📋</div>
            <div class="sc-num"><%= reuAnnee %></div>
            <div class="sc-lbl">Réunions en <%= annee %></div>
            <div class="sc-total">Total : <%= reunions != null ? reunions.size() : 0 %></div>
        </div>
        <div class="stat-card sc4">
            <div class="sc-icon">👥</div>
            <div class="sc-num"><%= nbMembres %></div>
            <div class="sc-lbl">Membres actifs</div>
            <div class="sc-total">Au <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></div>
        </div>
    </div>

    <!-- Publications + Événements -->
    <div class="section-grid">
        <div class="card">
            <div class="card-title">📚 Publications <%= annee %></div>
            <% if (publications == null || pubAnnee == 0) { %>
                <div class="empty">Aucune publication en <%= annee %></div>
            <% } else { for (Publication p : publications) { if (p.getAnnee() != annee) continue; %>
            <div class="rapport-item">
                <strong><%= p.getTitre() != null ? p.getTitre() : "-" %></strong>
                <span>👤 <%= p.getAuteurs() != null ? p.getAuteurs() : "-" %>
                <% if (p.getRevue() != null) { %> — 📖 <%= p.getRevue() %><% } %></span>
            </div>
            <% } } %>
        </div>

        <div class="card">
            <div class="card-title">📅 Événements <%= annee %></div>
            <% if (evenements == null || evtAnnee == 0) { %>
                <div class="empty">Aucun événement en <%= annee %></div>
            <% } else { for (Evenement e : evenements) {
                if (e.getDateDebut() == null) continue;
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(e.getDateDebut());
                if (cal.get(java.util.Calendar.YEAR) != annee) continue;
                String typeLabel = "conference".equals(e.getType()) ? "Conférence" : "seminaire".equals(e.getType()) ? "Séminaire" : "Workshop";
                String badgeClass = "conference".equals(e.getType()) ? "badge-teal" : "badge-purple";
            %>
            <div class="rapport-item">
                <strong><%= e.getTitre() %><span class="badge <%= badgeClass %>"><%= typeLabel %></span></strong>
                <span>📅 <%= sdf.format(e.getDateDebut()) %>
                <% if (e.getLieu() != null) { %> — 📍 <%= e.getLieu() %><% } %></span>
            </div>
            <% } } %>
        </div>
    </div>

    <!-- Réunions + Documents -->
    <div class="section-grid">
        <div class="card">
            <div class="card-title">📋 Réunions <%= annee %></div>
            <% if (reunions == null || reuAnnee == 0) { %>
                <div class="empty">Aucune réunion en <%= annee %></div>
            <% } else { for (Reunion r : reunions) {
                if (r.getDateReunion() == null) continue;
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(r.getDateReunion());
                if (cal.get(java.util.Calendar.YEAR) != annee) continue;
            %>
            <div class="rapport-item">
                <strong><%= r.getTitre() %></strong>
                <span>📅 <%= sdf.format(r.getDateReunion()) %>
                <% if (r.getOrdreJour() != null && !r.getOrdreJour().isEmpty()) { %><br>📌 <%= r.getOrdreJour() %><% } %></span>
            </div>
            <% } } %>
        </div>

        <div class="card">
            <div class="card-title">📁 Documents archivés <%= annee %></div>
            <% if (documents == null || docAnnee == 0) { %>
                <div class="empty">Aucun document en <%= annee %></div>
            <% } else { for (Document d : documents) {
                if (d.getDateUpload() == null) continue;
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(d.getDateUpload());
                if (cal.get(java.util.Calendar.YEAR) != annee) continue;
            %>
            <div class="rapport-item">
                <strong><%= d.getNom() != null ? d.getNom() : "-" %></strong>
                <span>📋 <%= d.getType() != null ? d.getType() : "-" %>
                <% if (d.getNomEvenement() != null) { %> — 📅 <%= d.getNomEvenement() %><% } %></span>
            </div>
            <% } } %>
        </div>
    </div>

</div>
</body>
</html>