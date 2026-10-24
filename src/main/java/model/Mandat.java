package model;

import java.util.Date;

public class Mandat {
    private int id;
    private int directeurId;
    private int viceDirecteurId;
    private Date dateDebut;
    private Date dateFin;
    private String nomDirecteur;
    private String prenomDirecteur;
    private String nomViceDirecteur;
    private String prenomViceDirecteur;

    public Mandat() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDirecteurId() { return directeurId; }
    public void setDirecteurId(int directeurId) { this.directeurId = directeurId; }
    public int getViceDirecteurId() { return viceDirecteurId; }
    public void setViceDirecteurId(int viceDirecteurId) { this.viceDirecteurId = viceDirecteurId; }
    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }
    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }
    public String getNomDirecteur() { return nomDirecteur; }
    public void setNomDirecteur(String nomDirecteur) { this.nomDirecteur = nomDirecteur; }
    public String getPrenomDirecteur() { return prenomDirecteur; }
    public void setPrenomDirecteur(String prenomDirecteur) { this.prenomDirecteur = prenomDirecteur; }
    public String getNomViceDirecteur() { return nomViceDirecteur; }
    public void setNomViceDirecteur(String nomViceDirecteur) { this.nomViceDirecteur = nomViceDirecteur; }
    public String getPrenomViceDirecteur() { return prenomViceDirecteur; }
    public void setPrenomViceDirecteur(String prenomViceDirecteur) { this.prenomViceDirecteur = prenomViceDirecteur; }
}