@echo off

@echo =======================
@echo preBuild
@echo =======================

@echo.
@echo ---- HeaderMake ----
HeaderMake -in=..\sakura_core\Funccode_x.hsrc -out=..\sakura_core\Funccode_define.h -mode=define
HeaderMake -in=..\sakura_core\Funccode_x.hsrc -out=..\sakura_core\Funccode_enum.h -mode=enum -enum=EFunctionCode

@echo.
@echo ---- MakefileMake ----
MakefileMake -file=..\sakura_core\Makefile -dir=..\sakura_core

@echo.
@echo ---- Make gitrev.h ----
: Git enabled checking
set GIT_ENABLED=1
where git 1>nul 2>&1
if not "%ERRORLEVEL%" == "0" (
	set GIT_ENABLED=0
	@echo NOTE: No git command
)
if not exist ..\.git (
	set GIT_ENABLED=0
	@echo NOTE: No .git directory
)

: Get git hash if git is enabled
if "%GIT_ENABLED%" == "1" (
	for /f "usebackq" %%s in (`git show -s --format^=%%H`) do (
		set COMMITID=%%s
	)
	for /f "usebackq" %%s in (`git show -s --format^=%%h`) do (
		set SHORT_COMMITID=%%s
	)
) else (
	set SHORT_COMMITID=
	set COMMITID=
)
@echo SHORT_COMMITID: %SHORT_COMMITID%
@echo COMMITID: %COMMITID%

: Output gitrev.h
set GITREV_H=..\sakura_core\gitrev.h
type nul                                  > %GITREV_H%
if "%COMMITID%" == "" (
	type nul                                  >> %GITREV_H%
) else (
	echo #define GIT_COMMIT_HASH "%COMMITID%" >> %GITREV_H%
)
if "%SHORT_COMMITID%" == "" (
	type nul                                              >> %GITREV_H%
) else (
	echo #define GIT_SHORT_COMMIT_HASH "%SHORT_COMMITID%" >> %GITREV_H%
)

ENDLOCAL
rem exit 0
