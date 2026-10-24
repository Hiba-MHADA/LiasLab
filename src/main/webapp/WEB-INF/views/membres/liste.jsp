<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, java.util.List" %>
<%
    if (session.getAttribute("membreConnecte") == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Membre> membres = (List<Membre>) request.getAttribute("membres");
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
    <title>LIAS Lab — Membres</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f5f7fa; display: flex; min-height: 100vh; }

        .sidebar { width: 255px; background: white; border-right: 1px solid #e8ecf0; position: fixed; height: 100vh; display: flex; flex-direction: column; box-shadow: 2px 0 16px rgba(0,0,0,0.04); }
        .sidebar-logo { padding: 22px 20px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; gap: 12px; }
        .logo-box { width: 42px; height: 42px; border-radius: 12px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-size: 1.3rem; box-shadow: 0 4px 12px rgba(13,148,136,0.3); }
        .logo-txt h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .logo-txt p  { font-size: 0.65rem; color: #94a3b8; }
        .sidebar-menu { padding: 16px 0; flex: 1; overflow-y: auto; }
        .menu-label { padding: 10px 20px 4px; font-size: 0.58rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; color: #cbd5e1; }
        .sidebar a { display: flex; align-items: center; gap: 10px; padding: 9px 16px; margin: 1px 8px; color: #64748b; text-decoration: none; font-size: 0.825rem; font-weight: 500; border-radius: 10px; transition: all 0.15s; }
        .sidebar a:hover { background: #f0fdf4; color: #0d9488; }
        .sidebar a.active { background: linear-gradient(135deg, #ccfbf1, #cffafe); color: #0d9488; font-weight: 700; box-shadow: 0 2px 8px rgba(13,148,136,0.12); }
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
        .btn-new { padding: 10px 20px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.85rem; font-weight: 700; text-decoration: none; box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s; }
        .btn-new:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(13,148,136,0.4); }

        .stats-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 14px; margin-bottom: 22px; }
        .stat-mini { background: white; border-radius: 14px; padding: 16px 18px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); display: flex; align-items: center; gap: 12px; }
        .sm-ico { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .smi1 { background: #ccfbf1; }
        .smi2 { background: #fef3c7; }
        .smi3 { background: #dbeafe; }
        .smi4 { background: #fce7f3; }
        .sm-num { font-size: 1.4rem; font-weight: 800; color: #0f172a; }
        .sm-lbl { font-size: 0.72rem; color: #94a3b8; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-hdr { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; padding-bottom: 14px; border-bottom: 1px solid #f8fafc; }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; }

        .filters { display: flex; gap: 10px; margin-bottom: 16px; flex-wrap: wrap; }
        .search-box { display: flex; align-items: center; gap: 8px; padding: 9px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; background: #f8fafc; flex: 1; min-width: 200px; transition: all 0.2s; }
        .search-box:focus-within { border-color: #0d9488; background: white; }
        .search-box input { border: none; background: transparent; outline: none; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; flex: 1; }
        .search-box input::placeholder { color: #94a3b8; }
        .filter-select { padding: 9px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #374151; background: #f8fafc; outline: none; cursor: pointer; transition: border 0.2s; }
        .filter-select:focus { border-color: #0d9488; }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 11px 16px; font-size: 0.7rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.8px; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 14px 16px; font-size: 0.875rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }

        .member-cell { display: flex; align-items: center; gap: 10px; }
        .m-avatar { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.78rem; color: white; flex-shrink: 0; }
        .m-name { font-weight: 700; color: #0f172a; font-size: 0.875rem; }
        .m-email { font-size: 0.72rem; color: #94a3b8; }

        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
        .bs-permanent { background: #ccfbf1; color: #0d9488; }
        .bs-associe   { background: #dbeafe; color: #1d4ed8; }
        .bs-doctorant { background: #ede9fe; color: #6d28d9; }
        .bs-retraite  { background: #f1f5f9; color: #64748b; }
        .bs-ancien    { background: #fce7f3; color: #9d174d; }
        .bs-actif     { background: #dcfce7; color: #166534; }
        .bs-inactif   { background: #fee2e2; color: #991b1b; }

        .actions { display: flex; gap: 6px; }
        .btn-sm { padding: 5px 12px; border-radius: 7px; font-size: 0.75rem; font-weight: 700; cursor: pointer; text-decoration: none; border: none; font-family: 'Outfit', sans-serif; transition: all 0.15s; }
        .btn-edit  { background: #f0fdf4; color: #0d9488; border: 1px solid #a7f3d0; }
        .btn-edit:hover { background: #ccfbf1; }
        .btn-deact { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }
        .btn-deact:hover { background: #ffe4e6; }
        .btn-react { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .btn-react:hover { background: #dcfce7; }

        .empty { text-align: center; padding: 48px; color: #94a3b8; }
        .empty .e-ico { font-size: 3rem; margin-bottom: 12px; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="membres" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>👥 Membres</h1>
            <p>Gestion complète des membres du laboratoire</p>
        </div>
        <a href="<%= request.getContextPath() %>/membres?action=nouveau" class="btn-new">+ Nouveau membre</a>
    </div>

    <%
        int total=0, actifs=0, doctorants=0, associes=0;
        if(membres!=null){ for(Membre m:membres){ total++;
            if(m.isActif()) actifs++;
            if("doctorant".equals(m.getStatut())) doctorants++;
            if("associe".equals(m.getStatut())) associes++;
        }}
    %>
    <div class="stats-row">
        <div class="stat-mini"><div class="sm-ico smi1">👥</div><div><div class="sm-num"><%= total %></div><div class="sm-lbl">Total membres</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi2">✅</div><div><div class="sm-num"><%= actifs %></div><div class="sm-lbl">Actifs</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi3">📖</div><div><div class="sm-num"><%= doctorants %></div><div class="sm-lbl">Doctorants</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi4">🤝</div><div><div class="sm-num"><%= associes %></div><div class="sm-lbl">Associés</div></div></div>
    </div>

    <div class="card">
        <div class="card-hdr">
            <span class="card-title">Liste des membres</span>
        </div>
        <div class="filters">
            <div class="search-box">
                🔍 <input type="text" id="searchInput" placeholder="Rechercher par nom, email..." onkeyup="filterTable()" />
            </div>
            <select class="filter-select" id="statutFilter" onchange="filterTable()">
                <option value="">Tous les statuts</option>
                <option value="permanent">Permanent</option>
                <option value="associe">Associé</option>
                <option value="doctorant">Doctorant</option>
                <option value="retraite">Retraité</option>
                <option value="ancien">Ancien membre</option>
            </select>
            <select class="filter-select" id="etatFilter" onchange="filterTable()">
                <option value="">Tous les états</option>
                <option value="actif">Actif</option>
                <option value="inactif">Inactif</option>
            </select>
        </div>

        <% if (membres == null || membres.isEmpty()) { %>
            <div class="empty"><div class="e-ico">👥</div><p>Aucun membre trouvé</p></div>
        <% } else { %>
        <table id="membresTable">
            <thead>
                <tr>
                    <th>Membre</th>
                    <th>Statut</th>
                    <th>Établissement</th>
                    <th>État</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Membre m : membres) { %>
                <tr>
                    <td>
                        <div class="member-cell">
                            <div class="m-avatar">
                                <%= m.getPrenom()!=null?m.getPrenom().charAt(0):'?' %><%= m.getNom()!=null?m.getNom().charAt(0):'?' %>
                            </div>
                            <div>
                                <div class="m-name"><%= m.getPrenom() %> <%= m.getNom() %></div>
                                <div class="m-email"><%= m.getEmail() %></div>
                            </div>
                        </div>
                    </td>
                    <td><span class="badge bs-<%= m.getStatut()!=null?m.getStatut():"" %>"><%= m.getStatut()!=null?m.getStatut():"-" %></span></td>
                    <td><%= m.getEtablissement()!=null?m.getEtablissement():"-" %></td>
                    <td><span class="badge <%= m.isActif()?"bs-actif":"bs-inactif" %>"><%= m.isActif()?"✅ Actif":"❌ Inactif" %></span></td>
                    <td>
                        <div class="actions">
                            <a href="<%= request.getContextPath() %>/membres?action=detail&id=<%= m.getId() %>" class="btn-sm btn-edit">📅 Affiliation</a>
                            <a href="<%= request.getContextPath() %>/membres?action=modifier&id=<%= m.getId() %>" class="btn-sm btn-edit">✏️ Modifier</a>
                            <% if (m.isActif()) { %>
                                <a href="<%= request.getContextPath() %>/membres?action=desactiver&id=<%= m.getId() %>" class="btn-sm btn-deact" onclick="return confirm('Désactiver ce membre ?')">🔒</a>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/membres?action=reactiver&id=<%= m.getId() %>" class="btn-sm btn-react">🔓</a>
                            <% } %>
                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<script>
function filterTable() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const statut = document.getElementById('statutFilter').value.toLowerCase();
    const etat   = document.getElementById('etatFilter').value.toLowerCase();
    document.querySelectorAll('#membresTable tbody tr').forEach(row => {
        const text = row.textContent.toLowerCase();
        const statutCell = row.cells[1].textContent.toLowerCase().trim();
        const etatCell   = row.cells[3].textContent.toLowerCase().trim();
        const ms = statut==='' || statutCell.includes(statut);
        const me = etat==='' || (etat==='actif'?etatCell.includes('actif'):etatCell.includes('inactif'));
        row.style.display = text.includes(search) && ms && me ? '' : 'none';
    });
}
</script>
</body>
</html>