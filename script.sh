#!/bin/bash

# $erreurSelection=0

if [[ $(whoami) != 'root' ]]; then
	whiptail --title "ATTENTION" --msgbox "Certaines fonctionnalitées de ce script nécéssite les droits root. Pour profiter de toutes les fonctionnalitées de ce script, executez le avec la commande 'sudo' ou avec l'utilisateur root" 11 78
fi


while [ -z $fin ]; do

	# clear

	OPTION=$(whiptail --title "MENU" --cancel-button Fermer --ok-button Valider  --menu "Choisissez une action" 20 70 6 \
	"1" "Informations" \
	"2" "Etats des services" \
	"3" "Installation des services web" \
	"4" "Création d'un site web" \
	"5" "Gestion des sites web" \
	"6" "Redémarrage des services" 3>&1 1>&2 2>&3)
	 
	getURL(){
		if [[ -n $1 ]]; then
			# templateURL="ok"
			templateURL=$(curl -s https://raw.githubusercontent.com/Jonathanb-74/Installation-Serveur-Web/master/url.json | jq .$1)
			templateURL=${templateURL:1:-1}
		fi
	}
	# siteON(){
	# 	if [[ -n $1 ]]; then
			
	# 	fi
	# }
	# siteOFF(){
	# 	if [[ -n $1 ]]; then
			
	# 	fi
	# }

	case $OPTION in
		"1")
			whiptail --title "INFORMATIONS" --msgbox "Script par Jonathan BREA. \nGitHub: Jonathanb-74" 8 78
			;;
		"2")
			# clear
			packetsInstal=("nginx" "php-fpm" "mariadb-server" "phpmyadmin")
			packetsService=("nginx" "php7.*" "mysql" "phpmyadmin")

			unset INSTALLED
			unset STATUS
			unset STATUS

			for (( i = 0; i < 4; i++ ))
			do
			   : 
				INSTALLED=$(dpkg -l | grep ${packetsInstal[$i]} >/dev/null && echo "OUI" || echo "NON")
				STATUS=$(systemctl status ${packetsService[$i]} | grep "Active")
				if [[ ${packetsInstal[$i]} = "phpmyadmin" ]]; then
					statusVar="$statusVar> ${packetsInstal[$i]} \n    Installé: ${INSTALLED}\n\n"
				elif [[ ${packetsInstal[$i]} = "php-fpm" ]]; then
					#statements
					VERSION=$(php -v | grep "PHP")
					statusVar="$statusVar> ${packetsInstal[$i]} \n    Installé: ${INSTALLED}\n    Status: ${STATUSVar}\n    Installé: ${VERSION}\n\n"
				else
					statusVar="$statusVar> ${packetsInstal[$i]} \n    Installé: ${INSTALLED}\n    Status: ${STATUSVar}\n\n"
				fi
      

			done
				echo -e "$statusVar" > $test_textbox

			# echo "Welcome to Bash $BASH_VERSION" > test_textbox
			#                  filename height width
			whiptail --title "Etats des services"  --textbox $test_textbox 25 80
			
			# echo -e "\n"
			# read -p "Selectionnez [Enter] pour retourner au menu..."
			;;
		"3")

			packetsInstallation=$(whiptail --title "Installation du serveur web" --cancel-button "Retour au menu" --ok-button "Valider" --checklist \
				"Selectionnez les composants à installer" 18 80 6 \
				UPDATE "Update des sources" ON \
				Autre "Extracteur JSON, curl (obligatoire pour la configuration des site)" ON \
				NGINX "Serveur web" OFF \
				PHP-FPM "Serveur PHP" OFF \
				MariaDB-Server "Serveur SQL" OFF \
				phpMyAdmin "Interface web de gestion de BDD" OFF 3>&1 1>&2 2>&3)
			 
			exitstatus=$?
			if [ $exitstatus = 0 ]; then

				packetsInstallation2=( "NGINX" "PHP-FPM" )

				echo $packetsInstallation
				# echo $packetsInstallation2

				for iInstall in ${packetsInstallation[@]}
				do
					echo $iInstall
					if [[ $iInstall = '"UPDATE"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t \e[5mUPDATE DES SOURCES"
						echo -e "\e[92m*********************************************\e[0m"
						apt update -y
						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $iInstall = '"Autre"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mJQ"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y jq curl
						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $iInstall = '"NGINX"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mNGINX"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y nginx
						echo -e "Suppression des fichiers de configurations par défaur..."
						rm "/etc/nginx/sites-available/*"
						rm "/etc/nginx/sites-enabled/*"

						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $iInstall = '"PHP-FPM"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mPHP-FPM"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y php-fpm
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Informations de: \e[5mPHP-FPM"
						echo -e "\e[92m*********************************************\e[0m"
						php -v
						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $iInstall = '"MariaDB-Server"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mMariaDB-Server"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y mariadb-server
						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Configuration de: \e[5mMariaDB-Server"
						echo -e "\e[92m*********************************************\e[0m"
						mysql_secure_installation
						read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $iInstall = '"phpMyAdmin"' ]]; then
						if (whiptail --title "phpMyAdmin" --yesno --defaultno --no-button "Revenir au menu" --yes-button "Continuer"  "ATTENTION: avant d'installer phpMyAdmin, vous devez avoir installé \"mariadb-server\". Si vous n'avez PAS installé mariadb-server, sélectionnez \"Revenir au menu\" pour retourner au menu principale, sinon, sélectionnez \"Continuer\"" 12 60) then
							clear
							echo -e "\e[92m*********************************************\e[0m"
							echo -e "\t Installation de: \e[5mNphpMyAdmin"
							echo -e "\e[92m*********************************************\e[0m"
							apt install -y phpmyadmin
							read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"

							clear
							echo -e "\e[92m*********************************************\e[0m"
							echo -e "\t Configuration de: \e[5mNphpMyAdmin"
							echo -e "\e[92m*********************************************\e[0m"

							getURL "nginx_conf_pma"
							wget $templateURL -O "/etc/nginx/sites-available/phpmyadmin"

							pmaPort=$(whiptail --inputbox "Saisissez le port de connexion à phpMyAdmin. (Par défaut: 8080)." 8 39 8080 --title "Port phpMyAdmin" 3>&1 1>&2 2>&3)

							exitstatus=$?
							if [ $exitstatus != 0 ]; then
							    pmaPort="8080"
							fi

							recherche=( "pma_port" "pma_php_version" )
							remplace=( "$pmaPort" "$hoteVersionPHP" )

							for (( i = 0; i < 4; i++ )); do
								#statements
								echo "sed -i 's/\[${recherche[$i]}\]/${remplace[$i]}/g' /etc/nginx/sites-available/phpmyadmin"
								sed -i "s/\[${recherche[$i]}\]/${remplace[$i]}/g" /etc/nginx/sites-available/phpmyadmin
							done

							read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
						fi
					fi
				done
			fi
			;;
		"4")
			if (whiptail --title "Création d'un site web" --yesno "Voulez-vous vraiment lancer l'utilitaire de création d'un site web ?" 8 78); then
			    siteNom=$(whiptail --inputbox "Saisissez le nom d'utilisateur associé au site (sans espaces)." 8 39 --title "Nom d'utilisateur" 3>&1 1>&2 2>&3)
				exitstatus=$?
				if [ $exitstatus = 0 ]; then
					mdpOK="NON"
					while [ $mdpOK != OUI ]
					do
					    siteMDP=$(whiptail --passwordbox "Saisissez le mot de passe associé au compte utilisateur du site." 8 78 --title "Mot de passe utilisateur" 3>&1 1>&2 2>&3)
						exitstatus=$?
						siteMDP2=$(whiptail --passwordbox "Ressaisissez le mot de passe." 8 78 --title "Mot de passe utilisateur" 3>&1 1>&2 2>&3)
						exitstatus2=$?
						if [[ $siteMDP = $siteMDP2 ]]; then
							mdpOK="OUI"
						else
							echo -e "Les mots de passe ne correspondent pas. Veuillez ressaisir les mots de passe." > $test_textbox
							whiptail --textbox $test_textbox 20 80
						fi
					done
					if [[ $exitstatus = 0 && $exitstatus2 = 0 ]]; then
						sitePort=$(whiptail --inputbox "Saisissez le port assosié à votre site. (Par défaut: 80)." 8 39 --title "Port" 3>&1 1>&2 2>&3)
						exitstatus=$?
						if [ $exitstatus = 0 ]; then
							siteDomaine=$(whiptail --inputbox "Saisissez le domaine assosié à votre site. Si vous n'en avez pas laissez la case vide." 8 39 --title "Domaine" 3>&1 1>&2 2>&3)
							exitstatus=$?
							if [ $exitstatus = 0 ]; then
								hoteVersionPHP=$(php -v | grep "PHP")
								hoteVersionPHP=${hoteVersionPHP:4:3}
								siteVersionPHP=$(whiptail --inputbox "Vous pouvez modifier ici la version de PHP à utiliser." 8 39 $hoteVersionPHP --title "Version de PHP" 3>&1 1>&2 2>&3)
								exitstatus=$?
								if [ $exitstatus = 0 ]; then
									if (whiptail --title "BDD" --yesno "Souhaitez vous configurer une BDD ?" 8 78); then
									    siteBddNom=$(whiptail --inputbox "Le nom par défaut de votre BDD est le nom de votre site. Vous pouvez le changer ici." 8 39 $siteNom  --title "Example Dialog" 3>&1 1>&2 2>&3)
										exitstatus=$?
										if [ $exitstatus = 0 ]; then
											mdpOK="NON"
											while [ $mdpOK != OUI ]
											do
											    siteBddMDP=$(whiptail --passwordbox "Saisissez le mot de passe assicié à votre BDD" 8 78 --title "Mot de passe BDD" 3>&1 1>&2 2>&3)
												exitstatus=$?
												siteBddMDP2=$(whiptail --passwordbox "Ressaisissez le mot de passe." 8 78 --title "Mot de passe utilisateur" 3>&1 1>&2 2>&3)
												exitstatus2=$?
												if [[ $siteBddMDP = $siteBddMDP2 ]]; then
													mdpOK="OUI"
												else
													echo -e "Les mots de passe ne correspondent pas. Veuillez ressaisir les mots de passe." > $test_textbox
													whiptail --textbox $test_textbox 20 80
												fi
											done
											if [ $exitstatus = 0 ]; then
											    siteBddConnexion=$(whiptail --title "Autorisation de connexion à la BDD" --nocancel --ok-button Valider  --menu "Choisissez une action" 15 60 5 \
												"1" "localhost" \
												"2" "%" 3>&1 1>&2 2>&3)
												exitstatus=$?
												if [ $exitstatus = 0 ]; then
												    siteConfBDD="ok"
													siteConf="ok"
												fi
											fi
										fi
									else
										siteConf="ok"
									fi
								fi
							fi
						fi
					fi
				fi
				# Nom du site = $siteNom
				# Mot de passe = $siteMDP
				# Mot de passe = $siteMDP2
				# Domaine = $siteDomaine
				# Version de PHP = $siteVersionPHP
				# BDD - Nom = $siteBddNom
				# BDD - MDP = $siteBddMDP
				# BDD - MDP = $siteBddMDP2
				# BDD - Connexion = $siteBddConnexion

				if [[ $siteConf = ok ]]; then

					if [[ -e "/etc/nginx/sites-available/$siteNom" ]]; then

						echo -e "Le fichier  existe déjà !"
						echo -e "Fin du processus d'installation du site"

					elif [[ -n $(grep "$siteNom" /etc/passwd) ]]; then

						echo -e "L'utilisateur existe déjà !"
						echo -e "Fin du processus d'installation du site"

					else
						getURL "nginx_conf_all"

						# echo $templateURL

						wget $templateURL -O "/etc/nginx/sites-available/$siteNom"

						if [[ -e "/etc/nginx/sites-available/$siteNom" && -r "/etc/nginx/sites-available/$siteNom" ]]; then
							echo -e "Le fichier à bien été créer\n"

							read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"

							echo -e "Modification du fichier...\n"

							if [[ -z $sitePort ]]; then
								sitePort="80"
							fi
							if [[ -z $siteDomaine ]]; then
								siteDomaine="_"
							fi

							recherche=( "conf_serveur_port" "conf_user" "conf_domaine" "conf_php_version" )
							remplace=( "$sitePort" "$siteNom" "$siteDomaine" "$siteVersionPHP" )

							for (( i = 0; i < 4; i++ )); do
								#statements
								echo "sed -i 's/\[${recherche[$i]}\]/${remplace[$i]}/g' /etc/nginx/sites-available/$siteNom"
								sed -i "s/\[${recherche[$i]}\]/${remplace[$i]}/g" /etc/nginx/sites-available/$siteNom
							done

							testGroupManagement=$(getent group scriptManagement || { echo "0"; })

							if [[ $testGroupManagement = 0 ]]; then
								groupadd "scriptManagement"
							fi

							useradd -m -p $(echo "$siteMDP" | openssl passwd -1 -stdin) -s /bin/bash -g "www-data" -G "scriptManagement" "$siteNom"
							# adduser "$siteNom" "www-data"
							if [[ -e "/home/$siteNom" ]]; then
								echo -e "Le rep home à bien été créer"
							fi

							mkdir "/home/$siteNom/html"
							if [[ -e "/home/$siteNom/html" ]]; then
								echo -e "Le rep home/html à bien été créer"
							fi

							wget $templateURL -O "/home/$siteNom/html/maintenance.html"
							if [[ -e "/home/$siteNom/html/maintenance.html" ]]; then
								echo -e "La page maintenance.html à été ajouter au repertoire"
							fi
							chown -R "$siteNom:www-data" "/home/$siteNom/html"

							if [[ $siteConfBDD = ok ]]; then	

								if [[ $siteBddConnexion = 2 ]]; then
									siteBddConnexion="%"
								else
									siteBddConnexion="localhost"
								fi

								mysql -u root -e "CREATE USER $siteBddNom@'$siteBddConnexion' IDENTIFIED BY '$siteBddMDP';"
								mysql -u root -e "GRANT USAGE ON *.* TO $siteBddNom@'$siteBddConnexion' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
								mysql -u root -e "CREATE DATABASE IF NOT EXISTS $siteBddNom;"
								mysql -u root -e "GRANT ALL PRIVILEGES ON $siteBddNom.* TO $siteBddNom@'$siteBddConnexion';"
							fi

						fi
						
						whiptail --title "Terminé" --msgbox "La configuration de votre site est maintenant terminée." 8 78

					fi
				fi
			fi
			read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
			;;
		"5")
			finConfSites="0"

			while [[ $finConfSites = "0" ]]; do
				function contains() {
				    local n=$#
				    local value=${!n}
				    for ((i=1;i < $#;i++)) {
				        if [ "${!i}" == "${value}" ]; then
				            echo "y"
				            return 0
				        fi
				    }
				    echo "n"
				    return 1
				}

				hash -r
				unset listeSite
				unset available
				unset enabled

				i=0
				while read line
				do
				    available[$i]="$line"        
				    (( i++ ))
				done < <(ls -1 /etc/nginx/sites-available)

				j=0
				while read line
				do
				    enabled[$j]="$line"        
				    (( j++ ))
				done < <(ls -1 /etc/nginx/sites-enabled)

				listeID=0
				for i in "${available[@]}"
				do
					: 
					# echo $i
					# echo ${enabled[$1]}
					if [[ $(contains "${enabled[@]}" "$i") == "y" ]]; then
						# echo "$i est activé !"
						listeSite[$listeID]="$i"
						echo ${listeSite[$listeID]}
						(( listeID++ ))
						listeSite[$listeID]="..."
						echo ${listeSite[$listeID]}
						(( listeID++ ))
						listeSite[$listeID]="ON"
						echo ${listeSite[$listeID]}
						(( listeID++ ))
					else
						listeSite[$listeID]="$i"
						echo ${listeSite[$listeID]}
						(( listeID++ ))
						listeSite[$listeID]="..."
						echo ${listeSite[$listeID]}
						(( listeID++ ))
						listeSite[$listeID]="OFF"
						echo ${listeSite[$listeID]}
						(( listeID++ ))
					fi
					echo $listID
				done

				SiteManagement=$(whiptail --title "Check list example" --checklist "Choose user's permissions" 20 78 6 "${listeSite[@]}" 3>&1 1>&2 2>&3)

				# packetsInstallation=$(whiptail --title "Installation du serveur web" --cancel-button "Retour au menu" --ok-button "Valider" --checklist \
				# 	"Selectionnez les composants à installer" 18 80 6 \
				# 	UPDATE "Update des sources" ON \
				# 	Autre "Extracteur JSON, curl (obligatoire pour la configuration des site)" ON \
				# 	NGINX "Serveur web" OFF \
				# 	PHP-FPM "Serveur PHP" OFF \
				# 	MariaDB-Server "Serveur SQL" OFF \
				# 	phpMyAdmin "Interface web de gestion de BDD" OFF 3>&1 1>&2 2>&3)
				 
				exitstatus=$?
				if [ $exitstatus = 0 ]; then

					# echo ${SiteManagement[@]}

					clear

					for siteExiste in ${available[@]}
					do
						echo -e "\n\n\n\n************************\n\n\n"
						
						coche=""
						for saisie in ${SiteManagement[@]}
						do
							saisie=${saisie:1:-1}
							echo -e "Site existe: $siteExiste  --  Site à conf $saisie"
							if [[ -z $coche ]]; then
								if [[ $siteExiste = $saisie ]]; then
									coche="oui"
									echo -e "$siteExiste - OUI\n"
								fi
							fi
						done

						echo	-e "$coche\n"


						fichier="/etc/nginx/sites-enabled/${siteExiste}"

						if [[ $coche = "oui" ]]; then
							if [[ -e ${fichier} ]]; then
								echo -e "Le fichier $siteExiste existe"
							else
								echo -e "Le fichier $siteExiste n'existe pas. On le créer"
								ln -s /etc/nginx/sites-available/${siteExiste} /etc/nginx/sites-enabled/${siteExiste}
							fi
						else
							if [[ -e ${fichier} ]]; then
								echo -e "Le fichier $siteExiste existe. On le supprime."
								rm "/etc/nginx/sites-enabled/${siteExiste}"
							else
								echo -e "Le fichier $siteExiste n'existe pas"
							fi
						fi
					done
				else
					finConfSites="1"
				fi

				# read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
			done
			;;
		"6")
			restartServiceLoop="0"

			while [[ $restartServiceLoop = "0" ]]; do
				
				restartService=$(whiptail --title "Redémarrage des services" --cancel-button Fermer --ok-button Valider  --menu "Choisissez un service à redémarrer" 20 70 6 \
					"1" "NGINX" \
					"2" "PHP" \
					"3" "MySQL" 3>&1 1>&2 2>&3)

				exitstatus=$?
				if [ $exitstatus = 0 ]; then
					if [[ $restartService = "1" ]]; then
						service nginx restart
						# read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $restartService = "2" ]]; then
						service php* restart
						# read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					elif [[ $restartService = "3" ]]; then
						service mysql restart
						# read -p "\e[34mSelectionnez [Enter] pour continuer...\e[39m"
					fi
				else
					restartServiceLoop="1"
				fi
			done
			;;
		*)
			fin=1
			;;
	esac
done