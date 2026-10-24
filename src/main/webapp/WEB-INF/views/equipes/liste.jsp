<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, model.Equipe, java.util.List" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Equipe> equipes = (List<Equipe>) request.getAttribute("equipes");
    boolean canManage = "admin".equals(role) || "directeur".equals(role);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Équipes & Rôles</title>
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

        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.3); z-index: 100; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; padding: 28px; width: 440px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
        .modal-title { font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 20px; }
        .modal-actions { display: flex; gap: 10px; margin-top: 20px; }
        .btn-cancel-modal { padding: 10px 20px; background: #f8fafc; color: #64748b; border: 1px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; }

        .btn-new { padding: 10px 20px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.85rem; font-weight: 700; border: none; cursor: pointer; font-family: 'Outfit', sans-serif; box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s; }
        .btn-new:hover { transform: translateY(-1px); }

        .equipes-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px,1fr)); gap: 16px; }
        .equipe-card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); transition: all 0.2s; position: relative; overflow: hidden; }
        .equipe-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(13,148,136,0.1); }
        .equipe-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, #0d9488, #0891b2); }
        .eq-icon { width: 48px; height: 48px; border-radius: 14px; background: linear-gradient(135deg, #ccfbf1, #cffafe); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; margin-bottom: 14px; }
        .eq-nom { font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 6px; }
        .eq-desc { font-size: 0.8rem; color: #94a3b8; line-height: 1.5; margin-bottom: 16px; min-height: 36px; }
        .eq-footer { display: flex; justify-content: space-between; align-items: center; }
        .btn-detail { padding: 7px 14px; border-radius: 8px; background: #f0fdf4; color: #0d9488; border: 1px solid #a7f3d0; font-size: 0.78rem; font-weight: 700; text-decoration: none; transition: all 0.15s; }
        .btn-detail:hover { background: #ccfbf1; }
        .eq-actions { display: flex; gap: 6px; }
        .btn-sm { padding: 5px 10px; border-radius: 7px; font-size: 0.72rem; font-weight: 700; cursor: pointer; text-decoration: none; border: none; font-family: 'Outfit', sans-serif; transition: all 0.15s; }
        .btn-del { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }
        .btn-del:hover { background: #ffe4e6; }

        .empty { text-align: center; padding: 60px; color: #94a3b8; }
        .empty .e-ico { font-size: 3.5rem; margin-bottom: 16px; }

        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 0.72rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 7px; }
        .form-group input, .form-group textarea { width: 100%; padding: 11px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.9rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; transition: all 0.2s; }
        .form-group input:focus, .form-group textarea:focus { border-color: #0d9488; background: white; }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .btn-save { padding: 10px 22px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
    </style>
</head>
<body>

<% if (canManage) { %>
<div class="modal-overlay" id="modalEquipe">
    <div class="modal">
        <div class="modal-title">🏛️ Nouvelle équipe</div>
        <form method="post" action="<%= request.getContextPath() %>/equipes">
            <input type="hidden" name="action" value="ajouterEquipe" />
            <div class="form-group">
                <label>Nom de l'équipe *</label>
                <input type="text" name="nom" required placeholder="Ex: Équipe IA & ML" />
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" placeholder="Description de l'équipe..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="submit" class="btn-save">➕ Créer</button>
                <button type="button" class="btn-cancel-modal" onclick="closeModal()">Annuler</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="equipes" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🏛️ Équipes & Rôles</h1>
            <p>Gestion des équipes et des rôles des membres</p>
        </div>
        <% if (canManage) { %>
        <button class="btn-new" onclick="openModal()">+ Nouvelle équipe</button>
        <% } %>
    </div>

    <% if (equipes == null || equipes.isEmpty()) { %>
        <div class="empty">
            <div class="e-ico">🏛️</div>
            <p>Aucune équipe pour le moment</p>
        </div>
    <% } else { %>
    <div class="equipes-grid">
        <% for (Equipe eq : equipes) { %>
        <div class="equipe-card">
            <div class="eq-icon">🏛️</div>
            <div class="eq-nom"><%= eq.getNom() %></div>
            <div class="eq-desc"><%= eq.getDescription() != null ? eq.getDescription() : "Aucune description" %></div>
            <div class="eq-footer">
                <a href="<%= request.getContextPath() %>/equipes?action=detail&id=<%= eq.getId() %>" class="btn-detail">👥 Voir les membres →</a>
                <% if (canManage) { %>
                <div class="eq-actions">
                    <a href="<%= request.getContextPath() %>/equipes?action=supprimer&id=<%= eq.getId() %>" class="btn-sm btn-del" onclick="return confirm('Supprimer cette équipe ?')">🗑️</a>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<script>
function openModal() { document.getElementById('modalEquipe').classList.add('open'); }
function closeModal() { document.getElementById('modalEquipe').classList.remove('open'); }
</script>
</body>
</html>