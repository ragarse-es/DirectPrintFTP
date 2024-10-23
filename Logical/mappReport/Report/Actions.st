(*--------------------------------------------------------
 * Author: garciar 
 * Created:September 26, 2024/11:09 AM 
 * File Related: Report.st
----------------------------------------------------------
 * Description: Action to initalize the mpReport functions and parameters
 *
---------------------------------------------------------*)
ACTION MpReportInit: 
	(********* Parameters intialization *********)
	Ctrl.Para.DeviceName 		:= 'USER';																		(* Device name *)
	Ctrl.Para.StoragePath		:= 'USER_PATH';																	(* Storage path *)
	Ctrl.Para.DeviceInit 		:= '/DEVICE=';																	(* Device handling path *)
	brsstrcat(ADR(Ctrl.Para.DevicePath),ADR(Ctrl.Para.DeviceInit));												(* Concatenate path *)
	brsstrcat(ADR(Ctrl.Para.DevicePath),ADR(Ctrl.Para.StoragePath));											(* Concatenate path *)
	Ctrl.Para.ReportName		:= 'TableReport';																(* Report name *)
	Ctrl.Para.ReportLanguage	:= 'en';																		(* Report language *)
	
	(********* MpReport intialization *********)
	Ctrl.FUB.MpReportCore_0.MpLink 				:= ADR(gReport);												(* Mapping MpLink *)
	Ctrl.FUB.MpReportCore_0.DeviceName 			:= ADR(Ctrl.Para.DeviceName);									(* Mapping the file device name *)
	Ctrl.FUB.MpReportCore_0.Name				:= ADR(Ctrl.Para.ReportName);									(* Mapping report name *)
	Ctrl.FUB.MpReportCore_0.Language			:= ADR(Ctrl.Para.ReportLanguage);								(* Mapping report language *)
	Ctrl.FUB.MpReportCore_0.Enable 				:= TRUE;
END_ACTION


(*--------------------------------------------------------
 * Author: garciar 
 * Created:September 26, 2024/11:09 AM 
 * File Related: Report.st
----------------------------------------------------------
 * Description: Action to execute all the cyclic task
 *		of the mpReport neccesary in the cyclic 
---------------------------------------------------------*)
ACTION MpReportCyclic: 
	(********* Lanuguage selector *********)	
	Ctrl.Para.ReportLanguage := 'en';		(* english selected *)
		
	(********* Report selector *********)		
	Ctrl.Para.ReportName	:= 'CompleteReport';		
		
	(********* Cyclic values *********)
	Ctrl.FUB.MpReportCore_0.Name				:= ADR(Ctrl.Para.ReportName);									(* Mapping report name *)
	Ctrl.FUB.MpReportCore_0.Language			:= ADR(Ctrl.Para.ReportLanguage);								(* Mapping report language *)

	(********* Calling FUBs *********)
	Ctrl.FUB.MpReportCore_0();
	
	(********* Reseting commands *********)
	IF ((Ctrl.FUB.MpReportCore_0.ErrorReset = TRUE) AND (Ctrl.FUB.MpReportCore_0.Error = FALSE)) THEN			(* ErrorReset command reset *)
		Ctrl.FUB.MpReportCore_0.ErrorReset 		:= FALSE;
	END_IF;
	
	IF ((Ctrl.FUB.MpReportCore_0.Generate = TRUE) AND (Ctrl.FUB.MpReportCore_0.CommandDone = TRUE)) THEN		(* Generate command reset *)
		Ctrl.FUB.MpReportCore_0.Generate		:= FALSE;	
	END_IF;
END_ACTION
