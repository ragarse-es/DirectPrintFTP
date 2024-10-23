(*********************************************************************************
* Copyright: Bernecker+Rainer
* Author:    garciar
* Created:   September 26, 2024/8:26 AM 
*********************************************************************************
* MpReport + Send files to external FTP server
*********************************************************************************
* This template provides the user the basic implementation OF the mapp component
* MpReport. It is possible to create PDF files in the application.
* Also it is handled to send this generated report to an external FTP server (printer)
*********************************************************************************)  

PROGRAM _INIT
	
	MpReportInit;
	
	(********* Devices intialization *********)
	ParamString := '/SIP=10.10.10.100 /PROTOCOL=ftp /USER=admin /PASSWORD=adminadmin';
	SourceDeviceName := 'USER';
	
	PrintStep := PRINT_WAIT;
	
	//Set an initial valufor the fields of the document
	HeaderValue := 'REPORT';
	InformationValue := 'Printing Report';	
	Line1 := 'First Information';
	Line2 := 'Second Information';
	Line3 := 'Third Information';
	FooterValue := 'Page 12';
	
END_PROGRAM

PROGRAM _CYCLIC
	MpReportCyclic;
	
	(********************************************************
	********State machine: Step of the printing	
	********************************************************)
	CASE PrintStep OF
		PRINT_WAIT:
			IF GenerateAndPrint THEN
				PrintStep := PRINT_GENERATE_REPORT;
				GenerateAndPrint := FALSE;
			END_IF;
			
		PRINT_GENERATE_REPORT:
			Ctrl.FUB.MpReportCore_0.Generate := TRUE;
			PrintStep := PRINT_WAITING_REPORT;
			
			
		PRINT_WAITING_REPORT:
			IF Ctrl.FUB.MpReportCore_0.CommandDone THEN
	  			PrintStep := PRINT_LINK_DEVICE;
			END_IF;
			
			IF Ctrl.FUB.MpReportCore_0.Error THEN
	  			PrintStep := PRINT_ERROR;
			END_IF;
			
			
		PRINT_LINK_DEVICE:		
			SourceFileName := Ctrl.FUB.MpReportCore_0.Info.GeneratedFileName;
			DestFileName := SourceFileName;
			DevLink_0.enable := TRUE;	
			DevLink_0.pDevice := ADR(NewDeviceName);
			DevLink_0.pParam := ADR(ParamString);
			
			PrintStep := PRINT_WAITING_LINK;
			
		PRINT_WAITING_LINK:
			//Once get it send the handle to the other functions and the name
			IF DevLink_0.handle <> 0 THEN	  
				DevUnlink_0.handle := DevLink_0.handle;	
				FileCopy_0.pDestDev := ADR(NewDeviceName);
			END_IF;
	
			//Once finished the Link, start the Copy process
			IF DevLink_0.status = ERR_OK THEN	
				DevLink_0.enable := FALSE;
				PrintStep := PRINT_COPY_FILE;
			ELSIF DevLink_0.status <> ERR_FUB_BUSY THEN 
				PrintStep := PRINT_ERROR;
			END_IF;
			
		PRINT_COPY_FILE:	
			FileCopy_0.pSrcDev := ADR(SourceDeviceName);	
			FileCopy_0.pSrc := ADR(SourceFileName);	
			FileCopy_0.pDest := ADR(DestFileName);	
			FileCopy_0.option := fiOVERWRITE;
			FileCopy_0.enable := TRUE;
			
			PrintStep := PRINT_WAITING_COPY;
			
		PRINT_WAITING_COPY:
			//Once finished the copy, start the unlink process
			IF FileCopy_0.status = ERR_OK THEN
				FileCopy_0.enable := FALSE;
				PrintStep := PRINT_UNLINK_DEVICE;
			ELSIF FileCopy_0.status <> ERR_FUB_BUSY THEN
				PrintStep := PRINT_ERROR;
			END_IF;	
			
		PRINT_UNLINK_DEVICE:
			DevUnlink_0.enable := TRUE;
			PrintStep := PRINT_WAITING_UNLINK;
			
		PRINT_WAITING_UNLINK:		
			IF DevUnlink_0.status = ERR_OK THEN
				DevUnlink_0.enable := FALSE;
				PrintStep := PRINT_WAIT;
			ELSIF DevUnlink_0.status <> ERR_FUB_BUSY THEN
				PrintStep := PRINT_ERROR;
			END_IF;
			
		PRINT_ERROR:
		  

	END_CASE;
	
	
	(************** Function calls*****************)
	DevLink_0();
	FileCopy_0();
	DevUnlink_0();
	
END_PROGRAM

PROGRAM _EXIT
	(********** EXIT routine **********)
	Ctrl.FUB.MpReportCore_0.Enable				:= FALSE;														(* Disable FUB *)
	Ctrl.FUB.MpReportCore_0();
END_PROGRAM

