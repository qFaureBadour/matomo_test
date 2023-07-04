#!/bin/bash

# Colors and helpers
C_WHITE="\033[38;5;15m"
C_YELLOW="\033[38;5;11m"
C_LIME="\033[38;5;10m"
C_DODGERBLUE2="\033[38;5;27m"
END_FORMAT="\033[0m"

# get package infos
PACKAGE_NAME="@rhinos-solutions/corn-nuxt"
PACKAGE_OUTDATED_LINE=$(npm outdated $PACKAGE_NAME | grep "$PACKAGE_NAME")

if [[ $PACKAGE_OUTDATED_LINE != '' ]]; then
  arrIN=(${PACKAGE_OUTDATED_LINE//\s+/});

  CURRENT_PACKAGE_VERSION=${arrIN[1]};
  WANTED_PACKAGE_VERSION=${arrIN[2]};

  echo $CURRENT_PACKAGE_VERSION, $WANTED_PACKAGE_VERSION

  # Check if the package have a wanted version
  if [ ${CURRENT_PACKAGE_VERSION} != ${WANTED_PACKAGE_VERSION} ]; then
    echo -e "${C_YELLOW}
                                   ____ ___  ____  _   _ 
                                  / ___/ _ \|  _ \| \ | |
                                 | |  | | | | |_) |  \| |
                                 | |__| |_| |  _ <| |\  |
                                  \____\___/|_| \_\_| \_|
  ${C_WHITE}                                                        
  ----------------------------------------------------------------------------------------\n
    Votre projet semble avoir besoin de ${C_DODGERBLUE2}${PACKAGE_NAME}@${WANTED_PACKAGE_VERSION}${C_WHITE} (actuellement ${CURRENT_PACKAGE_VERSION})
    ${C_LIME}npm install${C_WHITE} ou ${C_LIME}npm update${C_WHITE} afin de vous mettre à jour\n
  ----------------------------------------------------------------------------------------${END_FORMAT}\n";
    read -n 1 -s -r -p "Press any key to continue..."
  fi
fi
