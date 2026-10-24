package model;

import java.util.Date;

public class Notification {
    private int id;
    private int membreId;
    private String message;
    private boolean lu;
    private Date dateCreation;

    public Notification() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public boolean isLu() { return lu; }
    public void setLu(boolean lu) { this.lu = lu; }
    public Date getDateCreation() { return dateCreation; }
    public void setDateCreation(Date dateCreation) { this.dateCreation = dateCreation; }
}