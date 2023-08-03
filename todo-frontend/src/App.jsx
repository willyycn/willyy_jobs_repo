import React, {Component} from "react";
import Header from './Components/Header'
import Main from './Components/Main'
import Footer from './Components/Footer'
import './App.css'

export default class App extends Component{
    state = {
        tasks: [],
        search: ''
    }

    componentDidMount() {
        this.getTasks();
    }

    deleteAllTask = ()=>{
        fetch('/tasks', {
            method: 'DELETE',
        })
            .then(() => this.getTasks())
            .catch((err) => console.error(err));
    }

    getTasks = () => {
        fetch('/tasks')
            .then((response) => response.json())
            .then((tasks) => this.setState({ tasks }))
            .catch((error) => console.error('Error:', error));
    };

    searchTask = (value) => {
        this.setState({ search: value });
    };

    createTask = (task_detail) => {
        fetch('/task', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ task_detail }),
        })
            .then(() => this.getTasks())
            .catch((err) => console.error(err));
    };

    updateTask = (id, check) => {
        fetch(`/task/${id}/${check}`, {
            method: 'PUT',
        })
            .then(() => this.getTasks())
            .catch((err) => console.error(err));
    };

    render() {
        const { tasks } = this.state
        const filteredTasks = tasks.filter((task) =>
            task.task_detail.toLowerCase().includes(this.state.search.toLowerCase())
        );
        const checkedTasks = filteredTasks.filter(task => task.finished);
        const sortedTasks = checkedTasks.sort((a, b) => new Date(b.update_time) - new Date(a.update_time));
        const topTen = sortedTasks.slice(0,10);
        return (
            <div className="todo-container">
                <div className="todo-wrap">
                    <Header deleteAllTask={this.deleteAllTask}/>
                    <Main createTask = {this.createTask} searchTask={this.searchTask}/>
                    <Footer tasks={filteredTasks} checked_tasks={topTen} updateTask={this.updateTask}/>
                </div>
            </div>
        )
    }
}