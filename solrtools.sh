#!/bin/bash
#Dennis Wisnia
#Next Commerce

reload_solr_core() {
    # Production or Staging Core
    if [ "$1" = "" ]; then
        echo -n "prod or stage?"
        read type
    else
        type=$1
    fi

    # reloads a Solr core
    if [ "$2" = "" ]; then
        echo -n "You forget the Name, Maybe collection1 or give me a name of core to reload: "
        read name
    else
        name=$2
    fi

    #advanced logging 
    grep $name /opt/solr_$type/solr.xml >> /dev/null
    if [ $? -eq 1 ]; then
            logger -p local0.notice "Core $name not found!"
            exit 1
        elif [ $? -eq 2 ]; then
            logger -p local0.notice "Instance $type not found!"
            exit 2
    fi

    curl "http://localhost:8080/solr_$type/admin/cores?action=RELOAD&core=$name"
    echo "Core $name from $type has been reloaded"
    logger -p local0.notice "Core $name from $type has been reloaded"
}

case "$1" in
    reload)
        reload_solr_core $2 $3
        ;;
esac
exit 0

