@echo off

REM Function to run the specified task
:run_task
if "%1"=="build-latex" (
	latexmk --lualatex --output-directory=build thesis.tex
	call :backup_file "build\thesis.pdf"
) else if "%1"=="build-tikz" (
	latexmk --lualatex --output-directory=tikz\tests\build tikz\tests\tikz.tex
) else if "%1"=="build-and-open-pdf" (
	latexmk --lualatex --output-directory=build thesis.tex
	call :backup_file "build\thesis.pdf"
	start "" "build\thesis.pdf"
) else (
	echo Invalid task. Available tasks are: build-latex, build-tikz, build-and-open-pdf
)
goto :eof

REM Function to backup the specified file
:backup_file
if exist "%~1" (
	for /f "tokens=1-4 delims=:. " %%a in ("%date% %time%") do (
		set timestamp=%%a%%b%%c%%d
	)
	if not exist backup mkdir backup
	copy "%~1" "backup\thesis_%timestamp%.pdf"
	echo Backup created: backup\thesis_%timestamp%.pdf
	for /f "skip=20 delims=" %%a in ('dir /b /o-d "backup\thesis_*.pdf"') do del "backup\%%a"
) else (
	echo File not found: %~1
)
goto :eof

REM Check if an argument is passed
if "%~1"=="" (
	echo No task specified. Available tasks are: build-latex, build-tikz, build-and-open-pdf
	exit /b 1
)

REM Run the specified task
call :run_task %1
