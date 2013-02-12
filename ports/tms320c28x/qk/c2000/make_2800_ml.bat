@echo off
:: ==========================================================================
:: Product: QP/C++ buld script for TMS320C28x, QK port, C2000-compiler
:: Last Updated for Version: 4.5.03
:: Date of the Last Update:  Jan 18, 2013
::
::                    Q u a n t u m     L e a P s
::                    ---------------------------
::                    innovating embedded systems
::
:: Copyright (C) 2002-2012 Quantum Leaps, LLC. All rights reserved.
::
:: This program is open source software: you can redistribute it and/or
:: modify it under the terms of the GNU General Public License as published
:: by the Free Software Foundation, either version 2 of the License, or
:: (at your option) any later version.
::
:: Alternatively, this program may be distributed and modified under the
:: terms of Quantum Leaps commercial licenses, which expressly supersede
:: the GNU General Public License and are specifically designed for
:: licensees interested in retaining the proprietary status of their code.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program. If not, see <http://www.gnu.org/licenses/>.
::
:: Contact information:
:: Quantum Leaps Web sites: http://www.quantum-leaps.com
::                          http://www.state-machine.com
:: e-mail:                  info@quantum-leaps.com
:: ==========================================================================
setlocal

:: adjust the following path to the location where you've installed
:: the TI CodeComposer/C2000 toolset...
::
set TI_C2000=C:\tools\TI\ccsv5\ccsv5\tools\compiler\c2000_6.1.0


:: Typically, you don't need to modify this file past this line -------------

set PATH=%TI_C2000%\bin;%PATH%

set CC=cl2000
set ASM=ac2000
set LIB=ar2000

set QP_INCDIR=..\..\..\..\include
set QP_PRTDIR=.

:: Specify TMS320Cxx architecture
set TMS320_VER=28

:: Specify memory model
set MEM_MODEL=l

if "%1"=="" (
    echo default selected
    set BINDIR=dbg
    set CCFLAGS=-v%TMS320_VER% -m%MEM_MODEL% -g -ep.cpp -mn -d"DEBUG"
)
if "%1"=="rel" (
    echo rel selected
    set BINDIR=rel
    set CCFLAGS=-v%TMS320_VER% -m%MEM_MODEL% -ep.cpp -o3 -d"NDEBUG"
)
if "%1"=="spy" (
    echo spy selected
    set BINDIR=spy
    set CCFLAGS=-v%TMS320_VER% -m%MEM_MODEL% -g -ep.cpp -mn -d"Q_SPY"
)

set LIBDIR=%BINDIR%
set LIBFLAGS=a
mkdir %BINDIR%

erase %BINDIR%\qp%TMS320_VER%00_m%MEM_MODEL%.lib

:: QEP ----------------------------------------------------------------------
set SRCDIR=..\..\..\..\qep\source
set CCINC=-i%QP_PRTDIR% -i%QP_INCDIR% -i%SRCDIR%

@echo on
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qep.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qfsm_ini.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qfsm_dis.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_ini.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_dis.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_top.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qhsm_in.cpp 

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%00_m%MEM_MODEL%.lib %BINDIR%\qep.obj %BINDIR%\qfsm_ini.obj %BINDIR%\qfsm_dis.obj %BINDIR%\qhsm_ini.obj %BINDIR%\qhsm_dis.obj %BINDIR%\qhsm_top.obj %BINDIR%\qhsm_in.obj
@echo off

:: QF -----------------------------------------------------------------------
set SRCDIR=..\..\..\..\qf\source
set CCINC=-I%QP_PRTDIR% -I%QP_INCDIR% -I%SRCDIR%

@echo on
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_defer.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_fifo.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_lifo.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_get_.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_sub.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_usub.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qa_usuba.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_fifo.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_get.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_init.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qeq_lifo.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_act.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_gc.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_log2.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_new.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pool.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_psini.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pspub.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_pwr2.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qf_tick.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_get.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_init.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qmp_put.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_ctor.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_arm.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_darm.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qte_rarm.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" src\qf_port.cpp

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%00_m%MEM_MODEL%.lib %BINDIR%\qa_defer.obj %BINDIR%\qa_fifo.obj %BINDIR%\qa_lifo.obj %BINDIR%\qa_get_.obj %BINDIR%\qa_sub.obj %BINDIR%\qa_usub.obj %BINDIR%\qa_usuba.obj %BINDIR%\qeq_fifo.obj %BINDIR%\qeq_get.obj %BINDIR%\qeq_init.obj %BINDIR%\qeq_lifo.obj %BINDIR%\qf_act.obj %BINDIR%\qf_gc.obj %BINDIR%\qf_log2.obj %BINDIR%\qf_new.obj %BINDIR%\qf_pool.obj %BINDIR%\qf_pspub.obj %BINDIR%\qf_pwr2.obj %BINDIR%\qf_tick.obj %BINDIR%\qmp_get.obj %BINDIR%\qmp_init.obj %BINDIR%\qmp_put.obj %BINDIR%\qte_ctor.obj %BINDIR%\qte_arm.obj %BINDIR%\qte_darm.obj %BINDIR%\qte_rarm.obj %BINDIR%\qf_port.obj
@echo off

:: QK -----------------------------------------------------------------------
set SRCDIR=..\..\..\..\qk\source
set CCINC=-I%QP_PRTDIR% -I%QP_INCDIR% -I%SRCDIR%

@echo on
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qk.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qk_sched.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qk_mutex.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" src\qk_port.cpp

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%00_m%MEM_MODEL%.lib %BINDIR%\qk.obj %BINDIR%\qk_sched.obj %BINDIR%\qk_mutex.obj %BINDIR%\qk_port.obj
@echo off

:: QS -----------------------------------------------------------------------
if not "%1"=="spy" goto clean

set SRCDIR=..\..\..\..\qs\source
set CCINC=-I%QP_PRTDIR% -I%QP_INCDIR% -I%SRCDIR%

@echo on
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_blk.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_byte.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_f32.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_f64.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_mem.cpp
::%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" %SRCDIR%\qs_str.cpp
%CC% %CCFLAGS% %CCINC% -fr"%QP_PRTDIR%\%BINDIR%" src\qs_port.cpp

%LIB% %LIBFLAGS% %LIBDIR%\qp%TMS320_VER%00_m%MEM_MODEL%.lib %BINDIR%\qs_port.obj
@echo off

:: --------------------------------------------------------------------------

:clean
@echo off

erase %BINDIR%\*.obj

endlocal