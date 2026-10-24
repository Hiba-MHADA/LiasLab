package util;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
public class EmailUtil {
    private static final String FROM     = "hibamhada@gmail.com";
    private static final String PASSWORD = "jwrikxoukgqxfasu";
    public static boolean sendCredentials(String toEmail, String nom, 
                                          String prenom, String motDePasse) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM, PASSWORD);
                }
            });
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM));
            message.setRecipients(Message.RecipientType.TO, 
                                  InternetAddress.parse(toEmail));
            message.setSubject("Bienvenue au LIAS Lab — Vos identifiants");
            String body =
                "Bonjour " + prenom + " " + nom + ",\n\n" +
                "Votre demande d'adhésion au laboratoire LIAS a été acceptée !\n\n" +
                "Vos identifiants de connexion :\n" +
                "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
                "🌐 Lien    : http://localhost:8080/LiasLab/login\n" +
                "📧 Email   : " + toEmail + "\n" +
                "🔑 Mot de passe : " + motDePasse + "\n" +
                "━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n" +
                "⚠️ Changez votre mot de passe après la première connexion.\n\n" +
                "Bienvenue dans l'équipe !\n" +
                "LIAS Lab — Faculté des Sciences Ben M'Sik";
            message.setText(body);
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendRefus(String toEmail, String nom, String prenom) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM, PASSWORD);
                }
            });
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM));
            message.setRecipients(Message.RecipientType.TO,
                                  InternetAddress.parse(toEmail));
            message.setSubject("LIAS Lab — Réponse à votre demande d'adhésion");
            String body =
                "Bonjour " + prenom + " " + nom + ",\n\n" +
                "Nous vous remercions pour l'intérêt que vous portez au laboratoire LIAS.\n\n" +
                "Après étude de votre dossier, nous ne sommes malheureusement pas en mesure " +
                "de donner une suite favorable à votre demande d'adhésion pour le moment.\n\n" +
                "Nous vous encourageons à suivre nos actualités et à renouveler votre candidature " +
                "ultérieurement si vous le souhaitez.\n\n" +
                "Cordialement,\n" +
                "LIAS Lab — Faculté des Sciences Ben M'Sik";
            message.setText(body);
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}