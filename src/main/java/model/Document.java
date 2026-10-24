package model;

import java.util.Date;

public class Document {
    private int id;
    private String nom;
    private String type;
    private String chemin;
    private int evenementId;
    private int conventionId;
    private Date dateUpload;
    private String nomEvenement;
    private String nomConvention;

    public Document() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getChemin() { return chemin; }
    public void setChemin(String chemin) { this.chemin = chemin; }
    public int getEvenementId() { return evenementId; }
    public void setEvenementId(int evenementId) { this.evenementId = evenementId; }
    public int getConventionId() { return conventionId; }
    public void setConventionId(int conventionId) { this.conventionId = conventionId; }
    public Date getDateUpload() { return dateUpload; }
    public void setDateUpload(Date dateUpload) { this.dateUpload = dateUpload; }
    public String getNomEvenement() { return nomEvenement; }
    public void setNomEvenement(String nomEvenement) { this.nomEvenement = nomEvenement; }
    public String getNomConvention() { return nomConvention; }
    public void setNomConvention(String nomConvention) { this.nomConvention = nomConvention; }
}