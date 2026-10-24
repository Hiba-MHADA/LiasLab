<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    Materiel mat = (Materiel) request.getAttribute("materielDetail");
    List<DistributionMateriel> distributions = (List<DistributionMateriel>) request.getAttribute("distributions");
    List<Membre> membresNonRecus = (List<Membre>) request.getAttribute("membresNonRecus");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfH = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Détail Matériel</title>
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

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 10px 14px; font-size: 0.68rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 13px 14px; font-size: 0.875rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }

        .qty-badge { display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 8px; background: #ccfbf1; color: #0d9488; font-weight: 800; font-size: 0.9rem; }
        .badge-missing { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 8px; background: #fff1f2; color: #e11d48; font-weight: 700; font-size: 0.75rem; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group input:focus, .form-group select:focus { border-color: #0d9488; background: white; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }
        .info-stat { display: flex; gap: 16px; margin-bottom: 20px; }
        .stat-box { flex: 1; background: #f8fafc; border-radius: 12px; padding: 14px; text-align: center; }
        .stat-box .num { font-size: 1.4rem; font-weight: 800; color: #0d9488; }
        .stat-box .lbl { font-size: 0.7rem; color: #94a3b8; text-transform: uppercase; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="materiel" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🖥️ <%= mat != null ? mat.getDesignation() : "Matériel" %></h1>
            <p>Arrivé le <%= mat != null && mat.getDateArrivee() != null ? sdf.format(mat.getDateArrivee()) : "-" %> — Quantité totale : <%= mat != null ? mat.getQuantite() : 0 %></p>
        </div>
        <a href="<%= request.getContextPath() %>/materiel" class="btn-back">← Retour à la liste</a>
    </div>

    <% if (mat == null) { %>
        <div class="card"><div class="empty">⚠️ Matériel introuvable</div></div>
    <% } else { %>

    <div class="info-stat">
        <div class="stat-box">
            <div class="num"><%= mat.getQuantite() %></div>
            <div class="lbl">Quantité totale</div>
        </div>
        <div class="stat-box">
            <div class="num"><%= distributions != null ? distributions.size() : 0 %></div>
            <div class="lbl">Distributions effectuées</div>
        </div>
        <div class="stat-box">
            <div class="num"><%= membresNonRecus != null ? membresNonRecus.size() : 0 %></div>
            <div class="lbl">Membres n'ayant pas reçu</div>
        </div>
    </div>

    <div class="content-grid">
        <div>
            <div class="card">
                <div class="card-title">✅ Qui a reçu ce matériel</div>
                <% if (distributions == null || distributions.isEmpty()) { %>
                    <div class="empty">Aucune distribution enregistrée pour le moment</div>
                <% } else { %>
                <table>
                    <thead><tr><th>Membre</th><th>Quantité reçue</th><th>Date</th></tr></thead>
                    <tbody>
                    <% for (DistributionMateriel d : distributions) { %>
                    <tr>
                        <td><strong><%= d.getPrenomMembre() %> <%= d.getNomMembre() %></strong></td>
                        <td><div class="qty-badge"><%= d.getQuantiteRecue() %></div></td>
                        <td><%= sdfH.format(d.getDateDistribution()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>

            <div class="card">
                <div class="card-title">❌ Qui n'a pas encore reçu</div>
                <% if (membresNonRecus == null || membresNonRecus.isEmpty()) { %>
                    <div class="empty">✅ Tous les membres ont reçu ce matériel</div>
                <% } else { %>
                <table>
                    <thead><tr><th>Membre</th></tr></thead>
                    <tbody>
                    <% for (Membre mb : membresNonRecus) { %>
                    <tr>
                        <td><span class="badge-missing"><%= mb.getPrenom() %> <%= mb.getNom() %></span></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>

        <% if ("admin".equals(role) || "directeur".equals(role)) { %>
        <div class="card">
            <div class="card-title">➕ Distribuer ce matériel</div>
            <form method="post" action="<%= request.getContextPath() %>/materiel">
                <input type="hidden" name="action" value="distribuer" />
                <input type="hidden" name="materielId" value="<%= mat.getId() %>" />
                <div class="form-group">
                    <label>Membre *</label>
                    <select name="membreId" required>
                        <option value="">-- Choisir un membre --</option>
                        <% if (membresNonRecus != null) { for (Membre mb : membresNonRecus) { %>
                        <option value="<%= mb.getId() %>"><%= mb.getPrenom() %> <%= mb.getNom() %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Quantité *</label>
                    <input type="number" name="quantite" min="1" value="1" required />
                </div>
                <button type="submit" class="btn-save">✅ Confirmer la distribution</button>
            </form>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>