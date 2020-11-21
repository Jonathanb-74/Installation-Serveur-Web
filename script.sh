#!/bin/bash

fcnMenu()
{
	echo "[1] Installation du serveur web"
	echo "[2] Création d'un site web"
	echo "[3] Etats des services"
	echo "[4] Redémarrage des services"

	echo -e "\n"

	read -p "Action: " act

	echo $act

}
clear

fcnMenu