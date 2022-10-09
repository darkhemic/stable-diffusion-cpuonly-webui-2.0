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

# Checks to see which mode Ultimate Stable Diffusion is running in: STANDARD or OPTIMIZED
# Then asks the user which mode they wish to use
gradio_stable_diffusion_arguments () {
    if [ "$1" = "customize" ]; then
        printf "Do you want extra upscaling models to be run on the CPU instead of the GPU to save on VRAM at the cost of speed?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting extra upscaling models to use the CPU...\n"; sed -i 's/extra_models_cpu = False/extra_models_cpu = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Extra upscaling models will run on the GPU. Continuing...\n"; sed -i 's/extra_models_cpu = True/extra_models_cpu = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want for Stable Diffusion cpuonly webui 2.0 to automatically launch a new browser window or tab on first launch?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Stable Diffusion cpuonly webui 2.0 to open a new browser window/tab at first launch...\n"; sed -i 's/open_in_browser = False/open_in_browser = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Stable Diffusion cpuonly webui 2.0 will not open automatically in a new browser window/tab. Continuing...\n"; sed -i 's/open_in_browser = True/open_in_browser = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to run Ultimate Stable Diffusion in Optimized mode - Requires only 4GB of VRAM, but is significantly slower?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to run in Optimized Mode...\n"; sed -i 's/optimized = False/optimized = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will launch in Standard Mode. Continuing...\n"; sed -i 's/optimized = True/optimized = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to start Ultimate Stable Diffusion in Optimized Turbo mode - Requires more VRAM than regular optimized, but is faster (incompatible with Optimized Mode)?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Stable Diffusion cpuonly webui 2.0 to run in Optimized Turbo mode...\n"; sed -i 's/optimized_turbo = False/optimized_turbo = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Stable Diffusion cpuonly webui 2.0 will launch in Standard Mode. Continuing...\n"; sed -i 's/optimized_turbo = True/optimized_turbo = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to create a public xxxxx.gradi.app URL to allow others to uses your interface? (Requires properly forwarded ports)\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Stable Diffusion cpuonly webui 2.0 to open a public share URL...\n"; sed -i 's/share = False/share = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Setting Stable Diffusion cpuonly webui 2.0 to not open a public share URL. Continuing...\n"; sed -i 's/share = True/share = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\nCustomization of Stable Diffusion cpuonly webui 2.0 is complete. Continuing...\n\n"
    else
        printf "\n\n########## GRADIO CUSTOMIZATION ##########\nPlease Note: These Arguments Only Affect The Gradio Interface Version Of The Stable Diffusion Webui.\n\n"
        printf "Do you wish to customize the launch arguments for the Gradio Webui Interface?\n"
        printf "(This will be where you select Optimized mode, auto open in browser, share to public, and more.)\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Starting customization of Gradio Interface launch arguments...\n"; gradio_stable_diffusion_arguments customize; break;;
                No ) printf "Maintaining current Gradio Interface launch arguments...\n"; break;;
            esac
        done
    fi    
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

