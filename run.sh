#!/bin/bash

docker run --rm --name ft_server_container -e AUTOINDEX='on' -it -p 80:80 -p 443:443 ft_server
