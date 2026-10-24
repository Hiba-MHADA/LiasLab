<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Convention> conventions = (List<Convention>) request.getAttribute("conventions");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Conventions</title>
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

        .conv-item { padding: 16px 0; border-bottom: 1px solid #f8fafc; }
        .conv-item:last-child { border-bottom: none; }
        .conv-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
        .conv-partenaire { font-weight: 700; font-size: 0.95rem; color: #0f172a; display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .conv-partenaire::before { content: '🤝'; }
        .conv-partenaire:hover { color: #0d9488; }
        .conv-dates { font-size: 0.78rem; color: #64748b; margin-bottom: 6px; }
        .conv-desc { font-size: 0.8rem; color: #94a3b8; line-height: 1.5; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; }
        .status-active  { background: #dcfce7; color: #166534; }
        .status-expired { background: #f1f5f9; color: #64748b; }
        .btn-view { padding: 4px 10px; border-radius: 6px; background: #eff6ff; color: #1d4ed8; border: 1px solid #dbeafe; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }
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
    <jsp:param name="currentPage" value="conventions" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🤝 Conventions</h1>
            <p>Gestion des partenariats et conventions du laboratoire</p>
        </div>
    </div>
    <div class="content-grid">
        <div class="card">
            <div class="card-title">Conventions actives et archivées</div>
            <% if (conventions == null || conventions.isEmpty()) { %>
                <div class="empty">🤝 Aucune convention enregistrée</div>
            <% } else {
                java.util.Date today = new java.util.Date();
                for (Convention c : conventions) {
                boolean active = c.getDateFin() == null || c.getDateFin().after(today);
            %>
            <div class="conv-item">
                <div class="conv-header">
                    <a href="<%= request.getContextPath() %>/conventions?action=detail&id=<%= c.getId() %>" class="conv-partenaire"><%= c.getPartenaire() %></a>
                    <div style="display:flex;gap:8px;align-items:center;">
                        <span class="status-badge <%= active ? "status-active" : "status-expired" %>"><%= active ? "✅ Active" : "⏰ Expirée" %></span>
                        <a href="<%= request.getContextPath() %>/conventions?action=detail&id=<%= c.getId() %>" class="btn-view">📁 Documents</a>
                        <a href="<%= request.getContextPath() %>/conventions?action=supprimer&id=<%= c.getId() %>" class="btn-del" onclick="return confirm('Supprimer ?')">🗑️</a>
                    </div>
                </div>
                <div class="conv-dates">📅 <%= c.getDateDebut()!=null?sdf.format(c.getDateDebut()):"?" %> → <%= c.getDateFin()!=null?sdf.format(c.getDateFin()):"En cours" %></div>
                <% if (c.getDescription()!=null&&!c.getDescription().isEmpty()) { %>
                <div class="conv-desc"><%= c.getDescription() %></div>
                <% } %>
            </div>
            <% } } %>
        </div>
        <div class="card">
            <div class="card-title">➕ Nouvelle convention</div>
            <form method="post" action="<%= request.getContextPath() %>/conventions">
                <div class="form-group">
                    <label>Partenaire *</label>
                    <input type="text" name="partenaire" required placeholder="Nom de l'institution partenaire" />
                </div>
                <div class="form-group">
                    <label>Date début</label>
                    <input type="date" name="dateDebut" />
                </div>
                <div class="form-group">
                    <label>Date fin</label>
                    <input type="date" name="dateFin" />
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" placeholder="Objet de la convention..."></textarea>
                </div>
                <button type="submit" class="btn-save">➕ Ajouter</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>