#!/bin/bash
# NexusWorld - Oracle Cloud Free Tier Deployment Script
# Run on your Oracle Cloud Ubuntu instance

echo "=== NexusWorld Deploy Script ==="

# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt update && sudo apt install -y nginx
fi

# Create web directory
sudo mkdir -p /var/www/nexusworld

# Copy files
echo "Copying game files..."
sudo cp game.html /var/www/nexusworld/
sudo cp admin-panel.html /var/www/nexusworld/
sudo cp nginx.conf /etc/nginx/sites-available/nexusworld
sudo ln -sf /etc/nginx/sites-available/nexusworld /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Set permissions
sudo chown -R www-data:www-data /var/www/nexusworld
sudo chmod -R 755 /var/www/nexusworld

# Open firewall (Oracle Cloud requires this)
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo netfilter-persistent save 2>/dev/null || true

# Restart nginx
sudo nginx -t && sudo systemctl restart nginx

echo ""
echo "✅ Deploy xong!"
echo "🎮 Game:  http://$(curl -s ifconfig.me)"
echo "⚙  Admin: http://$(curl -s ifconfig.me)/admin"
echo ""
echo "📌 Nhớ mở port 80 trong Oracle Cloud Security List!"
