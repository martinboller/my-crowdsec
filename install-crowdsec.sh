#!/bin/bash

#############################################################################
#                                                                           #
# Last Update:  2023-02-04                                                  #
# Version:      1.00                                                        #
#                                                                           #
# Changes:      Initial Version (1.00)                                      #
#                                                                           #
#                                                                           #
#############################################################################

install_crowdsec() {
    echo -e "\e[1;32m--------------------------------------------\e[0m";
    echo -e "\e[1;32m - Installing Crowdsec Agent and Netfilter Firewall Bouncer\e[0m";
    echo -e "\e[1;36m - Adding Crowdsec repo\e[0m";
	# Add repo
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash  > /dev/null 2>&1
    echo -e "\e[1;36m - Installing Crowdsec Agent\e[0m";
    #install crowdsec core daemon
    apt-get -qq -y install crowdsec > /dev/null 2>&1
    echo -e "\e[1;36m - Installing Netfilter Firewall Bouncer\e[0m";
    # install firewall bouncer
    apt-get -qq -y install crowdsec-firewall-bouncer-nftables > /dev/null 2>&1
	sync;
}


install_modules() {
    echo -e "\e[1;32m--------------------------------------------\e[0m";
    echo -e "\e[1;32m - Installing Modules\e[0m";

    echo -e "\e[1;36m - Adding Parsers\e[0m";
	cscli parsers install crowdsecurity/geoip-enrich
	cscli parsers install crowdsecurity/sshd-logs
	cscli parsers install crowdsecurity/sshd-logs
	cscli parsers install mstilkerich/bind9-logs

    echo -e "\e[1;36m - Adding Postoverflows\e[0m";
	cscli postoverflows install crowdsecurity/rdns

    echo -e "\e[1;36m - Adding Collections\e[0m";
	cscli collections install mstilkerich/bind9
	cscli collections install crowdsecurity/linux
	cscli collections install mstilkerich/bind9

    echo -e "\e[1;36m - Adding Scenarios\e[0m";
	cscli scenarios install crowdsecurity/ssh-bf
	cscli scenarios install mstilkerich/bind9-refused
	cscli scenarios install crowdsecurity/http-backdoors-attempts
	cscli scenarios install crowdsecurity/ssh-slow-bf

    echo -e "\e[1;36m - Configuring autocomplete for Debian & Bash\e[0m";
	cscli completion bash | sudo tee -a /usr/share/bash-completion/bash_completion
	source ~/.bashrc
}

##################################################################################################################
## Main                                                                                                          #
##################################################################################################################

main() {
	install_crowdsec;
	install_modules;
}

main;

exit 0;