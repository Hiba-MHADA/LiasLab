package dao;

import model.Membre;
import model.Document;
import model.Evenement;
import model.Publication;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RechercheDAO {

    public List<Membre> rechercherMembres(String terme) {
        List<Membre> list = new ArrayList<>();
        String sql = "SELECT * FROM membre WHERE actif = true AND " +
                     "(nom LIKE ? OR prenom LIKE ? OR email LIKE ?) ORDER BY nom";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            String like = "%" + terme + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Membre m = new Membre();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setPrenom(rs.getString("prenom"));
                m.setEmail(rs.getString("email"));
                m.setStatut(rs.getString("statut"));
                list.add(m);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Document> rechercherDocuments(String terme) {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT d.*, e.titre as nom_evenement FROM document d " +
                     "LEFT JOIN evenement e ON d.evenement_id = e.id " +
                     "WHERE d.actif = true AND (d.nom LIKE ? OR d.type LIKE ?) " +
                     "ORDER BY d.date_upload DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            String like = "%" + terme + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Document d = new Document();
                d.setId(rs.getInt("id"));
                d.setNom(rs.getString("nom"));
                d.setType(rs.getString("type"));
                d.setChemin(rs.getString("chemin"));
                d.setDateUpload(rs.getTimestamp("date_upload"));
                d.setNomEvenement(rs.getString("nom_evenement"));
                list.add(d);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Evenement> rechercherEvenements(String terme) {
        List<Evenement> list = new ArrayList<>();
        String sql = "SELECT * FROM evenement WHERE actif = true AND " +
                     "(titre LIKE ? OR type LIKE ? OR lieu LIKE ?) ORDER BY date_debut DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            String like = "%" + terme + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Evenement e = new Evenement();
                e.setId(rs.getInt("id"));
                e.setTitre(rs.getString("titre"));
                e.setType(rs.getString("type"));
                e.setDateDebut(rs.getDate("date_debut"));
                e.setDateFin(rs.getDate("date_fin"));
                e.setLieu(rs.getString("lieu"));
                e.setDescription(rs.getString("description"));
                list.add(e);
            }
            conn.close();
        } catch (SQLException ex) { ex.printStackTrace(); }
        return list;
    }

    public List<Publication> rechercherPublications(String terme) {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publication WHERE actif = true AND " +
                     "(titre LIKE ? OR auteurs LIKE ? OR revue LIKE ?) ORDER BY annee DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            String like = "%" + terme + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Publication p = new Publication();
                p.setId(rs.getInt("id"));
                p.setTitre(rs.getString("titre"));
                p.setAuteurs(rs.getString("auteurs"));
                p.setAnnee(rs.getInt("annee"));
                p.setRevue(rs.getString("revue"));
                p.setLien(rs.getString("lien"));
                list.add(p);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}