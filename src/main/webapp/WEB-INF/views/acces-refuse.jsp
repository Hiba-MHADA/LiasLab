<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Membre" %>
<%
    Membre membre = (Membre) session.getAttribute("membreConnecte");
    String erreur = (String) request.getAttribute("erreurAcces");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Accès refusé</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f0f2f8; min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
        }
        .card {
            background: white; border-radius: 20px; padding: 48px;
            box-shadow: 0 8px 40px rgba(45,27,105,0.1);
            text-align: center; max-width: 460px; width: 100%;
        }
        .icon { font-size: 4rem; margin-bottom: 20px; }
        h1 { font-size: 1.5rem; font-weight: 800; color: #1e1b4b; margin-bottom: 10px; }
        p  { color: #64748b; font-size: 0.9rem; line-height: 1.6; margin-bottom: 28px; }
        .role-badge {
            display: inline-block; padding: 5px 14px;
            background: #eef2ff; color: #4338ca;
            border-radius: 20px; font-size: 0.8rem; font-weight: 600;
            margin-bottom: 24px;
        }
        .btn {
            display: inline-block; padding: 12px 28px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white; border-radius: 10px; text-decoration: none;
            font-weight: 700; font-size: 0.9rem;
            box-shadow: 0 4px 14px rgba(99,102,241,0.3);
            transition: all 0.2s;
        }
        .btn:hover { transform: translateY(-2px); }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">🔒</div>
        <h1>Accès refusé</h1>
        <% if (erreur != null) { %>
            <p><%= erreur %></p>
        <% } else { %>
            <p>Vous n'avez pas les droits nécessaires pour accéder à cette page.</p>
        <% } %>
        <% if (membre != null) { %>
            <div class="role-badge">Votre rôle : <%= membre.getRole() %></div><br>
        <% } %>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn">← Retour au dashboard</a>
    </div>
</body>
</html>