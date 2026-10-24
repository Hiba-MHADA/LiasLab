<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre" %>
<%
    Membre membre = (Membre) session.getAttribute("membreConnecte");
    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = membre.getRole() != null ? membre.getRole() : "membre";
    String statut = membre.getStatut() != null ? membre.getStatut() : "permanent";
    boolean isAdmin     = "admin".equals(role);
    boolean isDirecteur = "directeur".equals(role) || "vice_directeur".equals(role);
    boolean isChef      = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(statut);
    boolean isAssocie   = "associe".equals(statut);
    boolean isMembre    = "membre".equals(role);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f5f7fa; display: flex; min-height: 100vh; }

        /* ══ SIDEBAR ══ */
        .sidebar {
            width: 255px;
            background: #ffffff;
            border-right: 1px solid #e8ecf0;
            position: fixed; height: 100vh;
            display: flex; flex-direction: column;
            box-shadow: 2px 0 16px rgba(0,0,0,0.04);
        }

        .sidebar-logo {
            padding: 22px 20px;
            border-bottom: 1px solid #f0f2f5;
            display: flex; align-items: center; gap: 12px;
        }
        .logo-box {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(13,148,136,0.3);
        }
        .logo-txt h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .logo-txt p  { font-size: 0.65rem; color: #94a3b8; margin-top: 1px; }

        .sidebar-menu { padding: 16px 0; flex: 1; overflow-y: auto; }

        .menu-label {
            padding: 10px 20px 4px;
            font-size: 0.58rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: #cbd5e1;
        }

        .sidebar a {
            display: flex; align-items: center; gap: 10px;
            padding: 9px 16px; margin: 1px 8px;
            color: #64748b; text-decoration: none;
            font-size: 0.825rem; font-weight: 500;
            border-radius: 10px;
            transition: all 0.15s;
        }
        .sidebar a:hover { background: #f0fdf4; color: #0d9488; }
        .sidebar a.active {
            background: linear-gradient(135deg, #ccfbf1, #cffafe);
            color: #0d9488; font-weight: 700;
            box-shadow: 0 2px 8px rgba(13,148,136,0.12);
        }
        .sidebar a .ico { font-size: 1rem; width: 20px; text-align: center; }

        .role-chip {
            margin: 4px 12px 8px;
            padding: 6px 12px; border-radius: 8px;
            font-size: 0.68rem; font-weight: 700;
            text-align: center; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .rc-admin     { background: #fef3c7; color: #b45309; }
        .rc-directeur { background: #dbeafe; color: #1d4ed8; }
        .rc-chef      { background: #dcfce7; color: #166534; }
        .rc-membre    { background: #f0fdf4; color: #0d9488; }
        .rc-doctorant { background: #ede9fe; color: #6d28d9; }
        .rc-associe   { background: #fce7f3; color: #9d174d; }

        .sidebar-footer {
            padding: 14px 16px;
            border-top: 1px solid #f0f2f5;
            display: flex; align-items: center; gap: 10px;
        }
        .s-avatar {
            width: 36px; height: 36px; border-radius: 10px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.8rem; color: white; flex-shrink: 0;
        }
        .s-info .s-name { font-size: 0.82rem; font-weight: 700; color: #0f172a; }
        .s-info .s-role { font-size: 0.67rem; color: #94a3b8; }

        /* ══ MAIN ══ */
        .main { margin-left: 255px; padding: 28px 32px; flex: 1; }

        /* TOPBAR */
        .topbar {
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 24px;
        }
        .topbar-left h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.8rem; color: #0f172a;
        }
        .topbar-left p { font-size: 0.85rem; color: #94a3b8; margin-top: 3px; }
        .topbar-right { display: flex; align-items: center; gap: 10px; }

        .notif-btn {
            width: 38px; height: 38px; border-radius: 10px;
            background: white; border: 1px solid #e8ecf0;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; cursor: pointer;
            box-shadow: 0 1px 4px rgba(0,0,0,0.04);
            text-decoration: none;
        }
        .date-chip {
            padding: 8px 14px; background: white;
            border: 1px solid #e8ecf0; border-radius: 10px;
            font-size: 0.78rem; color: #64748b;
            box-shadow: 0 1px 4px rgba(0,0,0,0.04);
        }
        .btn-logout {
            padding: 8px 16px; border-radius: 10px;
            background: #fff1f2; color: #e11d48;
            border: 1px solid #fecdd3;
            font-size: 0.82rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
            font-family: 'Outfit', sans-serif;
        }
        .btn-logout:hover { background: #ffe4e6; }

        /* WELCOME */
        .welcome-wrap {
            display: grid; grid-template-columns: 1fr auto;
            gap: 16px; margin-bottom: 24px;
        }
        .welcome-main {
            background: white; border-radius: 18px;
            padding: 28px 32px;
            border: 1px solid #e8ecf0;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
            display: flex; align-items: center;
            justify-content: space-between;
            position: relative; overflow: hidden;
        }
        .welcome-main::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 3px;
            background: linear-gradient(90deg, #0d9488, #0891b2, #6366f1);
        }
        .w-text h2 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.4rem; color: #0f172a; margin-bottom: 6px;
        }
        .w-text p { font-size: 0.875rem; color: #64748b; }
        .w-role-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 4px 12px; border-radius: 20px;
            font-size: 0.72rem; font-weight: 700;
            margin-top: 10px;
        }
        .wrb-admin     { background: #fef3c7; color: #b45309; }
        .wrb-directeur { background: #dbeafe; color: #1d4ed8; }
        .wrb-chef      { background: #dcfce7; color: #166534; }
        .wrb-membre    { background: #ccfbf1; color: #0d9488; }
        .wrb-doctorant { background: #ede9fe; color: #6d28d9; }
        .wrb-associe   { background: #fce7f3; color: #9d174d; }

        .w-icons { display: flex; gap: 10px; }
        .w-icon-box {
            width: 52px; height: 52px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
        }
        .wi1 { background: #ccfbf1; }
        .wi2 { background: #cffafe; }
        .wi3 { background: #dbeafe; }

        .welcome-side {
            background: linear-gradient(135deg, #0d9488, #0891b2);
            border-radius: 18px; padding: 24px 20px;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            gap: 8px; min-width: 130px;
            box-shadow: 0 4px 20px rgba(13,148,136,0.25);
        }
        .ws-icon { font-size: 2.5rem; }
        .ws-text { color: white; font-size: 0.78rem; text-align: center; opacity: 0.85; }
        .ws-text strong { display: block; font-size: 1rem; opacity: 1; }

        /* STATS */
        .stat-grid {
            display: grid; grid-template-columns: repeat(4,1fr);
            gap: 14px; margin-bottom: 24px;
        }
        .stat-card {
            background: white; border-radius: 16px;
            padding: 18px 20px; border: 1px solid #e8ecf0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: all 0.2s; cursor: default;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.08); }
        .sc-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .sc-icon {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
        }
        .sci1 { background: #ccfbf1; }
        .sci2 { background: #dbeafe; }
        .sci3 { background: #ede9fe; }
        .sci4 { background: #fef3c7; }
        .sc-trend {
            font-size: 0.68rem; font-weight: 700; padding: 3px 8px;
            border-radius: 20px;
        }
        .trend-up   { background: #dcfce7; color: #166534; }
        .trend-wait { background: #fef3c7; color: #b45309; }
        .sc-num { font-size: 2rem; font-weight: 800; color: #0f172a; line-height: 1; }
        .sc-lbl { font-size: 0.75rem; color: #94a3b8; margin-top: 5px; font-weight: 500; }

        /* GRID */
        .content-grid { display: grid; grid-template-columns: 1.3fr 1fr; gap: 18px; margin-bottom: 18px; }
        .card {
            background: white; border-radius: 16px;
            padding: 22px; border: 1px solid #e8ecf0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .card-hdr {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; padding-bottom: 12px;
            border-bottom: 1px solid #f8fafc;
        }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; }
        .card-badge {
            padding: 3px 10px; border-radius: 20px;
            font-size: 0.68rem; font-weight: 600;
            background: #f0fdf4; color: #0d9488;
        }

        /* ACTIONS */
        .actions-list { display: flex; flex-direction: column; gap: 8px; }
        .action-item {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px; border-radius: 12px;
            text-decoration: none; font-size: 0.82rem; font-weight: 600;
            transition: all 0.15s; border: 1px solid transparent;
        }
        .action-item .a-ico {
            width: 34px; height: 34px; border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.95rem; flex-shrink: 0;
        }
        .action-item .a-text strong { display: block; font-size: 0.82rem; }
        .action-item .a-text span   { font-size: 0.72rem; opacity: 0.7; }
        .action-item .a-arrow { margin-left: auto; font-size: 0.8rem; opacity: 0.4; }

        .ai1 { background: #f0fdf4; color: #0d9488; }
        .ai1 .a-ico { background: #ccfbf1; }
        .ai1:hover { background: #ccfbf1; border-color: #0d9488; }

        .ai2 { background: #eff6ff; color: #1d4ed8; }
        .ai2 .a-ico { background: #dbeafe; }
        .ai2:hover { background: #dbeafe; border-color: #1d4ed8; }

        .ai3 { background: #fdf4ff; color: #7e22ce; }
        .ai3 .a-ico { background: #f3e8ff; }
        .ai3:hover { background: #f3e8ff; border-color: #7e22ce; }

        .ai4 { background: #fff7ed; color: #c2410c; }
        .ai4 .a-ico { background: #ffedd5; }
        .ai4:hover { background: #ffedd5; border-color: #c2410c; }

        .ai5 { background: #f0f9ff; color: #0369a1; }
        .ai5 .a-ico { background: #e0f2fe; }
        .ai5:hover { background: #e0f2fe; border-color: #0369a1; }

        /* MODULES */
        .modules-wrap { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .mod-item {
            display: flex; flex-direction: column; align-items: center; gap: 6px;
            padding: 14px 10px; border-radius: 12px;
            text-decoration: none; font-size: 0.75rem; font-weight: 700;
            background: #f8fafc; border: 1px solid #e8ecf0;
            color: #334155; text-align: center; transition: all 0.15s;
        }
        .mod-item:hover { background: #f0fdf4; border-color: #0d9488; color: #0d9488; transform: translateY(-2px); }
        .mod-item .m-ico { font-size: 1.4rem; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="dashboard" />
</jsp:include>

<!-- MAIN -->
<div class="main">

    <!-- TOPBAR -->
    <div class="topbar">
        <div class="topbar-left">
            <h1>Tableau de bord</h1>
            <p>Bienvenue sur la plateforme LIAS Lab</p>
        </div>
        <div class="topbar-right">
            <span class="notif-btn">🔔</span>
            <div class="date-chip">📅 <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">🚪 Déconnexion</a>
        </div>
    </div>

    <!-- WELCOME -->
    <div class="welcome-wrap">
        <div class="welcome-main">
            <div class="w-text">
                <h2>Bonjour, <%= membre.getPrenom() %> ! 👋</h2>
                <p>Gérez les activités du laboratoire depuis votre espace personnel</p>
                <div class="w-role-badge
                    <%= isAdmin ? "wrb-admin" : isDirecteur ? "wrb-directeur" : isChef ? "wrb-chef" : isDoctorant ? "wrb-doctorant" : isAssocie ? "wrb-associe" : "wrb-membre" %>">
                    <%= isAdmin ? "⚙️ Administrateur système" :
                        "directeur".equals(role) ? "🎓 Directeur du laboratoire" :
                        "vice_directeur".equals(role) ? "🎓 Vice-Directeur" :
                        isChef ? "🏛️ Chef d'équipe" :
                        isDoctorant ? "📖 Doctorant" :
                        isAssocie ? "🤝 Membre associé" : "👤 Membre permanent" %>
                </div>
            </div>
            <div class="w-icons">
                <div class="w-icon-box wi1">🔬</div>
                <div class="w-icon-box wi2">📚</div>
                <div class="w-icon-box wi3">🏛️</div>
            </div>
        </div>
        <div class="welcome-side">
            <div class="ws-icon">🏛️</div>
            <div class="ws-text">
                <strong>LIAS Lab</strong>
                Ben M'Sik<br>Hassan II
            </div>
        </div>
    </div>

    <!-- STATS -->
    <div class="stat-grid">
        <% if (isAdmin || isDirecteur) { %>
        <div class="stat-card">
            <div class="sc-top">
                <div class="sc-icon sci1">👥</div>
                <span class="sc-trend trend-up">Actifs</span>
            </div>
            <div class="sc-num"><%= request.getAttribute("nbMembres") != null ? request.getAttribute("nbMembres") : 0 %></div>
            <div class="sc-lbl">Membres actifs</div>
        </div>
        <div class="stat-card">
            <div class="sc-top">
                <div class="sc-icon sci4">📋</div>
                <span class="sc-trend trend-wait">En attente</span>
            </div>
            <div class="sc-num"><%= request.getAttribute("nbAdhesions") != null ? request.getAttribute("nbAdhesions") : 0 %></div>
            <div class="sc-lbl">Demandes adhésion</div>
        </div>
        <% } %>
        <div class="stat-card">
            <div class="sc-top">
                <div class="sc-icon sci2">📚</div>
                <span class="sc-trend trend-up">Total</span>
            </div>
            <div class="sc-num"><%= request.getAttribute("nbPubs") != null ? request.getAttribute("nbPubs") : 0 %></div>
            <div class="sc-lbl">Publications</div>
        </div>
        <div class="stat-card">
            <div class="sc-top">
                <div class="sc-icon sci3">📅</div>
                <span class="sc-trend trend-up">Planifiés</span>
            </div>
            <div class="sc-num"><%= request.getAttribute("nbEvts") != null ? request.getAttribute("nbEvts") : 0 %></div>
            <div class="sc-lbl">Événements</div>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="content-grid">
        <div class="card">
            <div class="card-hdr">
                <span class="card-title">⚡ Actions rapides</span>
                <span class="card-badge">Raccourcis</span>
            </div>
            <div class="actions-list">
                <% if (isAdmin || isDirecteur) { %>
                <a href="<%= request.getContextPath() %>/membres?action=nouveau" class="action-item ai1">
                    <div class="a-ico">➕</div>
                    <div class="a-text"><strong>Ajouter un membre</strong><span>Créer un nouveau compte membre</span></div>
                    <span class="a-arrow">→</span>
                </a>
                <a href="<%= request.getContextPath() %>/adhesions" class="action-item ai2">
                    <div class="a-ico">📋</div>
                    <div class="a-text"><strong>Demandes d'adhésion</strong><span>Gérer les nouvelles demandes</span></div>
                    <span class="a-arrow">→</span>
                </a>
                <% } %>
                <a href="<%= request.getContextPath() %>/publications" class="action-item ai3">
                    <div class="a-ico">📚</div>
                    <div class="a-text"><strong>Nouvelle publication</strong><span>Ajouter une publication</span></div>
                    <span class="a-arrow">→</span>
                </a>
                <% if (!isDoctorant) { %>
                <a href="<%= request.getContextPath() %>/evenements" class="action-item ai4">
                    <div class="a-ico">📅</div>
                    <div class="a-text"><strong>Créer un événement</strong><span>Conférence, séminaire...</span></div>
                    <span class="a-arrow">→</span>
                </a>
                <% } %>
                <a href="<%= request.getContextPath() %>/profil" class="action-item ai5">
                    <div class="a-ico">🔑</div>
                    <div class="a-text"><strong>Mon profil</strong><span>Modifier mes informations</span></div>
                    <span class="a-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="card">
            <div class="card-hdr">
                <span class="card-title">🗂️ Mes modules</span>
                <span class="card-badge">Accès rapide</span>
            </div>
            <div class="modules-wrap">
                <% if (isAdmin || isDirecteur) { %>
                <a href="<%= request.getContextPath() %>/membres" class="mod-item">
                    <span class="m-ico">👥</span> Membres
                </a>
                <% } %>
                <a href="<%= request.getContextPath() %>/publications" class="mod-item"><span class="m-ico">📚</span> Publications</a>
                <% if (!isDoctorant) { %>
                <a href="<%= request.getContextPath() %>/evenements" class="mod-item"><span class="m-ico">📅</span> Événements</a>
                <a href="<%= request.getContextPath() %>/equipes" class="mod-item"><span class="m-ico">🏛️</span> Équipes</a>
                <% } %>
                <% if (!isDoctorant && !isAssocie) { %>
                <a href="<%= request.getContextPath() %>/documents" class="mod-item"><span class="m-ico">📁</span> Documents</a>
                <a href="<%= request.getContextPath() %>/materiel" class="mod-item"><span class="m-ico">🖥️</span> Matériel</a>
                <a href="<%= request.getContextPath() %>/reunions" class="mod-item"><span class="m-ico">📋</span> PV Réunions</a>
                <% } %>
                <a href="<%= request.getContextPath() %>/recherche" class="mod-item"><span class="m-ico">🔍</span> Recherche</a>
                <% if (isAdmin || isDirecteur) { %>
                <a href="<%= request.getContextPath() %>/rapport" class="mod-item"><span class="m-ico">📊</span> Rapport annuel</a>
                <a href="<%= request.getContextPath() %>/conventions" class="mod-item"><span class="m-ico">🤝</span> Conventions</a>
                <% } %>
            </div>
        </div>
    </div>

</div>

</body>
</html>