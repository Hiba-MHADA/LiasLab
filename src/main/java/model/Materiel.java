package model;

import java.util.Date;

public class Materiel {
    private int id;
    private String designation;
    private Date dateArrivee;
    private int quantite;

    public Materiel() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public Date getDateArrivee() { return dateArrivee; }
    public void setDateArrivee(Date dateArrivee) { this.dateArrivee = dateArrivee; }
    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }
    private int quantiteDisponible;
    public int getQuantiteDisponible() { return quantiteDisponible; }
    public void setQuantiteDisponible(int quantiteDisponible) { this.quantiteDisponible = quantiteDisponible; }
}