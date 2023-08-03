import React, { Component } from "react"
import PropTypes from 'prop-types'
import './index.css'
import Item from "../Item";

export default class Footer extends Component{
    static propTypes = {
        tasks: PropTypes.array.isRequired,
        checked_tasks: PropTypes.array.isRequired,
        updateTask: PropTypes.func.isRequired
    }

    render() {
        const {tasks, checked_tasks, updateTask} = this.props;
        return (
            <div className='todo-footer'>
                <div className='todo-left'>
                    <p>
                        To Do
                    </p>
                    <hr/>
                    <ul className="todo-list">
                        {
                            tasks.map(task => {
                                if (!task.finished){
                                    return <Item key={task.task_id} {...task} updateTask={updateTask}/>
                                }
                            })
                        }
                    </ul>
                </div>
                <div className='todo-right'>
                    <p>
                        Done
                    </p>
                    <hr/>
                    <ul className="todo-list">
                        {
                            checked_tasks.map(task => {
                                return <Item key={task.task_id} {...task} updateTask={updateTask}/>
                            })
                        }
                    </ul>
                </div>
            </div>
        );
    }
}