const { Pool } = require('pg');

const pool = new Pool({
    user: 'todo_user',
    host: 'localhost',
    database: 'todos_db',
    password: 'todo_list_001',
    port: 5432,
});

// 连接数据库
pool.connect((err) => {
    if (err) {
        console.error('Connection error', err.stack);
    } else {
        console.log('Connected to the database');
    }
});

// 初始化数据库
const initDb = () => {
    const createTableQuery = `
    CREATE TABLE IF NOT EXISTS todos_list (
      task_id SERIAL PRIMARY KEY,
      task_detail TEXT NOT NULL,
      finished BOOLEAN NOT NULL DEFAULT FALSE,
      create_time TIMESTAMP DEFAULT current_timestamp,
      update_time TIMESTAMP DEFAULT current_timestamp
    );
  `;

    pool.query(createTableQuery, (err) => {
        if (err) {
            console.error('Error creating table', err.stack);
        } else {
            console.log('Table created successfully');
        }
    });
};

// 提供API
const db = {
    query: (text, params) => pool.query(text, params),
};

// 断开连接
const closeDb = () => {
    pool.end();
};

module.exports = { initDb, db, closeDb };