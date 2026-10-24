<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
    List<Evenement>   evenements   = (List<Evenement>)   request.getAttribute("evenements");
    List<Equipe>      equipes      = (List<Equipe>)      request.getAttribute("equipes");
    int nbMembres = request.getAttribute("nbMembres") != null ? (int) request.getAttribute("nbMembres") : 0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIAS Lab — Laboratoire d'Informatique et Applications des Sciences</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: #f8fafc; color: #0f172a; }

        /* NAVBAR */
        .navbar {
            background: white; border-bottom: 1px solid #e8ecf0;
            padding: 0 48px; height: 68px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        }
        .nav-logo { display: flex; align-items: center; gap: 12px; text-decoration: none; }
        .nav-logo-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
        }
        .nav-logo-text h2 { font-size: 1rem; font-weight: 800; color: #0f172a; }
        .nav-logo-text p  { font-size: 0.65rem; color: #94a3b8; }
        .nav-links { display: flex; align-items: center; gap: 8px; }
        .nav-links a {
            padding: 7px 16px; border-radius: 8px;
            font-size: 0.85rem; font-weight: 500; color: #64748b;
            text-decoration: none; transition: all 0.15s;
        }
        .nav-links a:hover { background: #f0fdf4; color: #0d9488; }
        .nav-btn {
            padding: 8px 20px; border-radius: 10px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            color: white !important; font-weight: 700 !important;
            box-shadow: 0 4px 12px rgba(13,148,136,0.25);
        }
        .nav-btn:hover { transform: translateY(-1px); background: linear-gradient(135deg, #0d9488, #0891b2) !important; }

        /* HERO */
        .hero {
            background: linear-gradient(135deg, #0f172a 0%, #1e3a5f 50%, #0d9488 100%);
            padding: 100px 48px;
            text-align: center;
            position: relative; overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background-image: radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px);
            background-size: 30px 30px;
        }
        .hero-content { position: relative; z-index: 1; max-width: 800px; margin: 0 auto; }
        .hero-tag {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(13,148,136,0.2); border: 1px solid rgba(13,148,136,0.4);
            color: #5eead4; padding: 6px 16px; border-radius: 20px;
            font-size: 0.78rem; font-weight: 600; margin-bottom: 24px;
            text-transform: uppercase; letter-spacing: 0.8px;
        }
        .hero h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 3.2rem; color: white; line-height: 1.2;
            margin-bottom: 20px; letter-spacing: -1px;
        }
        .hero h1 span { color: #5eead4; }
        .hero p { color: rgba(255,255,255,0.65); font-size: 1.1rem; line-height: 1.7; margin-bottom: 36px; }
        .hero-btns { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
        .hero-btn-primary {
            padding: 13px 28px; border-radius: 12px;
            background: linear-gradient(135deg, #0d9488, #0891b2);
            color: white; font-weight: 700; text-decoration: none;
            font-size: 0.95rem; box-shadow: 0 8px 24px rgba(13,148,136,0.35);
            transition: all 0.2s;
        }
        .hero-btn-primary:hover { transform: translateY(-2px); }
        .hero-btn-secondary {
            padding: 13px 28px; border-radius: 12px;
            background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2);
            color: white; font-weight: 600; text-decoration: none;
            font-size: 0.95rem; transition: all 0.2s;
        }
        .hero-btn-secondary:hover { background: rgba(255,255,255,0.15); }

        /* STATS */
        .stats-section {
            background: white; padding: 48px;
            display: grid; grid-template-columns: repeat(4,1fr); gap: 0;
            border-bottom: 1px solid #e8ecf0;
        }
        .stat-item {
            text-align: center; padding: 24px;
            border-right: 1px solid #e8ecf0;
        }
        .stat-item:last-child { border-right: none; }
        .stat-item .num { font-size: 2.5rem; font-weight: 800; color: #0d9488; line-height: 1; }
        .stat-item .lbl { font-size: 0.85rem; color: #64748b; margin-top: 6px; }

        /* SECTIONS */
        .section { padding: 80px 48px; }
        .section-alt { background: white; }
        .section-header { text-align: center; margin-bottom: 48px; }
        .section-tag {
            display: inline-block; padding: 4px 14px; border-radius: 20px;
            background: #ccfbf1; color: #0d9488;
            font-size: 0.72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.8px; margin-bottom: 14px;
        }
        .section-header h2 {
            font-family: 'DM Serif Display', serif;
            font-size: 2.2rem; color: #0f172a; margin-bottom: 12px;
        }
        .section-header p { color: #64748b; font-size: 0.95rem; max-width: 500px; margin: 0 auto; }

        /* ABOUT */
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; align-items: center; max-width: 1100px; margin: 0 auto; }
        .about-text h3 { font-family: 'DM Serif Display', serif; font-size: 1.8rem; color: #0f172a; margin-bottom: 16px; }
        .about-text p  { color: #64748b; line-height: 1.8; margin-bottom: 16px; font-size: 0.95rem; }
        .about-features { display: flex; flex-direction: column; gap: 12px; margin-top: 20px; }
        .about-feature { display: flex; align-items: center; gap: 10px; font-size: 0.875rem; color: #334155; }
        .about-feature::before { content: '✅'; }
        .about-visual {
            background: linear-gradient(135deg, #ccfbf1, #cffafe);
            border-radius: 20px; padding: 40px;
            display: flex; flex-direction: column; gap: 14px;
        }
        .av-item {
            background: white; border-radius: 12px; padding: 16px 20px;
            display: flex; align-items: center; gap: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .av-icon { font-size: 1.5rem; }
        .av-text strong { display: block; font-size: 0.875rem; font-weight: 700; color: #0f172a; }
        .av-text span   { font-size: 0.78rem; color: #64748b; }

        /* EQUIPES */
        .equipes-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px,1fr)); gap: 20px; max-width: 1100px; margin: 0 auto; }
        .equipe-card {
            background: white; border-radius: 16px; padding: 24px;
            border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: all 0.2s; position: relative; overflow: hidden;
        }
        .equipe-card:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(13,148,136,0.12); }
        .equipe-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, #0d9488, #0891b2); }
        .eq-icon { width: 48px; height: 48px; border-radius: 14px; background: linear-gradient(135deg, #ccfbf1, #cffafe); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; margin-bottom: 14px; }
        .eq-nom  { font-size: 1rem; font-weight: 800; color: #0f172a; margin-bottom: 8px; }
        .eq-desc { font-size: 0.8rem; color: #94a3b8; line-height: 1.5; }

        /* PUBLICATIONS */
        .pub-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px,1fr)); gap: 20px; max-width: 1100px; margin: 0 auto; }
        .pub-card {
            background: #f8fafc; border-radius: 14px; padding: 22px;
            border: 1px solid #e8ecf0; transition: all 0.2s;
            position: relative;
        }
        .pub-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(13,148,136,0.1); }
        .pub-card::before { content: ''; position: absolute; top: 0; left: 0; bottom: 0; width: 3px; background: linear-gradient(180deg, #0d9488, #0891b2); border-radius: 3px 0 0 3px; }
        .pub-year { display: inline-block; padding: 3px 10px; border-radius: 20px; background: #ccfbf1; color: #0d9488; font-size: 0.72rem; font-weight: 700; margin-bottom: 10px; }
        .pub-titre  { font-size: 0.95rem; font-weight: 700; color: #0f172a; margin-bottom: 8px; line-height: 1.4; }
        .pub-auteurs{ font-size: 0.8rem; color: #64748b; margin-bottom: 4px; }
        .pub-revue  { font-size: 0.78rem; color: #94a3b8; font-style: italic; }
        .pub-lien   { display: inline-block; margin-top: 10px; font-size: 0.78rem; color: #0d9488; font-weight: 600; text-decoration: none; }
        .pub-lien:hover { text-decoration: underline; }

        /* EVENEMENTS */
        .evt-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px,1fr)); gap: 20px; max-width: 1100px; margin: 0 auto; }
        .evt-card {
            background: white; border-radius: 16px; padding: 22px;
            border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: all 0.2s; position: relative; overflow: hidden;
        }
        .evt-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(13,148,136,0.1); }
        .evt-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
        .evt-conference::before { background: linear-gradient(90deg, #0d9488, #0891b2); }
        .evt-seminaire::before  { background: linear-gradient(90deg, #7c3aed, #6366f1); }
        .evt-workshop::before   { background: linear-gradient(90deg, #d97706, #f59e0b); }
        .evt-type { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; margin-bottom: 12px; }
        .type-conference { background: #ccfbf1; color: #0d9488; }
        .type-seminaire  { background: #ede9fe; color: #6d28d9; }
        .type-workshop   { background: #fef3c7; color: #b45309; }
        .evt-titre { font-size: 0.95rem; font-weight: 700; color: #0f172a; margin-bottom: 10px; }
        .evt-meta  { font-size: 0.78rem; color: #64748b; display: flex; flex-direction: column; gap: 4px; }

        /* CONTACT */
        .contact-section {
            background: linear-gradient(135deg, #0f172a, #1e3a5f);
            padding: 80px 48px; text-align: center;
        }
        .contact-section h2 { font-family: 'DM Serif Display', serif; font-size: 2rem; color: white; margin-bottom: 14px; }
        .contact-section p  { color: rgba(255,255,255,0.6); margin-bottom: 32px; font-size: 0.95rem; }
        .contact-info { display: flex; justify-content: center; gap: 32px; flex-wrap: wrap; }
        .contact-item { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,0.8); font-size: 0.875rem; }

        /* FOOTER */
        .footer {
            background: #0f172a; padding: 24px 48px;
            display: flex; justify-content: space-between; align-items: center;
            border-top: 1px solid rgba(255,255,255,0.08);
        }
        .footer p { color: rgba(255,255,255,0.4); font-size: 0.8rem; }
        .footer-login { color: #0d9488; text-decoration: none; font-size: 0.8rem; font-weight: 600; }

        .empty { text-align: center; padding: 48px; color: #94a3b8; font-size: 0.9rem; }

        /* SCROLL animations */
        html { scroll-behavior: smooth; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/public" class="nav-logo">
        <div class="nav-logo-icon">🔬</div>
        <div class="nav-logo-text">
            <h2>LIAS Lab</h2>
            <p>Faculté Ben M'Sik</p>
        </div>
    </a>
    <div class="nav-links">
        <a href="#about">À propos</a>
        <a href="#equipes">Équipes</a>
        <a href="#publications">Publications</a>
        <a href="#evenements">Événements</a>
        <a href="<%= request.getContextPath() %>/login" class="nav-btn">🔓 Connexion membre</a>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-tag">🔬 Laboratoire de Recherche</div>
        <h1>Laboratoire <span>LIAS</span><br>Faculté des Sciences Ben M'Sik</h1>
        <p>Laboratoire d'Informatique et Applications des Sciences — Université Hassan II de Casablanca. Un centre d'excellence pour la recherche en informatique et sciences appliquées.</p>
        <div class="hero-btns">
            <a href="#publications" class="hero-btn-primary">📚 Nos publications</a>
            <a href="#evenements" class="hero-btn-secondary">📅 Nos événements</a>
        </div>
    </div>
</section>

<!-- STATS -->
<div class="stats-section">
    <div class="stat-item">
        <div class="num"><%= nbMembres %>+</div>
        <div class="lbl">Membres actifs</div>
    </div>
    <div class="stat-item">
        <div class="num"><%= publications != null ? publications.size() : 0 %>+</div>
        <div class="lbl">Publications</div>
    </div>
    <div class="stat-item">
        <div class="num"><%= evenements != null ? evenements.size() : 0 %>+</div>
        <div class="lbl">Événements organisés</div>
    </div>
    <div class="stat-item">
        <div class="num"><%= equipes != null ? equipes.size() : 0 %>+</div>
        <div class="lbl">Équipes de recherche</div>
    </div>
</div>

<!-- À PROPOS -->
<section class="section" id="about">
    <div class="about-grid">
        <div class="about-text">
            <h3>À propos du laboratoire LIAS</h3>
            <p>Le laboratoire LIAS (Laboratoire d'Informatique et Applications des Sciences) est un centre de recherche rattaché à la Faculté des Sciences Ben M'Sik de l'Université Hassan II de Casablanca.</p>
            <p>Nos travaux de recherche portent sur l'informatique théorique et appliquée, les systèmes intelligents, le traitement de données et les applications scientifiques innovantes.</p>
            <div class="about-features">
                <div class="about-feature">Recherche fondamentale et appliquée</div>
                <div class="about-feature">Collaboration nationale et internationale</div>
                <div class="about-feature">Formation doctorale de qualité</div>
                <div class="about-feature">Publications dans des revues de haut niveau</div>
            </div>
        </div>
        <div class="about-visual">
            <div class="av-item">
                <div class="av-icon">🔬</div>
                <div class="av-text">
                    <strong>Recherche scientifique</strong>
                    <span>Projets innovants et publications</span>
                </div>
            </div>
            <div class="av-item">
                <div class="av-icon">🎓</div>
                <div class="av-text">
                    <strong>Formation doctorale</strong>
                    <span>Encadrement de doctorants</span>
                </div>
            </div>
            <div class="av-item">
                <div class="av-icon">🤝</div>
                <div class="av-text">
                    <strong>Partenariats</strong>
                    <span>Conventions nationales et internationales</span>
                </div>
            </div>
            <div class="av-item">
                <div class="av-icon">🏛️</div>
                <div class="av-text">
                    <strong>Université Hassan II</strong>
                    <span>Faculté des Sciences Ben M'Sik</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ÉQUIPES -->
<section class="section section-alt" id="equipes">
    <div class="section-header">
        <div class="section-tag">🏛️ Équipes</div>
        <h2>Nos équipes de recherche</h2>
        <p>Des équipes pluridisciplinaires travaillant sur des projets de recherche innovants</p>
    </div>
    <% if (equipes == null || equipes.isEmpty()) { %>
        <div class="empty">Aucune équipe pour le moment</div>
    <% } else { %>
    <div class="equipes-grid">
        <% for (Equipe eq : equipes) { %>
        <div class="equipe-card">
            <div class="eq-icon">🏛️</div>
            <div class="eq-nom"><%= eq.getNom() %></div>
            <div class="eq-desc"><%= eq.getDescription() != null ? eq.getDescription() : "Équipe de recherche du laboratoire LIAS" %></div>
        </div>
        <% } %>
    </div>
    <% } %>
</section>

<!-- PUBLICATIONS -->
<section class="section" id="publications">
    <div class="section-header">
        <div class="section-tag">📚 Publications</div>
        <h2>Publications scientifiques</h2>
        <p>Les travaux de recherche publiés par les membres du laboratoire</p>
    </div>
    <% if (publications == null || publications.isEmpty()) { %>
        <div class="empty">Aucune publication pour le moment</div>
    <% } else { %>
    <div class="pub-grid">
        <% int pubCount = 0; for (Publication p : publications) { if (pubCount >= 6) break; pubCount++; %>
        <div class="pub-card">
            <div class="pub-year">📅 <%= p.getAnnee() %></div>
            <div class="pub-titre"><%= p.getTitre() != null ? p.getTitre() : "-" %></div>
            <div class="pub-auteurs">👤 <%= p.getAuteurs() != null ? p.getAuteurs() : "-" %></div>
            <div class="pub-revue">📖 <%= p.getRevue() != null ? p.getRevue() : "-" %></div>
            <% if (p.getLien() != null && !p.getLien().isEmpty()) { %>
            <a href="<%= p.getLien() %>" target="_blank" class="pub-lien">🔗 Lire la publication</a>
            <% } %>
        </div>
        <% } %>
    </div>
    <% } %>
</section>

<!-- ÉVÉNEMENTS -->
<section class="section section-alt" id="evenements">
    <div class="section-header">
        <div class="section-tag">📅 Événements</div>
        <h2>Activités scientifiques</h2>
        <p>Conférences, séminaires et workshops organisés par le laboratoire</p>
    </div>
    <% if (evenements == null || evenements.isEmpty()) { %>
        <div class="empty">Aucun événement pour le moment</div>
    <% } else { %>
    <div class="evt-grid">
        <% int evtCount = 0; for (Evenement e : evenements) { if (evtCount >= 6) break; evtCount++;
            String typeClass  = "conference".equals(e.getType()) ? "evt-conference" : "seminaire".equals(e.getType()) ? "evt-seminaire" : "evt-workshop";
            String badgeClass = "conference".equals(e.getType()) ? "type-conference" : "seminaire".equals(e.getType()) ? "type-seminaire" : "type-workshop";
            String typeLabel  = "conference".equals(e.getType()) ? "🎤 Conférence" : "seminaire".equals(e.getType()) ? "📖 Séminaire" : "🔧 Workshop";
        %>
        <div class="evt-card <%= typeClass %>">
            <span class="evt-type <%= badgeClass %>"><%= typeLabel %></span>
            <div class="evt-titre"><%= e.getTitre() != null ? e.getTitre() : "-" %></div>
            <div class="evt-meta">
                <% if (e.getDateDebut() != null) { %><span>📅 <%= sdf.format(e.getDateDebut()) %></span><% } %>
                <% if (e.getLieu() != null && !e.getLieu().isEmpty()) { %><span>📍 <%= e.getLieu() %></span><% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</section>

<!-- CONTACT -->
<section class="contact-section">
    <h2>Contactez-nous</h2>
    <p>Faculté des Sciences Ben M'Sik — Université Hassan II de Casablanca</p>
    <div class="contact-info">
        <div class="contact-item">🏛️ Faculté des Sciences Ben M'Sik</div>
        <div class="contact-item">📍 Casablanca, Maroc</div>
        <div class="contact-item">🌐 Université Hassan II</div>
        <div class="contact-item">✉️ contact@lias.ma</div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    <p>© 2026 LIAS Lab — Faculté des Sciences Ben M'Sik — Université Hassan II de Casablanca</p>
    <a href="<%= request.getContextPath() %>/login" class="footer-login">🔓 Espace membre</a>
</footer>

</body>
</html>