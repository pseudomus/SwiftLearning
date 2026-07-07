
# Swift Learning

A collection of small, self-contained projects built as part of my personal journey learning **Swift**, **SwiftUI**, and the Apple ecosystem.

Rather than building a single application, this repository is organized into multiple independent projects, each focused on exploring a specific concept, framework, or language feature.

## Goals

- Learn and practice the Swift language.
- Explore SwiftUI and Apple's frameworks.
- Experiment with architecture and design patterns.
- Build focused examples around a single topic.
- Maintain a practical reference for future learning.

---

## Repository Structure

```text
.
├── Makefile
├── Templates/
└── Projects/
    ├── Concurrency/
    ├── ...
````

Each directory inside `Projects/` represents an independent Xcode project.

Projects are generated using **XcodeGen**, so `.xcodeproj` files are not committed to the repository.

---

# Projects

| Project                     | Topic             | Description                                                                                                  |
| --------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------ |
| [Concurrency](#concurrency) | Swift Concurrency | Exploring Swift's modern concurrency model, including async/await, actors, structured concurrency, and more. |

---

# Requirements

Before running any project, make sure you have:

* Xcode
* Xcode Command Line Tools
* XcodeGen

Install XcodeGen with Homebrew:

```bash
brew install xcodegen
```

---

# Getting Started

## List available projects

```bash
make list
```

---

## Generate an Xcode project

```bash
make generate PROJECT=Concurrency
```

---

## Open the project in Xcode

```bash
make open PROJECT=Concurrency
```

---

## Build the project

```bash
make build PROJECT=Concurrency
```

---

## Run tests

```bash
make test PROJECT=Concurrency
```

---

## Generate every project

```bash
make generate-all
```

---

## Create a new project

```bash
make new-project NAME=Networking
```

This creates the following structure:

```text
Projects/
└── Networking/
```

Then generate the Xcode project:

```bash
make generate PROJECT=Networking
```

---

# Project Details

## Concurrency

### Objective

Learn Swift's modern concurrency model and understand how to write safe, efficient, and structured asynchronous code.

### Topics Covered

* async/await
* Tasks
* Task Groups
* Actors
* Structured Concurrency
* Cancellation
* MainActor
* AsyncSequence

### Status

In progress.

```
```
