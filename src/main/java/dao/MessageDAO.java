package dao;

import model.Message;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public List<Message> getMessagesRecus(int membreId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT msg.*, " +
                     "e.nom as nom_exp, e.prenom as prenom_exp, " +
                     "d.nom as nom_dest, d.prenom as prenom_dest " +
                     "FROM message msg " +
                     "JOIN membre e ON msg.expediteur_id = e.id " +
                     "LEFT JOIN membre d ON msg.destinataire_id = d.id " +
                     "WHERE msg.destinataire_id = ? OR msg.destinataire_id IS NULL " +
                     "ORDER BY msg.date_envoi DESC";
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

    public List<Message> getMessagesEnvoyes(int membreId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT msg.*, " +
                     "e.nom as nom_exp, e.prenom as prenom_exp, " +
                     "d.nom as nom_dest, d.prenom as prenom_dest " +
                     "FROM message msg " +
                     "JOIN membre e ON msg.expediteur_id = e.id " +
                     "LEFT JOIN membre d ON msg.destinataire_id = d.id " +
                     "WHERE msg.expediteur_id = ? " +
                     "ORDER BY msg.date_envoi DESC";
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

    public boolean envoyer(Message m) {
        String sql = "INSERT INTO message (expediteur_id, destinataire_id, equipe_id, evenement_id, contenu, date_envoi) VALUES (?,?,?,?,?,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, m.getExpediteurId());
            if (m.getDestinataireId() > 0) ps.setInt(2, m.getDestinataireId());
            else ps.setNull(2, Types.INTEGER);
            if (m.getEquipeId() > 0) ps.setInt(3, m.getEquipeId());
            else ps.setNull(3, Types.INTEGER);
            if (m.getEvenementId() > 0) ps.setInt(4, m.getEvenementId());
            else ps.setNull(4, Types.INTEGER);
            ps.setString(5, m.getContenu());
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Message map(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getInt("id"));
        m.setExpediteurId(rs.getInt("expediteur_id"));
        m.setDestinataireId(rs.getInt("destinataire_id"));
        m.setContenu(rs.getString("contenu"));
        m.setDateEnvoi(rs.getTimestamp("date_envoi"));
        m.setNomExpediteur(rs.getString("nom_exp"));
        m.setPrenomExpediteur(rs.getString("prenom_exp"));
        m.setNomDestinataire(rs.getString("nom_dest"));
        m.setPrenomDestinataire(rs.getString("prenom_dest"));
        return m;
    }
}