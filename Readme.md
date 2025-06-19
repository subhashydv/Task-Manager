# ✅ Task Manager

A simple command-line task manager written in **Bash**. It allows you to add, view, complete, and delete tasks easily from the terminal.

---

## 📦 Features

- Add tasks with descriptions
- List active tasks or all tasks with status
- Mark tasks as done
- Delete tasks
- Built-in help command

---

## 🛠️ Installation

1. Clone the repository:

```bash
git https://github.com/subhashydv/Task-Manager.git
cd Task-Manager
```

2. Set task alias: 

```bash
alias task="./start_task_manager.sh"
```

3. Set task alias globally:

```bash
echo 'alias task="./start_task_manager.sh"' >> ~/.bashrc
echo 'alias task="./start_task_manager.sh"' >> ~/.zshrc
```

## 🚀 Usage

### ➕ Add a Task

```bash
task add "<task description>"
```

### 📋 List All Active Tasks

```bash
task list
```

### ✅ Mark Task as Done

```bash
task done <id>
```

### ❌ Delete a Task

```bash
task delete <id>
```

### 📝 List All Tasks (With Status)

```bash
task longlist
```

### 📖 Show Help

```bash
task help
```
