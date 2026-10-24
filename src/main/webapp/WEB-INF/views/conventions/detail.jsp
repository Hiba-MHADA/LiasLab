<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    Convention c = (Convention) request.getAttribute("convention");
    List<Document> documents = (List<Document>) request.getAttribute("documents");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfH = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Détail Convention</title>
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
        .btn-back { padding: 8px 16px; border-radius: 10px; background: #f0fdf4; color: #0d9488; border: 1px solid #ccfbf1; font-size: 0.82rem; font-weight: 600; text-decoration: none; }

        .content-grid { display: grid; grid-template-columns: 1fr 360px; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); margin-bottom: 20px; }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        .info-box { background: #f8fafc; border-radius: 12px; padding: 16px; margin-bottom: 20px; }
        .info-box p { font-size: 0.85rem; color: #64748b; margin-bottom: 6px; }
        .info-box strong { color: #0f172a; }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 10px 14px; font-size: 0.68rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 13px 14px; font-size: 0.875rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }
        .btn-dl { padding: 4px 10px; border-radius: 6px; background: #f0fdf4; color: #0d9488; border: 1px solid #ccfbf1; font-size: 0.7rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group input:focus, .form-group select:focus { border-color: #0d9488; background: white; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="conventions" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🤝 <%= c != null ? c.getPartenaire() : "Convention" %></h1>
            <p>Documents archivés et détails de la convention</p>
        </div>
        <a href="<%= request.getContextPath() %>/conventions" class="btn-back">← Retour à la liste</a>
    </div>

    <% if (c == null) { %>
        <div class="card"><div class="empty">⚠️ Convention introuvable</div></div>
    <% } else { %>

    <div class="content-grid">
        <div>
            <div class="card">
                <div class="card-title">ℹ️ Informations</div>
                <div class="info-box">
                    <p><strong>Partenaire :</strong> <%= c.getPartenaire() %></p>
                    <p><strong>Période :</strong> <%= c.getDateDebut()!=null?sdf.format(c.getDateDebut()):"?" %> → <%= c.getDateFin()!=null?sdf.format(c.getDateFin()):"En cours" %></p>
                    <% if (c.getDescription()!=null && !c.getDescription().isEmpty()) { %>
                    <p><strong>Description :</strong> <%= c.getDescription() %></p>
                    <% } %>
                </div>
            </div>

            <div class="card">
                <div class="card-title">📁 Documents archivés</div>
                <% if (documents == null || documents.isEmpty()) { %>
                    <div class="empty">Aucun document archivé pour cette convention</div>
                <% } else { %>
                <table>
                    <thead><tr><th>Nom</th><th>Type</th><th>Date</th><th></th></tr></thead>
                    <tbody>
                    <% for (Document d : documents) { %>
                    <tr>
                        <td><strong><%= d.getNom() %></strong></td>
                        <td><%= d.getType() %></td>
                        <td><%= sdfH.format(d.getDateUpload()) %></td>
                        <td><a href="<%= request.getContextPath() %>/uploads/documents/<%= d.getChemin() %>" class="btn-dl" target="_blank">⬇️ Voir</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>

        <div class="card">
            <div class="card-title">➕ Ajouter un document</div>
            <form method="post" action="<%= request.getContextPath() %>/documents" enctype="multipart/form-data">
                <input type="hidden" name="conventionId" value="<%= c.getId() %>" />
                <div class="form-group">
                    <label>Nom du document</label>
                    <input type="text" name="nom" placeholder="Ex: Convention signée 2026" />
                </div>
                <div class="form-group">
                    <label>Type *</label>
                    <select name="type" required>
                        <option value="convention">Convention</option>
                        <option value="financement">Financement</option>
                        <option value="rapport">Rapport</option>
                        <option value="administratif">Administratif</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Fichier *</label>
                    <input type="file" name="fichier" required />
                </div>
                <button type="submit" class="btn-save">📤 Téléverser</button>
            </form>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>