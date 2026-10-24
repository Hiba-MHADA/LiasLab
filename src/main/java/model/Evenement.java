package model;

import java.util.Date;

public class Evenement {
    private int id;
    private String titre;
    private String type;
    private Date dateDebut;
    private Date dateFin;
    private String lieu;
    private String description;
    private int edition;

    public Evenement() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getEdition() { return edition; }
    public void setEdition(int edition) { this.edition = edition; }
}