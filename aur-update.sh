#!/bin/bash
pacman -Qqm | xargs bash <(curl aur.sh) -si --needed
