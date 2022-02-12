#!/bin/bash

docker run --rm --name ft_server_container -e AUTOINDEX='off' -it -p 80:80 -p 443:443 ft_server
