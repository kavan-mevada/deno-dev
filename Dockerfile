FROM denoland/deno:debian

# Install OpenSSH server, sudo, git, and clean up apt cache to keep image slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure the SSH daemon runtime directory
RUN mkdir /var/run/sshd

# Create a non-root developer user (e.g., 'denodev') with sudo privileges
RUN useradd -ms /bin/bash denodev && \
    echo "denodev:developmentpassword" | chpasswd && \
    adduser denodev sudo

# Ensure passwordless or standard sudo rights for development tasks if needed
RUN echo "denodev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup SSH directory for key-based authentication
RUN mkdir -p /home/denodev/.ssh && \
    chmod 700 /home/denodev/.ssh && \
    chown -R denodev:denodev /home/denodev/.ssh

# Expose Deno development port and SSH port
EXPOSE 22 8000

# Copy and use an entrypoint script to start SSH daemon safely
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]