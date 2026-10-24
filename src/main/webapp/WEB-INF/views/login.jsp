<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIAS Lab — Connexion</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            background: #f0f4ff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .page-wrapper {
            width: 100%;
            max-width: 1100px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            align-items: center;
        }

        /* ── CÔTÉ GAUCHE ── */
        .left {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .univ-card {
            background: white;
            border-radius: 20px;
            padding: 28px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 4px 24px rgba(99,102,241,0.08);
            border: 1px solid #e8eaf6;
        }
        .univ-seal {
            width: 64px; height: 64px; border-radius: 16px;
            background: linear-gradient(135deg, #1565c0, #283593);
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; flex-shrink: 0;
        }
        .univ-details h3 {
            font-size: 1rem; font-weight: 700; color: #1a237e;
        }
        .univ-details p {
            font-size: 0.8rem; color: #5c6bc0; margin-top: 3px;
        }
        .univ-details .badges {
            display: flex; gap: 6px; margin-top: 8px;
        }
        .ubadge {
            padding: 3px 10px; border-radius: 20px;
            font-size: 0.65rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .ub1 { background: #e8eaf6; color: #3949ab; }
        .ub2 { background: #e3f2fd; color: #1565c0; }

        .hero-card {
            background: linear-gradient(135deg, #1a237e 0%, #283593 50%, #1565c0 100%);
            border-radius: 20px;
            padding: 36px 32px;
            position: relative;
            overflow: hidden;
        }
        .hero-card::before {
            content: '';
            position: absolute; top: -60px; right: -60px;
            width: 200px; height: 200px; border-radius: 50%;
            background: rgba(255,255,255,0.05);
        }
        .hero-card::after {
            content: '';
            position: absolute; bottom: -40px; left: -40px;
            width: 150px; height: 150px; border-radius: 50%;
            background: rgba(255,255,255,0.05);
        }
        .hero-tag {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 20px; padding: 5px 14px;
            font-size: 0.72rem; font-weight: 600; color: white;
            text-transform: uppercase; letter-spacing: 0.8px;
            margin-bottom: 20px;
        }
        .hero-card h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 2.6rem; color: white; line-height: 1.2;
            margin-bottom: 12px; position: relative; z-index: 1;
        }
        .hero-card p {
            color: rgba(255,255,255,0.65); font-size: 0.9rem;
            line-height: 1.6; position: relative; z-index: 1;
        }

        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
            margin-top: 24px; position: relative; z-index: 1;
        }
        .stat-item {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 12px; padding: 14px;
            text-align: center;
        }
        .stat-item .s-num {
            font-size: 1.6rem; font-weight: 800; color: white; line-height: 1;
        }
        .stat-item .s-lbl {
            font-size: 0.7rem; color: rgba(255,255,255,0.6); margin-top: 4px;
        }
        .stat-item .s-ico { font-size: 1.2rem; margin-bottom: 6px; }

        .modules-grid {
            display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px;
        }
        .module-card {
            background: white; border-radius: 14px; padding: 16px;
            display: flex; align-items: center; gap: 12px;
            box-shadow: 0 2px 12px rgba(99,102,241,0.06);
            border: 1px solid #e8eaf6;
            transition: all 0.2s;
        }
        .module-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(26,35,126,0.1); }
        .mod-icon {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
            flex-shrink: 0;
        }
        .mi1 { background: #e8eaf6; }
        .mi2 { background: #e3f2fd; }
        .mi3 { background: #e8f5e9; }
        .mi4 { background: #fff3e0; }
        .mod-text strong { font-size: 0.82rem; font-weight: 700; color: #1a237e; display: block; }
        .mod-text span   { font-size: 0.72rem; color: #7986cb; }

        /* ── CÔTÉ DROIT ── */
        .right {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .login-card {
            background: white;
            border-radius: 20px;
            padding: 40px 36px;
            box-shadow: 0 8px 40px rgba(26,35,126,0.1);
            border: 1px solid #e8eaf6;
        }

        .login-header { margin-bottom: 28px; }
        .login-header .logo-row {
            display: flex; align-items: center; gap: 12px; margin-bottom: 20px;
        }
        .login-logo {
            width: 52px; height: 52px; border-radius: 14px;
            background: linear-gradient(135deg, #1565c0, #283593);
            display: flex; align-items: center; justify-content: center; font-size: 1.5rem;
        }
        .login-logo-text h2 { font-size: 1.1rem; font-weight: 800; color: #1a237e; }
        .login-logo-text p  { font-size: 0.72rem; color: #7986cb; margin-top: 2px; }

        .login-header h3 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.7rem; color: #0d1b5e; margin-bottom: 6px;
        }
        .login-header p { color: #78909c; font-size: 0.875rem; }

        .divider-line {
            height: 1px; background: linear-gradient(90deg, #e8eaf6, transparent);
            margin: 20px 0;
        }

        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: flex; align-items: center; gap: 6px;
            font-size: 0.75rem; font-weight: 700; color: #37474f;
            text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 8px;
        }
        .input-box {
            display: flex; align-items: center;
            border: 1.5px solid #e8eaf6; border-radius: 12px;
            background: #f5f7ff; overflow: hidden;
            transition: all 0.2s;
        }
        .input-box:focus-within {
            border-color: #1565c0;
            background: white;
            box-shadow: 0 0 0 3px rgba(21,101,192,0.08);
        }
        .input-box .i-prefix {
            padding: 0 14px; font-size: 1rem; color: #90a4ae;
            border-right: 1px solid #e8eaf6; height: 46px;
            display: flex; align-items: center;
        }
        .input-box input {
            flex: 1; padding: 13px 14px; border: none;
            font-size: 0.9rem; font-family: 'Outfit', sans-serif;
            color: #0d1b5e; outline: none; background: transparent;
        }
        .input-box input::placeholder { color: #b0bec5; }

        .error-msg {
            background: #fce4ec; color: #c62828;
            border-left: 4px solid #e53935;
            border-radius: 10px; padding: 11px 14px;
            font-size: 0.83rem; margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }

        .row-opts {
            display: flex; justify-content: space-between;
            align-items: center; margin: 12px 0 20px;
        }
        .check-lbl {
            display: flex; align-items: center; gap: 7px;
            font-size: 0.82rem; color: #607d8b; cursor: pointer;
        }
        .check-lbl input { accent-color: #1565c0; }
        .forgot { font-size: 0.82rem; color: #1565c0; text-decoration: none; font-weight: 600; }

        .btn-login {
            width: 100%; padding: 14px; border: none; border-radius: 12px;
            background: linear-gradient(135deg, #1565c0, #283593);
            color: white; font-size: 0.95rem; font-weight: 700;
            font-family: 'Outfit', sans-serif; cursor: pointer;
            letter-spacing: 0.3px;
            box-shadow: 0 6px 20px rgba(21,101,192,0.3);
            transition: all 0.2s;
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(21,101,192,0.4); }

        .or-divider {
            display: flex; align-items: center; gap: 12px;
            margin: 16px 0; color: #90a4ae; font-size: 0.78rem;
        }
        .or-divider::before, .or-divider::after {
            content: ''; flex: 1; height: 1px; background: #eceff1;
        }

        .btn-visitor {
            width: 100%; padding: 12px; border: 1.5px solid #e8eaf6;
            border-radius: 12px; background: #f5f7ff; color: #546e7a;
            font-size: 0.875rem; font-weight: 600;
            font-family: 'Outfit', sans-serif; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: all 0.2s; text-decoration: none;
        }
        .btn-visitor:hover { border-color: #1565c0; color: #1565c0; background: #e8eaf6; }

        .security-row {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            margin-top: 16px; padding: 10px;
            background: #f5f7ff; border-radius: 10px;
            border: 1px solid #e8eaf6; font-size: 0.75rem; color: #78909c;
        }

        /* Carte info adhésion */
        .adhesion-card {
            background: linear-gradient(135deg, #e3f2fd, #e8eaf6);
            border-radius: 16px; padding: 20px 24px;
            border: 1px solid #bbdefb;
            display: flex; align-items: center; gap: 14px;
        }
        .adh-icon {
            width: 44px; height: 44px; border-radius: 12px;
            background: #1565c0; color: white;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; flex-shrink: 0;
        }
        .adh-text h4 { font-size: 0.875rem; font-weight: 700; color: #0d47a1; margin-bottom: 3px; }
        .adh-text p  { font-size: 0.78rem; color: #1565c0; }
        .adh-text a  { color: #1565c0; font-weight: 700; text-decoration: none; }
        .adh-text a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="page-wrapper">

    <!-- GAUCHE -->
    <div class="left">

        <!-- Carte université -->
        <div class="univ-card">
            <div class="univ-seal">🏛️</div>
            <div class="univ-details">
                <h3>Faculté des Sciences Ben M'Sik</h3>
                <p>Université Hassan II de Casablanca</p>
                <div class="badges">
                    <span class="ubadge ub1">Master Big Data</span>
                    <span class="ubadge ub2">2025 — 2026</span>
                </div>
            </div>
        </div>

        <!-- Hero card -->
        <div class="hero-card">
            <div class="hero-tag">🔬 Laboratoire LIAS</div>
            <h1>Système de<br>Gestion<br>Intégrée</h1>
            <p>Gérez les membres, publications, événements et la mémoire institutionnelle du laboratoire.</p>
            <div class="stats-row">
                <div class="stat-item">
                    <div class="s-ico">👥</div>
                    <div class="s-num">∞</div>
                    <div class="s-lbl">Membres</div>
                </div>
                <div class="stat-item">
                    <div class="s-ico">📚</div>
                    <div class="s-num">∞</div>
                    <div class="s-lbl">Publications</div>
                </div>
                <div class="stat-item">
                    <div class="s-ico">📅</div>
                    <div class="s-num">∞</div>
                    <div class="s-lbl">Événements</div>
                </div>
            </div>
        </div>

        <!-- Modules -->
        <div class="modules-grid">
            <div class="module-card">
                <div class="mod-icon mi1">👥</div>
                <div class="mod-text">
                    <strong>Membres & Rôles</strong>
                    <span>Cycle de vie complet</span>
                </div>
            </div>
            <div class="module-card">
                <div class="mod-icon mi2">📚</div>
                <div class="mod-text">
                    <strong>Publications</strong>
                    <span>Archivage scientifique</span>
                </div>
            </div>
            <div class="module-card">
                <div class="mod-icon mi3">📅</div>
                <div class="mod-text">
                    <strong>Événements</strong>
                    <span>Conférences & séminaires</span>
                </div>
            </div>
            <div class="module-card">
                <div class="mod-icon mi4">📊</div>
                <div class="mod-text">
                    <strong>Rapport annuel</strong>
                    <span>Génération automatique</span>
                </div>
            </div>
        </div>

    </div>

    <!-- DROITE -->
    <div class="right">

        <div class="login-card">
            <div class="login-header">
                <div class="logo-row">
                    <div class="login-logo">🔬</div>
                    <div class="login-logo-text">
                        <h2>LIAS Lab</h2>
                        <p>Plateforme de gestion</p>
                    </div>
                </div>
                <h3>Bon retour !</h3>
                <p>Connectez-vous à votre espace de gestion</p>
            </div>

            <div class="divider-line"></div>

            <% if (request.getAttribute("erreur") != null) { %>
                <div class="error-msg">⚠️ <%= request.getAttribute("erreur") %></div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/login">
                <div class="form-group">
                    <label>✉️ Email</label>
                    <div class="input-box">
                        <span class="i-prefix">@</span>
                        <input type="email" name="email" placeholder="exemple@lias.ma" required autofocus />
                    </div>
                </div>
                <div class="form-group">
                    <label>🔑 Mot de passe</label>
                    <div class="input-box">
                        <span class="i-prefix">••</span>
                        <input type="password" name="motDePasse" placeholder="Votre mot de passe" required />
                    </div>
                </div>
                <div class="row-opts">
                    <label class="check-lbl">
                        <input type="checkbox" /> Se souvenir de moi
                    </label>
                    <a href="#" class="forgot">Mot de passe oublié ?</a>
                </div>
                <button type="submit" class="btn-login">🔓 Se connecter</button>
            </form>

            <div class="or-divider">ou</div>

            <a href="<%= request.getContextPath() %>/public" class="btn-visitor">
                🌐 Accès visiteur (sans connexion)
            </a>

            <div class="security-row">
                🛡️ Connexion sécurisée — Données protégées
            </div>
        </div>

        <!-- Carte adhésion -->
        <div class="adhesion-card">
            <div class="adh-icon">📝</div>
            <div class="adh-text">
                <h4>Pas encore membre ?</h4>
                <p>Soumettez une demande d'adhésion →
                    <a href="<%= request.getContextPath() %>/adhesions?action=formulaire">
                        Rejoindre le laboratoire
                    </a>
                </p>
            </div>
        </div>

    </div>
</div>

</body>
</html>