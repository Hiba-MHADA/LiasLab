<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Reunion> reunions = (List<Reunion>) request.getAttribute("reunions");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — PV Réunions</title>
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

        .content-grid { display: grid; grid-template-columns: 1fr 360px; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        .reunion-item { padding: 16px 0; border-bottom: 1px solid #f8fafc; display: flex; align-items: flex-start; gap: 14px; }
        .reunion-item:last-child { border-bottom: none; }
        .r-date-box { background: linear-gradient(135deg, #0d9488, #0891b2); border-radius: 12px; padding: 10px 12px; text-align: center; min-width: 52px; color: white; flex-shrink: 0; }
        .r-date-box .day  { font-size: 1.3rem; font-weight: 800; line-height: 1; }
        .r-date-box .month{ font-size: 0.62rem; font-weight: 600; opacity: 0.8; text-transform: uppercase; }
        .r-content { flex: 1; }
        .r-titre { font-weight: 700; font-size: 0.95rem; color: #0f172a; margin-bottom: 6px; }
        .r-ordre { font-size: 0.8rem; color: #64748b; line-height: 1.5; margin-bottom: 8px; }
        .r-pv { display: inline-flex; align-items: center; gap: 5px; font-size: 0.78rem; color: #0d9488; font-weight: 600; text-decoration: none; }
        .r-pv:hover { text-decoration: underline; }
        .r-actions { display: flex; gap: 6px; margin-top: 8px; }
        .btn-del { padding: 4px 10px; border-radius: 6px; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group input:focus, .form-group textarea:focus { border-color: #0d9488; background: white; }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .empty { text-align: center; padding: 48px; color: #94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="reunions" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>📋 PV Réunions</h1>
            <p>Procès-verbaux et archives des réunions du laboratoire</p>
        </div>
    </div>
    <div class="content-grid">
        <div class="card">
            <div class="card-title">Réunions archivées (<%= reunions != null ? reunions.size() : 0 %>)</div>
            <% if (reunions == null || reunions.isEmpty()) { %>
                <div class="empty">📋 Aucune réunion enregistrée</div>
            <% } else { %>
                <% for (Reunion r : reunions) {
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    if (r.getDateReunion() != null) cal.setTime(r.getDateReunion());
                    String[] months = {"Jan","Fév","Mar","Avr","Mai","Jun","Jul","Aoû","Sep","Oct","Nov","Déc"};
                    String month = r.getDateReunion() != null ? months[cal.get(java.util.Calendar.MONTH)] : "?";
                    String day   = r.getDateReunion() != null ? String.valueOf(cal.get(java.util.Calendar.DAY_OF_MONTH)) : "?";
                %>
                <div class="reunion-item">
                    <div class="r-date-box">
                        <div class="day"><%= day %></div>
                        <div class="month"><%= month %></div>
                    </div>
                    <div class="r-content">
                        <div class="r-titre"><%= r.getTitre() %></div>
                        <% if (r.getOrdreJour()!=null&&!r.getOrdreJour().isEmpty()) { %>
                        <div class="r-ordre">📌 <%= r.getOrdreJour() %></div>
                        <% } %>
                        <% if (r.getPvPath()!=null&&!r.getPvPath().isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/uploads/pv/<%= r.getPvPath() %>" target="_blank" class="r-pv">📄 Voir le PV</a>
                        <% } %>
                        <div class="r-actions">
                            <a href="<%= request.getContextPath() %>/reunions?action=supprimer&id=<%= r.getId() %>" class="btn-del" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                        </div>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>
        <div class="card">
            <div class="card-title">➕ Nouvelle réunion</div>
            <form method="post" action="<%= request.getContextPath() %>/reunions" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Titre *</label>
                    <input type="text" name="titre" required placeholder="Ex: Réunion mensuelle LIAS" />
                </div>
                <div class="form-group">
                    <label>Date de réunion</label>
                    <input type="date" name="dateReunion" />
                </div>
                <div class="form-group">
                    <label>Ordre du jour</label>
                    <textarea name="ordreJour" placeholder="Points à aborder..."></textarea>
                </div>
                <div class="form-group">
                    <label>Fichier PV (PDF, optionnel)</label>
                    <input type="file" name="pvFichier" accept=".pdf,.doc,.docx" />
                </div>
                <button type="submit" class="btn-save">➕ Enregistrer</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>