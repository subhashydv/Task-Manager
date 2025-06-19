# ✅ Bash Task Manager

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
git clone https://github.com/your-username/bash-task-manager.git
cd bash-task-manager
```

2. Make Script Executable: 

```bash
chmod +x task
```

3. Add it to your PATH:

```bash
sudo mv task /usr/local/bin/
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
