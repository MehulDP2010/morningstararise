@echo off
call algo-trading-env\Scripts\activate
start cmd /k python app.py
timeout /t 2 /nobreak > NUL
start http://localhost:5000