package dao;

import model.Materiel;
import model.Attribution;
import model.Membre;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterielDAO {

    // Liste tout le matériel
    public List<Materiel> getAll() {
        List<Materiel> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM materiel ORDER BY date_arrivee DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Materiel m = new Materiel();
                m.setId(rs.getInt("id"));
                m.setDesignation(rs.getString("designation"));
                m.setDateArrivee(rs.getDate("date_arrivee"));
                m.setQuantite(rs.getInt("quantite"));
                m.setQuantiteDisponible(rs.getInt("quantite_disponible"));
                list.add(m);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Ajouter matériel
    public boolean add(Materiel m) {
        String sql = "INSERT INTO materiel (designation, date_arrivee, quantite, quantite_disponible) VALUES (?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, m.getDesignation());
            ps.setDate(2, m.getDateArrivee() != null ? new java.sql.Date(m.getDateArrivee().getTime()) : null);
            ps.setInt(3, m.getQuantite());
            ps.setInt(4, m.getQuantite()); // disponible = total au départ
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Supprimer matériel
    public boolean delete(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM materiel WHERE id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean attribuer(int materielId, int membreId, int quantite, java.util.Date dateRetourPrevue) {
        try {
            Connection conn = DBConnection.getConnection();

            // Vérifier disponibilité
            PreparedStatement check = conn.prepareStatement(
                "SELECT quantite_disponible FROM materiel WHERE id=?");
            check.setInt(1, materielId);
            ResultSet rs = check.executeQuery();

            if (rs.next() && rs.getInt("quantite_disponible") >= quantite) {

                // Créer attribution avec date Java au lieu de CURDATE()
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO attribution_materiel " +
                    "(materiel_id, membre_id, quantite, date_attribution, date_retour_prevue, statut) " +
                    "VALUES (?, ?, ?, ?, ?, 'attribue')");
                ps.setInt(1, materielId);
                ps.setInt(2, membreId);
                ps.setInt(3, quantite);
                ps.setDate(4, new java.sql.Date(new java.util.Date().getTime()));
                if (dateRetourPrevue != null)
                    ps.setDate(5, new java.sql.Date(dateRetourPrevue.getTime()));
                else
                    ps.setNull(5, java.sql.Types.DATE);
                ps.executeUpdate();

                // Mettre à jour quantité disponible
                PreparedStatement upd = conn.prepareStatement(
                    "UPDATE materiel SET quantite_disponible = quantite_disponible - ? WHERE id=?");
                upd.setInt(1, quantite);
                upd.setInt(2, materielId);
                upd.executeUpdate();

                conn.close();
                return true;
            }
            conn.close();
            return false;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Retourner matériel
    public boolean retourner(int attributionId) {
        try {
            Connection conn = DBConnection.getConnection();

            // Récupérer quantite et materiel_id
            PreparedStatement get = conn.prepareStatement(
                "SELECT materiel_id, quantite FROM attribution_materiel WHERE id=?");
            get.setInt(1, attributionId);
            ResultSet rs = get.executeQuery();
            if (rs.next()) {
                int materielId = rs.getInt("materiel_id");
                int quantite   = rs.getInt("quantite");

                // Marquer comme retourné
                PreparedStatement upd = conn.prepareStatement(
                    "UPDATE attribution_materiel SET statut='retourne', date_retour_effective=CURDATE() WHERE id=?");
                upd.setInt(1, attributionId);
                upd.executeUpdate();

                // Remettre disponible
                PreparedStatement updM = conn.prepareStatement(
                    "UPDATE materiel SET quantite_disponible = quantite_disponible + ? WHERE id=?");
                updM.setInt(1, quantite);
                updM.setInt(2, materielId);
                updM.executeUpdate();

                conn.close();
                return true;
            }
            conn.close();
            return false;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Historique des attributions
    public List<Attribution> getHistorique() {
        List<Attribution> list = new ArrayList<>();
        String sql = "SELECT a.*, m.designation as nom_materiel, mb.nom as nom_membre, mb.prenom as prenom_membre " +
                     "FROM attribution_materiel a " +
                     "JOIN materiel m ON a.materiel_id = m.id " +
                     "JOIN membre mb ON a.membre_id = mb.id " +
                     "ORDER BY a.date_attribution DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attribution a = new Attribution();
                a.setId(rs.getInt("id"));
                a.setMaterielId(rs.getInt("materiel_id"));
                a.setMembreId(rs.getInt("membre_id"));
                a.setQuantite(rs.getInt("quantite"));
                a.setDateAttribution(rs.getDate("date_attribution"));
                a.setDateRetourPrevue(rs.getDate("date_retour_prevue"));
                a.setDateRetourEffective(rs.getDate("date_retour_effective"));
                a.setStatut(rs.getString("statut"));
                a.setNomMateriel(rs.getString("nom_materiel"));
                a.setNomMembre(rs.getString("nom_membre"));
                a.setPrenomMembre(rs.getString("prenom_membre"));
                list.add(a);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Membres actifs pour formulaire
    public List<Membre> getMembresActifs() {
        List<Membre> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM membre WHERE actif=true ORDER BY nom, prenom");
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
}