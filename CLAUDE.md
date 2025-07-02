# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a budget management application (予算管理アプリ) written in Python. The codebase is currently minimal with only a single `app.py` file that is currently empty.

## Development Commands

- **Install dependencies**: `pip3 install -r requirements.txt`
- **Run the application**: `streamlit run main.py`
- **Python version**: This project uses Python 3.12.3
- **Python executable**: `/usr/bin/python3`

## Architecture Notes

- Streamlit-based web application for NPO grant management
- Main application logic in `main.py`
- Session state management for data persistence during user session
- Modular page structure with separate functions for each feature
- Japanese UI for NPO法人「ながいく」

## Key Features

- **freee CSV Upload**: Import transaction data from freee accounting software
- **Grant Budget Management**: Register and manage multiple grants with budget items
- **Transaction Allocation**: Assign transactions to specific grants
- **Analysis & Reporting**: Generate reports and export data

## Development Environment

- Primary development environment appears to be WSL2 on Windows
- No test framework or linting tools configured yet
- No CI/CD or build processes defined

## Next Steps for Development

When adding features to this application, consider:
- Adding a requirements.txt file for dependency management
- Implementing proper Python project structure with modules
- Adding testing framework (pytest recommended)
- Adding linting tools (flake8, black, or ruff)