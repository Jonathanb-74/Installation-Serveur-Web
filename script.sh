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
			packetsInstal=("nginx" "php-fpm" "mariadb-server" "phpmyadmin")
			packetsService=("nginx" "php7.*" "mysql" "phpmyadmin")

			for (( i = 0; i < 4; i++ ))
			do
			   : 
				INSTALLED=$(dpkg -l | grep ${packetsInstal[$i]} >/dev/null && echo "OUI" || echo "NON")
				STATUS=$(systemctl status ${packetsService[$i]} | grep "Active")
				if [[ ${packetsService[$i]} != "phpmyadmin" ]]; then
					status="$status> ${packetsInstal[$i]} \n    Installé: ${INSTALLED}\n    Status: ${STATUS}\n\n"
				else
					status="$status> ${packetsInstal[$i]} \n    Installé: ${INSTALLED}\n\n"
				fi
      

			done
				echo -e "$status" > test_textbox

			# echo "Welcome to Bash $BASH_VERSION" > test_textbox
			#                  filename height width
			whiptail --title "Etats des services"  --textbox test_textbox 25 80
			
			# echo -e "\n"
			# read -p "Selectionnez [Enter] pour retourner au menu..."
			;;
		"3")

			packetsInstallation=$(whiptail --title "Installation du serveur web" --cancel-button "Retour au menu" --ok-button "Valider" --checklist \
				"Selectionnez les composants à installer" 15 60 5 \
				UPDATE "Update des sources" ON \
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
						read -p "Selectionnez [Enter] pour continuer..."
					elif [[ $iInstall = '"NGINX"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mNGINX"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y nginx
						read -p "Selectionnez [Enter] pour continuer..."
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
						read -p "Selectionnez [Enter] pour continuer..."
					elif [[ $iInstall = '"MariaDB-Server"' ]]; then
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Installation de: \e[5mMariaDB-Server"
						echo -e "\e[92m*********************************************\e[0m"
						apt install -y mariadb-server
						read -p "Selectionnez [Enter] pour continuer..."
						clear
						echo -e "\e[92m*********************************************\e[0m"
						echo -e "\t Configuration de: \e[5mMariaDB-Server"
						echo -e "\e[92m*********************************************\e[0m"
						mysql_secure_installation
						read -p "Selectionnez [Enter] pour continuer..."
					elif [[ $iInstall = '"phpMyAdmin"' ]]; then
						if (whiptail --title "phpMyAdmin" --yesno --defaultno --no-button "Revenir au menu" --yes-button "Continuer"  "ATTENTION: avant d'installer phpMyAdmin, vous devez avoir installé \"mariadb-server\". Si vous n'avez PAS installé mariadb-server, sélectionnez \"Revenir au menu\" pour retourner au menu principale, sinon, sélectionnez \"Continuer\"" 12 60) then
							clear
							echo -e "\e[92m*********************************************\e[0m"
							echo -e "\t Installation de: \e[5mNphpMyAdmin"
							echo -e "\e[92m*********************************************\e[0m"
							apt install -y phpmyadmin
							read -p "Selectionnez [Enter] pour continuer..."
						fi
					fi
				done
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