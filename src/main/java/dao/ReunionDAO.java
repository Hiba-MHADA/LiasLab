package dao;

import model.Reunion;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReunionDAO {

    // Toutes les réunions actives
    public List<Reunion> getAll() {
        List<Reunion> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM reunion WHERE actif = true ORDER BY date_reunion DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reunion r = new Reunion();
                r.setId(rs.getInt("id"));
                r.setTitre(rs.getString("titre"));
                r.setDateReunion(rs.getDate("date_reunion"));
                r.setOrdreJour(rs.getString("ordre_du_jour"));
                r.setPvPath(rs.getString("pv_path"));
                list.add(r);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Récupérer par année
    public List<Reunion> getByAnnee(int annee) {
        List<Reunion> list = new ArrayList<>();
        String sql = "SELECT * FROM reunion WHERE actif = true AND YEAR(date_reunion) = ? ORDER BY date_reunion DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, annee);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reunion r = new Reunion();
                r.setId(rs.getInt("id"));
                r.setTitre(rs.getString("titre"));
                r.setDateReunion(rs.getDate("date_reunion"));
                r.setOrdreJour(rs.getString("ordre_du_jour"));
                r.setPvPath(rs.getString("pv_path"));
                list.add(r);
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Ajouter une réunion
    public boolean add(Reunion r) {
        String sql = "INSERT INTO reunion (titre, date_reunion, ordre_du_jour, pv_path) VALUES (?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, r.getTitre());
            ps.setDate(2, r.getDateReunion() != null ? new java.sql.Date(r.getDateReunion().getTime()) : null);
            ps.setString(3, r.getOrdreJour());
            ps.setString(4, r.getPvPath());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Désactiver (suppression logique pour historisation)
    public boolean delete(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE reunion SET actif = false WHERE id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}