package dao;

import model.Mandat;
import model.Membre;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MandatDAO {

	public List<Mandat> getAll() {
	    List<Mandat> list = new ArrayList<>();
	    String sql = "SELECT m.*, " +
	                 "d.nom as nom_dir, d.prenom as prenom_dir, " +
	                 "v.nom as nom_vd, v.prenom as prenom_vd " +
	                 "FROM mandat m " +
	                 "LEFT JOIN membre d ON m.directeur_id = d.id " +
	                 "LEFT JOIN membre v ON m.vice_directeur_id = v.id " +
	                 "WHERE m.actif = true " +
	                 "ORDER BY m.date_debut DESC";
	    try {
	        Connection conn = DBConnection.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) list.add(map(rs));
	        conn.close();
	    } catch (SQLException e) { e.printStackTrace(); }
	    return list;
	}

    public boolean add(Mandat m) {
        String sql = "INSERT INTO mandat (directeur_id, vice_directeur_id, date_debut, date_fin) VALUES (?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, m.getDirecteurId());
            if (m.getViceDirecteurId() > 0) ps.setInt(2, m.getViceDirecteurId());
            else ps.setNull(2, Types.INTEGER);
            ps.setDate(3, m.getDateDebut() != null ? new java.sql.Date(m.getDateDebut().getTime()) : null);
            ps.setDate(4, m.getDateFin() != null ? new java.sql.Date(m.getDateFin().getTime()) : null);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE mandat SET actif = false WHERE id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Membre> getMembresActifs() {
        List<Membre> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM membre WHERE actif=true AND statut='permanent' ORDER BY nom, prenom");
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

    private Mandat map(ResultSet rs) throws SQLException {
        Mandat m = new Mandat();
        m.setId(rs.getInt("id"));
        m.setDirecteurId(rs.getInt("directeur_id"));
        m.setViceDirecteurId(rs.getInt("vice_directeur_id"));
        m.setDateDebut(rs.getDate("date_debut"));
        m.setDateFin(rs.getDate("date_fin"));
        m.setNomDirecteur(rs.getString("nom_dir"));
        m.setPrenomDirecteur(rs.getString("prenom_dir"));
        m.setNomViceDirecteur(rs.getString("nom_vd"));
        m.setPrenomViceDirecteur(rs.getString("prenom_vd"));
        return m;
    }
}