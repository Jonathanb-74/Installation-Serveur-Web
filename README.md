
# Installation-Serveur-Web

## Description
Ce script permet d'installer de manière simple les packages essentiels à la création d'un serveur web. Il permet aussi de configurer des sites web (vHost) sur le serveur ainsi qu'un répertoire et une BDD dédiée.

## Fonctionnalités

 - Installation automatisée des services
 - Configuration des site web automatiquement
 - Chaque site web à un compte utilisateur dédié
 - Possibilité pour chaque site d'avoir une BDD (crée automatiquement) avec un accès à phpMyAdmin
 - Redémarrage des services depuis le menu 

## Informations
Ce script à été testé sur Ubuntu 20.04

## Installation
Téléchargement du script

    wget -q --no-cache --no-cookies https://raw.githubusercontent.com/Jonathanb-74/Installation-Serveur-Web/master/script.sh

Autorisation de l’exécution

    chmod +x script.sh

Exécution du script

    sudo ./script.sh
***ATTENTION**: ce script doit-être exécute en mode root ou avec la commande 'sudo'*

## Utilisation

Lors de l’exécution du script, le menu principale s'affiche:![Menu principale](https://raw.githubusercontent.com/Jonathanb-74/Installation-Serveur-Web/master/img/docMenu.PNG)
### Informations

Cette section affiches des informations sur le programme ainsi que son auteur.

### États des services

Cette section indique différentes informations des services:

 - S'il est installé (oui / non)
 - Son status
 - Sa version

![Aucun service installé](https://raw.githubusercontent.com/Jonathanb-74/Installation-Serveur-Web/master/img/docEtatsDesServices1.PNG)

### Installation des services web

Cette section permet d'installer les différents packages pour un serveur web ainsi que des packages nécessaires au bon fonctionnement du script.

![Liste de sélection des services à installer](https://raw.githubusercontent.com/Jonathanb-74/Installation-Serveur-Web/master/img/docInstallationDesServices.PNG)
#### Description des packages installés

 - **UPDATE**: Exécute un `apt update`, ce qui permet de mettre à jour les sources avant l'installation des autres packages.
 - **Autre**: Installe curl et [jq](https://stedolan.github.io/jq/) qui sont des outils nécessaires à l’exécution du script.
 - **NGINX**: Installe le serveur web
 - **PHP-FPM**: Installe le serveur PHP (dernière version)
 - **MariaDB-Server**: Installe le serveur SQL
	 - Dans la seconde partie de son installation, vous devrez configurer le mot de passe `root` de mysql ainsi que de configurer d'autres paramètres. Pour plus d'informations, [voir cette documentation](https://mariadb.com/kb/en/mysql_secure_installation/).
 - **phpMyAdmin**: Installe l'interface web phpMyAdmin (PMA) qui permet de gérer ses bases de données depuis une page web.
	 - Lors de l'installation de PMA, vous devrez configurer le port d'accès à l'interface web (par défaut: 8080) ainsi que le mot de passe de l'utilisateur `phpmyadmin` et le type de serveur, choisissez `Apache 2`.

### Création d'un site web

Lorsque vous souhaitez créer un site web, vous devez:

 1. **Saisir le nom du site web** (c'est le nom du compte utilisateur système qui sera créé)
 2. **Saisir un mot de passe** pour ce compte utilisateur
 3. **Saisir le port du site** (par défaut: 80)
 4. **Saisir le nom de domaine** associé au site (laissez vide si vous n'en avez pas)
 5. **Choisir la version de PHP**. La case doit déjà être remplie, si vous ne savez pas ce que vous faites, ne modifiez pas con contenu ! Si la case est vide, vous n'avez probablement pas installer PHP.
 6. Choisir si vous souhaitez configurer une BDD pour ce site.
 7. Si **OUI**, continuez cette procédure, si **NON** passez à l'étape 11
 8. **Choisissez le nom de la BDD** (par défaut: le nom de votre site précédaient saisie)
 9. **Saisir un mot de passe** pour ce compte SQL
 10. **Choisissez le type de connexion** autorisée pour ce compte.
 11. La configuration est maintenant terminée. 
 12. Depuis le menu principale, dans le menu **`Redémarrage...`** redémarrez `NGINX`.

Votre site devrait maintenant être accessible.

## Gestion des sites

Cette interface permet d'activé ou de désactivé des site web. 

 - Case cochée: site activé
 - Case décochée: site désactivé

> **ATTENTION: Ce script ne vérifie pas la configuration des sites, en fonction de leurs configurations (port + domaine), deux sites peuvent rentrer en conflits, ce qui peut faire apparaitre des comportements indésirables.**

## Redémarrage des services

Cette section vous permet de redémarrer chaque service de maniéré individuelle.
