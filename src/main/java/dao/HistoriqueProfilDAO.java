package dao;

import model.HistoriqueProfil;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoriqueProfilDAO {

    // Enregistrer un changement
    public boolean enregistrer(int membreId, String champ, String ancienneValeur, String nouvelleValeur) {
        // Ne rien enregistrer si rien n'a changé
        if (ancienneValeur == null) ancienneValeur = "";
        if (nouvelleValeur == null) nouvelleValeur = "";
        if (ancienneValeur.equals(nouvelleValeur)) return true;

        String sql = "INSERT INTO historique_profil (membre_id, champ_modifie, ancienne_valeur, nouvelle_valeur, date_modification) VALUES (?,?,?,?,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ps.setString(2, champ);
            ps.setString(3, ancienneValeur);
            ps.setString(4, nouvelleValeur);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Historique complet d'un membre
    public List<HistoriqueProfil> getByMembre(int membreId) {
        List<HistoriqueProfil> list = new ArrayList<>();
        String sql = "SELECT * FROM historique_profil WHERE membre_id=? ORDER BY date_modification DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HistoriqueProfil h = new HistoriqueProfil();
                h.setId(rs.getInt("id"));
                h.setMembreId(rs.getInt("membre_id"));
                h.setChampModifie(rs.getString("champ_modifie"));
                h.setAncienneValeur(rs.getString("ancienne_valeur"));
                h.setNouvelleValeur(rs.getString("nouvelle_valeur"));
                h.setDateModification(rs.getTimestamp("date_modification"));
                list.add(h);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}