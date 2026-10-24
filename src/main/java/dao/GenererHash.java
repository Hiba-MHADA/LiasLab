package dao;

import org.mindrot.jbcrypt.BCrypt;

public class GenererHash {
    public static void main(String[] args) {
        String motDePasse = "test1234"; // <- change ce mot de passe si tu veux
        String hash = BCrypt.hashpw(motDePasse, BCrypt.gensalt());
        System.out.println("Mot de passe : " + motDePasse);
        System.out.println("Hash à coller en base : " + hash);
    }
}