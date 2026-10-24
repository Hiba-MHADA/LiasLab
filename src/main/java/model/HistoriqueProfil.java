package model;

import java.util.Date;

public class HistoriqueProfil {
    private int id;
    private int membreId;
    private String champModifie;
    private String ancienneValeur;
    private String nouvelleValeur;
    private Date dateModification;

    public HistoriqueProfil() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public String getChampModifie() { return champModifie; }
    public void setChampModifie(String champModifie) { this.champModifie = champModifie; }

    public String getAncienneValeur() { return ancienneValeur; }
    public void setAncienneValeur(String ancienneValeur) { this.ancienneValeur = ancienneValeur; }

    public String getNouvelleValeur() { return nouvelleValeur; }
    public void setNouvelleValeur(String nouvelleValeur) { this.nouvelleValeur = nouvelleValeur; }

    public Date getDateModification() { return dateModification; }
    public void setDateModification(Date dateModification) { this.dateModification = dateModification; }
}