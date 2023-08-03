import React, { Component } from 'react'
import PropTypes from 'prop-types'
import './index.css'

export default class Item extends Component{
    static propTypes = {
        updateTask: PropTypes.func.isRequired
    }
    handleCheck = (id)=>{
        const { updateTask } = this.props;
        return (event)=>{
            updateTask(id, event.target.checked);
        }
    }
    render() {
        const {task_id, task_detail, finished} = this.props
        return (
            <li>
                <label>
                    <input type="checkbox" checked={!!finished} onChange={this.handleCheck(task_id)}/>
                    <span>{ task_detail }</span>
                </label>
            </li>
        )
    }
}