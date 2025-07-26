#!/bin/bash

# ────────────────────────────────────────────────────────────
# Initial settings
# ────────────────────────────────────────────────────────────
USERS=("richard" "ansible")
SSH_CONFIG="/etc/ssh/sshd_config"

echo "Updating system..."
dnf update -y

# ────────────────────────────────────────────────────────────
# User creation
# ────────────────────────────────────────────────────────────
for USER in "${USERS[@]}"; do
    if id "$USER" &>/dev/null; then
        echo "User '$USER' already exists. Skipping..."
    else
        echo "Creating user: $USER"
        adduser "$USER"
        echo "Setting password for: $USER"
        passwd "$USER"
        usermod -aG wheel "$USER"
    fi
done

# ────────────────────────────────────────────────────────────
# SSH Hardening
# ────────────────────────────────────────────────────────────
echo "Configuring SSH Security..."

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"


# ────────────────────────────────────────────────────────────
# Finishing
# ────────────────────────────────────────────────────────────
cat <<EOF

Initial setup complete.

Next steps:
- Copy SSH keys
- Restart SSH:
  systemctl restart sshd

EOF
