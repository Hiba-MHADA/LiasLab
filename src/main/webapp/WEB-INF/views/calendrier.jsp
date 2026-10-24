<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.text.SimpleDateFormat" %>
<%
    Membre connecte = (Membre) session.getAttribute("membreConnecte");
    if (connecte == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String role = connecte.getRole() != null ? connecte.getRole() : "membre";
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS Lab — Calendrier</title>
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

        .cal-grid { display: grid; grid-template-columns: 1fr 320px; gap: 20px; }

        /* Calendrier */
        .cal-card { background: white; border-radius: 16px; padding: 24px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .cal-month { font-family: 'DM Serif Display', serif; font-size: 1.3rem; color: #0f172a; }
        .cal-nav { display: flex; gap: 6px; }
        .cal-nav button { width: 34px; height: 34px; border-radius: 8px; border: 1px solid #e8ecf0; background: white; cursor: pointer; font-size: 0.875rem; transition: all 0.15s; }
        .cal-nav button:hover { background: #f0fdf4; border-color: #0d9488; color: #0d9488; }

        .cal-days-header { display: grid; grid-template-columns: repeat(7,1fr); gap: 4px; margin-bottom: 8px; }
        .cal-day-name { text-align: center; font-size: 0.72rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; padding: 6px; }

        .cal-days { display: grid; grid-template-columns: repeat(7,1fr); gap: 4px; }
        .cal-day {
            aspect-ratio: 1; border-radius: 10px; display: flex; flex-direction: column;
            align-items: center; justify-content: center; cursor: pointer;
            font-size: 0.85rem; font-weight: 500; color: #334155;
            transition: all 0.15s; position: relative; padding: 4px;
        }
        .cal-day:hover { background: #f0fdf4; color: #0d9488; }
        .cal-day.today { background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-weight: 800; }
        .cal-day.other-month { color: #cbd5e1; }
        .cal-day.has-event::after { content: ''; position: absolute; bottom: 4px; width: 5px; height: 5px; border-radius: 50%; background: #0d9488; }
        .cal-day.today.has-event::after { background: white; }

        /* Liste événements */
        .evt-list-card { background: white; border-radius: 16px; padding: 22px; border: 1px solid #e8ecf0; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
        .evt-list-title { font-size: 0.92rem; font-weight: 700; color: #0f172a; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid #f0f2f5; }

        .evt-list-item { padding: 12px 0; border-bottom: 1px solid #f8fafc; display: flex; gap: 12px; }
        .evt-list-item:last-child { border-bottom: none; }
        .el-date { text-align: center; min-width: 44px; }
        .el-date .day   { font-size: 1.2rem; font-weight: 800; color: #0d9488; line-height: 1; }
        .el-date .month { font-size: 0.62rem; color: #94a3b8; text-transform: uppercase; }
        .el-content {}
        .el-titre { font-size: 0.85rem; font-weight: 700; color: #0f172a; margin-bottom: 4px; }
        .el-type { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 0.65rem; font-weight: 700; }
        .type-conference { background: #ccfbf1; color: #0d9488; }
        .type-seminaire  { background: #ede9fe; color: #6d28d9; }
        .type-workshop   { background: #fef3c7; color: #b45309; }
        .el-lieu { font-size: 0.75rem; color: #94a3b8; margin-top: 3px; }

        .legend { display: flex; gap: 16px; margin-top: 16px; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 0.75rem; color: #64748b; }
        .legend-dot { width: 8px; height: 8px; border-radius: 50%; background: #0d9488; }

        .empty { text-align: center; padding: 32px; color: #94a3b8; font-size: 0.85rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/sidebar.jsp">
    <jsp:param name="currentPage" value="calendrier" />
</jsp:include>

<div class="main">
    <div class="topbar">
        <div>
            <h1>🗓️ Calendrier</h1>
            <p>Visualisation des événements du laboratoire</p>
        </div>
    </div>

    <div class="cal-grid">
        <!-- Calendrier -->
        <div class="cal-card">
            <div class="cal-header">
                <div class="cal-month" id="calMonth"></div>
                <div class="cal-nav">
                    <button onclick="prevMonth()">←</button>
                    <button onclick="goToday()">Aujourd'hui</button>
                    <button onclick="nextMonth()">→</button>
                </div>
            </div>
            <div class="cal-days-header">
                <div class="cal-day-name">Lun</div>
                <div class="cal-day-name">Mar</div>
                <div class="cal-day-name">Mer</div>
                <div class="cal-day-name">Jeu</div>
                <div class="cal-day-name">Ven</div>
                <div class="cal-day-name">Sam</div>
                <div class="cal-day-name">Dim</div>
            </div>
            <div class="cal-days" id="calDays"></div>
            <div class="legend">
                <div class="legend-item"><div class="legend-dot"></div> Événement</div>
                <div class="legend-item" style="background:#ccfbf1;padding:2px 8px;border-radius:10px;color:#0d9488;">Aujourd'hui</div>
            </div>
        </div>

        <!-- Liste des événements -->
        <div class="evt-list-card">
            <div class="evt-list-title">📅 Tous les événements</div>
            <% if (evenements == null || evenements.isEmpty()) { %>
                <div class="empty">Aucun événement</div>
            <% } else { %>
                <% for (Evenement e : evenements) {
                    String typeLabel = "conference".equals(e.getType()) ? "🎤 Conférence" : "seminaire".equals(e.getType()) ? "📖 Séminaire" : "🔧 Workshop";
                    String typeClass = "conference".equals(e.getType()) ? "type-conference" : "seminaire".equals(e.getType()) ? "type-seminaire" : "type-workshop";
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    if (e.getDateDebut() != null) cal.setTime(e.getDateDebut());
                    String[] months = {"Jan","Fév","Mar","Avr","Mai","Jun","Jul","Aoû","Sep","Oct","Nov","Déc"};
                    String month = e.getDateDebut() != null ? months[cal.get(java.util.Calendar.MONTH)] : "?";
                    String day   = e.getDateDebut() != null ? String.valueOf(cal.get(java.util.Calendar.DAY_OF_MONTH)) : "?";
                %>
                <div class="evt-list-item">
                    <div class="el-date">
                        <div class="day"><%= day %></div>
                        <div class="month"><%= month %></div>
                    </div>
                    <div class="el-content">
                        <div class="el-titre"><%= e.getTitre() %></div>
                        <span class="el-type <%= typeClass %>"><%= typeLabel %></span>
                        <% if (e.getLieu() != null && !e.getLieu().isEmpty()) { %>
                        <div class="el-lieu">📍 <%= e.getLieu() %></div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
</div>

<script>
// Dates des événements depuis JSP
const eventDates = [
    <% if (evenements != null) { for (Evenement e : evenements) { if (e.getDateDebut() != null) { %>
    "<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(e.getDateDebut()) %>",
    <% } } } %>
];

let currentDate = new Date();

function renderCalendar() {
    const year  = currentDate.getFullYear();
    const month = currentDate.getMonth();
    const today = new Date();

    const months = ['Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
    document.getElementById('calMonth').textContent = months[month] + ' ' + year;

    const firstDay = new Date(year, month, 1);
    const lastDay  = new Date(year, month + 1, 0);
    let startDay = firstDay.getDay() - 1;
    if (startDay < 0) startDay = 6;

    let html = '';
    for (let i = 0; i < startDay; i++) {
        const d = new Date(year, month, -startDay + i + 1);
        html += '<div class="cal-day other-month">' + d.getDate() + '</div>';
    }
    for (let d = 1; d <= lastDay.getDate(); d++) {
        const dateStr = year + '-' + String(month+1).padStart(2,'0') + '-' + String(d).padStart(2,'0');
        const isToday = d === today.getDate() && month === today.getMonth() && year === today.getFullYear();
        const hasEvt  = eventDates.includes(dateStr);
        const classes = 'cal-day' + (isToday ? ' today' : '') + (hasEvt ? ' has-event' : '');
        html += '<div class="' + classes + '">' + d + '</div>';
    }
    document.getElementById('calDays').innerHTML = html;
}

function prevMonth() { currentDate.setMonth(currentDate.getMonth() - 1); renderCalendar(); }
function nextMonth() { currentDate.setMonth(currentDate.getMonth() + 1); renderCalendar(); }
function goToday()   { currentDate = new Date(); renderCalendar(); }

renderCalendar();
</script>
</body>
</html>