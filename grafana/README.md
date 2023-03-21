## How To Install Grafana on Ubuntu.

## Introduction

=> Grafana is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources.

## Following this steps for Grafana Installation.

## Step 1 — Your system update and upgrade.

     sudo apt-get update
     sudo apt-get upgrade

## Step 2 — Add Grafana APT repository

=> curl -fsSL https://packages.grafana.com/gpg.key|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/grafana.gpg

     sudo apt install -y gnupg2 curl software-properties-common
     curl -fsSL https://packages.grafana.com/gpg.key|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/grafana.gpg

=> curl -fsSL https://packages.grafana.com/gpg.key|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/grafana.gpg

     sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

## Step 3 - Install Grafana on Ubuntu

=> Once the repository is added, proceed to update your Apt repositories and install Grafana.

     sudo apt update
     sudo apt -y install grafana

## Step 4 - Now the following step is to instruct systemd to enable and start the service.

     sudo systemctl enable grafana-server
     sudo systemctl start grafana-server
     sudo systemctl status grafana-server
     sudo journalctl -fu grafana-server (log check command)


## Step 5 - Open Port on Firewall (Optional)

=> Grafana default http port is 3000, you’ll need to allow access to this port on the firewall.

     sudo apt -y install ufw

=> Then enable the firewall service:

     sudo ufw enable

=> Open the port on the firewall:

     sudo ufw allow ssh
     sudo ufw allow 3000/tcp

=> To allow access only from a specific subnet, use:

     sudo ufw allow from 192.168.50.0/24 to any port 3000

## Step 6 - Access Grafana Dashboard on Ubuntu

=> Access Grafana Dashboard using the server IP address or hostname and port 3000.

![newgrafana](https://user-images.githubusercontent.com/89242355/226573567-5625cd6b-dc2f-4b36-a6f0-a6fbd7d52a6f.png)

=> Default logins are:

     Username: admin
     Password: admin

=> Remember to change admin password from default admin. Login and navigate to:
