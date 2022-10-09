#!/bin/bash -i

# Linux Stable Diffusion Script

# Version: 2.0

# MIT License

# Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: https://rentry.org/linux-sd #####

# Confirmed working as of September 22nd, 2022. May be subject to breakage at a later date due to bleeding-edge updates in the Stable Diffusion WebUI repo
# Please see my GitHub for updates on this script: https://github.com/JoshuaKimsey/Linux-StableDiffusion-Script

printf "\n\n\n"
printf "WELCOME TO THE STABLE DIFFUSION CPU ONLY WEBUI 2.0 ON LINUX"
printf "\n\n"
printf "Please ensure you have Anaconda installed properly on your Linux system before running this."
printf "\n"
printf "Please refer to the original guide for more info and additional links for this project: https://rentry.org/guitard"
printf "\n\n"

DIRECTORY=./stable-diffusion-cpuonly-webui-2.0
REPO=https://github.com/darkhemic/stable-diffusion-cpuonly-webui-2.0.git
ENV=sdco2

stable_diffusion_cpuonly_webui_2_repo () {
    # Check to see if Ultimate Stable Diffusion repo is cloned
    if [ -d "$DIRECTORY" ]; then
        printf "\n\n########## CHECK FOR UPDATES ##########\n\n"
        printf "Stable Diffusion cpuonly webui 2.0 already exists. Do you want to update Stable Diffusion cpuonly webui 2.0?\n"
        printf "(This will reset your installation if you are experiencing issues)\n"
        printf "Pulling updates for the Stable Diffusion cpuonly webui 2.0. Please wait...\n"; stable_diffusion_cpuonly_webui_2_repo_update;         
    else
        printf "Cloning Stable Diffusion cpuonly webui 2.0. Please wait..."
        git clone https://github.com/darkhemic/stable-diffusion-cpuonly-webui-2.0.git
        cp $DIRECTORY/scripts/relauncher.py $DIRECTORY/scripts/relauncher-backup.py
    fi
}

stable_diffusion_cpuonly_webui_2_repo_update () {
    cd $DIRECTORY
    git fetch --all
    git reset --hard origin/master
    cp ./scripts/relauncher.py ./scripts/relauncher-backup.py
    cd ..;
}

linux_setup_script () {
    cd $DIRECTORY
    printf "Running webui.sh...\n\n"
    bash -i ./webui.sh
}

# Function to install and run the Ultimate Stable Diffusion fork
stable_diffusion_cpuonly_webui_2 () {
    if [ "$1" = "initial" ]; then
        stable_diffusion_cpuonly_webui_2_repo
        #gradio_stable_diffusion_arguments
        linux_setup_script
    else
        if [[ $(conda env list | grep "$ENV") = $ENV* ]]; then
            printf "\n\n########## RUN PREVIOUS SETUP ##########\n\n"
            printf "Do you wish to run Stable Diffusion cpuonly webui 2.0 with the previous parameters?\n"
            printf "(Select NO to update or fix your Stable Diffusion cpuonly webui 2.0 setup)\n"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) printf "Starting Stable Diffusion cpuonly webui 2.0 using previous parameters. Please wait..."; linux_setup_script; break;;
                    No ) printf "Beginning updating Stable Diffusion cpuonly webui 2.0..."; stable_diffusion_cpuonly_webui_2 initial; break;;
                esac
            done
        else
            printf "ERROR: Conda Env not found. Will attempt to rebuild, please go through the update steps below...\n"
            stable_diffusion_cpuonly_webui_2 initial
        fi
    fi
}

# Initialization 
if [ ! -d "$DIRECTORY" ]; then
    printf "Starting Stable Diffusion cpuonly webui 2.0 installation..."
    printf "\n"
    stable_diffusion_cpuonly_webui_2 initial
else
    stable_diffusion_cpuonly_webui_2
fi

