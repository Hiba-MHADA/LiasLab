package model;

import java.util.Date;

public class Attribution {
    private int id;
    private int materielId;
    private int membreId;
    private int quantite;
    private Date dateAttribution;
    private Date dateRetourPrevue;
    private Date dateRetourEffective;
    private String statut;
    private String nomMateriel;
    private String nomMembre;
    private String prenomMembre;

    public Attribution() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMaterielId() { return materielId; }
    public void setMaterielId(int materielId) { this.materielId = materielId; }
    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }
    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }
    public Date getDateAttribution() { return dateAttribution; }
    public void setDateAttribution(Date dateAttribution) { this.dateAttribution = dateAttribution; }
    public Date getDateRetourPrevue() { return dateRetourPrevue; }
    public void setDateRetourPrevue(Date dateRetourPrevue) { this.dateRetourPrevue = dateRetourPrevue; }
    public Date getDateRetourEffective() { return dateRetourEffective; }
    public void setDateRetourEffective(Date dateRetourEffective) { this.dateRetourEffective = dateRetourEffective; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    public String getNomMateriel() { return nomMateriel; }
    public void setNomMateriel(String nomMateriel) { this.nomMateriel = nomMateriel; }
    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }
    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}