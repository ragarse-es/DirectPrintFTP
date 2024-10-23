(*********************************************************************************
 * Copyright: Bernecker+Rainer
 * Author:    novellaj
 * Created:   February 15, 2018/8:29 AM 
 *********************************************************************************)
(* MpReport control data types *)

TYPE
	REPORT_CTRL_TYP : 	STRUCT  (* Main MpReport control data type *)
		FUB : REPORT_CTRL_FUB_TYP; (* FUBs data type *)
		Para : REPORT_CTRL_PARA_TYP; (*Parameters data type*)
		Vis : REPORT_CTRL_VIS_TYP; (*Visualization data type*)
	END_STRUCT;
END_TYPE

(* FUBs data types *)

TYPE
	REPORT_CTRL_FUB_TYP : 	STRUCT  (* Main FUBs data type *)
		MpReportCore_0 : MpReportCore; (*Report handling FUB*)
	END_STRUCT;
END_TYPE

(*Parameters data types*)

TYPE
	REPORT_CTRL_PARA_TYP : 	STRUCT  (*Main parameters data type*)
		DeviceName : STRING[80]; (*Device name to create the file device*)
		StoragePath : STRING[80]; (*Storage path for the file device*)
		DevicePath : STRING[80]; (*Storage path for the file device*)
		ReportName : STRING[50]; (*Name for the report *)
		ReportLanguage : STRING[20]; (*Language of the report*)
		DeviceInit : STRING[80]; (*Device init*)
	END_STRUCT;
END_TYPE

(*Visualization data types*)

TYPE
	REPORT_CTRL_VIS_TYP : 	STRUCT  (*Main visualization data type*)
		LanguageIndex : USINT; (*Selected index language*)
		ReportIndex : USINT; (*Selected index report*)
	END_STRUCT;
	StepPrint_enum : 
		(
		PRINT_WAIT := 0,
		PRINT_GENERATE_REPORT := 10,
		PRINT_WAITING_REPORT := 20,
		PRINT_LINK_DEVICE := 30,
		PRINT_WAITING_LINK := 40,
		PRINT_COPY_FILE := 50,
		PRINT_WAITING_COPY := 60,
		PRINT_UNLINK_DEVICE := 70,
		PRINT_WAITING_UNLINK := 80,
		PRINT_ERROR := 100
		);
END_TYPE
