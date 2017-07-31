#!/bin/sh

/app/fiche -d ${DOMAIN:-localhost} -o ${BASEDIR:-/data} -l /dev/stdout -s ${SLUG:-8} -B ${BUFFER:-4096} -u ${USER:-fiche}
