#!/bin/bash

# Verify if the user is root while running the script
if [ "$EUID" -ne 0 ]; then
  echo -e "\nYou are not root. Run this script as root.\n"
  exit 1
fi

# List the available regions
REGIONS=("Africa" "Europe" "America" "Asia")

# Print the regions to select
echo -e "\nSelect the following region:\n"
for i in "${!REGIONS[@]}"; do
  echo "$((i+1))) ${REGIONS[$i]}"
done

# Ask the user to choose the region with validation
while true; do
  read -e -p "Enter the number of the region you want (1-4): " REGION_CHOICE
  # Validate user input (must be a number between 1 and 4)
  if [[ "$REGION_CHOICE" =~ ^[1-4]$ ]]; then
    break  # Exit the loop if the choice is valid
  else
    echo -e "\nInvalid choice. Please select a number between 1 and 4.\n"
  fi
done

# Get the selected region
SELECTED_REGION="${REGIONS[$((REGION_CHOICE-1))]}"
echo -e "\nSelected region: $SELECTED_REGION.\n"

# List the timezones for the selected region
echo -e "\nAvailable timezones for $SELECTED_REGION:\n"
timedatectl list-timezones | grep "^$SELECTED_REGION/"

# Ask the user to select a timezone with validation
while true; do
  read -e -p "Select the exact timezone (e.g., Europe/Paris): " SELECTED_TIMEZONE
  # Check if the timezone is valid
  if timedatectl list-timezones | grep -q "^$SELECTED_TIMEZONE$"; then
    break  # Exit the loop if the timezone is valid
  else
    echo -e "\nTimezone '$SELECTED_TIMEZONE' is not valid. Please try again.\n"
  fi
done

# Configure the timezone
echo -e "\nSetting the timezone to: $SELECTED_TIMEZONE ..."
timedatectl set-timezone "$SELECTED_TIMEZONE"

# Confirm the timezone change
echo -e "\nThe timezone has been set to: $(timedatectl show -p Timezone --value)\n"

# Print the current status of timedatectl
echo "Current status of timedatectl:"
timedatectl
echo -e "\n"

exit 0
