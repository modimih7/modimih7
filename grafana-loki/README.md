## How To Install Grafana Loki on Ubuntu.

## Introduction

=> Grafana Loki is an open-source, horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. Unlike other log aggregation systems, Loki is designed to index only the metadata of logs (such as labels), not the full log content.

## Following this steps for Grafana Loki Installation.

## Step 1 — Your system update and upgrade.

     sudo apt-get update
     sudo apt-get upgrade

## Step 2 — Install dependencies:

=> Ensure you have wget and curl installed:

     sudo apt install wget curl -y

## Step 3 - Download and install Loki:

=> Download the latest version of Loki from the official Loki releases page. Replace v2.8.2 with the latest version if necessary.

     wget https://github.com/grafana/loki/releases/download/v2.8.2/loki-linux-amd64.zip
     unzip loki-linux-amd64.zip
     sudo mv loki-linux-amd64 /usr/local/bin/loki
     sudo chmod +x /usr/local/bin/loki

## Step 4 - Create a configuration file:

=> Create a directory for Loki configuration:

     sudo mkdir /etc/loki

=> Create a configuration file:

     sudo nano /etc/loki/loki-config.yaml

=> Here's a basic example of the configuration:

     auth_enabled: false

     server:
     http_listen_port: 3100

     ingester:
     lifecycler:
     address: 127.0.0.1
     ring:
          kvstore:
          store: inmemory
          replication_factor: 1
     final_sleep: 0s
     chunk_idle_period: 5m
     chunk_retain_period: 30s
     max_transfer_retries: 0

     schema_config:
     configs:
     - from: 2020-10-24
          store: boltdb
          object_store: filesystem
          schema: v11
          index:
          prefix: index_
          period: 168h

     storage_config:
     boltdb:
     directory: /loki/index
     filesystem:
     directory: /loki/chunks

     limits_config:
     enforce_metric_name: false
     reject_old_samples: true
     reject_old_samples_max_age: 168h

     chunk_store_config:
     max_look_back_period: 0s

     table_manager:
     retention_deletes_enabled: true
     retention_period: 168h


## Step 5 - Create Loki directories and set permissions:

     sudo mkdir -p /loki/index /loki/chunks
     sudo chown -R $USER:$USER /loki

## Step 6 - Create a systemd service:

     sudo nano /etc/systemd/system/loki.service

=> Add the following content:

     [Unit]
     Description=Loki Service
     After=network.target

     [Service]
     ExecStart=/usr/local/bin/loki -config.file /etc/loki/loki-config.yaml
     Restart=on-failure

     [Install]
     WantedBy=multi-user.target

## Step 7 - Start and enable Loki service:

     sudo systemctl daemon-reload
     sudo systemctl start loki
     sudo systemctl enable loki

## Step 8 - Verify Loki is running:

     sudo systemctl status loki