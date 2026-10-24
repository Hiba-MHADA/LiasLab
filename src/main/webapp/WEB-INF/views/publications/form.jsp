<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, model.Publication" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
    Publication p = (Publication) request.getAttribute("publication");
    boolean isEdit = (p != null);
    int anneeActuelle = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
    java.util.List<model.Equipe> listeEquipes = (java.util.List<model.Equipe>) request.getAttribute("equipes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — <%= isEdit ? "Modifier" : "Nouvelle" %> publication</title>
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
        .topbar { margin-bottom: 24px; }
        .topbar h1 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; color: #0f172a; }
        .topbar p  { font-size: 0.85rem; color: #94a3b8; margin-top: 3px; }

        .form-card { background: white; border-radius: 16px; padding: 32px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); max-width: 700px; }
        .form-section { font-size: 0.78rem; font-weight: 700; color: #0d9488; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #f0fdf4; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 0.72rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 7px; }
        .form-group input, .form-group select { width: 100%; padding: 11px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; transition: all 0.2s; }
        .form-group input:focus, .form-group select:focus { border-color: #0d9488; background: white; box-shadow: 0 0 0 3px rgba(13,148,136,0.08); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-actions { display: flex; gap: 12px; margin-top: 24px; padding-top: 20px; border-top: 1px solid #f0f2f5; }
        .btn-save { padding: 11px 28px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.9rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s; }
        .btn-save:hover { transform: translateY(-1px); }
        .btn-cancel { padding: 11px 24px; background: white; color: #64748b; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; text-decoration: none; display: flex; align-items: center; transition: all 0.2s; }
        .btn-cancel:hover { border-color: #0d9488; color: #0d9488; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="publications" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <h1><%= isEdit ? "✏️ Modifier la publication" : "➕ Nouvelle publication" %></h1>
        <p><%= isEdit ? "Modifier les informations de la publication" : "Ajouter une nouvelle publication scientifique" %></p>
    </div>

    <div class="form-card">
        <div class="form-section">📚 Informations de la publication</div>
        <form method="post" action="<%= request.getContextPath() %>/publications">
            <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "nouveau" %>" />
            <% if (isEdit) { %><input type="hidden" name="id" value="<%= p.getId() %>" /><% } %>

            <div class="form-group">
                <label>Titre *</label>
                <input type="text" name="titre" required
                       value="<%= isEdit && p.getTitre()!=null ? p.getTitre() : "" %>"
                       placeholder="Titre de la publication" />
            </div>
            <div class="form-group">
                <label>Auteurs *</label>
                <input type="text" name="auteurs" required
                       value="<%= isEdit && p.getAuteurs()!=null ? p.getAuteurs() : "" %>"
                       placeholder="Ex: Ben Ali M., El Fassi K., ..." />
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Année *</label>
                    <input type="number" name="annee" required
                           min="1990" max="<%= anneeActuelle %>"
                           value="<%= isEdit ? p.getAnnee() : anneeActuelle %>" />
                </div>
                <div class="form-group">
                    <label>Revue / Conférence</label>
                    <input type="text" name="revue"
                           value="<%= isEdit && p.getRevue()!=null ? p.getRevue() : "" %>"
                           placeholder="Nom de la revue ou conférence" />
                </div>
            </div>
            <div class="form-group">
                <label>Lien DOI / URL</label>
                <input type="text" name="lien"
                       value="<%= isEdit && p.getLien()!=null ? p.getLien() : "" %>"
                       placeholder="https://doi.org/..." />
            </div>
            <div class="form-group">
                <label>Équipe</label>
                <select name="equipeId">
                    <option value="0">-- Aucune équipe --</option>
                    <% if (listeEquipes != null) { for (model.Equipe eq : listeEquipes) { %>
                    <option value="<%= eq.getId() %>" <%= isEdit && p.getEquipeId() == eq.getId() ? "selected" : "" %>>
                        <%= eq.getNom() %>
                    </option>
                    <% } } %>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save"><%= isEdit ? "💾 Enregistrer" : "➕ Ajouter" %></button>
                <a href="<%= request.getContextPath() %>/publications" class="btn-cancel">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>