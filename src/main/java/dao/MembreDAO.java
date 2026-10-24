package dao;

import model.Membre;
import util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MembreDAO {

    // Login
    public Membre login(String email, String motDePasse) {
        Membre membre = null;
        String sql = "SELECT * FROM membre WHERE email = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashEnBase = rs.getString("mot_de_passe");
                if (hashEnBase != null && BCrypt.checkpw(motDePasse, hashEnBase)) {
                    membre = mapMembre(rs);
                }
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return membre;
    }

    // Liste tous les membres
    public List<Membre> getAllMembres() {
        List<Membre> list = new ArrayList<>();
        String sql = "SELECT * FROM membre ORDER BY nom, prenom";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapMembre(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Ajouter un membre — retourne l'ID généré (ou -1 si échec)
    public int addMembre(Membre m) {
        String sql = "INSERT INTO membre (nom, prenom, email, mot_de_passe, statut, etablissement, laboratoire_origine, biographie, actif, date_affiliation) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, m.getNom());
            ps.setString(2, m.getPrenom());
            ps.setString(3, m.getEmail());
            ps.setString(4, BCrypt.hashpw(m.getMotDePasse(), BCrypt.gensalt()));
            ps.setString(5, m.getStatut());
            ps.setString(6, m.getEtablissement());
            ps.setString(7, m.getLaboratoireOrigine());
            ps.setString(8, m.getBiographie());
            ps.setBoolean(9, true);
            ps.setDate(10, m.getDateAffiliation() != null ? new java.sql.Date(m.getDateAffiliation().getTime()) : null);
            int rows = ps.executeUpdate();
            int generatedId = -1;
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) generatedId = rs.getInt(1);
            }
            conn.close();
            return generatedId;
        } catch (SQLException e) { e.printStackTrace(); return -1; }
    }

    // Modifier un membre
    public boolean updateMembre(Membre m) {
    	String sql = "UPDATE membre SET nom=?, prenom=?, email=?, statut=?, etablissement=?, laboratoire_origine=?, biographie=?, centres_interet=? WHERE id=?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, m.getNom());
            ps.setString(2, m.getPrenom());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getStatut());
            ps.setString(5, m.getEtablissement());
            ps.setString(6, m.getLaboratoireOrigine());
            ps.setString(7, m.getBiographie());
            ps.setString(8, m.getCentresInteret());
            ps.setInt(9, m.getId());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Désactiver un membre (jamais supprimer)
    public boolean desactiverMembre(int id) {
        String sql = "UPDATE membre SET actif = false WHERE id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Réactiver un membre
    public boolean reactiverMembre(int id) {
        String sql = "UPDATE membre SET actif = true WHERE id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Trouver par ID
    public Membre getMembreById(int id) {
        Membre membre = null;
        String sql = "SELECT * FROM membre WHERE id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) membre = mapMembre(rs);
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return membre;
    }

    // Compter membres actifs
    public int countMembresActifs() {
        String sql = "SELECT COUNT(*) FROM membre WHERE actif = true";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int count = rs.getInt(1); conn.close(); return count; }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Mapper ResultSet → Membre
    private Membre mapMembre(ResultSet rs) throws SQLException {
        Membre m = new Membre();
        m.setId(rs.getInt("id"));
        m.setNom(rs.getString("nom"));
        m.setPrenom(rs.getString("prenom"));
        m.setEmail(rs.getString("email"));
        m.setMotDePasse(rs.getString("mot_de_passe"));
        m.setStatut(rs.getString("statut"));
        m.setEtablissement(rs.getString("etablissement"));
        m.setLaboratoireOrigine(rs.getString("laboratoire_origine"));
        m.setBiographie(rs.getString("biographie"));
        m.setActif(rs.getBoolean("actif"));
        m.setRole(rs.getString("role"));
        m.setDateAffiliation(rs.getDate("date_affiliation"));
        m.setCentresInteret(rs.getString("centres_interet"));
        return m;
    }

    public boolean changerMotDePasse(int id, String ancienMdp, String nouveauMdp) {
        String sqlSelect = "SELECT mot_de_passe FROM membre WHERE id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement psSelect = conn.prepareStatement(sqlSelect);
            psSelect.setInt(1, id);
            ResultSet rs = psSelect.executeQuery();

            if (rs.next()) {
                String hashActuel = rs.getString("mot_de_passe");
                if (hashActuel != null && BCrypt.checkpw(ancienMdp, hashActuel)) {
                    String sqlUpdate = "UPDATE membre SET mot_de_passe = ? WHERE id = ?";
                    PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                    psUpdate.setString(1, BCrypt.hashpw(nouveauMdp, BCrypt.gensalt()));
                    psUpdate.setInt(2, id);
                    int rows = psUpdate.executeUpdate();
                    conn.close();
                    return rows > 0;
                }
            }
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}