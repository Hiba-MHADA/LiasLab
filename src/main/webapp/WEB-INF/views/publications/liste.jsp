<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, model.Publication, java.util.List" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Publications</title>
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
        .btn-add { padding: 11px 22px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.9rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 14px rgba(13,148,136,0.3); }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 10px 14px; font-size: 0.68rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 13px 14px; font-size: 0.875rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }
        .btn-edit { padding: 4px 10px; border-radius: 6px; background: #eff6ff; color: #1d4ed8; border: 1px solid #dbeafe; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; margin-right: 6px; }
        .btn-del { padding: 4px 10px; border-radius: 6px; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }
        .empty { text-align: center; padding: 48px; color: #94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="publications" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>📚 Publications</h1>
            <p>Liste des publications scientifiques du laboratoire</p>
        </div>
        <a href="<%= request.getContextPath() %>/publications?action=nouveau" class="btn-add">➕ Nouvelle publication</a>
    </div>

    <div class="card">
        <% if (publications == null || publications.isEmpty()) { %>
            <div class="empty">📚 Aucune publication enregistrée</div>
        <% } else { %>
        <table>
            <thead>
                <tr><th>Titre</th><th>Auteurs</th><th>Année</th><th>Revue</th><th></th></tr>
            </thead>
            <tbody>
                <% for (Publication p : publications) { %>
                <tr>
                    <td><strong><%= p.getTitre() %></strong></td>
                    <td><%= p.getAuteurs() %></td>
                    <td><%= p.getAnnee() %></td>
                    <td><%= p.getRevue() != null ? p.getRevue() : "-" %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/publications?action=modifier&id=<%= p.getId() %>" class="btn-edit">✏️ Modifier</a>
                        <a href="<%= request.getContextPath() %>/publications?action=supprimer&id=<%= p.getId() %>" class="btn-del" onclick="return confirm('Supprimer cette publication ?')">🗑️</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>