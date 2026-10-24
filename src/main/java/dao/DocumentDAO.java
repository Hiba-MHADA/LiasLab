package dao;
import model.Document;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class DocumentDAO {
    // Tous les documents actifs
    public List<Document> getAllDocuments() {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, e.titre as nom_evenement, c.partenaire as nom_convention FROM document d " +
                     "LEFT JOIN evenement e ON d.evenement_id = e.id " +
                     "LEFT JOIN convention c ON d.convention_id = c.id " +
                     "WHERE d.actif = true " +
                     "ORDER BY d.date_upload DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // Récupérer par année d'upload
    public List<Document> getByAnnee(int annee) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, e.titre as nom_evenement, c.partenaire as nom_convention FROM document d " +
                     "LEFT JOIN evenement e ON d.evenement_id = e.id " +
                     "LEFT JOIN convention c ON d.convention_id = c.id " +
                     "WHERE d.actif = true AND YEAR(d.date_upload) = ? " +
                     "ORDER BY d.date_upload DESC";
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
    // Récupérer les documents liés à une convention (§16)
    public List<Document> getByConvention(int conventionId) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, e.titre as nom_evenement, c.partenaire as nom_convention FROM document d " +
                     "LEFT JOIN evenement e ON d.evenement_id = e.id " +
                     "LEFT JOIN convention c ON d.convention_id = c.id " +
                     "WHERE d.actif = true AND d.convention_id = ? " +
                     "ORDER BY d.date_upload DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, conventionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // Ajouter
    public boolean add(Document d) {
        String sql = "INSERT INTO document (nom, type, chemin, evenement_id, convention_id, date_upload) VALUES (?,?,?,?,?,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, d.getNom());
            ps.setString(2, d.getType());
            ps.setString(3, d.getChemin());
            if (d.getEvenementId() > 0) ps.setInt(4, d.getEvenementId());
            else ps.setNull(4, Types.INTEGER);
            if (d.getConventionId() > 0) ps.setInt(5, d.getConventionId());
            else ps.setNull(5, Types.INTEGER);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    // Désactiver (historisation)
    public boolean delete(int id) {
        String sql = "UPDATE document SET actif = false WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    // Compter total
    public int count() {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM document");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int c = rs.getInt(1); conn.close(); return c; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
    // Mapper
    private Document map(ResultSet rs) throws SQLException {
        Document d = new Document();
        d.setId(rs.getInt("id"));
        d.setNom(rs.getString("nom"));
        d.setType(rs.getString("type"));
        d.setChemin(rs.getString("chemin"));
        d.setEvenementId(rs.getInt("evenement_id"));
        d.setConventionId(rs.getInt("convention_id"));
        d.setDateUpload(rs.getTimestamp("date_upload"));
        d.setNomEvenement(rs.getString("nom_evenement"));
        d.setNomConvention(rs.getString("nom_convention"));
        return d;
    }
}