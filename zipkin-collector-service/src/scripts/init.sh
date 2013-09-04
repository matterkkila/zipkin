#!/bin/sh
### BEGIN INIT INFO
# Provides:          zipkin-collector
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Start/stop zipkin-collector service
### END INIT INFO

NAME="zipkin-collector"
VERSION="@VERSION@"
USER="zipkin-collector"
CONFIG_FILE="/etc/zipkin/collector.scala"
PIDFILE="/var/run/zipkin-collector.pid"
DIR="/var/lib/zipkin-collector"

DAEMON="/usr/bin/java"
DAEMON_ARGS="-server -cp '$DIR/libs/*' -jar $DIR/zipkin-collector-service-$VERSION.jar -f $CONFIG_FILE"

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