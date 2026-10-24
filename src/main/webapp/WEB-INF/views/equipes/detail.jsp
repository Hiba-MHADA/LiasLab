<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    Equipe equipe = (Equipe) request.getAttribute("equipe");
    List<RoleMembre> membresEquipe = (List<RoleMembre>) request.getAttribute("membresEquipe");
    List<Membre> tousMembers = (List<Membre>) request.getAttribute("tousMembers");
    boolean canManage = "admin".equals(role) || "directeur".equals(role) || "chef_equipe".equals(role);
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — <%= equipe != null ? equipe.getNom() : "Équipe" %></title>
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
        .btn-back { padding: 8px 16px; border-radius: 10px; background: #f8fafc; color: #64748b; border: 1px solid #e8ecf0; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-back:hover { border-color: #0d9488; color: #0d9488; }

        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; gap: 8px; }

        .member-item { display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #f8fafc; }
        .member-item:last-child { border-bottom: none; }
        .member-left { display: flex; align-items: center; gap: 10px; }
        .m-avatar { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.78rem; color: white; flex-shrink: 0; }
        .m-name { font-weight: 700; font-size: 0.875rem; color: #0f172a; }
        .m-role-badge { font-size: 0.68rem; color: #64748b; }
        .role-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; }
        .rb-directeur { background: #dbeafe; color: #1d4ed8; }
        .rb-chef_equipe { background: #ccfbf1; color: #0d9488; }
        .rb-membre { background: #f0fdf4; color: #166534; }

        .btn-retirer { padding: 4px 10px; border-radius: 6px; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.72rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group select { width: 100%; padding: 10px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group select:focus { border-color: #0d9488; }
        .btn-save { padding: 10px 22px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; box-shadow: 0 4px 14px rgba(13,148,136,0.3); }

        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.875rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="equipes" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🏛️ <%= equipe != null ? equipe.getNom() : "Équipe" %></h1>
            <p><%= equipe != null && equipe.getDescription() != null ? equipe.getDescription() : "Détails de l'équipe" %></p>
        </div>
        <a href="<%= request.getContextPath() %>/equipes" class="btn-back">← Retour aux équipes</a>
    </div>

    <div class="content-grid">
        <div class="card">
            <div class="card-title">👥 Membres de l'équipe (<%= membresEquipe != null ? membresEquipe.size() : 0 %>)</div>
            <% if (membresEquipe == null || membresEquipe.isEmpty()) { %>
                <div class="empty">Aucun membre dans cette équipe</div>
            <% } else { %>
                <% for (RoleMembre rm : membresEquipe) { %>
                <div class="member-item">
                    <div class="member-left">
                        <div class="m-avatar">
                            <%= rm.getPrenomMembre()!=null?rm.getPrenomMembre().charAt(0):'?' %><%= rm.getNomMembre()!=null?rm.getNomMembre().charAt(0):'?' %>
                        </div>
                        <div>
                            <div class="m-name"><%= rm.getPrenomMembre() %> <%= rm.getNomMembre() %></div>
                            <span class="role-badge rb-<%= rm.getRole() %>"><%= rm.getRole() %></span>
                            <% if (rm.getDateDebut() != null) { %>
                            <div class="m-role-badge">Depuis le <%= sdf.format(rm.getDateDebut()) %></div>
                            <% } %>
                        </div>
                    </div>
                    <% if (canManage) { %>
                    <a href="<%= request.getContextPath() %>/equipes?action=retirer&roleId=<%= rm.getId() %>&equipeId=<%= equipe.getId() %>"
                       class="btn-retirer" onclick="return confirm('Retirer ce membre ?')">Retirer</a>
                    <% } %>
                </div>
                <% } %>
            <% } %>
        </div>

        <% if (canManage) { %>
        <div class="card">
            <div class="card-title">➕ Affecter un membre</div>
            <form method="post" action="<%= request.getContextPath() %>/equipes">
                <input type="hidden" name="action" value="affecterMembre" />
                <input type="hidden" name="equipeId" value="<%= equipe != null ? equipe.getId() : 0 %>" />
                <div class="form-group">
                    <label>Membre *</label>
                    <select name="membreId" required>
                        <option value="">-- Choisir un membre --</option>
                        <% if (tousMembers != null) for (Membre m : tousMembers) { %>
                        <option value="<%= m.getId() %>"><%= m.getPrenom() %> <%= m.getNom() %> (<%= m.getStatut() %>)</option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Rôle dans l'équipe *</label>
                    <select name="role" required>
                        <option value="">-- Choisir un rôle --</option>
                        <option value="directeur">🎓 Directeur</option>
                        <option value="chef_equipe">🏛️ Chef d'équipe</option>
                        <option value="membre">👤 Membre</option>
                    </select>
                </div>
                <button type="submit" class="btn-save">➕ Affecter</button>
            </form>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>