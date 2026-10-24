<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isAssocie   = "associe".equals(role);
    List<Materiel>   materiels  = (List<Materiel>)   request.getAttribute("materiels");
    List<Attribution> historique = (List<Attribution>) request.getAttribute("historique");
    List<Membre>     membres    = (List<Membre>)     request.getAttribute("membres");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Matériel</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f5f7fa; display: flex; min-height: 100vh; }
        .sidebar { width: 255px; background: white; border-right: 1px solid #e8ecf0; position: fixed; height: 100vh; display: flex; flex-direction: column; overflow-y: auto; box-shadow: 2px 0 16px rgba(0,0,0,0.04); }
        .sidebar-logo { padding: 22px 20px; border-bottom: 1px solid #f0f2f5; display: flex; align-items: center; gap: 12px; }
        .logo-box { width: 42px; height: 42px; border-radius: 12px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .logo-txt h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .logo-txt p  { font-size: 0.65rem; color: #94a3b8; }
        .sidebar-menu { padding: 16px 0; flex: 1; }
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

        /* Tabs */
        .tabs { display: flex; gap: 4px; background: #f1f5f9; padding: 4px; border-radius: 12px; margin-bottom: 22px; width: fit-content; }
        .tab-btn { padding: 8px 20px; border: none; border-radius: 9px; font-size: 0.84rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; background: transparent; color: #64748b; transition: all 0.15s; }
        .tab-btn.active { background: white; color: #0d9488; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }

        .tab-content { display: none; }
        .tab-content.active { display: block; }

        .grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; }
        .grid-2 { display: grid; grid-template-columns: 1.4fr 1fr; gap: 20px; }

        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f8fafc; }

        /* Inventaire cards */
        .mat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px,1fr)); gap: 14px; }
        .mat-card { background: #f8fafc; border-radius: 14px; padding: 18px; border: 1px solid #e8ecf0; transition: all 0.2s; position: relative; overflow: hidden; }
        .mat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, #0d9488, #0891b2); }
        .mat-card:hover { box-shadow: 0 6px 20px rgba(13,148,136,0.1); }
        .mat-icon { width: 44px; height: 44px; border-radius: 12px; background: #ccfbf1; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; margin-bottom: 12px; }
        .mat-name { font-size: 0.9rem; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
        .mat-qty { display: flex; gap: 8px; margin-bottom: 10px; }
        .qty-badge { padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
        .qty-total { background: #dbeafe; color: #1d4ed8; }
        .qty-dispo { background: #dcfce7; color: #166534; }
        .qty-attrib { background: #fef3c7; color: #b45309; }
        .mat-date { font-size: 0.72rem; color: #94a3b8; }
        .btn-del-sm { position: absolute; top: 10px; right: 10px; width: 26px; height: 26px; border-radius: 6px; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; font-size: 0.75rem; cursor: pointer; display: flex; align-items: center; justify-content: center; text-decoration: none; }

        /* Formulaires */
        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group input:focus, .form-group select:focus { border-color: #0d9488; background: white; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .btn-save:hover { opacity: 0.9; }

        /* Historique table */
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 10px 14px; font-size: 0.68rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.8px; text-align: left; border-bottom: 1px solid #f0f2f5; }
        td { padding: 13px 14px; font-size: 0.85rem; color: #334155; border-bottom: 1px solid #f8fafc; }
        tbody tr:hover td { background: #f0fdf4; }

        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
        .b-attribue { background: #fef3c7; color: #b45309; }
        .b-retourne { background: #dcfce7; color: #166634; }

        .person-cell { display: flex; align-items: center; gap: 8px; }
        .p-av { width: 30px; height: 30px; border-radius: 8px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.72rem; color: white; flex-shrink: 0; }

        .btn-retour { padding: 4px 10px; border-radius: 6px; background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; font-size: 0.72rem; font-weight: 700; cursor: pointer; text-decoration: none; font-family: 'Outfit', sans-serif; }
        .btn-retour:hover { background: #dcfce7; }

        .empty { text-align: center; padding: 40px; color: #94a3b8; }
        .info-box { background: #f0fdf4; border: 1px solid #a7f3d0; border-radius: 10px; padding: 12px 16px; margin-bottom: 14px; font-size: 0.82rem; color: #166534; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-box">🔬</div>
        <div class="logo-txt"><h2>LIAS Lab</h2><p>Faculté Ben M'Sik</p></div>
    </div>
    <div class="sidebar-menu">
        <% if (isAdmin) { %>
            <div class="role-chip rc-admin">⚙️ Administrateur</div>
        <% } else if (isDirecteur) { %>
            <div class="role-chip rc-directeur">🎓 Directeur</div>
        <% } else if (isChef) { %>
            <div class="role-chip rc-chef">🏛️ Chef d'équipe</div>
        <% } else if (isDoctorant) { %>
            <div class="role-chip rc-doctorant">📖 Doctorant</div>
        <% } else if (isAssocie) { %>
            <div class="role-chip rc-associe">🤝 Associé</div>
        <% } else { %>
            <div class="role-chip rc-membre">👤 Membre</div>
        <% } %>
        <div class="menu-label">Principal</div>
        <a href="<%= request.getContextPath() %>/dashboard"><span class="ico">🏠</span> Tableau de bord</a>
        <% if (isAdmin || isDirecteur) { %>
        <a href="<%= request.getContextPath() %>/membres"><span class="ico">👥</span> Membres</a>
        <a href="<%= request.getContextPath() %>/adhesions"><span class="ico">📋</span> Demandes d'adhésion</a>
        <% } %>
        <div class="menu-label">Scientifique</div>
        <a href="<%= request.getContextPath() %>/publications"><span class="ico">📚</span> Publications</a>
        <% if (!isDoctorant) { %>
        <a href="<%= request.getContextPath() %>/evenements"><span class="ico">📅</span> Événements</a>
        <a href="<%= request.getContextPath() %>/equipes"><span class="ico">🏛️</span> Équipes & Rôles</a>
        <% } %>
        <% if (isAdmin || isDirecteur) { %>
        <a href="<%= request.getContextPath() %>/mandats"><span class="ico">🎓</span> Mandats</a>
        <% } %>
        <% if (!isDoctorant && !isAssocie) { %>
        <div class="menu-label">Administratif</div>
        <a href="<%= request.getContextPath() %>/documents"><span class="ico">📁</span> Documents</a>
        <a href="<%= request.getContextPath() %>/materiel" class="active"><span class="ico">🖥️</span> Matériel</a>
        <% if (isAdmin || isDirecteur) { %>
        <a href="<%= request.getContextPath() %>/conventions"><span class="ico">🤝</span> Conventions</a>
        <% } %>
        <a href="<%= request.getContextPath() %>/reunions"><span class="ico">📋</span> PV Réunions</a>
        <% } %>
        <div class="menu-label">Autre</div>
        <a href="<%= request.getContextPath() %>/communication"><span class="ico">💬</span> Communication</a>
        <a href="<%= request.getContextPath() %>/calendrier"><span class="ico">🗓️</span> Calendrier</a>
        <a href="<%= request.getContextPath() %>/notifications"><span class="ico">🔔</span> Notifications</a>
        <% if (isAdmin || isDirecteur) { %>
        <a href="<%= request.getContextPath() %>/rapport"><span class="ico">📊</span> Rapport annuel</a>
        <% } %>
        <div class="menu-label">Compte</div>
        <a href="<%= request.getContextPath() %>/profil"><span class="ico">👤</span> Mon profil</a>
        <a href="<%= request.getContextPath() %>/logout"><span class="ico">🚪</span> Déconnexion</a>
    </div>
    <div class="sidebar-footer">
        <div class="s-avatar"><%= connecte.getPrenom().charAt(0) %><%= connecte.getNom().charAt(0) %></div>
        <div class="s-info">
            <div class="s-name"><%= connecte.getPrenom() %> <%= connecte.getNom() %></div>
            <div class="s-role"><%= role %></div>
        </div>
    </div>
</div>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🖥️ Matériel</h1>
            <p>Inventaire, attribution et historique du matériel du laboratoire</p>
        </div>
    </div>

    <!-- TABS -->
    <div class="tabs">
        <button class="tab-btn active" onclick="showTab('inventaire', this)">📦 Inventaire</button>
        <button class="tab-btn" onclick="showTab('attribution', this)">🔄 Attribuer</button>
        <button class="tab-btn" onclick="showTab('historique', this)">📋 Historique</button>
    </div>

    <!-- TAB 1 : INVENTAIRE -->
    <div class="tab-content active" id="tab-inventaire">
        <div class="grid-2">
            <div class="card">
                <div class="card-title">Inventaire du matériel (<%= materiels != null ? materiels.size() : 0 %> articles)</div>
                <% if (materiels == null || materiels.isEmpty()) { %>
                    <div class="empty">🖥️ Aucun matériel enregistré</div>
                <% } else { %>
                <div class="mat-grid">
                    <% for (Materiel m : materiels) {
                        int attribue = m.getQuantite() - m.getQuantiteDisponible();
                    %>
                    <div class="mat-card">
                        <a href="<%= request.getContextPath() %>/materiel?action=supprimer&id=<%= m.getId() %>"
                           class="btn-del-sm" onclick="return confirm('Supprimer ?')">🗑️</a>
                        <div class="mat-icon">🖥️</div>
                        <div class="mat-name"><%= m.getDesignation() %></div>
                        <div class="mat-qty">
                            <span class="qty-badge qty-total">Total: <%= m.getQuantite() %></span>
                            <span class="qty-badge qty-dispo">Dispo: <%= m.getQuantiteDisponible() %></span>
                        </div>
                        <% if (attribue > 0) { %>
                        <div class="mat-qty"><span class="qty-badge qty-attrib">Attribué: <%= attribue %></span></div>
                        <% } %>
                        <div class="mat-date"><%= m.getDateArrivee() != null ? "📅 " + sdf.format(m.getDateArrivee()) : "" %></div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>

            <!-- Ajouter matériel -->
            <div class="card">
                <div class="card-title">➕ Enregistrer un arrivage</div>
                <form method="post" action="<%= request.getContextPath() %>/materiel">
                    <input type="hidden" name="action" value="ajouter" />
                    <div class="form-group">
                        <label>Désignation *</label>
                        <input type="text" name="designation" required placeholder="Ex: Ordinateur portable HP" />
                    </div>
                    <div class="form-group">
                        <label>Quantité *</label>
                        <input type="number" name="quantite" required min="1" value="1" />
                    </div>
                    <div class="form-group">
                        <label>Date d'arrivée</label>
                        <input type="date" name="dateArrivee" />
                    </div>
                    <button type="submit" class="btn-save">➕ Enregistrer</button>
                </form>
            </div>
        </div>
    </div>

    <!-- TAB 2 : ATTRIBUTION -->
    <div class="tab-content" id="tab-attribution">
        <div class="grid-2">
            <div class="card">
                <div class="card-title">🔄 Attribuer du matériel à un membre</div>
                <div class="info-box">ℹ️ Le matériel attribué sera déduit du stock disponible. Vous pouvez enregistrer le retour depuis l'onglet Historique.</div>
                <form method="post" action="<%= request.getContextPath() %>/materiel">
                    <input type="hidden" name="action" value="attribuer" />
                    <div class="form-group">
                        <label>Matériel *</label>
                        <select name="materielId" required>
                            <option value="">-- Choisir le matériel --</option>
                            <% if (materiels != null) for (Materiel m : materiels) { %>
                            <option value="<%= m.getId() %>">
                                <%= m.getDesignation() %> (Dispo: <%= m.getQuantiteDisponible() %>)
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Membre *</label>
                        <select name="membreId" required>
                            <option value="">-- Choisir le membre --</option>
                            <% if (membres != null) for (Membre m : membres) { %>
                            <option value="<%= m.getId() %>"><%= m.getPrenom() %> <%= m.getNom() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Quantité *</label>
                        <input type="number" name="quantite" required min="1" value="1" />
                    </div>
                    <div class="form-group">
                        <label>Date de retour prévue</label>
                        <input type="date" name="dateRetourPrevue" />
                    </div>
                    <button type="submit" class="btn-save">🔄 Attribuer</button>
                </form>
            </div>

            <!-- Attributions en cours -->
            <div class="card">
                <div class="card-title">📌 Attributions en cours</div>
                <% if (historique == null || historique.isEmpty()) { %>
                    <div class="empty">Aucune attribution en cours</div>
                <% } else { %>
                    <% for (Attribution a : historique) {
                        if (!"attribue".equals(a.getStatut())) continue;
                    %>
                    <div style="padding: 12px 0; border-bottom: 1px solid #f8fafc;">
                        <div class="person-cell" style="margin-bottom: 6px;">
                            <div class="p-av"><%= a.getPrenomMembre()!=null?a.getPrenomMembre().charAt(0):'?' %><%= a.getNomMembre()!=null?a.getNomMembre().charAt(0):'?' %></div>
                            <div>
                                <div style="font-weight:700;font-size:0.85rem;color:#0f172a;"><%= a.getPrenomMembre() %> <%= a.getNomMembre() %></div>
                                <div style="font-size:0.72rem;color:#94a3b8;">🖥️ <%= a.getNomMateriel() %> × <%= a.getQuantite() %></div>
                            </div>
                        </div>
                        <div style="display:flex;justify-content:space-between;align-items:center;">
                            <div style="font-size:0.72rem;color:#64748b;">
                                📅 Pris le: <%= a.getDateAttribution() != null ? sdf.format(a.getDateAttribution()) : "-" %>
                                <% if (a.getDateRetourPrevue() != null) { %>
                                | Retour prévu: <%= sdf.format(a.getDateRetourPrevue()) %>
                                <% } %>
                            </div>
                            <a href="<%= request.getContextPath() %>/materiel?action=retourner&attributionId=<%= a.getId() %>"
                               class="btn-retour" onclick="return confirm('Marquer comme retourné ?')">✅ Retour</a>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <!-- TAB 3 : HISTORIQUE -->
    <div class="tab-content" id="tab-historique">
        <div class="card">
            <div class="card-title">📋 Historique complet des attributions</div>
            <% if (historique == null || historique.isEmpty()) { %>
                <div class="empty">📋 Aucun historique disponible</div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Membre</th>
                        <th>Matériel</th>
                        <th>Qté</th>
                        <th>Date attribution</th>
                        <th>Retour prévu</th>
                        <th>Retour effectif</th>
                        <th>Statut</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Attribution a : historique) { %>
                <tr>
                    <td>
                        <div class="person-cell">
                            <div class="p-av"><%= a.getPrenomMembre()!=null?a.getPrenomMembre().charAt(0):'?' %><%= a.getNomMembre()!=null?a.getNomMembre().charAt(0):'?' %></div>
                            <div>
                                <div style="font-weight:700;"><%= a.getPrenomMembre() %> <%= a.getNomMembre() %></div>
                            </div>
                        </div>
                    </td>
                    <td><strong><%= a.getNomMateriel() %></strong></td>
                    <td><span style="font-weight:800;color:#0d9488;"><%= a.getQuantite() %></span></td>
                    <td><%= a.getDateAttribution() != null ? sdf.format(a.getDateAttribution()) : "-" %></td>
                    <td><%= a.getDateRetourPrevue() != null ? sdf.format(a.getDateRetourPrevue()) : "-" %></td>
                    <td><%= a.getDateRetourEffective() != null ? sdf.format(a.getDateRetourEffective()) : "-" %></td>
                    <td>
                        <span class="badge <%= "attribue".equals(a.getStatut()) ? "b-attribue" : "b-retourne" %>">
                            <%= "attribue".equals(a.getStatut()) ? "🔄 Attribué" : "✅ Retourné" %>
                        </span>
                    </td>
                    <td>
                        <% if ("attribue".equals(a.getStatut())) { %>
                        <a href="<%= request.getContextPath() %>/materiel?action=retourner&attributionId=<%= a.getId() %>"
                           class="btn-retour" onclick="return confirm('Marquer comme retourné ?')">✅ Retour</a>
                        <% } else { %>
                        <span style="color:#94a3b8;font-size:0.78rem;">Terminé</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<script>
function showTab(tabName, btn) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + tabName).classList.add('active');
    btn.classList.add('active');
}
</script>
</body>
</html>