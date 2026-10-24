package model;

import java.util.Date;

public class Message {
    private int id;
    private int expediteurId;
    private int destinataireId;
    private int equipeId;
    private int evenementId;
    private String contenu;
    private Date dateEnvoi;
    private String nomExpediteur;
    private String prenomExpediteur;
    private String nomDestinataire;
    private String prenomDestinataire;

    public Message() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getExpediteurId() { return expediteurId; }
    public void setExpediteurId(int expediteurId) { this.expediteurId = expediteurId; }
    public int getDestinataireId() { return destinataireId; }
    public void setDestinataireId(int destinataireId) { this.destinataireId = destinataireId; }
    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }
    public int getEvenementId() { return evenementId; }
    public void setEvenementId(int evenementId) { this.evenementId = evenementId; }
    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }
    public Date getDateEnvoi() { return dateEnvoi; }
    public void setDateEnvoi(Date dateEnvoi) { this.dateEnvoi = dateEnvoi; }
    public String getNomExpediteur() { return nomExpediteur; }
    public void setNomExpediteur(String nomExpediteur) { this.nomExpediteur = nomExpediteur; }
    public String getPrenomExpediteur() { return prenomExpediteur; }
    public void setPrenomExpediteur(String prenomExpediteur) { this.prenomExpediteur = prenomExpediteur; }
    public String getNomDestinataire() { return nomDestinataire; }
    public void setNomDestinataire(String nomDestinataire) { this.nomDestinataire = nomDestinataire; }
    public String getPrenomDestinataire() { return prenomDestinataire; }
    public void setPrenomDestinataire(String prenomDestinataire) { this.prenomDestinataire = prenomDestinataire; }
}