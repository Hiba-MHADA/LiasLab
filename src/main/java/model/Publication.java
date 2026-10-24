package model;

public class Publication {
    private int id;
    private String titre;
    private String auteurs;
    private int annee;
    private String revue;
    private String lien;
    private int equipeId;
    private int membreId;

    public Publication() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getAuteurs() { return auteurs; }
    public void setAuteurs(String auteurs) { this.auteurs = auteurs; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    public String getRevue() { return revue; }
    public void setRevue(String revue) { this.revue = revue; }

    public String getLien() { return lien; }
    public void setLien(String lien) { this.lien = lien; }

    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }
}