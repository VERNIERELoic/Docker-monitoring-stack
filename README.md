[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) [![made-with-Go](https://img.shields.io/badge/Made%20with-Go-1f425f.svg)](http://golang.org) [![Bash Shell](https://badges.frapsoft.com/bash/v1/bash.png?v=103)](https://github.com/ellerbrock/open-source-badges/)


# Docker stack monitoring
**caddy version : 2.4.3**

## Install docker / compose

Auto install script
run : 
```ruby
chmod 755 docker-install.sh
docker-install.sh
```

## Deployment and evolution of the stack
Depuis le repertoire de la stack: 
```ruby
git clone https://github.com/
cd Monitoring
docker-compose up -d
```
##### Stack evolution 
Edit theses two files : 
- ./docker-compose.yml
- ./prometheus/prometheus.yml

###### Add container
Edit : ./docker-compose.yml
Exemple node-exporter : 
```ruby
  node-exporter:
    image: prom/node-exporter:latest
    container_name: monitoring_node_exporter
    restart: unless-stopped
    expose:
      - 9100
    ports:
      - 9100:9100
```
###### Add prometheus targets 
Edit : ./prometheus/prometheus.yml : 
Edit in **"scrab_config:"**
```ruby
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 120s
    static_configs:
         - targets: ['localhost:9090','node-exporter:9100','grafana:3000','NOM_DU_SERVICE:PORT','ect...']
```
New job exemple : 
Edit in **"scrab_config:"**
```ruby
scrape_configs:
  - job_name: 'New_JOB'
    scrape_interval: 120s
    static_configs:
         - targets: ['IP:PORT']
```

## Caddy config https reverse proxy
##### Caddyfile
```ruby
{
	email yourmail@email.com
}

Domaine {
#    tls internal # For local https certificat
    log {
      output stdout
    }
    reverse_proxy domain:3000
}
```

##### Prometheus metrics behind caddy reverse proxy
###### Add external link datasource.yml 
``` ruby
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://IP:9090 # This needs to be replaced by your server's ip
    # For behind revers proxy all these things: 
    jsonData: 
      httpmethod: POST
      exemplarTraceIdDestinations: 
              - name: vpsmetrics
                url: https://domain/metrics
```
##### Firewall config with iptables
Remove access to port 9090,9100,3000 from http
You have to add the following rules in DOCKER-USER : 
````ruby
sudo iptables -I DOCKER-USER -p tcp -i eth0 ! -s IP --dport 3000 -j DROP
sudo iptables -I DOCKER-USER -p tcp -i eth0 ! -s IP --dport 9100 -j DROP
sudo iptables -I DOCKER-USER -p tcp -i eth0 ! -s IP --dport 9090 -j DROP
```
##### For persistent rules
```ruby
sudo apt install iptables-persistent
``` 

