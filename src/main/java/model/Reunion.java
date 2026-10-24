package model;

import java.util.Date;

public class Reunion {
    private int id;
    private String titre;
    private Date dateReunion;
    private String ordreJour;
    private String pvPath;

    public Reunion() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public Date getDateReunion() { return dateReunion; }
    public void setDateReunion(Date dateReunion) { this.dateReunion = dateReunion; }
    public String getOrdreJour() { return ordreJour; }
    public void setOrdreJour(String ordreJour) { this.ordreJour = ordreJour; }
    public String getPvPath() { return pvPath; }
    public void setPvPath(String pvPath) { this.pvPath = pvPath; }
}