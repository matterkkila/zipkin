#!/bin/sh
### BEGIN INIT INFO
# Provides:          zipkin-web
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Start/stop zipkin-web service
### END INIT INFO

NAME="zipkin-web"
VERSION="@VERSION@"
USER="zipkin-web"
PORT=":8080"
ROOT_URL="http://localhost:8080/"
CACHE_RESOURCES="true"
PIN_TTL="5.days"
QUERY_SERVER="127.0.0.1:9411"
PIDFILE="/var/run/zipkin-web.pid"
DIR="/var/lib/zipkin-web"

if [ -f /etc/default/zipkin-web ]; then
    . /etc/default/zipkin-web
fi

DAEMON="/usr/bin/java"
DAEMON_ARGS="-server -cp '$DIR/libs/*' -jar $DIR/zipkin-web-$VERSION.jar -zipkin.web.port=$PORT -zipkin.web.rootUrl=$ROOT_URL -zipkin.web.cacheResources=$CACHE_RESOURCES -zipkin.web.query.dest=$QUERY_SERVER -zipkin.web.pinTtl=$PIN_TTL"

case $1 in
    start)
        start-stop-daemon --start --oknodo --pidfile "$PIDFILE" --user "$USER" --chuid "$USER" --verbose --background --make-pidfile --startas "$DAEMON" -- $DAEMON_ARGS
    ;;
    stop)
        start-stop-daemon --stop --oknodo --pidfile "$PIDFILE" --user "$USER" --verbose --retry=TERM/30/KILL/5
    ;;
    status)
        if [ ! -f "$PIDFILE" ]; then
            exit 1
        fi
        ps -p `cat $PIDFILE`
        exit $?
    ;;
    restart)
        $0 stop && sleep 2 && $0 start
    ;;
esac