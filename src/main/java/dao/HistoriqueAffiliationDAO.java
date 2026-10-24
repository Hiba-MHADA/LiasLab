package dao;

import model.HistoriqueAffiliation;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoriqueAffiliationDAO {

    // Ouvrir une nouvelle période d'affiliation (premier arrivée, ou retour après un départ)
    public boolean ouvrirPeriode(int membreId, java.util.Date dateDebut) {
        String sql = "INSERT INTO historique_affiliation (membre_id, date_debut) VALUES (?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ps.setDate(2, new java.sql.Date(dateDebut.getTime()));
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Clôturer la période en cours (départ) — la dernière période sans date_fin
    public boolean cloturerPeriodeEnCours(int membreId, java.util.Date dateFin, String motif) {
        String sql = "UPDATE historique_affiliation SET date_fin = ?, motif = ? " +
                     "WHERE membre_id = ? AND date_fin IS NULL " +
                     "ORDER BY date_debut DESC LIMIT 1";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(dateFin.getTime()));
            ps.setString(2, motif);
            ps.setInt(3, membreId);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Vérifie si le membre a une période active (non clôturée)
    public boolean aPeriodeActive(int membreId) {
        String sql = "SELECT COUNT(*) FROM historique_affiliation WHERE membre_id = ? AND date_fin IS NULL";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { boolean has = rs.getInt(1) > 0; conn.close(); return has; }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Historique complet d'un membre (toutes ses périodes, triées les plus récentes en premier)
    public List<HistoriqueAffiliation> getByMembre(int membreId) {
        List<HistoriqueAffiliation> list = new ArrayList<>();
        String sql = "SELECT * FROM historique_affiliation WHERE membre_id = ? ORDER BY date_debut DESC";
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

    // Mapper
    private HistoriqueAffiliation map(ResultSet rs) throws SQLException {
        HistoriqueAffiliation h = new HistoriqueAffiliation();
        h.setId(rs.getInt("id"));
        h.setMembreId(rs.getInt("membre_id"));
        h.setDateDebut(rs.getDate("date_debut"));
        h.setDateFin(rs.getDate("date_fin"));
        h.setMotif(rs.getString("motif"));
        return h;
    }
}