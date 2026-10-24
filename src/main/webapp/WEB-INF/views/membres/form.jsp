<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre" %>
<%
    if (session.getAttribute("membreConnecte") == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    Membre m = (Membre) request.getAttribute("membre");
    boolean isEdit = (m != null);
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — <%= isEdit ? "Modifier" : "Nouveau" %> membre</title>
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

        .form-card { background: white; border-radius: 16px; padding: 32px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); max-width: 820px; }
        .form-section { font-size: 0.8rem; font-weight: 700; color: #0d9488; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 1px solid #f0fdf4; display: flex; align-items: center; gap: 8px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 7px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { font-size: 0.75rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group input, .form-group select, .form-group textarea { padding: 11px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; transition: all 0.2s; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #0d9488; background: white; box-shadow: 0 0 0 3px rgba(13,148,136,0.08); }
        .form-group textarea { resize: vertical; min-height: 100px; }

        .form-actions { display: flex; gap: 12px; padding-top: 20px; border-top: 1px solid #f0f2f5; }
        .btn-save { padding: 11px 28px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.9rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s; }
        .btn-save:hover { transform: translateY(-1px); }
        .btn-cancel { padding: 11px 24px; background: white; color: #64748b; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; text-decoration: none; display: flex; align-items: center; transition: all 0.2s; }
        .btn-cancel:hover { border-color: #0d9488; color: #0d9488; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="membres" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <h1><%= isEdit ? "✏️ Modifier membre" : "➕ Nouveau membre" %></h1>
        <p><%= isEdit ? "Modifier les informations du membre" : "Ajouter un nouveau membre au laboratoire" %></p>
    </div>

    <div class="form-card">
        <div class="form-section">👤 Informations personnelles</div>
        <form method="post" action="<%= request.getContextPath() %>/membres">
            <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "nouveau" %>" />
            <% if (isEdit) { %><input type="hidden" name="id" value="<%= m.getId() %>" /><% } %>
            <div class="form-grid">
                <div class="form-group">
                    <label>Nom *</label>
                    <input type="text" name="nom" required value="<%= isEdit&&m.getNom()!=null?m.getNom():"" %>" placeholder="Nom de famille" />
                </div>
                <div class="form-group">
                    <label>Prénom *</label>
                    <input type="text" name="prenom" required value="<%= isEdit&&m.getPrenom()!=null?m.getPrenom():"" %>" placeholder="Prénom" />
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" required value="<%= isEdit&&m.getEmail()!=null?m.getEmail():"" %>" placeholder="email@exemple.ma" />
                </div>
                <% if (!isEdit) { %>
                <div class="form-group">
                    <label>Mot de passe *</label>
                    <input type="password" name="motDePasse" required placeholder="Mot de passe" />
                </div>
                <% } %>
                <div class="form-group">
                    <label>Statut *</label>
                    <select name="statut" required>
                        <option value="">-- Choisir --</option>
                        <option value="permanent"  <%= isEdit&&"permanent".equals(m.getStatut())?"selected":"" %>>Permanent</option>
                        <option value="associe"    <%= isEdit&&"associe".equals(m.getStatut())?"selected":"" %>>Associé</option>
                        <option value="doctorant"  <%= isEdit&&"doctorant".equals(m.getStatut())?"selected":"" %>>Doctorant</option>
                        <option value="retraite"   <%= isEdit&&"retraite".equals(m.getStatut())?"selected":"" %>>Retraité</option>
                        <option value="ancien"     <%= isEdit&&"ancien".equals(m.getStatut())?"selected":"" %>>Ancien membre</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Établissement</label>
                    <input type="text" name="etablissement" value="<%= isEdit&&m.getEtablissement()!=null?m.getEtablissement():"" %>" placeholder="Université / Faculté" />
                </div>
                <div class="form-group">
                    <label>Laboratoire d'origine</label>
                    <input type="text" name="laboratoireOrigine" value="<%= isEdit&&m.getLaboratoireOrigine()!=null?m.getLaboratoireOrigine():"" %>" placeholder="Laboratoire d'origine" />
                </div>
                <div class="form-group full">
                    <label>Biographie</label>
                    <textarea name="biographie" placeholder="Courte biographie..."><%= isEdit&&m.getBiographie()!=null?m.getBiographie():"" %></textarea>
                </div>
                <div class="form-group full">
                    <label>Centres d'intérêt</label>
                    <textarea name="centresInteret" placeholder="Ex: Machine Learning, Big Data..."><%= isEdit&&m.getCentresInteret()!=null?m.getCentresInteret():"" %></textarea>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-save"><%= isEdit?"💾 Enregistrer":"➕ Ajouter le membre" %></button>
                <a href="<%= request.getContextPath() %>/membres" class="btn-cancel">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>