Docker OMD
==========

[Dockerfile](https://www.docker.com) for [Open Monitoring Distribution (OMD)](http://omdistro.org).

Synopsis
--------

Can be run as follows:

    docker run -d -t -p 80:80 --name 'omd' --hostname 'omd' -v /local/main.mk:/omd/sites/default/etc/check_mk/main.mk xforty.net/omd

This will leave a shell open to access the container.

OMD will become available on [http://172.X.X.X/default](http://172.X.X.X/default).
The default login is `omdadmin` with password `omd`.
To find out the IP address, run `ip addr` in the container shell.

Build from Source
-----------------

The Docker image can be built as follows:

    git clone https://github.com/xforty/docker-omd
    cd docker-omd
    docker build -t="xforty.net/omd" .
