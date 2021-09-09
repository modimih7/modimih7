## Installing Fluent-Bit using ubuntu.

=> The first step is to add our server GPG key to your keyring, on that way you can get our signed packages.

    sudo wget -qO - https://packages.fluentbit.io/fluentbit.key | sudo apt-key add

=> On Ubuntu, you need to add our APT server entry to your sources lists, please add the following content at bottom of your /etc/apt/sources.list file.

    deb https://packages.fluentbit.io/ubuntu/focal focal main

=> Now let your system update the apt database.

    sudo apt-get update

=> Using the following apt-get command you are able now to install the latest td-agent-bit.

    sudo apt-get install td-agent-bit

=> Now the following step is to instruct systemd to enable the service:

    sudo systemctl start td-agent-bit
    sudo systemctl enable td-agent-bit
    sudo systemctl status td-agent-bit
# How to ubuntu server log move to aws cloudwatch in fluent-bit.

=> Following content at bottom of your /etc/td-agent-bit/td-agent-bit.conf file.

=> Example of td-agent-bit config file.

[INPUT]


- Name tail
- Path [log file directory]
- Tag [your tag name]

[OUTPUT]

- Name cloudwatch_logs
- Match [your input tag name]
- region [your region]
- log_group_name [your input tag name]
- log_stream_name [your input tag name]
- auto_create_group On

=> Add AWS access key id and secret key in the environment variable of td-agent-bit service file.

    sudo apt install awscli
    aws configure
    Environment=AWS_ACCESS_KEY_ID=
    Environment=AWS_SECRET_ACCESS_KEY=

=> This changes for your td-agent-bit service file.

- Environment=HOME=/home/ubuntu
- Environment=AWS_SHARED_CREDENTIALS_FILE=/home/ubuntu/.aws/credentials

=> Example of td-agent-service file (directory for the service file /lib/systemd/system)

[Unit]

- Description=TD Agent Bit
- Requires=network.target
- After=network.target

[Service]

- Type=simple
- ExecStart=/opt/td-agent-bit/bin/td-agent-bit -c /etc/td-agent-bit/td-agent-bit.conf
- Restart=always
- Environment=HOME=/home/ubuntu
- Environment=AWS_SHARED_CREDENTIALS_FILE=/home/ubuntu/.aws/credentials

[Install]

- WantedBy=multi-user.target

=> Now the following step is to instruct systemd to restart the service:

    sudo systemctl daemon-reload
    sudo systemctl restart td-agent-bit
    sudo systemctl status td-agent-bit
    sudo journalctl -fu td-agent-bit (log check command)

=> Error log filter configuration.

=> Example:-

[INPUT]

- Name tail
- Path [log file directory]
- Tag [your tag name]

[FILTER]

- name grep
- match [your tag name]
- regex log ERROR

[OUTPUT]

- Name cloudwatch_logs
- Match [your tag name]
- region eu-west-2
- log_group_name [your tag name]
- log_stream_name [your tag name]
- auto_create_group On