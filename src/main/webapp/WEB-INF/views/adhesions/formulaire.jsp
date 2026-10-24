<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String success = (String) request.getAttribute("success");
    String erreur  = (String) request.getAttribute("erreur");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Demande d'adhésion</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #0f172a, #1e3a5f, #0d9488);
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 24px;
        }
        .wrap { width: 100%; max-width: 560px; }
        .back-link { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 6px; margin-bottom: 20px; }
        .back-link:hover { color: white; }

        .card { background: white; border-radius: 20px; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .logo-row { display: flex; align-items: center; gap: 12px; margin-bottom: 28px; }
        .logo-box { width: 48px; height: 48px; border-radius: 14px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; }
        .logo-txt h2 { font-family: 'DM Serif Display', serif; font-size: 1.3rem; color: #0f172a; }
        .logo-txt p  { font-size: 0.78rem; color: #94a3b8; }

        h1 { font-family: 'DM Serif Display', serif; font-size: 1.5rem; color: #0f172a; margin-bottom: 8px; }
        .subtitle { font-size: 0.875rem; color: #64748b; margin-bottom: 28px; line-height: 1.6; }

        .success-msg { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; border-left: 4px solid #22c55e; border-radius: 10px; padding: 14px 16px; margin-bottom: 20px; font-size: 0.875rem; }
        .error-msg { background: #fff1f2; color: #be123c; border: 1px solid #fecdd3; border-left: 4px solid #f43f5e; border-radius: 10px; padding: 14px 16px; margin-bottom: 20px; font-size: 0.875rem; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 18px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 0.75rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 7px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 12px 14px; border: 1.5px solid #e8ecf0; border-radius: 10px;
            font-size: 0.9rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; transition: all 0.2s;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #0d9488; background: white; box-shadow: 0 0 0 3px rgba(13,148,136,0.08); }
        .form-group textarea { resize: vertical; min-height: 120px; }

        .upload-zone { border: 2px dashed #e8ecf0; border-radius: 12px; padding: 20px; text-align: center; background: #f8fafc; transition: all 0.2s; cursor: pointer; }
        .upload-zone:hover { border-color: #0d9488; background: #f0fdf4; }
        .upload-zone input { display: none; }
        .upload-zone p { font-size: 0.8rem; color: #94a3b8; margin-top: 6px; }
        .file-name { font-size: 0.78rem; color: #0d9488; margin-top: 6px; font-weight: 600; }

        .btn-submit {
            width: 100%; padding: 14px; border: none; border-radius: 12px;
            background: linear-gradient(135deg, #0d9488, #0891b2); color: white;
            font-size: 0.95rem; font-weight: 700; font-family: 'Outfit', sans-serif;
            cursor: pointer; box-shadow: 0 6px 20px rgba(13,148,136,0.35); transition: all 0.2s;
        }
        .btn-submit:hover { transform: translateY(-2px); }

        .login-link { text-align: center; margin-top: 20px; font-size: 0.85rem; color: #64748b; }
        .login-link a { color: #0d9488; font-weight: 700; text-decoration: none; }
    </style>
</head>
<body>
<div class="wrap">
    <a href="<%= request.getContextPath() %>/public" class="back-link">← Retour à l'accueil</a>
    <div class="card">
        <div class="logo-row">
            <div class="logo-box">🔬</div>
            <div class="logo-txt">
                <h2>LIAS Lab</h2>
                <p>Faculté Ben M'Sik</p>
            </div>
        </div>

        <h1>📋 Demande d'adhésion</h1>
        <p class="subtitle">Rejoignez le laboratoire LIAS en soumettant votre candidature. Notre équipe examinera votre demande dans les meilleurs délais.</p>

        <% if (success != null) { %><div class="success-msg">✅ Votre demande a bien été envoyée. Vous recevrez une réponse par email.</div><% } %>
        <% if (erreur != null) { %><div class="error-msg">⚠️ <%= erreur %></div><% } %>

        <form method="post" action="<%= request.getContextPath() %>/adhesions" enctype="multipart/form-data">
            <input type="hidden" name="action" value="soumettre" />
            <div class="form-row">
                <div class="form-group">
                    <label>Nom *</label>
                    <input type="text" name="nom" required placeholder="Votre nom" />
                </div>
                <div class="form-group">
                    <label>Prénom *</label>
                    <input type="text" name="prenom" required placeholder="Votre prénom" />
                </div>
            </div>
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" required placeholder="email@exemple.ma" />
            </div>
            <div class="form-group">
                <label>Motivation *</label>
                <textarea name="motivation" required placeholder="Expliquez pourquoi vous souhaitez rejoindre le laboratoire LIAS..."></textarea>
            </div>
            <div class="form-group">
                <label>CV (PDF ou Word) *</label>
                <div class="upload-zone" onclick="document.getElementById('cvInput').click()">
                    <div style="font-size:1.6rem;">📄</div>
                    <p>Cliquez pour joindre votre CV</p>
                    <input type="file" id="cvInput" name="cv" accept=".pdf,.doc,.docx" required onchange="updateFileName(this)" />
                </div>
                <p class="file-name" id="fileName"></p>
            </div>
            <button type="submit" class="btn-submit">📨 Soumettre ma demande</button>
        </form>

        <div class="login-link">Déjà membre ? <a href="<%= request.getContextPath() %>/login">Connectez-vous</a></div>
    </div>
</div>
<script>
function updateFileName(input) {
    document.getElementById('fileName').textContent = input.files[0] ? '✅ ' + input.files[0].name : '';
}
</script>
</body>
</html>