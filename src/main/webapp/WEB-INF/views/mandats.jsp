<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    if (!isAdmin && !isDirecteur) {
        response.sendRedirect(request.getContextPath() + "/dashboard"); return;
    }
    List<Mandat> mandats  = (List<Mandat>)  request.getAttribute("mandats");
    List<Membre> membres  = (List<Membre>)  request.getAttribute("membres");
    SimpleDateFormat sdf  = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Mandats</title>
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

        .content-grid { display: grid; grid-template-columns: 1fr 380px; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        .mandat-item { padding: 16px 0; border-bottom: 1px solid #f8fafc; position: relative; }
        .mandat-item:last-child { border-bottom: none; }
        .mandat-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .mandat-actif { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; background: #dcfce7; color: #166534; }
        .mandat-expire { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; background: #f1f5f9; color: #64748b; }

        .person-row { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
        .p-avatar { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.78rem; color: white; flex-shrink: 0; }
        .p-avatar.vd { background: linear-gradient(135deg, #7c3aed, #6366f1); }
        .p-info strong { display: block; font-size: 0.875rem; font-weight: 700; color: #0f172a; }
        .p-info span   { font-size: 0.72rem; color: #94a3b8; }

        .mandat-dates { font-size: 0.78rem; color: #64748b; margin-top: 8px; }
        .btn-del { padding: 4px 10px; border-radius: 6px; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group input:focus, .form-group select:focus { border-color: #0d9488; background: white; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .empty { text-align: center; padding: 48px; color: #94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="mandats" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🎓 Mandats</h1>
            <p>Historique des mandats de gouvernance du laboratoire</p>
        </div>
    </div>
    <div class="content-grid">
        <div class="card">
            <div class="card-title">Historique des mandats</div>
            <% if (mandats == null || mandats.isEmpty()) { %>
                <div class="empty">🎓 Aucun mandat enregistré</div>
            <% } else {
                java.util.Date today = new java.util.Date();
                for (Mandat m : mandats) {
                boolean actif = m.getDateFin() == null || m.getDateFin().after(today);
            %>
            <div class="mandat-item">
                <div class="mandat-header">
                    <span class="<%= actif ? "mandat-actif" : "mandat-expire" %>">
                        <%= actif ? "✅ Mandat actif" : "⏰ Mandat terminé" %>
                    </span>
                    <a href="<%= request.getContextPath() %>/mandats?action=supprimer&id=<%= m.getId() %>"
                       class="btn-del" onclick="return confirm('Supprimer ce mandat ?')">🗑️</a>
                </div>
                <div class="person-row">
                    <div class="p-avatar">
                        <%= m.getPrenomDirecteur()!=null?m.getPrenomDirecteur().charAt(0):'?' %><%= m.getNomDirecteur()!=null?m.getNomDirecteur().charAt(0):'?' %>
                    </div>
                    <div class="p-info">
                        <strong><%= m.getPrenomDirecteur() %> <%= m.getNomDirecteur() %></strong>
                        <span>🎓 Directeur du laboratoire</span>
                    </div>
                </div>
                <% if (m.getNomViceDirecteur() != null) { %>
                <div class="person-row">
                    <div class="p-avatar vd">
                        <%= m.getPrenomViceDirecteur()!=null?m.getPrenomViceDirecteur().charAt(0):'?' %><%= m.getNomViceDirecteur()!=null?m.getNomViceDirecteur().charAt(0):'?' %>
                    </div>
                    <div class="p-info">
                        <strong><%= m.getPrenomViceDirecteur() %> <%= m.getNomViceDirecteur() %></strong>
                        <span>🏛️ Vice-Directeur</span>
                    </div>
                </div>
                <% } %>
                <div class="mandat-dates">
                    📅 <%= m.getDateDebut()!=null?sdf.format(m.getDateDebut()):"?" %>
                    → <%= m.getDateFin()!=null?sdf.format(m.getDateFin()):"En cours" %>
                </div>
            </div>
            <% } } %>
        </div>

        <div class="card">
            <div class="card-title">➕ Nouveau mandat</div>
            <form method="post" action="<%= request.getContextPath() %>/mandats">
                <div class="form-group">
                    <label>Directeur *</label>
                    <select name="directeurId" required>
                        <option value="">-- Choisir le directeur --</option>
                        <% if (membres != null) for (Membre m : membres) { %>
                        <option value="<%= m.getId() %>"><%= m.getPrenom() %> <%= m.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Vice-Directeur</label>
                    <select name="viceDirecteurId">
                        <option value="">-- Aucun --</option>
                        <% if (membres != null) for (Membre m : membres) { %>
                        <option value="<%= m.getId() %>"><%= m.getPrenom() %> <%= m.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Date début *</label>
                    <input type="date" name="dateDebut" required />
                </div>
                <div class="form-group">
                    <label>Date fin</label>
                    <input type="date" name="dateFin" />
                </div>
                <button type="submit" class="btn-save">➕ Enregistrer le mandat</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>