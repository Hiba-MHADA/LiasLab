package dao;

import model.Evenement;
import model.Membre;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvenementDAO {

    // Tous les événements actifs
    public List<Evenement> getAllEvenements() {
        List<Evenement> list = new ArrayList<>();
        String sql = "SELECT * FROM evenement WHERE actif = true ORDER BY date_debut DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Récupérer par année (basé sur la date de début)
    public List<Evenement> getByAnnee(int annee) {
        List<Evenement> list = new ArrayList<>();
        String sql = "SELECT * FROM evenement WHERE actif = true AND YEAR(date_debut) = ? ORDER BY date_debut DESC";
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

    // Ajouter
    public boolean add(Evenement e) {
        String sql = "INSERT INTO evenement (titre, type, date_debut, date_fin, lieu, description, edition) VALUES (?,?,?,?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getType());
            ps.setDate(3, e.getDateDebut() != null ? new java.sql.Date(e.getDateDebut().getTime()) : null);
            ps.setDate(4, e.getDateFin() != null ? new java.sql.Date(e.getDateFin().getTime()) : null);
            ps.setString(5, e.getLieu());
            ps.setString(6, e.getDescription());
            ps.setInt(7, e.getEdition());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException ex) { ex.printStackTrace(); return false; }
    }

    // Modifier
    public boolean update(Evenement e) {
        String sql = "UPDATE evenement SET titre=?, type=?, date_debut=?, date_fin=?, lieu=?, description=?, edition=? WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getType());
            ps.setDate(3, e.getDateDebut() != null ? new java.sql.Date(e.getDateDebut().getTime()) : null);
            ps.setDate(4, e.getDateFin() != null ? new java.sql.Date(e.getDateFin().getTime()) : null);
            ps.setString(5, e.getLieu());
            ps.setString(6, e.getDescription());
            ps.setInt(7, e.getEdition());
            ps.setInt(8, e.getId());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException ex) { ex.printStackTrace(); return false; }
    }

    // Désactiver (jamais supprimer)
    public boolean delete(int id) {
        String sql = "UPDATE evenement SET actif = false WHERE id=?";
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
    public Evenement getById(int id) {
        String sql = "SELECT * FROM evenement WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { Evenement e = map(rs); conn.close(); return e; }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Compter total
    public int count() {
        String sql = "SELECT COUNT(*) FROM evenement";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int c = rs.getInt(1); conn.close(); return c; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // --- §9 : Affectation d'organisateurs ---

    // Ajouter un organisateur à un événement
    public boolean ajouterOrganisateur(int evenementId, int membreId) {
        String sql = "INSERT INTO organisateur_evenement (evenement_id, membre_id) VALUES (?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, evenementId);
            ps.setInt(2, membreId);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) {
            // Si déjà organisateur (contrainte UNIQUE), ne pas planter
            return false;
        }
    }

    // Retirer un organisateur
    public boolean retirerOrganisateur(int evenementId, int membreId) {
        String sql = "DELETE FROM organisateur_evenement WHERE evenement_id=? AND membre_id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, evenementId);
            ps.setInt(2, membreId);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Liste des organisateurs d'un événement
    public List<Membre> getOrganisateurs(int evenementId) {
        List<Membre> list = new ArrayList<>();
        String sql = "SELECT m.* FROM membre m " +
                     "JOIN organisateur_evenement oe ON m.id = oe.membre_id " +
                     "WHERE oe.evenement_id = ? ORDER BY m.nom, m.prenom";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, evenementId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Membre m = new Membre();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setPrenom(rs.getString("prenom"));
                list.add(m);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Membres actifs qui ne sont pas encore organisateurs de cet événement
    public List<Membre> getMembresNonOrganisateurs(int evenementId) {
        List<Membre> list = new ArrayList<>();
        String sql = "SELECT * FROM membre WHERE actif = true AND id NOT IN " +
                     "(SELECT membre_id FROM organisateur_evenement WHERE evenement_id = ?) " +
                     "ORDER BY nom, prenom";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, evenementId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Membre m = new Membre();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setPrenom(rs.getString("prenom"));
                list.add(m);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Mapper
    private Evenement map(ResultSet rs) throws SQLException {
        Evenement e = new Evenement();
        e.setId(rs.getInt("id"));
        e.setTitre(rs.getString("titre"));
        e.setType(rs.getString("type"));
        e.setDateDebut(rs.getDate("date_debut"));
        e.setDateFin(rs.getDate("date_fin"));
        e.setLieu(rs.getString("lieu"));
        e.setDescription(rs.getString("description"));
        e.setEdition(rs.getInt("edition"));
        return e;
    }
}