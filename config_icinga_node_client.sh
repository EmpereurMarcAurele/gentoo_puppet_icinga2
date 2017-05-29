#!/bin/bash

if [ "$#" -ne 4 ]; then
	echo "Usage: ./script [fqdn client] [fqdn master] [port master] [ticket]"
	echo "-fqdn client: fully host+domain name of the client."
	echo "-fqdn master: resolvable fqdn of the master or ip."
	echo "-port master: the port the master is connectable on.Default 5665"
	echo "-ticket: generated on the master via 'icinga2 pki ticket --cn fqdn_client'."
	exit 1
fi

$pki_dir="/etc/icinga2/pki"			#- /etc/icinga2/pki in the default installation
$fqdn=$1					#- fully host+domain name of the client.
$icinga2_master=$2 				#- resolvable fqdn of the master
$icinga2_master_port=$3 			#- the port the master is connectable on.
$ticket=$4					#- generated on the master via 'icinga2 pki ticket --cn $fqdn'

mkdir -v --mode=700 $pki_dir
chown -v icinga:icinga $pki_dir

icinga2 pki new-cert --cn $fqdn --key $pki_dir/$fqdn.key --cert $pki_dir/$fqdn.crt
icinga2 pki save-cert --key $pki_dir/$fqdn.key --cert $pki_dir/$fqdn.crt --trustedcert $pki_dir/trusted-master.crt --host $icinga2_master
icinga2 pki request --host $icinga2_master --port $icinga2_master_port --ticket $ticket --key $pki_dir/$fqdn.key --cert $pki_dir/$fqdn.crt --trustedcert $pki_dir/trusted-master.crt --ca $pki_dir/ca.key
icinga2 node setup --ticket $ticket --endpoint $icinga2_master --zone $fqdn --master_host $icinga2_master --trustedcert $pki_dir/trusted-master.crt
/etc/init.d/icinga2 restart  # or however you restart your icinga
