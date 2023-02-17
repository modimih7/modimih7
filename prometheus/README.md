## How To Install Prometheus on Ubuntu.

## Introduction

=> Prometheus is a powerful, open-source monitoring system that collects metrics from your services and stores them in a time-series database. It offers a multi-dimensional data model, a flexible query language, and diverse visualization possibilities through tools like Grafana.

=> By default, Prometheus only exports metrics about itself (e.g. the number of requests it’s received, its memory consumption, etc.). But, you can greatly expand Prometheus by installing exporters, optional programs that generate additional metrics.

## Following this steps for Prometheus Installation.

## Step 1 — Your system update and upgrade.

    sudo apt-get update
    sudo apt-get upgrade

## Step 2 — Using the following apt-get command you are able now to install the prometheus.

    sudo apt-get install prometheus

## Step 3 -  Now the following step is to instruct systemd to enable and start the service.

    sudo systemctl start prometheus
    sudo systemctl enable prometheus
    sudo systemctl status prometheus

## Step 4 - Check Prometheus Version

    prometheus --version
    promtool --version

## Step 4 — Prometheus configuration file location.

=> In the /etc/prometheus directory, and now for a check your prometheus.yml file in this directory.

    sudo nano /etc/prometheus/prometheus.yml

=> Warning: Prometheus’ configuration file uses the YAML format, which strictly forbids tabs and requires two spaces for indentation. Prometheus will fail to start if the configuration file is incorrectly formatted.

## Step 5 — Prometheus Service file location.

=> In the /lib/systemd/system directory, and now for a check your prometheus.service file in this directory.

## Step 6 — Accessing Prometheus.

=> Now as Prometheus installation and configuration is set up and it is ready to use we can access  its services via web interface.Also check weather port 9090 is UP in firewall.

=> Use below command to enable prometheus service in firewall

    sudo ufw allow 9090/tcp

=> Now Prometheus service is ready to run and we can access it from any web browser.

    http://server-IP-or-Hostname:9090.

<!-- ![prometheus](./prometheus.png) -->
![promethus](https://user-images.githubusercontent.com/89242355/219640535-cb45c7d3-abda-42a1-b7d8-5358f0a79c27.png)

=> As we can see the Prometheus dashboards, we can also check the target.As we can observe Current state is UP and we can also see the last scrape.


