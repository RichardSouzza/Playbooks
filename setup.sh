#!/bin/bash

# ────────────────────────────────────────────────────────────
# Initial settings
# ────────────────────────────────────────────────────────────
USERS=("richard" "ansible")
SSH_CONFIG="/etc/ssh/sshd_config"

log_info()    { echo -e "\e[1;34m[INFO] $1\e[0m"; }
log_success() { echo -e "\e[1;32m[SUCCESS] $1\e[0m"; }
log_warn()    { echo -e "\e[1;33m[WARNING] $1\e[0m"; }
log_error()   { echo -e "\e[1;31m[ERROR] $1\e[0m"; }
separator() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '='
}

log_info "Updating system..."
dnf update -y

# ────────────────────────────────────────────────────────────
# User creation
# ────────────────────────────────────────────────────────────
separator
for USER in "${USERS[@]}"; do
    if id "$USER" &>/dev/null; then
        log_warn "User '$USER' already exists. Skipping..."
    else
        log_info "Creating user: $USER"
        adduser "$USER"
        log_info "Setting password for: $USER"
        passwd "$USER"
        usermod -aG wheel "$USER"
    fi
done

# ────────────────────────────────────────────────────────────
# SSH Hardening
# ────────────────────────────────────────────────────────────
separator
log_info "Configuring SSH Security..."

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"


# ────────────────────────────────────────────────────────────
# Finishing
# ────────────────────────────────────────────────────────────
separator
echo -e "\e[1;32m[SUCCESS] Initial setup complete.\e[0m

Next steps:
- Copy SSH keys
- Restart SSH
"
