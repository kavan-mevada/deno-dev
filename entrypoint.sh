#!/bin/bash

# If an SSH public key is provided via environment variable, add it to authorized_keys
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" >> /home/denodev/.ssh/authorized_keys
    chmod 600 /home/denodev/.ssh/authorized_keys
    chown denodev:denodev /home/denodev/.ssh/authorized_keys
    echo "Authorized SSH public key injected successfully."
fi

# Start the SSH server in the background or foreground depending on needs
echo "Starting SSH server..."
exec /usr/sbin/sshd -D