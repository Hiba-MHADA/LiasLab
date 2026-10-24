package dao;

import model.Equipe;
import model.RoleMembre;
import model.Membre;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EquipeDAO {

    // Toutes les équipes
	public List<Equipe> getAllEquipes() {
	    List<Equipe> list = new ArrayList<>();
	    String sql = "SELECT * FROM equipe WHERE actif = true ORDER BY nom";
	    try {
	        Connection conn = DBConnection.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Equipe e = new Equipe();
	            e.setId(rs.getInt("id"));
	            e.setNom(rs.getString("nom"));
	            e.setDescription(rs.getString("description"));
	            list.add(e);
	        }
	        conn.close();
	    } catch (SQLException e) { e.printStackTrace(); }
	    return list;
	}
    // Ajouter équipe
    public boolean addEquipe(Equipe e) {
        String sql = "INSERT INTO equipe (nom, description) VALUES (?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getNom());
            ps.setString(2, e.getDescription());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException ex) { ex.printStackTrace(); return false; }
    }

    // Modifier équipe
    public boolean updateEquipe(Equipe e) {
        String sql = "UPDATE equipe SET nom=?, description=? WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getNom());
            ps.setString(2, e.getDescription());
            ps.setInt(3, e.getId());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException ex) { ex.printStackTrace(); return false; }
    }

    // Supprimer équipe
    public boolean deleteEquipe(int id) {
        String sql = "UPDATE equipe SET actif = false WHERE id=?";
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
    public Equipe getEquipeById(int id) {
        String sql = "SELECT * FROM equipe WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Equipe e = new Equipe();
                e.setId(rs.getInt("id"));
                e.setNom(rs.getString("nom"));
                e.setDescription(rs.getString("description"));
                conn.close();
                return e;
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Membres d'une équipe avec rôles
    public List<RoleMembre> getMembresEquipe(int equipeId) {
        List<RoleMembre> list = new ArrayList<>();
        String sql = "SELECT rm.*, m.nom as nom_membre, m.prenom as prenom_membre " +
                     "FROM role_membre rm " +
                     "JOIN membre m ON rm.membre_id = m.id " +
                     "WHERE rm.equipe_id = ? AND rm.date_fin IS NULL " +
                     "ORDER BY rm.role";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, equipeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoleMembre r = new RoleMembre();
                r.setId(rs.getInt("id"));
                r.setMembreId(rs.getInt("membre_id"));
                r.setEquipeId(rs.getInt("equipe_id"));
                r.setRole(rs.getString("role"));
                r.setDateDebut(rs.getDate("date_debut"));
                r.setNomMembre(rs.getString("nom_membre"));
                r.setPrenomMembre(rs.getString("prenom_membre"));
                list.add(r);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Affecter membre à équipe
    public boolean affecterMembre(int membreId, int equipeId, String role) {
        // D'abord fermer le rôle actuel si existe
        String sqlClose = "UPDATE role_membre SET date_fin = CURDATE() " +
                          "WHERE membre_id=? AND equipe_id=? AND date_fin IS NULL";
        String sqlInsert = "INSERT INTO role_membre (membre_id, equipe_id, role, date_debut) " +
                           "VALUES (?,?,?,CURDATE())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps1 = conn.prepareStatement(sqlClose);
            ps1.setInt(1, membreId);
            ps1.setInt(2, equipeId);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(sqlInsert);
            ps2.setInt(1, membreId);
            ps2.setInt(2, equipeId);
            ps2.setString(3, role);
            int rows = ps2.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Retirer membre d'équipe
    public boolean retirerMembre(int roleMembreId) {
        String sql = "UPDATE role_membre SET date_fin = CURDATE() WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roleMembreId);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Tous les membres actifs (pour le formulaire d'affectation)
    public List<Membre> getMembresActifs() {
        List<Membre> list = new ArrayList<>();
        String sql = "SELECT * FROM membre WHERE actif=true ORDER BY nom, prenom";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Membre m = new Membre();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setPrenom(rs.getString("prenom"));
                m.setStatut(rs.getString("statut"));
                list.add(m);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}