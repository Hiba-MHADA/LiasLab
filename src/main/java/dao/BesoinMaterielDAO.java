package dao;

import model.BesoinMateriel;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BesoinMaterielDAO {

    // Soumettre une demande (§15)
    public boolean soumettre(int membreId, String designation, String justification) {
        String sql = "INSERT INTO besoin_materiel (membre_id, designation, justification, statut, date_demande) VALUES (?,?,?,'en_attente',NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ps.setString(2, designation);
            ps.setString(3, justification);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Toutes les demandes (pour la direction)
    public List<BesoinMateriel> getAll() {
        List<BesoinMateriel> list = new ArrayList<>();
        String sql = "SELECT b.*, m.nom AS nom_membre, m.prenom AS prenom_membre " +
                     "FROM besoin_materiel b " +
                     "JOIN membre m ON b.membre_id = m.id " +
                     "ORDER BY b.date_demande DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Demandes d'un membre donné
    public List<BesoinMateriel> getByMembre(int membreId) {
        List<BesoinMateriel> list = new ArrayList<>();
        String sql = "SELECT b.*, m.nom AS nom_membre, m.prenom AS prenom_membre " +
                     "FROM besoin_materiel b " +
                     "JOIN membre m ON b.membre_id = m.id " +
                     "WHERE b.membre_id = ? ORDER BY b.date_demande DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Validation par la direction (§15)
    public boolean valider(int id) {
        return changerStatut(id, "validee");
    }

    public boolean refuser(int id) {
        return changerStatut(id, "refusee");
    }

    private boolean changerStatut(int id, String statut) {
        String sql = "UPDATE besoin_materiel SET statut=?, date_traitement=NOW() WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, statut);
            ps.setInt(2, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private BesoinMateriel map(ResultSet rs) throws SQLException {
        BesoinMateriel b = new BesoinMateriel();
        b.setId(rs.getInt("id"));
        b.setMembreId(rs.getInt("membre_id"));
        b.setDesignation(rs.getString("designation"));
        b.setJustification(rs.getString("justification"));
        b.setStatut(rs.getString("statut"));
        b.setDateDemande(rs.getTimestamp("date_demande"));
        b.setDateTraitement(rs.getTimestamp("date_traitement"));
        b.setNomMembre(rs.getString("nom_membre"));
        b.setPrenomMembre(rs.getString("prenom_membre"));
        return b;
    }
}