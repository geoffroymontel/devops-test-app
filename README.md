# Introduction

This is a test application for automatic deployment.

It consists in a simple scaffold to test the application deployment and DB setup.

# Expected behaviour

`/` should return the Welcome to Rails page

`/posts` should return the scaffolding page

# Develop

`config/database.yml` is not in the GIT repository.
It's copied at deployment time.

In development, add a file like 

```yaml
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
```

# Set up your machines
See https://github.com/geoffroymontel/devops-test-deploy

# Deploy
* First deployment :
```bash
cap deploy:setup
cap deploy:cold
```

* For subsequent deployment :
```bash
git push origin master
cap deploy
```

# It works
Point your browser to 

http://172.16.0.2  
http://172.16.0.2/posts

# Logging
* Nginx
```bash
cap ROLES="web" COMMAND="tail -f /var/log/nginx/access.log" invoke
cap ROLES="web" COMMAND="tail -f /var/log/nginx/error.log" invoke
```

* Unicorn
```bash
cap ROLES="app" COMMAND="tail -f /var/www/devops-test-app/current/log/production.log" invoke
cap ROLES="app" COMMAND="tail -f /var/www/devops-test-app/current/log/unicorn.log" invoke
```

