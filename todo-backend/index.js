const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const path = require('path');

const { initDb, db, closeDb } = require('./db.js');

// init db if necessary
initDb();

app.use(express.json());

// static path for react files
app.use(express.static(path.join(__dirname, '../todo-frontend/build')));

// create task
app.post('/task', (req, res) => {
    const { task_detail } = req.body;
    const query = 'INSERT INTO todos_list (task_detail) VALUES ($1) RETURNING *';
    db.query(query, [task_detail])
        .then((result) => res.send(result.rows[0]))
        .catch((err) => res.status(500).send(err));
});

// read all task
app.get('/tasks', (req, res) => {
    const query = 'SELECT * FROM todos_list ORDER BY task_detail ASC';
    db.query(query)
        .then((result) => res.send(result.rows))
        .catch((err) => res.status(500).send(err));
});

// read complete task
app.get('/checked_tasks', (req, res) => {
    const query = 'SELECT * FROM todos_list WHERE finished = true ORDER BY update_time DESC LIMIT 10';
    db.query(query)
        .then((result) => res.send(result.rows))
        .catch((err) => res.status(500).send(err));
});

app.get('/unchecked_tasks', (req, res) => {
    const query = 'SELECT * FROM todos_list WHERE finished = false ORDER BY task_detail ASC';
    db.query(query)
        .then((result) => res.send(result.rows))
        .catch((err) => res.status(500).send(err));
});

// update a task
app.put('/task/:id/:done', (req, res) => {
    const { id, done } = req.params;
    const query = 'UPDATE todos_list SET finished = $2, update_time = current_timestamp WHERE task_id = $1 RETURNING *';
    db.query(query, [id, done])
        .then((result) => res.send(result.rows[0]))
        .catch((err) => res.status(500).send(err));
});

// delete all task
app.delete('/tasks', (req, res) => {
    const query = 'DELETE FROM todos_list';
    db.query(query)
        .then(() => res.send({ message: 'All tasks deleted successfully' }))
        .catch((err) => res.status(500).send(err));
});

// entry of React page
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../todo-frontend/build', 'index.html'));
});

// start service
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// quit then close db connection
process.on('exit', closeDb);
