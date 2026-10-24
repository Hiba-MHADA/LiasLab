package model;

import java.util.Date;

public class Convention {
    private int id;
    private String partenaire;
    private Date dateDebut;
    private Date dateFin;
    private String description;

    public Convention() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getPartenaire() { return partenaire; }
    public void setPartenaire(String partenaire) { this.partenaire = partenaire; }
    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }
    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}