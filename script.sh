#!/bin/bash

# $erreurSelection=0

if [[ $(whoami) != 'root' ]]; then
	whiptail --title "ATTENTION" --msgbox "Certaines fonctionnalitées de ce script nécéssite les droits root. Pour profiter de toutes les fonctionnalitées de ce script, executez le avec la commande sudo ou avec l'utilisateur root" 8 78
fi


while [ -z $fin ]; do

	# clear

	OPTION=$(whiptail --title "MENU" --cancel-button Fermer --ok-button Valider  --menu "Choisissez une action" 15 60 5 \
	"1" "Informations" \
	"2" "Etats des services" \
	"3" "Installation des services web" \
	"4" "Création d'un site web" \
	"5" "Redémarrage des services" 3>&1 1>&2 2>&3)
	 
	# exitstatus=$?
	# if [ $exitstatus != 0 ]; then
	#     # echo "Vous avez choisi la distribution : " $OPTION
	#     echo "vous avez annulé"
	# fi

	case $OPTION in
		"1")
			whiptail --title "INFORMATIONS" --msgbox "Script par Jonathan BREA. \nGitHub: Jonathanb-74" 8 78
			;;
		"2")
			# clear
			packets=("nginx" "php-fpm" "mariadb-server")

			for i in "${packets[@]}"
			do
			   : 
				INSTALLED=$(dpkg -l | grep ${i} >/dev/null && echo "\e[92m OUI" || echo "\e[91m NON")

				echo -e " > ${i} \t| Installé: ${INSTALLED}\e[39m"
			done
			
			echo -e "\n"
			read -p "Selectionnez [Enter] pour retourner au menu..."
			;;
		"3")

			packetsInstallation=$(whiptail --title "Installation du serveur web" --cancel-button "Retour au menu" --ok-button "Valider" --checklist \
				"Selectionnez les composants à installer" 15 60 4 \
				NGINX "Serveur web" OFF \
				PHP-FPM "Serveur PHP" ON \
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
					if [[ $iInstall = '"NGINX"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mNGINX"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y nginx
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
					elif [[ $iInstall = '"MariaDB-Server"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mMariaDB-Server"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y mariadb-server
					elif [[ $iInstall = '"phpMyAdmin"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mNphpMyAdmin"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y phpmyadmin
					else
        				echo "NON"
					fi

					read -p "Selectionnez [Enter] pour continuer..."
				done
			else
			    echo "Vous avez annulé"
			fi
			;;
		"4")
			echo "Selection: 4"
			;;
		*)
			fin=1
			;;
	esac
	

done

# clear