# Freeradius Deploy

[**Freeradius**](https://freeradius.org) é um dos servidores RADIUS mais populares do mundo. O RADIUS é um protocolo de rede que estabelece as diretrizes para gerenciamento centralizado de autenticação, sendo RADIUS o acrônimo para **Remote Authentication Dial In User Service**. O Freeradius provê ferramentas para autenticação, autorização e contabilidade dos clientes da rede.

## Sumário
- [Freeradius Deploy](#freeradius-deploy)
  - [Sumário](#sumário)
  - [Requisitos e Dependências](#requisitos-e-dependências)
  - [Instalação](#instalação)
    - [Banco de Dados (MariaDB)](#banco-de-dados-mariadb)
      - [Estrutura de Diretórios](#estrutura-de-diretórios)
      - [Docker-Compose](#docker-compose)
        - [Portas](#portas)
        - [Volumes](#volumes)
        - [Variáveis de Ambiente (Environment)](#variáveis-de-ambiente-environment)
    - [Aplicação (Freeradius)](#aplicação-freeradius)
      - [Estrutura de Diretórios](#estrutura-de-diretórios-1)
      - [Raddb - Configuração](#raddb---configuração)
      - [Docker-Compose](#docker-compose-1)
        - [Arquivos de Configuração](#arquivos-de-configuração)
        - [Portas](#portas-1)
        - [Volumes](#volumes-1)
        - [Variáveis de Ambiente (Environment)](#variáveis-de-ambiente-environment-1)
    - [Docker-Compose Rede (Opcional)](#docker-compose-rede-opcional)

## Requisitos e Dependências

- [Docker e Docker-Compose](https://docs.docker.com/)

## Instalação

### Banco de Dados (MariaDB)

#### Estrutura de Diretórios

```bash
# Crie os diretórios.

# Dir. Dados
$ mkdir $(pwd)/lib-mysql
```

Sugestão (no Linux):
- Dir. Dados: /var/lib/mysqlglpi

#### Docker-Compose

##### Portas
```yml
# docker-compose.yml (Em services.db)

# Comente/Descomente (e/ou altere) as portas/serviços que você deseja oferecer.

# Cuidado, isso pode expor seu banco para outros hosts.
# Só altere se realmente for desejado.

ports:
# Bind "localhost" com o container.
# Porta padrão Mysql/MariaDB 
  - '127.0.0.1:3306:3306'
```

##### Volumes
```yml
# docker-compose.yml (Em services.db)
# Aponte para as pastas criadas anteriormente.

# Antes
volumes:
  - '$(pwd)/lib_mysql:/var/lib/mysql'

# Depois (exemplo)
volumes:
  - '/var/lib/mysqlglpi:/var/lib/mysql'
```

##### Variáveis de Ambiente (Environment)
```yml
# docker-compose.yml (Em services.db)

environment:
# Senha do usuário root
  - MARIADB_ROOT_PASSWORD=rootpass
# Host do root. "localhost" ou ["%"(não recomendado)]
  - MARIADB_ROOT_HOST=localhost
# Nome do usuário criado 
  - MARIADB_USER=yourdbuser
# Senha do usuário
  - MARIADB_PASSWORD=yourdbuserpass
```

### Aplicação (Freeradius)

#### Estrutura de Diretórios

```bash
# Crie os diretórios.

# Dir. Log
$ mkdir $(pwd)/log-radius
```

Sugestão (no Linux):
- Dir. Log: /var/log/radius

#### Raddb - Configuração

As configurações da aplicação serão copiada da máquina host para o container, unindo-se as configurações já existente dentro do container. Para fazer a aplicação "rodar" o usuário necessitará configurar 3 itens:
1. *radiusd.conf*: primeiro arquivo de configuração chamado pelo freeradius.
2. *mods-available*: pasta com os módulos que será agregado pela aplicação.
3. *sites-available*: servidores/pool de conexão que o freeradius irá subir. 

Em *app/raddb* exitem templates que podem ser usados como exemplo e até mesmo diretamente em produção. Nesse segundo caso, o usuário precisará configurá apenas o arquivos *app/raddb/sites-available/freeradius-server*. 

Obs: caso queira que esses arquivos sejam carregados a partir de outro(s) diretório(s) leia a secção [Docker-Compose: Arquivos de Configuração](#arquivos-de-configuração).

#### Docker-Compose

##### Arquivos de Configuração

Por padrão os arquivos de configuração será carregado do diretório *app/raddb*. Para alterar esse comportamento adicione *docker-compose.yml*:

```yml
# docker-compose.yml (Em services.app.build)

args:
# Arquivo radiusd.conf
  - CONF_RADIUSD=$(pwd)/radiusd.conf
# Diretório de mods
  - DIR_MODS=$(pwd)/dir_mod
# Diretório de servidores/pool
  - DIR_SITES=$(pwd)/dir_sites
```

##### Portas
```yml
# docker-compose.yml (Em services.app)

# Comente/Descomente (e/ou altere) as portas/serviços que você deseja oferecer.

ports:
# Porta 1812 "Autenticação"
# Porta 1813 "Contabilidade" 
  - '1812-1813:1812-1813/udp'
```

##### Volumes
```yml
# docker-compose.yml (Em services.app)
# Aponte para as pastas criadas anteriormente.

# Antes
volumes:
  - '$(pwd)/log_radius:/var/log/radius'

# Depois (exemplo)
volumes:
  - '/var/log/radius:/var/log/radius'
```

##### Variáveis de Ambiente (Environment)
```yml
# docker-compose.yml (Em services.app)

environment:
# Host do DB. Não será alterado normalmente.
  - DB_HOST=freeradius-db
# Porta do DB. Não será alterado normalmente.
  - DB_PORT=3306
# Usuário que a aplicação usará para acessar o DB.
  - DB_USER=yourdbuser
# Senha do usuário que a aplicação usará para acessar o DB.
  - DB_PASSWORD=yourdbuserpass
# Nome do DB.
  - DB_NAME=yourdbname
```

### Docker-Compose Rede (Opcional)

```yml
# docker-compose.yml (Em networks.freeradius-net.ipam)
# Altere os valores caso necessário. 

config:
# Endereço da rede
  - subnet: '172.18.0.0/28'
# Gateway da rede
    gateway: 172.18.0.1
```