package dao;

import model.DemandeAdhesion;
import util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdhesionDAO {

    // Soumettre une demande
    public boolean soumettre(DemandeAdhesion d) {
        String sql = "INSERT INTO demande_adhesion (nom, prenom, email, motivation, cv_path, statut, date_soumission) VALUES (?,?,?,?,?,?,NOW())";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, d.getNom());
            ps.setString(2, d.getPrenom());
            ps.setString(3, d.getEmail());
            ps.setString(4, d.getMotivation());
            ps.setString(5, d.getCvPath());
            ps.setString(6, "en_attente");
            int rows = ps.executeUpdate();

            conn.close();

            // Notifier admin/directeur qu'une nouvelle demande est arrivée
            if (rows > 0) {
                new NotificationDAO().notifierParRole(
                    "Nouvelle demande d'adhésion de " + d.getPrenom() + " " + d.getNom(),
                    "admin", "directeur"
                );
            }

            return rows > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Liste toutes les demandes
    public List<DemandeAdhesion> getAllDemandes() {
        List<DemandeAdhesion> list = new ArrayList<>();
        String sql = "SELECT * FROM demande_adhesion ORDER BY date_soumission DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapDemande(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Demandes en attente
    public List<DemandeAdhesion> getDemandesEnAttente() {
        List<DemandeAdhesion> list = new ArrayList<>();
        String sql = "SELECT * FROM demande_adhesion WHERE statut='en_attente' ORDER BY date_soumission DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapDemande(rs));
            conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Compter demandes en attente
    public int countEnAttente() {
        String sql = "SELECT COUNT(*) FROM demande_adhesion WHERE statut='en_attente'";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { int c = rs.getInt(1); conn.close(); return c; }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Accepter → crée un compte membre avec mot de passe aléatoire et envoi d'email
    public boolean accepter(int id) {
        try {
            Connection conn = DBConnection.getConnection();

            // 1. Récupérer les informations de la demande
            PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM demande_adhesion WHERE id=?");
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                String nom    = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String email  = rs.getString("email");

                // --- DÉBUT DE LA MISE À JOUR ---
                
                // Générer mot de passe aléatoire (en clair, pour l'envoyer par email)
                String motDePasse = "LIAS" + (int)(Math.random() * 9000 + 1000);

                // Créer le compte membre — on stocke le HASH, pas le mot de passe en clair
                PreparedStatement ps2 = conn.prepareStatement(
                    "INSERT INTO membre (nom, prenom, email, mot_de_passe, statut, role, actif) VALUES (?,?,?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
                ps2.setString(1, nom);
                ps2.setString(2, prenom);
                ps2.setString(3, email);
                ps2.setString(4, BCrypt.hashpw(motDePasse, BCrypt.gensalt()));
                ps2.setString(5, "permanent");
                ps2.setString(6, "membre");
                ps2.setBoolean(7, true);
                ps2.executeUpdate();

                // Récupérer l'id du membre nouvellement créé pour la notification interne
                ResultSet rsGen = ps2.getGeneratedKeys();
                int nouvelId = -1;
                if (rsGen.next()) nouvelId = rsGen.getInt(1);

                // Mettre à jour statut demande
                PreparedStatement ps3 = conn.prepareStatement(
                    "UPDATE demande_adhesion SET statut='acceptee' WHERE id=?");
                ps3.setInt(1, id);
                ps3.executeUpdate();

                // Envoyer email avec le mot de passe EN CLAIR (c'est normal, l'utilisateur doit le connaître)
                util.EmailUtil.sendCredentials(email, nom, prenom, motDePasse);

                // Notification interne de bienvenue pour le nouveau membre
                if (nouvelId > 0) {
                    new NotificationDAO().add(nouvelId, "Bienvenue au LIAS ! Votre demande d'adhésion a été acceptée.");
                }

                // --- FIN DE LA MISE À JOUR ---

                conn.close();
                return true;
            }
            conn.close();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // Refuser
    public boolean refuser(int id) {
        try {
            Connection conn = DBConnection.getConnection();

            // 1. Récupérer les informations de la demande avant de la modifier
            PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM demande_adhesion WHERE id=?");
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                String nom    = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String email  = rs.getString("email");

                // Mettre à jour le statut
                PreparedStatement ps2 = conn.prepareStatement(
                    "UPDATE demande_adhesion SET statut='refusee' WHERE id=?");
                ps2.setInt(1, id);
                ps2.executeUpdate();

                // Notifier le candidat par email
                util.EmailUtil.sendRefus(email, nom, prenom);

                conn.close();
                return true;
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Mapper
    private DemandeAdhesion mapDemande(ResultSet rs) throws SQLException {
        DemandeAdhesion d = new DemandeAdhesion();
        d.setId(rs.getInt("id"));
        d.setNom(rs.getString("nom"));
        d.setPrenom(rs.getString("prenom"));
        d.setEmail(rs.getString("email"));
        d.setMotivation(rs.getString("motivation"));
        d.setCvPath(rs.getString("cv_path"));
        d.setStatut(rs.getString("statut"));
        d.setDateSoumission(rs.getTimestamp("date_soumission"));
        return d;
    }
}