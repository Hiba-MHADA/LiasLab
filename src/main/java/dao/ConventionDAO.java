package dao;
import model.Convention;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class ConventionDAO {
	public List<Convention> getAll() {
	    List<Convention> list = new ArrayList<>();
	    try {
	        Connection conn = DBConnection.getConnection();
	        PreparedStatement ps = conn.prepareStatement("SELECT * FROM convention WHERE actif = true ORDER BY date_debut DESC");
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Convention c = new Convention();
	            c.setId(rs.getInt("id"));
	            c.setPartenaire(rs.getString("partenaire"));
	            c.setDateDebut(rs.getDate("date_debut"));
	            c.setDateFin(rs.getDate("date_fin"));
	            c.setDescription(rs.getString("description"));
	            list.add(c);
	        }
	        conn.close();
	    } catch (SQLException e) { e.printStackTrace(); }
	    return list;
	}
    public Convention getById(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM convention WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Convention c = new Convention();
                c.setId(rs.getInt("id"));
                c.setPartenaire(rs.getString("partenaire"));
                c.setDateDebut(rs.getDate("date_debut"));
                c.setDateFin(rs.getDate("date_fin"));
                c.setDescription(rs.getString("description"));
                conn.close();
                return c;
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    public boolean add(Convention c) {
        String sql = "INSERT INTO convention (partenaire, date_debut, date_fin, description) VALUES (?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getPartenaire());
            ps.setDate(2, c.getDateDebut() != null ? new java.sql.Date(c.getDateDebut().getTime()) : null);
            ps.setDate(3, c.getDateFin() != null ? new java.sql.Date(c.getDateFin().getTime()) : null);
            ps.setString(4, c.getDescription());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    public boolean delete(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE convention SET actif = false WHERE id=?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}