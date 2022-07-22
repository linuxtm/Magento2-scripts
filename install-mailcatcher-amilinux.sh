#!/bin/bash
yum -y install gcc gcc-c++ sqlite-devel ruby-devel && \
gem install mailcatcher && \

cat <<EOF > /etc/init.d/mailcatcher
#!/bin/sh
# chkconfig: 345 99 1
# description: mailcatcher
# processname: mailcatcher

start() {
    echo -n "starting mailcatcher:"
    /usr/local/bin/mailcatcher --http-ip=0.0.0.0
    return 0
}

stop() {
    killall mailcatcher
    return 0
}

case "\$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo $"Usage: \$0 {start|stop}"
        exit 2
esac

exit 0
EOF

service mailcatcher start && chkconfig mailcatcher on
