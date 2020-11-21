#!/bin/bash

# $erreurSelection=0


while [ -z $fin ]; do

	clear

	echo "[1] Informations"
	echo "[2] Etats des services"
	echo "[3] Installation du serveur web"
	echo "[4] Création d'un site web"
	echo "[5] Redémarrage des services"
	echo "[Q] Quiter"

	echo -e "\n"

	if [[ $erreurSelection = 1 ]];
	then
		echo -e "\t\e[31mAttention: \e[0m L'action selectionnée n'existe pas ! \e[0m \n"
	else
		echo -e "\n"
	fi
	
	erreurSelection=0

	read -p "Action: " act

	case $act in
			"1")
				clear
				echo -e ">"
				echo -e "\e[32m\t Informations\e[39m"
				echo -e ">"

				echo -e "\n"
				echo -e  "\e[92mAuteur: \e[0m Jonathan BREA"
				echo -e  "\e[92mLien GitHub: \e[0m https://github.com/Jonathanb-74/Installation-Serveur-Web"
				
				echo -e "\n"
				read -p "Selectionnez [Enter] pour retourner au menu..."
				;;
			"2")
				clear
				echo -e ">"
				echo -e "\e[32m\t Etats des services\e[39m"
				echo -e ">"

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
				clear
				echo -e ">"
				echo -e "\e[32m\t Installation du serveur web\e[39m"
				echo -e ">"
				
				

				echo -e "\n"
				read -p "Selectionnez [Enter] pour retourner au menu..."
				;;
			"4")
				echo "Selection: 4"
				;;
			"Q")
				fin=1
				;;
			"q")
				fin=1
				;;
			*)
				erreurSelection=1
				;;
	esac
	

done

clear