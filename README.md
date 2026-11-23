# LiasLab : Gestion du laboratoire LIAS

Application web **Java EE (Jakarta)** de gestion du laboratoire **LIAS**. Elle centralise les membres, leurs documents et le suivi de l'activité du laboratoire, avec une gestion des accès selon le rôle de chaque utilisateur.

## Fonctionnalités

- **Authentification sécurisée** : mots de passe hachés avec **BCrypt**
- **Contrôle d'accès par rôles** (RBAC) : chaque rôle accède uniquement à ses pages et actions (À COMPLÉTER : liste des rôles)
- **Gestion des profils** : dépôt de CV et renseignement des centres d'intérêt
- **Gestion des documents** : dépôt de fichiers PV et téléchargement des documents
- **Notifications par e-mail** : envoi d'un message en cas de refus (Jakarta Mail)
- **Rapport annuel** : export en **PDF**
- **Interface** : thème turquoise et blanc, avec barre latérale de navigation

## Technologies

| Couche | Technologie |
|--------|-------------|
| Back-end | Jakarta Servlets, JSP, JavaBeans |
| Base de données | MySQL (script `schema.sql` fourni) |
| Serveur | Apache Tomcat (À COMPLÉTER : version) |
| IDE | Eclipse (Dynamic Web Project) |
| Sécurité | jBCrypt |
| E-mail | Jakarta Mail, Jakarta Activation |
| Accès BD | MySQL Connector/J |

## Structure du projet

```
.
├── src/main/java/        # servlets, modèles, accès aux données
├── src/main/webapp/
│   ├── WEB-INF/lib/      # bibliothèques JAR
│   └── *.jsp             # pages de l'application
├── schema.sql            # création de la base de données
└── README.md
```

> Adapte l'arborescence à celle de ton projet Eclipse si elle diffère.

## Prérequis

- JDK 17 ou supérieur (À COMPLÉTER : version utilisée)
- Apache Tomcat (compatible Jakarta EE)
- MySQL 8
- Eclipse IDE for Enterprise Java and Web Developers

## Installation

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/Hiba-MHADA/lias-laboratory-management.git
   ```
2. **Créer la base de données** : exécuter `schema.sql` dans MySQL
   ```bash
   mysql -u root -p < schema.sql
   ```
3. **Configurer la connexion** : renseigner l'URL, l'utilisateur et le mot de passe MySQL (À COMPLÉTER : fichier ou classe concernée)
4. **Vérifier les JAR** dans `WEB-INF/lib` : `jakarta.activation`, `jbcrypt`, `jakarta.mail`, `mysql-connector-j`
5. **Importer le projet dans Eclipse**, l'ajouter à Tomcat, puis lancer le serveur
6. Ouvrir `http://localhost:8080/<nom-du-projet>`

## Sécurité

- Mots de passe hachés avec BCrypt
- Accès aux pages filtré selon le rôle
- Ne jamais versionner les identifiants MySQL ni le mot de passe du compte e-mail

## Améliorations possibles

- Migration vers Maven pour la gestion des dépendances
- Protection CSRF et validation renforcée des fichiers déposés
- Tests automatisés
- Déploiement avec Docker

## Auteure

Hiba, [Hiba-MHADA](https://github.com/Hiba-MHADA)
