#!/bin/sh
client_id=
host_name=
image=
project=
image_tag=
usage()
{
    echo "usage: sysinfo_page [[[-id oauth_client_id ] [-i]] | [-h]]"
}
while [ "$1" != "" ]; do
    case $1 in
        -id | --client_id )     shift
                                client_id=$1
                                ;;
        -host | --host_name )   shift
		                        host_name=$1
                                ;;
	    -p | --project ) 	    shift
		                        project=$1
				                ;;
	    -n | --image_name )	    shift
				                image=$1
				                ;;
	    -t | --image_tag )	    shift
				                image_tag=$1
				                ;;
        -ip | --external_ip )   shift
                                external_ip=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

replace_statement='s/OAUTH_CLIENT_ID/'$client_id'/g'
hostname_replace='s/HOST_NAME/'$external_ip'/g'

sed -i $hostname_replace OHIF/platform/viewer/.webpack/webpack.pwa.js
sed -i $hostname_replace OHIF/platform/viewer/public/config/google.js
echo "Assigned Hostname"
sed -i $replace_statement OHIF/platform/viewer/public/config/google.js
echo "Assigned ClientID"

docker build -t gcr.io/springml-public/ohif-viewer/main-app OHIF/
# docker push gcr.io/springml-public/ohif-viewer/main-app

# kubectl apply -f GKE-deployment/deployment.yaml
# kubectl apply -f GKE-deployment/service.yaml

default_client='s/'$client_id'/OAUTH_CLIENT_ID/g'
default_hostname='s/'$external_ip'/HOST_NAME/g'

sed -i $default_hostname OHIF/platform/viewer/.webpack/webpack.pwa.js
sed -i $default_hostname OHIF/platform/viewer/public/config/google.js
sed -i $default_client OHIF/platform/viewer/public/config/google.js

