<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre" %>
<%@ page import="model.HistoriqueProfil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Membre membre = (Membre) session.getAttribute("membreConnecte");
    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    String role = membre.getRole() != null ? membre.getRole() : "membre";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Mon Profil</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f5f7fa; display: flex; min-height: 100vh; }

        .sidebar {
            width: 255px; background: white; border-right: 1px solid #e8ecf0;
            position: fixed; height: 100vh; display: flex; flex-direction: column;
            box-shadow: 2px 0 16px rgba(0,0,0,0.04);
        }
        .sidebar-logo {
            padding: 22px 20px; border-bottom: 1px solid #f0f2f5;
            display: flex; align-items: center; gap: 12px;
        }
        .logo-box {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; box-shadow: 0 4px 12px rgba(13,148,136,0.3);
        }
        .logo-txt h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .logo-txt p  { font-size: 0.65rem; color: #94a3b8; }
        .sidebar-menu { padding: 16px 0; flex: 1; overflow-y: auto; }
        .menu-label {
            padding: 10px 20px 4px; font-size: 0.58rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px; color: #cbd5e1;
        }
        .sidebar a {
            display: flex; align-items: center; gap: 10px; padding: 9px 16px;
            margin: 1px 8px; color: #64748b; text-decoration: none;
            font-size: 0.825rem; font-weight: 500; border-radius: 10px; transition: all 0.15s;
        }
        .sidebar a:hover { background: #f0fdf4; color: #0d9488; }
        .sidebar a.active { background: linear-gradient(135deg, #ccfbf1, #cffafe); color: #0d9488; font-weight: 700; }
        .sidebar a .ico { font-size: 1rem; width: 20px; text-align: center; }
        .role-chip {
            margin: 4px 12px 8px; padding: 6px 12px; border-radius: 8px;
            font-size: 0.68rem; font-weight: 700; text-align: center;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .rc-admin     { background: #fef3c7; color: #b45309; }
        .rc-directeur { background: #dbeafe; color: #1d4ed8; }
        .rc-chef      { background: #dcfce7; color: #166534; }
        .rc-membre    { background: #f0fdf4; color: #0d9488; }
        .rc-doctorant { background: #ede9fe; color: #6d28d9; }
        .rc-associe   { background: #fce7f3; color: #9d174d; }
        .sidebar-footer {
            padding: 14px 16px; border-top: 1px solid #f0f2f5;
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

        .main { margin-left: 255px; padding: 28px 32px; flex: 1; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .topbar h1 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; color: #0f172a; }
        .topbar p  { font-size: 0.85rem; color: #94a3b8; margin-top: 3px; }
        .btn-logout {
            padding: 8px 16px; border-radius: 10px; background: #fff1f2;
            color: #e11d48; border: 1px solid #fecdd3; font-size: 0.82rem;
            font-weight: 600; text-decoration: none;
        }

        .profile-header {
            background: white; border-radius: 16px; padding: 28px 32px;
            border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            display: flex; align-items: center; gap: 24px;
            margin-bottom: 22px; position: relative; overflow: hidden;
        }
        .profile-header::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 3px;
            background: linear-gradient(90deg, #0d9488, #0891b2, #6366f1);
        }
        .ph-avatar {
            width: 80px; height: 80px; border-radius: 20px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 2rem; color: white; flex-shrink: 0;
            box-shadow: 0 8px 20px rgba(13,148,136,0.25);
        }
        .ph-info h2 { font-family: 'DM Serif Display', serif; font-size: 1.5rem; color: #0f172a; margin-bottom: 4px; }
        .ph-info p  { color: #94a3b8; font-size: 0.875rem; }
        .ph-badges { display: flex; gap: 8px; margin-top: 10px; }
        .ph-badge {
            padding: 4px 12px; border-radius: 20px; font-size: 0.72rem; font-weight: 700;
        }
        .phb-role   { background: #ccfbf1; color: #0d9488; }
        .phb-statut { background: #dbeafe; color: #1d4ed8; }
        .phb-actif  { background: #dcfce7; color: #166534; }

        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        .card {
            background: white; border-radius: 16px; padding: 24px;
            border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .card-title {
            font-size: 0.9rem; font-weight: 700; color: #0f172a;
            margin-bottom: 20px; padding-bottom: 12px;
            border-bottom: 1px solid #f0f2f5;
            display: flex; align-items: center; gap: 8px;
        }

        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block; font-size: 0.72rem; font-weight: 700;
            color: #475569; text-transform: uppercase;
            letter-spacing: 0.5px; margin-bottom: 7px;
        }
        .form-group input, .form-group textarea {
            width: 100%; padding: 11px 14px;
            border: 1.5px solid #e8ecf0; border-radius: 10px;
            font-size: 0.9rem; font-family: 'Outfit', sans-serif;
            color: #0f172a; outline: none; background: #f8fafc; transition: all 0.2s;
        }
        .form-group input:focus, .form-group textarea:focus {
            border-color: #0d9488; background: white;
            box-shadow: 0 0 0 3px rgba(13,148,136,0.08);
        }
        .form-group input[readonly] {
            background: #f1f5f9; color: #94a3b8; cursor: not-allowed;
        }
        .form-group textarea { resize: vertical; min-height: 90px; }

        .success-msg {
            background: #f0fdf4; color: #166534;
            border: 1px solid #bbf7d0; border-left: 4px solid #22c55e;
            border-radius: 10px; padding: 11px 14px;
            margin-bottom: 16px; font-size: 0.85rem;
            display: flex; align-items: center; gap: 8px;
        }
        .error-msg {
            background: #fff1f2; color: #be123c;
            border: 1px solid #fecdd3; border-left: 4px solid #f43f5e;
            border-radius: 10px; padding: 11px 14px;
            margin-bottom: 16px; font-size: 0.85rem;
            display: flex; align-items: center; gap: 8px;
        }

        .btn-save {
            padding: 11px 24px; border: none; border-radius: 10px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            color: white; font-size: 0.9rem; font-weight: 700;
            font-family: 'Outfit', sans-serif; cursor: pointer;
            box-shadow: 0 4px 14px rgba(13,148,136,0.3); transition: all 0.2s;
        }
        .btn-save:hover { transform: translateY(-1px); }

        .strength-wrap { margin-top: 8px; }
        .strength-bar {
            height: 5px; border-radius: 3px; background: #e8ecf0;
            overflow: hidden; margin-bottom: 4px;
        }
        .strength-fill { height: 100%; border-radius: 3px; transition: all 0.3s; width: 0; }
        .strength-txt { font-size: 0.72rem; color: #94a3b8; }

        .info-box {
            background: #f0fdf4; border: 1px solid #bbf7d0;
            border-radius: 10px; padding: 12px 14px;
            font-size: 0.8rem; color: #166534; margin-bottom: 16px;
            display: flex; align-items: flex-start; gap: 8px;
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="profil" />
</jsp:include>

<!-- MAIN -->
<div class="main">
    <div class="topbar">
        <div>
            <h1>👤 Mon Profil</h1>
            <p>Gérez vos informations et votre mot de passe</p>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">🚪 Déconnexion</a>
    </div>

    <!-- Header profil -->
    <div class="profile-header">
        <div class="ph-avatar">
            <%= membre.getPrenom().charAt(0) %><%= membre.getNom().charAt(0) %>
        </div>
        <div class="ph-info">
            <h2><%= membre.getPrenom() %> <%= membre.getNom() %></h2>
            <p><%= membre.getEmail() %></p>
            <div class="ph-badges">
                <span class="ph-badge phb-role">🎓 <%= role %></span>
                <span class="ph-badge phb-statut">📋 <%= membre.getStatut() != null ? membre.getStatut() : "membre" %></span>
                <span class="ph-badge phb-actif">✅ Actif</span>
            </div>
        </div>
    </div>

    <div class="profile-grid">

        <!-- MODIFIER PROFIL -->
        <div class="card">
            <div class="card-title">✏️ Mes informations</div>

            <% String successProfil = (String) request.getAttribute("successProfil");
               String erreurProfil  = (String) request.getAttribute("erreurProfil");
               if (successProfil != null) { %>
                <div class="success-msg"><%= successProfil %></div>
            <% } %>
            <% if (erreurProfil != null) { %>
                <div class="error-msg">⚠️ <%= erreurProfil %></div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/profil">
                <input type="hidden" name="action" value="modifierProfil" />
                <div class="form-group">
                    <label>Nom</label>
                    <input type="text" name="nom" value="<%= membre.getNom() != null ? membre.getNom() : "" %>" required />
                </div>
                <div class="form-group">
                    <label>Prénom</label>
                    <input type="text" name="prenom" value="<%= membre.getPrenom() != null ? membre.getPrenom() : "" %>" required />
                </div>
                <div class="form-group">
                    <label>Email (non modifiable)</label>
                    <input type="email" value="<%= membre.getEmail() != null ? membre.getEmail() : "" %>" readonly />
                </div>
                <div class="form-group">
                    <label>Établissement</label>
                    <input type="text" name="etablissement" value="<%= membre.getEtablissement() != null ? membre.getEtablissement() : "" %>" placeholder="Université / Faculté" />
                </div>
                <div class="form-group">
                    <label>Biographie</label>
                    <textarea name="biographie" placeholder="Décrivez votre parcours..."><%= membre.getBiographie() != null ? membre.getBiographie() : "" %></textarea>
                </div>
                <div class="form-group">
                    <label>Centres d'intérêt</label>
                    <textarea name="centresInteret" placeholder="Ex: Machine Learning, Big Data, Réseaux de capteurs..."><%= membre.getCentresInteret() != null ? membre.getCentresInteret() : "" %></textarea>
                </div>
                <button type="submit" class="btn-save">💾 Enregistrer</button>
            </form>
        </div>

        <!-- CHANGER MOT DE PASSE -->
        <div class="card">
            <div class="card-title">🔑 Changer mon mot de passe</div>

            <div class="info-box">
                ℹ️ Si vous venez d'être accepté, votre mot de passe initial commence par <strong>LIAS</strong>. Changez-le ici.
            </div>

            <% String successMdp = (String) request.getAttribute("successMdp");
               String erreurMdp  = (String) request.getAttribute("erreurMdp");
               if (successMdp != null) { %>
                <div class="success-msg"><%= successMdp %></div>
            <% } %>
            <% if (erreurMdp != null) { %>
                <div class="error-msg">⚠️ <%= erreurMdp %></div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/profil">
                <input type="hidden" name="action" value="changerMdp" />
                <div class="form-group">
                    <label>Ancien mot de passe</label>
                    <input type="password" name="ancienMdp" placeholder="••••••••" required />
                </div>
                <div class="form-group">
                    <label>Nouveau mot de passe</label>
                    <input type="password" name="nouveauMdp" id="nouveauMdp"
                           placeholder="Min. 6 caractères" required
                           onkeyup="checkStrength(this.value)" />
                    <div class="strength-wrap">
                        <div class="strength-bar">
                            <div class="strength-fill" id="sFill"></div>
                        </div>
                        <span class="strength-txt" id="sTxt">Entrez un mot de passe</span>
                    </div>
                </div>
                <div class="form-group">
                    <label>Confirmer le nouveau mot de passe</label>
                    <input type="password" name="confirmMdp" id="confirmMdp"
                           placeholder="••••••••" required
                           onkeyup="checkMatch()" />
                    <span id="matchTxt" style="font-size:0.72rem;"></span>
                </div>
                <button type="submit" class="btn-save">🔐 Changer le mot de passe</button>
            </form>
        </div>

        <!-- HISTORIQUE DES MODIFICATIONS -->
        <div class="card" style="grid-column: 1 / -1;">
            <div class="card-title">🕒 Historique des modifications</div>
            <%
                List<HistoriqueProfil> historique = (List<HistoriqueProfil>) request.getAttribute("historique");
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                if (historique == null || historique.isEmpty()) {
            %>
                <p style="color:#94a3b8; font-size:0.85rem;">Aucune modification enregistrée pour le moment.</p>
            <%
                } else {
                    for (HistoriqueProfil h : historique) {
            %>
                <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid #f0f2f5; font-size:0.85rem;">
                    <div>
                        <strong style="color:#0f172a;"><%= h.getChampModifie() %></strong>
                        <span style="color:#94a3b8;"> : </span>
                        <span style="color:#be123c; text-decoration:line-through;"><%= h.getAncienneValeur() %></span>
                        <span style="color:#94a3b8;"> → </span>
                        <span style="color:#166534; font-weight:600;"><%= h.getNouvelleValeur() %></span>
                    </div>
                    <span style="color:#cbd5e1; font-size:0.72rem;"><%= sdf.format(h.getDateModification()) %></span>
                </div>
            <%
                    }
                }
            %>
        </div>

    </div>
</div>

<script>
function checkStrength(val) {
    const fill = document.getElementById('sFill');
    const txt  = document.getElementById('sTxt');
    let score = 0;
    if (val.length >= 6)  score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const colors = ['#ef4444','#f59e0b','#f59e0b','#0d9488','#0d9488'];
    const labels = ['Très faible','Faible','Moyen','Fort','Très fort'];
    const widths = ['20%','40%','60%','80%','100%'];

    if (val.length === 0) {
        fill.style.width = '0'; txt.textContent = 'Entrez un mot de passe'; txt.style.color = '#94a3b8';
    } else {
        const i = Math.max(0, score - 1);
        fill.style.background = colors[i];
        fill.style.width = widths[i];
        txt.textContent = labels[i];
        txt.style.color = colors[i];
    }
}

function checkMatch() {
    const mdp  = document.getElementById('nouveauMdp').value;
    const conf = document.getElementById('confirmMdp').value;
    const el   = document.getElementById('matchTxt');
    if (conf.length === 0) { el.textContent = ''; return; }
    if (mdp === conf) {
        el.textContent = '✅ Correspondent'; el.style.color = '#0d9488';
    } else {
        el.textContent = '❌ Ne correspondent pas'; el.style.color = '#ef4444';
    }
}
</script>
</body>
</html>