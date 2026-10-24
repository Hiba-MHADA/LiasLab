<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role     = connecte.getRole() != null ? connecte.getRole() : "membre";
    String tab      = (String) request.getAttribute("tab");
    List<Message> recus   = (List<Message>) request.getAttribute("recus");
    List<Message> envoyes = (List<Message>) request.getAttribute("envoyes");
    List<Membre>  membres = (List<Membre>)  request.getAttribute("membres");
    SimpleDateFormat sdf  = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Communication</title>
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

        .comm-grid { display: grid; grid-template-columns: 1fr 360px; gap: 20px; }
        .card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .card-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        /* Tabs */
        .tabs { display: flex; gap: 4px; margin-bottom: 20px; background: #f8fafc; padding: 4px; border-radius: 12px; }
        .tab-btn { flex: 1; padding: 8px 14px; border: none; border-radius: 9px; font-size: 0.82rem; font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif; background: transparent; color: #64748b; transition: all 0.15s; text-decoration: none; text-align: center; }
        .tab-btn.active { background: white; color: #0d9488; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }

        .msg-item { padding: 14px 0; border-bottom: 1px solid #f8fafc; display: flex; gap: 12px; }
        .msg-item:last-child { border-bottom: none; }
        .msg-avatar { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.8rem; color: white; flex-shrink: 0; }
        .msg-content { flex: 1; }
        .msg-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px; }
        .msg-from   { font-size: 0.85rem; font-weight: 700; color: #0f172a; }
        .msg-date   { font-size: 0.72rem; color: #94a3b8; }
        .msg-dest   { font-size: 0.75rem; color: #64748b; margin-bottom: 4px; }
        .msg-text   { font-size: 0.85rem; color: #334155; line-height: 1.5; background: #f8fafc; padding: 10px 12px; border-radius: 10px; border: 1px solid #e8ecf0; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 0.7rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
        .form-group select, .form-group textarea { width: 100%; padding: 10px 13px; border: 1.5px solid #e8ecf0; border-radius: 10px; font-size: 0.875rem; font-family: 'Outfit', sans-serif; color: #0f172a; outline: none; background: #f8fafc; }
        .form-group select:focus, .form-group textarea:focus { border-color: #0d9488; background: white; }
        .form-group textarea { resize: vertical; min-height: 120px; }
        .btn-save { width: 100%; padding: 11px; border: none; border-radius: 10px; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-size: 0.875rem; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; }
        .empty { text-align: center; padding: 48px; color: #94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="communication" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>💬 Communication</h1>
            <p>Messages internes entre membres du laboratoire</p>
        </div>
    </div>

    <div class="comm-grid">
        <!-- Messages -->
        <div class="card">
            <div class="tabs">
                <a href="<%= request.getContextPath() %>/communication?tab=recus"
                   class="tab-btn <%= "recus".equals(tab) ? "active" : "" %>">
                    📥 Reçus (<%= recus != null ? recus.size() : 0 %>)
                </a>
                <a href="<%= request.getContextPath() %>/communication?tab=envoyes"
                   class="tab-btn <%= "envoyes".equals(tab) ? "active" : "" %>">
                    📤 Envoyés (<%= envoyes != null ? envoyes.size() : 0 %>)
                </a>
            </div>

            <% List<Message> currentMsgs = "envoyes".equals(tab) ? envoyes : recus; %>
            <% if (currentMsgs == null || currentMsgs.isEmpty()) { %>
                <div class="empty">💬 Aucun message</div>
            <% } else { %>
                <% for (Message m : currentMsgs) { %>
                <div class="msg-item">
                    <div class="msg-avatar">
                        <%= m.getPrenomExpediteur()!=null?m.getPrenomExpediteur().charAt(0):'?' %><%= m.getNomExpediteur()!=null?m.getNomExpediteur().charAt(0):'?' %>
                    </div>
                    <div class="msg-content">
                        <div class="msg-header">
                            <span class="msg-from">
                                <%= "envoyes".equals(tab) ? "À : " : "De : " %>
                                <%= "envoyes".equals(tab) ?
                                    (m.getNomDestinataire() != null ? m.getPrenomDestinataire() + " " + m.getNomDestinataire() : "Tous les membres") :
                                    m.getPrenomExpediteur() + " " + m.getNomExpediteur() %>
                            </span>
                            <span class="msg-date"><%= m.getDateEnvoi() != null ? sdf.format(m.getDateEnvoi()) : "-" %></span>
                        </div>
                        <div class="msg-text"><%= m.getContenu() %></div>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>

        <!-- Nouveau message -->
        <div class="card">
            <div class="card-title">✉️ Nouveau message</div>
            <form method="post" action="<%= request.getContextPath() %>/communication">
                <div class="form-group">
                    <label>Destinataire</label>
                    <select name="destinataireId">
                        <option value="">📢 Tous les membres</option>
                        <% if (membres != null) for (Membre m : membres) {
                            if (m.getId() == connecte.getId()) continue; %>
                        <option value="<%= m.getId() %>"><%= m.getPrenom() %> <%= m.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Message *</label>
                    <textarea name="contenu" required placeholder="Écrivez votre message..."></textarea>
                </div>
                <button type="submit" class="btn-save">📨 Envoyer</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>