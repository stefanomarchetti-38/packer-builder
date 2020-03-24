#!/bin/sh

# Download the template tar.gz package from the vRealize Automation appliance.
# If your environment is using self-signed certificates, you might need the --no-check-certificate option.

wget --no-check-certificate https://prdinfvra001imo.yoox.net/software/download/prepare_vra_template_linux.tar.gz
# wget https://prdinfvra001imo.yoox.net/software/download/prepare_vra_template_linux.tar.gz

# Untar the package.
tar -xvzf prepare_vra_template_linux.tar.gz

# In the untar output, find the installer script, and make it executable. Not necessary
chmod +x prepare_vra_template_linux/prepare_vra_template.sh

# Run the installer script.
#
# -m <ManagerServiceHost>  Hostname/IP/VIP of vRealize Manager Service
# -M <ManagerServicePort>  Port of vRealize Manager Service - (default to use port 443)
# -a <ApplianceServer>     Hostname/IP/VIP of vRealize Appliance
# -A <AppliancePort>       Port of vRealize Appliance-  (default to use port 443)
# -t <seconds>             Timeout for download attempts (Default 300)
# -f <ManagerFingerprint>  Manager Service RSA key fingerprint
#               Command used to extract: echo | openssl s_client -connect prdinfvrm001imo.yoox.net:443 | openssl x509 -fingerprint -sha1 2> /dev/null | sed -ne 's/\(.*\)=\(.*\)/\2/p'
# -g <ApplianceFingerprint>vRealize Appliance RSA key fingerprint
#               Command used to extract: echo | openssl s_client -connect prdinfvra001imo.yoox.net:443 | openssl x509 -fingerprint -sha1 2> /dev/null | sed -ne 's/\(.*\)=\(.*\)/\2/p'
# -j <true/false>          Install Java JRE Runtime (Default false)
# -c                       Cloud Provider (Default vsphere) Valid values are: 'vsphere', 'vca', 'vcd', 'ec2', 'azure',
# -n                       Disable Interactive Mode
# -e                       Use default wget or curl from the environment
# -o                       Use default openssl from the environment
# -u                       Uninstall gugent/agent from template
#
./prepare_vra_template_linux/prepare_vra_template.sh \
  -m "prdinfvrm001imo.yoox.net" \
  -M "443" \
  -a "prdinfvra001imo.yoox.net" \
  -A "443" \
  -f "6D:E0:06:E0:D0:88:9D:E6:8D:D4:16:E6:AF:3A:13:28:F5:55:42:A7" \
  -g "95:8E:60:B4:5A:DA:32:DF:8E:F6:F0:6D:08:F7:38:48:84:93:99:5A" \
  -c "vsphere" \
  -n \
  -e \
  -o
