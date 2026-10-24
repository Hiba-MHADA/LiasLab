package model;

import java.util.Date;

public class HistoriqueAffiliation {
    private int id;
    private int membreId;
    private Date dateDebut;
    private Date dateFin;
    private String motif;
    private String nomMembre;
    private String prenomMembre;

    public HistoriqueAffiliation() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}