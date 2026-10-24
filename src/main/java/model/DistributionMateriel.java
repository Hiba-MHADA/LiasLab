package model;

import java.util.Date;

public class DistributionMateriel {
    private int id;
    private int materielId;
    private int membreId;
    private int quantiteRecue;
    private Date dateDistribution;
    private String nomMateriel;
    private String nomMembre;
    private String prenomMembre;

    public DistributionMateriel() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMaterielId() { return materielId; }
    public void setMaterielId(int materielId) { this.materielId = materielId; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public int getQuantiteRecue() { return quantiteRecue; }
    public void setQuantiteRecue(int quantiteRecue) { this.quantiteRecue = quantiteRecue; }

    public Date getDateDistribution() { return dateDistribution; }
    public void setDateDistribution(Date dateDistribution) { this.dateDistribution = dateDistribution; }

    public String getNomMateriel() { return nomMateriel; }
    public void setNomMateriel(String nomMateriel) { this.nomMateriel = nomMateriel; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}