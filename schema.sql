-- ============================================================
-- LiasLab — Schéma de la base de données
-- Laboratoire LIAS — Faculté des Sciences Ben M'Sik
-- Université Hassan II de Casablanca
-- ============================================================

CREATE DATABASE IF NOT EXISTS lias_lab
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lias_lab;

CREATE TABLE `membre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prenom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mot_de_passe` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statut` enum('permanent','associe','doctorant','retraite','ancien') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('admin','directeur','vice_directeur','chef_equipe','membre','associe','doctorant','retraite','ancien','visiteur') COLLATE utf8mb4_unicode_ci DEFAULT 'membre',
  `etablissement` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `laboratoire_origine` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `biographie` text COLLATE utf8mb4_unicode_ci,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `date_embauche` date DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  `date_affiliation` date DEFAULT NULL,
  `centres_interet` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `equipe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `affiliation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `affiliation_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `historique_affiliation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date DEFAULT NULL,
  `motif` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `historique_affiliation_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `historique_profil` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int NOT NULL,
  `champ_modifie` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ancienne_valeur` text COLLATE utf8mb4_unicode_ci,
  `nouvelle_valeur` text COLLATE utf8mb4_unicode_ci,
  `date_modification` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `historique_profil_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `mandat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `directeur_id` int DEFAULT NULL,
  `vice_directeur_id` int DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `directeur_id` (`directeur_id`),
  CONSTRAINT `mandat_ibfk_1` FOREIGN KEY (`directeur_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `role_membre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int DEFAULT NULL,
  `equipe_id` int DEFAULT NULL,
  `role` enum('directeur','vice_directeur','chef_equipe','membre') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  KEY `equipe_id` (`equipe_id`),
  CONSTRAINT `role_membre_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`),
  CONSTRAINT `role_membre_ibfk_2` FOREIGN KEY (`equipe_id`) REFERENCES `equipe` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `demande_adhesion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prenom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `motivation` text COLLATE utf8mb4_unicode_ci,
  `cv_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statut` enum('en_attente','acceptee','refusee') COLLATE utf8mb4_unicode_ci DEFAULT 'en_attente',
  `date_soumission` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `evenement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('conference','seminaire','workshop') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `lieu` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `edition` int DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `organisateur_evenement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evenement_id` int NOT NULL,
  `membre_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_organisateur` (`evenement_id`,`membre_id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `organisateur_evenement_ibfk_1` FOREIGN KEY (`evenement_id`) REFERENCES `evenement` (`id`),
  CONSTRAINT `organisateur_evenement_ibfk_2` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `publication` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auteurs` text COLLATE utf8mb4_unicode_ci,
  `annee` year DEFAULT NULL,
  `revue` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lien` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `equipe_id` int DEFAULT NULL,
  `membre_id` int DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `equipe_id` (`equipe_id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `publication_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `equipe` (`id`),
  CONSTRAINT `publication_ibfk_2` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `convention` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partenaire` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('financement','programme','attestation','rapport','administratif','convention') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chemin` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `evenement_id` int DEFAULT NULL,
  `date_upload` datetime DEFAULT CURRENT_TIMESTAMP,
  `actif` tinyint(1) DEFAULT '1',
  `convention_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `evenement_id` (`evenement_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`evenement_id`) REFERENCES `evenement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `materiel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `designation` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_arrivee` date DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `attribution_materiel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `materiel_id` int DEFAULT NULL,
  `membre_id` int DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  `date_attribution` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `materiel_id` (`materiel_id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `attribution_materiel_ibfk_1` FOREIGN KEY (`materiel_id`) REFERENCES `materiel` (`id`),
  CONSTRAINT `attribution_materiel_ibfk_2` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `distribution_materiel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `materiel_id` int NOT NULL,
  `membre_id` int NOT NULL,
  `quantite_recue` int NOT NULL,
  `date_distribution` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `materiel_id` (`materiel_id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `distribution_materiel_ibfk_1` FOREIGN KEY (`materiel_id`) REFERENCES `materiel` (`id`),
  CONSTRAINT `distribution_materiel_ibfk_2` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `besoin_materiel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int NOT NULL,
  `designation` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `justification` text COLLATE utf8mb4_unicode_ci,
  `statut` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'en_attente',
  `date_demande` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_traitement` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `besoin_materiel_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `reunion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_reunion` date DEFAULT NULL,
  `ordre_du_jour` text COLLATE utf8mb4_unicode_ci,
  `pv_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `message` (
  `id` int NOT NULL AUTO_INCREMENT,
  `expediteur_id` int DEFAULT NULL,
  `destinataire_id` int DEFAULT NULL,
  `equipe_id` int DEFAULT NULL,
  `evenement_id` int DEFAULT NULL,
  `contenu` text COLLATE utf8mb4_unicode_ci,
  `date_envoi` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `expediteur_id` (`expediteur_id`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`expediteur_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `membre_id` int DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `lu` tinyint(1) DEFAULT '0',
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `membre_id` (`membre_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `membre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;