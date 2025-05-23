############################################################################################
#      NSIS Installation Script created by NSIS Quick Setup Script Generator v1.09.18
#               Entirely Edited with NullSoft Scriptable Installation System                
#              by Vlasis K. Barkas aka Red Wine red_wine@freemail.gr Sep 2006               
############################################################################################

!define APP_NAME "Together Live"
!define COMP_NAME "Together"
!define VERSION "00.1.00.00"
!define COPYRIGHT "Together"
!define DESCRIPTION "Application"
!define INSTALLER_NAME "C:\Home\together\setup\Together Live Setup.exe"
!define TOGETHER_SIRIUS_DIR "together-sirius-live"
!define TOGETHER_DIR "together-live"
!define MAIN_APP_EXE "${TOGETHER_DIR}\Together.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\together live.exe"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "${APP_NAME}"
Caption "${APP_NAME}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${REG_APP_PATH}" ""
InstallDir "$DESKTOP\Together Live"
RequestExecutionLevel user
ManifestDPIAware true

######################################################################

Function RunTogether

Exec "$\"$INSTDIR\${MAIN_APP_EXE}$\""

Var /GLOBAL retries

StrCpy $retries 0

retry:
Sleep 100
IntOp $retries $retries + 1
IntCmp $retries 100 0 0 done
FindWindow $0 "SplashWndClass" ""
IsWindow $0 continue retry

continue:
System::Call 'user32::SetForegroundWindow(i r0)'

done:

FunctionEnd

######################################################################

!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!define MUI_WELCOMEPAGE_TEXT "Setup will guide you through the installation of Together Live.\r\n\r\nTogether will be installed in the location where applications normally go on your computer. During the installation you may choose to put Together in a different location, but most people just leave it as is.\r\n\r\nWhen the installation is finished, you will have a green icon on your desktop that you can use to launch Together. This will be launched automatically the first time.\r\n\r\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN_FUNCTION "RunTogether"
!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_APP_EXE}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite on
SetOutPath "$INSTDIR"
RMDir /r "$INSTDIR\${TOGETHER_SIRIUS_DIR}"
RMDir /r "$INSTDIR\${TOGETHER_DIR}"
File /r "C:\Home\together\setup\${TOGETHER_DIR}"
SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"

WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "" "$INSTDIR\Dummy.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"

SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
RMDir /r "$INSTDIR\${TOGETHER_SIRIUS_DIR}"
RMDir /r "$INSTDIR\${TOGETHER_DIR}"

Delete "$INSTDIR\uninstall.exe"

RMDir "$INSTDIR"

Delete "$SMPROGRAMS\${APP_NAME}.lnk"
Delete "$DESKTOP\${APP_NAME}.lnk"

DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd

######################################################################
