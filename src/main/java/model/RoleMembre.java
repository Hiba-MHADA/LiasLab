package model;

import java.util.Date;

public class RoleMembre {
    private int id;
    private int membreId;
    private int equipeId;
    private String role;
    private Date dateDebut;
    private Date dateFin;
    private String nomMembre;
    private String prenomMembre;
    private String nomEquipe;

    public RoleMembre() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }

    public String getNomEquipe() { return nomEquipe; }
    public void setNomEquipe(String nomEquipe) { this.nomEquipe = nomEquipe; }
}