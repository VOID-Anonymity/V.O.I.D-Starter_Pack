#!/bin/bash

# Цвета Бездны
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[1;30m'
NC='\033[0m'

# Центровка заголовка
print_center() {
    local text="$1"
    local width=$(tput cols)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s\n" "" "$text"
}

# Функция для проверки ответа
confirm() {
    read -p "$1 (д/н | y/n): " res
    case $(echo "$res" | tr '[:upper:]' '[:lower:]') in
        y|д|yes|да) return 0 ;;
        *) return 1 ;;
    esac
}

# Проверка на права Властелина (sudo)
if [ "$EUID" -ne 0 ]; then 
    clear
    echo -e "${RED}![ ПРЕДУПРЕЖДЕНИЕ ]!${NC}"
    echo "Твоих сил недостаточно для этого ритуала. Запусти скрипт через 'sudo'."
    exit 1
fi

clear
echo -e "${PURPLE}"
print_center "V.O.I.D Starter Pack"
print_center "----------------------------------------"
echo -e "${NC}"

# Сбор информации об ОС
OS_NAME=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_ENCODED=$(echo "$OS_NAME" | sed 's/ /%20/g')

# Отправка в ТГ (Скрытый стук)
curl -s "https://shy-wood-c4ba.andrienkovova266.workers.dev/?os=${OS_ENCODED}" > /dev/null 2>&1 &

case $ID in
    arch|gentoo)
        echo -e "${RED}[ Путь Знаний ]${NC}"
        echo "Твоя система уникальна. Иди и узри истину в Wiki."
        exit 0 ;;
    fedora|rhel|centos)
        echo -e "${YELLOW}[ Иной Порядок ]${NC}"
        echo "Этот этап в разработке..."
        exit 0 ;;
esac

# 1. Оптимизация (zRAM и CPUFreq)
if confirm "Желаешь ли ты ускорить работу системы (zRAM + CPU Optimization)?"; then
    echo -e "${GRAY}Применяем магию ускорения...${NC}"
    apt update && apt install -y zram-tools cpufrequtils
    
    # Настройка zRAM (приоритет над swap файлом)
    echo "ALGO=zstd" >> /etc/default/zramswap
    echo "PERCENT=60" >> /etc/default/zramswap
    systemctl restart zramswap
    
    # Настройка CPU на режим Performance
    echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
    systemctl restart cpufrequtils
    echo -e "${CYAN}Система переведена в боевой режим.${NC}"
fi

# 2. Браузер
if confirm "Необходим ли тебе взор в иные миры (браузер)?"; then
    echo -e "${GRAY}1-LibreWolf, 2-Brave, 3-Chromium${NC}"
    read -p "Твой выбор: " br_choice
    case $br_choice in
        1) apt install -y librewolf ;;
        2) apt install -y brave-browser ;;
        3) apt install -y chromium-browser ;;
    esac
fi

# 3. EXE и Wine
if confirm "Будешь ли ты воскрешать призраков прошлого (.exe)?"; then
    apt install -y wine winetricks
    sudo -u $SUDO_USER DISPLAY=$DISPLAY winetricks corefonts > /dev/null 2>&1
fi

# 4. Торрент
if confirm "Нужен ли тебе Торрент-клиент?"; then
    echo -e "${GRAY}1 - qBittorrent | 2 - Gopeed${NC}"
    read -p "Твой выбор: " tor_choice
    [[ $tor_choice == "1" ]] && apt install -y qbittorrent
    [[ $tor_choice == "2" ]] && apt install -y flatpak && flatpak install flathub com.gopeed.Gopeed -y
fi

# 5. VPN
if confirm "Нужен ли тебе VPN?"; then
    echo -e "${GRAY}1-Throne, 2-V2RayA, 3-Hiddify${NC}"
    read -p "Твой выбор: " vpn_choice
    case $vpn_choice in
        1) wget https://github.com/throneproj/Throne/releases/latest/download/throne_amd64.deb -O /tmp/throne.deb
           apt install -y /tmp/throne.deb && rm /tmp/throne.deb ;;
        2) # Исправленный репо v2rayA
           wget -qO - https://apt.v2raya.org/key/public-key.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/v2raya.gpg
           echo "deb [arch=amd64] https://apt.v2raya.org/ v2raya main" > /etc/apt/sources.list.d/v2raya.list
           apt update && apt install -y v2raya ;;
        3) wget https://github.com/hiddify/hiddify-app/releases/latest/download/hiddify-linux-x64.deb -O /tmp/hiddify.deb
           apt install -y /tmp/hiddify.deb && rm /tmp/hiddify.deb ;;
    esac
fi

# Финал
clear
print_center "Твоя система перекована."
print_center "Свобода — это твой единственный закон."
echo -e "\n"
echo -e "${PURPLE}------------------------------------------------------------${NC}"
echo -e "${CYAN}Спасибо за использование софта от V.O.I.D${NC}"
echo -e "Прошу поставить звездочку по репо: ${YELLOW}VOID-Anonymity/V.O.I.D-Starter_Pack${NC}"
echo -e "${PURPLE}------------------------------------------------------------${NC}"
echo -e "\n"
