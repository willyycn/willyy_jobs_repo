import React, { Component } from "react"
import PropTypes from 'prop-types'
import './index.css'

export default class Main extends Component{
    static propTypes = {
        createTask: PropTypes.func.isRequired,
        searchTask: PropTypes.func.isRequired
    }

    handleSearch = (event) => {
        const {searchTask} = this.props;
        searchTask(event.target.value)
    };

    createTodoTask = (target) => {
        const { createTask } = this.props;
        const { value } = target;
        if (value.trim() === "") {
            alert("please input task name")
            return
        }
        createTask(value);
        target.value = ""
    };

    handleKeyUp = (event)=>{
        const { createTask } = this.props;
        const { keyCode, target } = event;
        if (keyCode !== 13) return;
        if (target.value.trim() === "") {
            alert("please input task name")
            return
        }
        createTask(target.value);
        target.value = ""
    }

    render() {
        return (
            <div className='todo-main'>
                <input className='add-input' type="text" onKeyUp={this.handleKeyUp} ref={(input) => (this.newTaskInput = input)} />
                <button className='btn' onClick={() => this.createTodoTask(this.newTaskInput)}>Add</button>
                <input className='search-input'
                    type="text"
                    placeholder="search..."
                    onChange={this.handleSearch}
                />
            </div>
        );
    }
}