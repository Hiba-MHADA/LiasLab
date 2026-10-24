package model;

import java.util.Date;

public class Membre {
    private int id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String statut; // permanent, associe, doctorant, retraite, ancien
    private String etablissement;
    private String laboratoireOrigine;
    private String biographie;
    private String photo;
    private Date dateNaissance;
    private Date dateEmbauche;
    private Date dateAffiliation;
    private boolean actif;
    private String role;
    private String centresInteret;

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // Constructeur vide
    public Membre() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getEtablissement() { return etablissement; }
    public void setEtablissement(String etablissement) { this.etablissement = etablissement; }

    public String getLaboratoireOrigine() { return laboratoireOrigine; }
    public void setLaboratoireOrigine(String laboratoireOrigine) { this.laboratoireOrigine = laboratoireOrigine; }

    public String getBiographie() { return biographie; }
    public void setBiographie(String biographie) { this.biographie = biographie; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public Date getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(Date dateNaissance) { this.dateNaissance = dateNaissance; }

    public Date getDateEmbauche() { return dateEmbauche; }
    public void setDateEmbauche(Date dateEmbauche) { this.dateEmbauche = dateEmbauche; }

    public Date getDateAffiliation() { return dateAffiliation; }
    public void setDateAffiliation(Date dateAffiliation) { this.dateAffiliation = dateAffiliation; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }
    
    public String getCentresInteret() { return centresInteret; }
    public void setCentresInteret(String centresInteret) { this.centresInteret = centresInteret; }
}