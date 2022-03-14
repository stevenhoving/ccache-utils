@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

SET "EXIT_ON_ERROR=%~1"
SET SUCCESS=0

PUSHD %~dp0

SET VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe

@rem Visual Studio 2019, 2022
FOR /f "delims=" %%A IN ('"%VSWHERE%" -property installationPath -prerelease -version [16.0^,18.0^)') DO (
	@rem Visual C++ 2022 v143 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v170\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2022 "!VCT_PATH!"
	@rem Visual C++ 2019 v142 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v160\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2019 "!VCT_PATH!"
	@rem Visual C++ 2017 v141 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v150\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

@rem Visual Studio 2019, 2022 Build Tools
FOR /f "delims=" %%A IN ('"%VSWHERE%" -products Microsoft.VisualStudio.Product.BuildTools -property installationPath -prerelease -version [16.0^,18.0^)') DO (
	@rem Visual C++ 2022 v143 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v170\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2022 "!VCT_PATH!"
	@rem Visual C++ 2019 v142 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v160\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2019 "!VCT_PATH!"
	@rem Visual C++ 2017 v141 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v150\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

IF %SUCCESS% == 0 (
	ECHO Visual C++ 2017, 2019 or 2022 NOT Installed.
	IF "%EXIT_ON_ERROR%" == "" PAUSE
)

POPD
ENDLOCAL
EXIT /B

:SUB_VS2022
ECHO VCTargetsPath for Visual Studio 2022: %~1
XCOPY /Q /Y "ccache" "%~1\..\ccache\"
XCOPY /Q /Y "ccache_v143" "%~1\x64\PlatformToolsets\ccache_v143\"
XCOPY /Q /Y "ccache_v143" "%~1\Win32\PlatformToolsets\ccache_v143\"
XCOPY /Q /Y "ccache_v143" "%~1\ARM64\PlatformToolsets\ccache_v143\"
XCOPY /Q /Y "ccache_v143" "%~1\ARM\PlatformToolsets\ccache_v143\"
SET SUCCESS=1
EXIT /B
