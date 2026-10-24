package model;

import java.util.Date;

public class DemandeAdhesion {
    private int id;
    private String nom;
    private String prenom;
    private String email;
    private String motivation;
    private String cvPath;
    private String statut;
    private Date dateSoumission;

    public DemandeAdhesion() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotivation() { return motivation; }
    public void setMotivation(String motivation) { this.motivation = motivation; }

    public String getCvPath() { return cvPath; }
    public void setCvPath(String cvPath) { this.cvPath = cvPath; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Date getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(Date dateSoumission) { this.dateSoumission = dateSoumission; }
}