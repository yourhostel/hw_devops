#!/usr/bin/env bash

# Basic text colors without the "m" at the end
BLACK_TEXT='\033[0;30'
RED_TEXT='\033[0;31'
GREEN_TEXT='\033[0;32'
YELLOW_TEXT='\033[0;33'
BLUE_TEXT='\033[0;34'
MAGENTA_TEXT='\033[0;35'
CYAN_TEXT='\033[0;36'
WHITE_TEXT='\033[0;37'

# Text colors with high intensity without the "m" at the end
BRIGHT_BLACK_TEXT='\033[0;90'
BRIGHT_RED_TEXT='\033[0;91'
BRIGHT_GREEN_TEXT='\033[0;92'
BRIGHT_YELLOW_TEXT='\033[0;93'
BRIGHT_BLUE_TEXT='\033[0;94'
BRIGHT_MAGENTA_TEXT='\033[0;95'
BRIGHT_CYAN_TEXT='\033[0;96'
BRIGHT_WHITE_TEXT='\033[0;97'

# Background colors without "\033[0;" at the start, with a semicolon before "m"
BG_BLACK=';40m'
BG_RED=';41m'
BG_GREEN=';42m'
BG_YELLOW=';43m'
BG_BLUE=';44m'
BG_MAGENTA=';45m'
BG_CYAN=';46m'
BG_WHITE=';47m'

# Background colors with high intensity without "\033[0;" at the start, with a semicolon before "m"
BG_BRIGHT_BLACK=';100m'
BG_BRIGHT_RED=';101m'
BG_BRIGHT_GREEN=';102m'
BG_BRIGHT_YELLOW=';103m'
BG_BRIGHT_BLUE=';104m'
BG_BRIGHT_MAGENTA=';105m'
BG_BRIGHT_CYAN=';106m'
BG_BRIGHT_WHITE=';107m'

# Prefix for background colors and postfix to complete the color
PREFIX='\033[0;'
POSTFIX='m'
NC='\033[0m'

# Arrays of text and background colors
text_colors=(BLACK_TEXT RED_TEXT GREEN_TEXT YELLOW_TEXT BLUE_TEXT MAGENTA_TEXT CYAN_TEXT WHITE_TEXT BRIGHT_BLACK_TEXT BRIGHT_RED_TEXT BRIGHT_GREEN_TEXT BRIGHT_YELLOW_TEXT BRIGHT_BLUE_TEXT BRIGHT_MAGENTA_TEXT BRIGHT_CYAN_TEXT BRIGHT_WHITE_TEXT)
bg_colors=(BG_BLACK BG_RED BG_GREEN BG_YELLOW BG_BLUE BG_MAGENTA BG_CYAN BG_WHITE BG_BRIGHT_BLACK BG_BRIGHT_RED BG_BRIGHT_GREEN BG_BRIGHT_YELLOW BG_BRIGHT_BLUE BG_BRIGHT_MAGENTA BG_BRIGHT_CYAN BG_BRIGHT_WHITE)

# Demonstrating all text colors without background
for text_color in "${text_colors[@]}"; do
    eval text=\$$text_color
    # Displaying text only with text color, using postfix
    echo -e "${text}${POSTFIX}This is just ${text_color}${NC}"
done

echo -e "\n---\n"

# Demonstrating all combinations of text and background
for text_color in "${text_colors[@]}"; do
    for bg_color in "${bg_colors[@]}"; do
        eval text=\$$text_color
        eval bg=\$$bg_color
        # Displaying text with specified text color on specified background
        echo -e "${text}${bg}This is ${text_color} on ${bg_color}${NC}"
    done
done

echo -e "\n---\n"

# Demonstrating all background colors with default text
for bg_color in "${bg_colors[@]}"; do
    eval bg=\$$bg_color
    # Displaying text on background, using prefix for background
    echo -e "${PREFIX}${bg}This is default text on ${bg_color}${NC}"
done

