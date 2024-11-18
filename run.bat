@echo off

REM variables
set script_dir=%~dp0
set env_name=proxy

REM init conda
call conda activate

REM check if conda environment is installed
conda env list | findstr /C:"%env_name%" >nul
if errorlevel 1 (
    echo creating conda environment %env_name% ...
    conda create --name %env_name% python=3.12 -y
    call conda activate %env_name%
    pip install --no-input -r %script_dir%requirements.txt
)

REM activate conda environment
echo activating conda environment %env_name% ...
call conda activate %env_name%

REM run mitmdump
echo starting mitmdump ...
mitmdump -s proxy.py -k --listen-port 8090