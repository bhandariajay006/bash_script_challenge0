#!/bin/bash

# Function to display usage information
display_usage() {
    echo "Usage: $0 [-c|--create] [-d|--delete] [-r|--reset] [-l|--list] [-h|--help]"
    echo "Options:"
    echo "  -c, --create     Create a new user account"
    echo "  -d, --delete     Delete an existing user account"
    echo "  -r, --reset      Reset password for an existing user account"
    echo "  -l, --list       List all user accounts"
    echo "  -h, --help       Display this help message"
}

# Function to create a new user account
create_account() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo "Error: User '$username' already exists."
    else
        read -p "Enter password: " -s password
        echo
        sudo useradd -m -s /bin/bash $username
        echo -e "$password\n$password" | sudo passwd $username &>/dev/null
        echo "User '$username' created successfully."
    fi
}

# Function to delete an existing user account
delete_account() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r $username
        echo "User '$username' deleted successfully."
    else
        echo "Error: User '$username' does not exist."
    fi
}

# Function to reset password for an existing user account
reset_password() {
    read -p "Enter username to reset password: " username
    if id "$username" &>/dev/null; then
        read -p "Enter new password: " -s password
        echo
        echo -e "$password\n$password" | sudo passwd $username &>/dev/null
        echo "Password for user '$username' reset successfully."
    else
        echo "Error: User '$username' does not exist."
    fi
}

# Function to list all user accounts with detailed information
list_accounts() {
    echo "User Accounts:"
    echo "--------------------------"
    printf "%-20s %-10s %-20s %-20s\n" "Username" "User ID" "Home Directory" "Shell"
    echo "--------------------------"
    awk -F ":" '{ printf "%-20s %-10s %-20s %-20s\n", $1, $3, $6, $7 }' /etc/passwd
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -c|--create)
            create_account
            exit 0
            ;;
        -d|--delete)
            delete_account
            exit 0
            ;;
        -r|--reset)
            reset_password
            exit 0
            ;;
        -l|--list)
            list_accounts
            exit 0
            ;;
        -h|--help)
            display_usage
            exit 0
            ;;
        *)
            echo "Error: Invalid option '$key'."
            display_usage
            exit 1
            ;;
    esac
    shift
done

# Display usage if no options provided
if [[ $# -eq 0 ]]; then
    display_usage
    exit 1
fi
