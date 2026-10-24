<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    int nbNonLus = request.getAttribute("nbNonLus") != null ? (int) request.getAttribute("nbNonLus") : 0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Notifications</title>
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
        .btn-all-read { padding: 9px 18px; border-radius: 10px; background: #f0fdf4; color: #0d9488; border: 1px solid #a7f3d0; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-all-read:hover { background: #ccfbf1; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); max-width: 700px; }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; justify-content: space-between; }
        .badge-count { display: inline-block; padding: 2px 8px; border-radius: 20px; background: #ef4444; color: white; font-size: 0.72rem; font-weight: 700; }

        .notif-item { padding: 14px 0; border-bottom: 1px solid #f8fafc; display: flex; align-items: flex-start; gap: 12px; }
        .notif-item:last-child { border-bottom: none; }
        .notif-item.non-lu { background: #f0fdf4; margin: 0 -22px; padding: 14px 22px; border-left: 3px solid #0d9488; }
        .notif-icon { width: 36px; height: 36px; border-radius: 10px; background: #ccfbf1; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
        .notif-content { flex: 1; }
        .notif-msg  { font-size: 0.875rem; color: #0f172a; margin-bottom: 4px; }
        .notif-date { font-size: 0.75rem; color: #94a3b8; }
        .btn-lu { padding: 3px 10px; border-radius: 6px; background: #f0fdf4; color: #0d9488; border: 1px solid #a7f3d0; font-size: 0.7rem; font-weight: 700; text-decoration: none; white-space: nowrap; }

        .empty { text-align: center; padding: 48px; color: #94a3b8; }
        .empty .e-ico { font-size: 3rem; margin-bottom: 12px; }

        .info-box { background: #f0fdf4; border: 1px solid #a7f3d0; border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; font-size: 0.85rem; color: #166534; display: flex; align-items: center; gap: 10px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="notifications" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🔔 Notifications</h1>
            <p>Vos alertes et messages du laboratoire</p>
        </div>
        <% if (nbNonLus > 0) { %>
        <a href="<%= request.getContextPath() %>/notifications?action=tousLus" class="btn-all-read">✅ Tout marquer comme lu</a>
        <% } %>
    </div>

    <% if (nbNonLus > 0) { %>
    <div class="info-box">
        🔔 Vous avez <strong><%= nbNonLus %> notification(s) non lue(s)</strong>
    </div>
    <% } %>

    <div class="card">
        <div class="card-title">
            <span>Toutes les notifications</span>
            <% if (nbNonLus > 0) { %><span class="badge-count"><%= nbNonLus %> nouvelles</span><% } %>
        </div>
        <% if (notifications == null || notifications.isEmpty()) { %>
            <div class="empty">
                <div class="e-ico">🔔</div>
                <p>Aucune notification pour le moment</p>
            </div>
        <% } else { %>
            <% for (Notification n : notifications) { %>
            <div class="notif-item <%= !n.isLu() ? "non-lu" : "" %>">
                <div class="notif-icon"><%= !n.isLu() ? "🔔" : "✅" %></div>
                <div class="notif-content">
                    <div class="notif-msg"><%= n.getMessage() %></div>
                    <div class="notif-date"><%= n.getDateCreation() != null ? sdf.format(n.getDateCreation()) : "-" %></div>
                </div>
                <% if (!n.isLu()) { %>
                <a href="<%= request.getContextPath() %>/notifications?action=lu&id=<%= n.getId() %>" class="btn-lu">Lu</a>
                <% } %>
            </div>
            <% } %>
        <% } %>
    </div>
</div>
</body>
</html>