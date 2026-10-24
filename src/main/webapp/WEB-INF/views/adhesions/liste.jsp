<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre, model.DemandeAdhesion, java.util.List" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
    boolean canManage   = isAdmin || isDirecteur;
    List<DemandeAdhesion> demandes = (List<DemandeAdhesion>) request.getAttribute("demandes");
    int enAttente=0, acceptees=0, refusees=0;
    if(demandes!=null){ for(DemandeAdhesion d:demandes){
        if("en_attente".equals(d.getStatut())) enAttente++;
        else if("acceptee".equals(d.getStatut())) acceptees++;
        else refusees++;
    }}
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Demandes d'adhésion</title>
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

        .stats-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; margin-bottom: 22px; }
        .stat-mini { background: white; border-radius: 14px; padding: 18px 20px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); display: flex; align-items: center; gap: 14px; }
        .sm-ico { width: 42px; height: 42px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .smi-wait   { background: #fef3c7; }
        .smi-accept { background: #dcfce7; }
        .smi-refuse { background: #fee2e2; }
        .sm-num { font-size: 1.6rem; font-weight: 800; color: #0f172a; }
        .sm-lbl { font-size: 0.72rem; color: #94a3b8; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-hdr { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; padding-bottom: 14px; border-bottom: 1px solid #f8fafc; }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; }

        .filter-select { padding: 8px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.85rem; font-family: 'Outfit', sans-serif; color: #374151; background: #f8fafc; outline: none; margin-bottom: 16px; }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 11px 16px; font-size: 0.7rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.8px; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 14px 16px; font-size: 0.875rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }

        .d-avatar { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.78rem; color: white; }
        .d-name { font-weight: 700; color: #0f172a; }
        .d-email { font-size: 0.72rem; color: #94a3b8; }
        .member-cell { display: flex; align-items: center; gap: 10px; }

        .badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
        .b-attente  { background: #fef3c7; color: #b45309; }
        .b-acceptee { background: #dcfce7; color: #166534; }
        .b-refusee  { background: #fee2e2; color: #991b1b; }

        .motivation-text { max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #94a3b8; font-size: 0.8rem; }
        .actions { display: flex; gap: 6px; }
        .btn-sm { padding: 5px 12px; border-radius: 7px; font-size: 0.75rem; font-weight: 700; cursor: pointer; text-decoration: none; border: none; font-family: 'Outfit', sans-serif; transition: all 0.15s; }
        .btn-cv { background: #eff6ff; color: #1d4ed8; border: 1px solid #dbeafe; }
        .btn-cv:hover { background: #dbeafe; }
        .btn-accept { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .btn-accept:hover { background: #bbf7d0; }
        .btn-refuse { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .btn-refuse:hover { background: #fecaca; }
        .empty { text-align: center; padding: 48px; color: #94a3b8; }
        .empty .e-ico { font-size: 3rem; margin-bottom: 12px; }
        .no-cv { color: #cbd5e1; font-size: 0.75rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="adhesions" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>📋 Demandes d'adhésion</h1>
            <p>Gestion des demandes d'adhésion au laboratoire</p>
        </div>
    </div>

    <div class="stats-row">
        <div class="stat-mini"><div class="sm-ico smi-wait">⏳</div><div><div class="sm-num"><%= enAttente %></div><div class="sm-lbl">En attente</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi-accept">✅</div><div><div class="sm-num"><%= acceptees %></div><div class="sm-lbl">Acceptées</div></div></div>
        <div class="stat-mini"><div class="sm-ico smi-refuse">❌</div><div><div class="sm-num"><%= refusees %></div><div class="sm-lbl">Refusées</div></div></div>
    </div>

    <div class="card">
        <div class="card-hdr"><span class="card-title">Toutes les demandes</span></div>
        <select class="filter-select" id="statutFilter" onchange="filterTable()">
            <option value="">Tous les statuts</option>
            <option value="en_attente">⏳ En attente</option>
            <option value="acceptee">✅ Acceptées</option>
            <option value="refusee">❌ Refusées</option>
        </select>

        <% if (demandes == null || demandes.isEmpty()) { %>
            <div class="empty"><div class="e-ico">📋</div><p>Aucune demande pour le moment</p></div>
        <% } else { %>
        <table id="demandesTable">
            <thead><tr>
                <th>Candidat</th><th>Motivation</th><th>CV</th><th>Date</th><th>Statut</th>
                <% if (canManage) { %><th>Actions</th><% } %>
            </tr></thead>
            <tbody>
            <% for (DemandeAdhesion d : demandes) { %>
                <tr>
                    <td>
                        <div class="member-cell">
                            <div class="d-avatar"><%= d.getPrenom()!=null?d.getPrenom().charAt(0):'?' %><%= d.getNom()!=null?d.getNom().charAt(0):'?' %></div>
                            <div><div class="d-name"><%= d.getPrenom() %> <%= d.getNom() %></div><div class="d-email"><%= d.getEmail() %></div></div>
                        </div>
                    </td>
                    <td><div class="motivation-text"><%= d.getMotivation()!=null?d.getMotivation():"-" %></div></td>
                    <td>
                        <% if (d.getCvPath() != null && !d.getCvPath().isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/uploads/cv/<%= d.getCvPath() %>" target="_blank" class="btn-sm btn-cv">📄 Voir</a>
                        <% } else { %>
                        <span class="no-cv">—</span>
                        <% } %>
                    </td>
                    <td><%= d.getDateSoumission()!=null?new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(d.getDateSoumission()):"-" %></td>
                    <td>
                        <span class="badge <%= "en_attente".equals(d.getStatut())?"b-attente":"acceptee".equals(d.getStatut())?"b-acceptee":"b-refusee" %>">
                            <%= "en_attente".equals(d.getStatut())?"⏳ En attente":"acceptee".equals(d.getStatut())?"✅ Acceptée":"❌ Refusée" %>
                        </span>
                    </td>
                    <% if (canManage) { %>
                    <td>
                        <% if ("en_attente".equals(d.getStatut())) { %>
                        <div class="actions">
                            <a href="<%= request.getContextPath() %>/adhesions?action=accepter&id=<%= d.getId() %>" class="btn-sm btn-accept" onclick="return confirm('Accepter et créer un compte ?')">✅ Accepter</a>
                            <a href="<%= request.getContextPath() %>/adhesions?action=refuser&id=<%= d.getId() %>" class="btn-sm btn-refuse" onclick="return confirm('Refuser cette demande ?')">❌ Refuser</a>
                        </div>
                        <% } else { %><span style="color:#94a3b8;font-size:0.8rem;">Traitée</span><% } %>
                    </td>
                    <% } %>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<script>
function filterTable() {
    const statut = document.getElementById('statutFilter').value;
    document.querySelectorAll('#demandesTable tbody tr').forEach(row => {
        const s = row.cells[4].textContent.toLowerCase();
        row.style.display = statut==='' || s.includes(statut.replace('_',' ')) ? '' : 'none';
    });
}
</script>
</body>
</html>