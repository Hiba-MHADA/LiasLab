package dao;

import model.Notification;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> getByMembre(int membreId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE membre_id=? ORDER BY date_creation DESC LIMIT 20";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setId(rs.getInt("id"));
                n.setMembreId(rs.getInt("membre_id"));
                n.setMessage(rs.getString("message"));
                n.setLu(rs.getBoolean("lu"));
                n.setDateCreation(rs.getTimestamp("date_creation"));
                list.add(n);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean marquerLu(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE notification SET lu=true WHERE id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean marquerTousLus(int membreId) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE notification SET lu=true WHERE membre_id=?");
            ps.setInt(1, membreId);
            ps.executeUpdate();
            conn.close();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countNonLus(int membreId) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM notification WHERE membre_id=? AND lu=false");
            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int c = rs.getInt(1); conn.close(); return c; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean add(int membreId, String message) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("INSERT INTO notification (membre_id, message, lu, date_creation) VALUES (?,?,false,NOW())");
            ps.setInt(1, membreId);
            ps.setString(2, message);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
 // Notifier TOUS les membres actifs (ex: nouvel événement, nouveau document)
    public void notifierTousMembres(String message) {
        String sqlIds = "SELECT id FROM membre WHERE actif = true";
        String sqlInsert = "INSERT INTO notification (membre_id, message, lu, date_creation) VALUES (?,?,false,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement psIds = conn.prepareStatement(sqlIds);
            ResultSet rs = psIds.executeQuery();
            PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
            while (rs.next()) {
                psInsert.setInt(1, rs.getInt("id"));
                psInsert.setString(2, message);
                psInsert.addBatch();
            }
            psInsert.executeBatch();
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Notifier uniquement les membres ayant un rôle donné (ex: "admin", "directeur")
    public void notifierParRole(String message, String... roles) {
        if (roles == null || roles.length == 0) return;
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < roles.length; i++) placeholders.append(i == 0 ? "?" : ",?");
        String sqlIds = "SELECT id FROM membre WHERE actif = true AND role IN (" + placeholders + ")";
        String sqlInsert = "INSERT INTO notification (membre_id, message, lu, date_creation) VALUES (?,?,false,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement psIds = conn.prepareStatement(sqlIds);
            for (int i = 0; i < roles.length; i++) psIds.setString(i + 1, roles[i]);
            ResultSet rs = psIds.executeQuery();
            PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
            while (rs.next()) {
                psInsert.setInt(1, rs.getInt("id"));
                psInsert.setString(2, message);
                psInsert.addBatch();
            }
            psInsert.executeBatch();
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}