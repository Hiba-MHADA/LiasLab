package model;

import java.util.Date;

public class BesoinMateriel {
    private int id;
    private int membreId;
    private String designation;
    private String justification;
    private String statut;
    private Date dateDemande;
    private Date dateTraitement;
    private String nomMembre;
    private String prenomMembre;

    public BesoinMateriel() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getJustification() { return justification; }
    public void setJustification(String justification) { this.justification = justification; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Date getDateDemande() { return dateDemande; }
    public void setDateDemande(Date dateDemande) { this.dateDemande = dateDemande; }

    public Date getDateTraitement() { return dateTraitement; }
    public void setDateTraitement(Date dateTraitement) { this.dateTraitement = dateTraitement; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}