# Set global values
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

function install {
    printf "\033c"
    header "TUX GAMES" "$1"
    echo "This will install the following classics:"
    echo "  - SuperTux                          (A lot like Super Mario)"
    echo "  - SuperTuxKart                      (A lot like Mario Kart)"
    echo "  - Extreme Tux Racer                 (Help Tux slide down slopes)"
    echo "  - FreedroidRPG                      (Sci-fi isometric role playing)"
    echo "  - WarMUX                            (A lot like Worms)"
    echo ""
    check_sudo
    echo "Ready to try some gaming with The TUX!?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "TUX GAMES" "$1"
                printf "${YELLOW}Initiating TUX Games installation...${NC}\n"
                install_if_not_found "supertux supertuxkart extremetuxracer freedroidrpg warmux"
                printf "${LIGHT_GREEN}Successfully installed the TUX Games.${NC}\n"
                break;;
            No ) printf "\033c"
                header "TUX GAMES" "$1"
                echo "The sound of Tux flapping with his feets slowly turns silent when he realizes" 
                echo "your response... He shrugs and answer with a lowly voice 'ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
    exit
}

function uninstall { 
    printf "\033c"
    header "TUX GAMES" "$1"
    echo "This will uninstall the following games:"
    echo "  - SuperTux                          (A lot like Super Mario)"
    echo "  - SuperTuxKart                      (A lot like Mario Kart)"
    echo "  - ExtremeTuxRacer                   (Help Tux slide down slopes)"
    echo "  - FreedroidRPG                      (Sci-fi isometric role playing)"
    echo "  - WarMUX                            (A lot like Worms)"
    echo ""
    check_sudo
    printf "${LIGHT_RED}Really sure about this?${NC}\n"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "TUX GAMES" "$1"
                echo "Initiating Tux Games uninstall..."
                uninstall_if_found "supertux supertuxkart extremetuxracer freedroidrpg warmux"
                sudo apt -y autoremove
                printf "${LIGHT_GREEN}Successfully uninstalled the TUX Games.${NC}\n"
                break;;
            No ) printf "\033c"
                header "TUX GAMES" "$1"
                echo "The sound of Tux flapping with his feets slowly turns silent when he realizes" 
                echo "your response... He shrugs and answer with a lowly voice 'ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
    exit
}

function header {
    var_size=${#1}
    # 80 is a full width set by us (to work in the smallest standard terminal window)
    if [ $STEPCOUNTER = false ]; then
        # 80 - 2 - 1 = 77 to allow space for side lines and the first space after border.
        len=$(expr 77 - $var_size)
    else   
        # "Step X/X " is 9
        # 80 - 2 - 1 - 9 = 68 to allow space for side lines and the first space after border.
        len=$(expr 68 - $var_size)
    fi
    ch=' '
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║"
    printf " ${YELLOW}$1${NC}"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "${LIGHT_GREEN}$2${NC}
        printf "/5 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        printf "Oh, TUX will ask below about sudo rights to copy and install everything...\n\n"
    fi
}

function install_if_not_found { 
    # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
    for pkg in $1; do
        if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
            echo -e "$pkg is already installed"
        else
            printf "${YELLOW}Installing $pkg.${NC}\n"
            if sudo apt-get -qq --allow-unauthenticated install $pkg; then
                printf "${YELLOW}Successfully installed $pkg${NC}\n"
            else
                printf "${LIGHT_RED}Error installing $pkg${NC}\n"
            fi        
        fi
    done
}

function uninstall_if_found { 
    # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
    for pkg in $1; do
        if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
            echo "Uninstalling $pkg."
            if sudo apt-get remove $pkg; then
                printf "${YELLOW}Successfully uninstalled $pkg${NC}\n"
            else
                printf "${LIGHT_RED}Error uninstalling $pkg${NC}\n"
            fi        
        else
            printf "${LIGHT_RED}$pkg is not installed${NC}\n"
        fi
    done
}

function goto_tux4ubuntu_org {
    echo ""
    printf "${YELLOW}Launching website in your favourite browser...${NC}\n"
    x-www-browser https://tux4ubuntu.org/portfolio/games &
    echo ""
    sleep 2
    read -n1 -r -p "Press any key to continue..." key
    exit
}

while :
do
    clear
    if [ -z "$1" ]; then
        :
    else
        STEPCOUNTER=true
    fi
    header "TUX GAMES" "$1"
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    cat<<EOF                                                                              
Type one of the following numbers/letters:          
                                                                            
1) Install                                - Install Desktop themes          
2) Uninstall                              - Uninstall Desktop themes       
--------------------------------------------------------------------------------
3) Read Instructions                      - Open up tux4ubuntu.org      
--------------------------------------------------------------------------------   
Q) Skip                                   - Quit Desktop theme installer 

(Press Control + C to quit the installer all together)
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    install $1;;
    "2")    uninstall $1;;
    "3")    goto_tux4ubuntu_org;;
    "S")    exit                      ;;
    "s")    exit                      ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done