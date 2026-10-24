package dao;

import model.Publication;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PublicationDAO {

    // Toutes les publications
    public List<Publication> getAllPublications() {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publication WHERE actif = true ORDER BY annee DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Récupérer par année
    public List<Publication> getByAnnee(int annee) {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publication WHERE actif = true AND annee = ? ORDER BY titre";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, annee);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Récupérer par équipe (§12)
    public List<Publication> getByEquipe(int equipeId) {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publication WHERE actif = true AND equipe_id = ? ORDER BY annee DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, equipeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Toutes les publications triées par équipe (§12)
    public List<Publication> getAllSortedByEquipe() {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publication WHERE actif = true ORDER BY equipe_id, annee DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Ajouter
    public boolean add(Publication p) {
        String sql = "INSERT INTO publication (titre, auteurs, annee, revue, lien, membre_id, equipe_id) VALUES (?,?,?,?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getTitre());
            ps.setString(2, p.getAuteurs());
            ps.setInt(3, p.getAnnee());
            ps.setString(4, p.getRevue());
            ps.setString(5, p.getLien());
            ps.setInt(6, p.getMembreId());
            ps.setInt(7, p.getEquipeId());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Modifier
    public boolean update(Publication p) {
        String sql = "UPDATE publication SET titre=?, auteurs=?, annee=?, revue=?, lien=?, equipe_id=? WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getTitre());
            ps.setString(2, p.getAuteurs());
            ps.setInt(3, p.getAnnee());
            ps.setString(4, p.getRevue());
            ps.setString(5, p.getLien());
            ps.setInt(6, p.getEquipeId());
            ps.setInt(7, p.getId());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Supprimer
    public boolean delete(int id) {
        String sql = "UPDATE publication SET actif = false WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Par ID
    public Publication getById(int id) {
        String sql = "SELECT * FROM publication WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { Publication p = map(rs); conn.close(); return p; }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Compter total
    public int count() {
        String sql = "SELECT COUNT(*) FROM publication";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int c = rs.getInt(1); conn.close(); return c; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Mapper
    private Publication map(ResultSet rs) throws SQLException {
        Publication p = new Publication();
        p.setId(rs.getInt("id"));
        p.setTitre(rs.getString("titre"));
        p.setAuteurs(rs.getString("auteurs"));
        p.setAnnee(rs.getInt("annee"));
        p.setRevue(rs.getString("revue"));
        p.setLien(rs.getString("lien"));
        p.setMembreId(rs.getInt("membre_id"));
        p.setEquipeId(rs.getInt("equipe_id"));
        return p;
    }
}