### env:

os: ubuntu 22.04

### database:

install postgres db

```sh
sudo apt update && sudo apt upgrade
sudo apt install postgresql
```

 then create and alter db using below sql code:

```sql
CREATE USER todo_user WITH PASSWORD 'todo_list_001';
CREATE DATABASE todos_db;
GRANT ALL PRIVILEGES ON DATABASE todos_db TO todo_user;
ALTER DATABASE todos_db OWNER TO todo_user;
```



### frontend:

install yarn via:

```sh
npm i yarn -g
```

then install the dependencies:

```
yarn add axios prop-types
```

then build the project:

```sh
yarn build
```

it would generate the files for the frontend in `build` folder.



### backend:

install the dependencies:

```
npm i express pm2 pg
```

run the server via:

```sh
pm2 start index.js
```



