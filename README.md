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
http://33.33.13.2
http://33.33.13.2/posts

