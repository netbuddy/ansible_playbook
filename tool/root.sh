#!/bin/bash

useradd -s /bin/bash -d /home/public -m public
passwd public
cat >> /etc/sudoers <<<'public  ALL=(ALL:ALL) NOPASSWD:ALL'