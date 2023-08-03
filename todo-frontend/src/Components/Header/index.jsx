import React, { Component } from "react"
import PropTypes from 'prop-types'
import './index.css'

export default class Header extends Component{
    static propTypes = {
        deleteAllTask: PropTypes.func.isRequired
    }

    handleDeleteAllTask = () => {
        const { deleteAllTask } = this.props;
        if (window.confirm("delete?")) {
            deleteAllTask();
        }
    }

    render() {
        return (
            <div className='todo-header'>
                <label>
                    Marvelous V2.0
                </label>
                <button onClick={this.handleDeleteAllTask}>delete all task</button>
            </div>
        );
    }
}
