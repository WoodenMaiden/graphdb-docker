#!/bin/bash
set -e

cat <<EOF
 .d8888b.                            888      8888888b.  888888b.   
d88P  Y88b                           888      888  "Y88b 888  "88b  
888    888                           888      888    888 888  .88P  
888        888d888 88888b.  88888b.  88888b.  888    888 8888888K.  
888  88888 888P"       "88b 888 "88b 888 "88b 888    888 888  "Y88b 
888    888 888     .d888888 888  888 888  888 888    888 888    888 
Y88b  d88P 888     888  888 888 d88P 888  888 888  .d88P 888   d88P 
 "Y8888P88 888     "Y888888 88888P"  888  888 8888888P"  8888888P"  
                            888                                     
                            888                                     
                            888                                    
EOF

OLDIFS=$IFS

IFS=', '


IMPORT_DIR="$(echo $GDB_JAVA_OPTS | grep -oE -- '-Dgraphdb.workbench.importDirectory=[/[:alnum:]_-]+' | cut -d'=' -f2)"
EXTRA=""

if [ -e "$CONFIG_PATH" ]; then 
    EXTRA="$EXTRA -c $CONFIG_PATH"
fi

if [ -n "$IMPORT_DIR" ]; then
    echo "Import data from $IMPORT_DIR!"
    echo    \> /opt/graphdb/dist/bin/importrdf preload --force --recursive -q /tmp $EXTRA "$IMPORT_DIR"
    /opt/graphdb/dist/bin/importrdf preload --force --recursive -q /tmp $EXTRA "$IMPORT_DIR"
fi

IFS=$OLDIFS

exec /opt/graphdb/dist/bin/graphdb "$@"

