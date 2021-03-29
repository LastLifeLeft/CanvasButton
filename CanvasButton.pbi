DeclareModule CanvasButton
	
	EnumerationBinary ;Flags
		#Default = 0
		#LightTheme = 0
		
		#ToggleButton
		#MaterialVectorIcon
		#DarkTheme
	EndEnumeration
	
	Enumeration ;Colors
		#ColorType_BackCold
		#ColorType_BackWarm
		#ColorType_BackHot
		
		#ColorType_FrontCold
		#ColorType_FrontWarm
		#ColorType_FrontHot
		
	EndEnumeration
	
	Declare Gadget(Gadget, X, Y, Width, Height, Text.s, Flags = #Default)
	Declare GadgetImage(Gadget, X, Y, Width, Height, Image = -1, Flags = #Default)
	Declare SetColor(Gadget, Colortype, Color)
	Declare Free(Gadget)
	Declare BindEventHandler(Gadget, *Handler)
	Declare SetData(Gadget, *Data)
	Declare GetData(Gadget)
	Declare SetText(Gadget, Text.s)
	Declare SetImage(Gadget, Image)
EndDeclareModule

Module CanvasButton
	EnableExplicit
	;{ Private variables, structures, constants...
	Enumeration ;States
		#Cold
		#Warm
		#Hot
	EndEnumeration
	
	Enumeration ;Type
		#Text
		#Image
	EndEnumeration
	
	Structure GadgetData
		MouseInside.b
		
		Array BackColors.l(2)
		Array FrontColors.l(2)
		
		State.b
		Type.b
		Text.s
		Width.i
		Height.i
		
		Image.i
		ImageWidth.i
		ImageHeight.i
		ImageXOffset.i
		ImageYOffset.i
		
		*Handler
		*Data
		
		CompilerIf Defined(MaterialVector,#PB_Module)
			MaterialVector.b
			MaterialVectorStyle.l
		CompilerEndIf
	EndStructure
	
	; Default theme
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows ; RGB/GBR switcharoo...
		#Style_Dark_Back = $FF36312F
		#Style_Dark_BackWarm = $FF3C3734
		#Style_Dark_BackHot = $FF433C39
		
		#Style_Dark_Front = $FF97928E
		#Style_Dark_FrontWarm = $FFDEDDDC
		#Style_Dark_FrontHot = $FFFFFFFF
		
		#Style_Light_Back = $FFF5F3F2
		#Style_Light_BackWarm = $FFEDEAE8
		#Style_Light_BackHot = $FFDCD7D4
		
		#Style_Light_Front = $FF80746A
		#Style_Light_FrontWarm = $FF38332E
		#Style_Light_FrontHot = $FF070606
		
	CompilerElse
		#Style_Dark_Back = $2F3136FF
		#Style_Dark_BackWarm = $34373CFF
		#Style_Dark_BackHot = $393C43FF
		
		#Style_Dark_Front = $8E9297FF
		#Style_Dark_FrontWarm = $DCDDDEFF
		#Style_Dark_FrontHot = $FFFFFFFF
		
		#Style_Light_Back = $F2F3F5FF
		#Style_Light_BackWarm = $E8EAEDFF
		#Style_Light_BackHot = $D4D7DCFF
		
		#Style_Light_Front = $6A7480FF
		#Style_Light_FrontWarm = $2E3338FF
		#Style_Light_FrontHot = $060607FF
	CompilerEndIf
	;}
	
	; Private procedures declaration
	Declare Handler_Canvas()
	
	Declare Redraw(Gadget)
	
	; Public procedures
	Procedure GadgetImage(Gadget, X, Y, Width, Height, Image = -1, Flags = #Default)
		Protected Result, *Data.GadgetData
		
		Result = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard)
		
		If Result
			If Gadget = #PB_Any
				Gadget = Result
			EndIf
			
			*Data = AllocateStructure(GadgetData)
			
			With *Data
				If Flags & #DarkTheme
					\BackColors(#Cold) = #Style_Dark_Back
					\BackColors(#Warm) = #Style_Dark_BackWarm
					\BackColors(#Hot) = #Style_Dark_BackHot
					
					\FrontColors(#Cold) = #Style_Dark_Front
					\FrontColors(#Warm) = #Style_Dark_FrontWarm
					\FrontColors(#Hot) = #Style_Dark_FrontHot
				Else
					\BackColors(#Cold) = #Style_Light_Back
					\BackColors(#Warm) = #Style_Light_BackWarm
					\BackColors(#Hot) = #Style_Light_BackHot
					
					\FrontColors(#Cold) = #Style_Light_Front
					\FrontColors(#Warm) = #Style_Light_FrontWarm
					\FrontColors(#Hot) = #Style_Light_FrontHot
				EndIf
				
				\Width = Width
				\Height = Height
				
				\Type = #Image
				\Image = Image
				CompilerIf Defined(MaterialVector,#PB_Module)
					If Flags & #MaterialVectorIcon
						\MaterialVector = #True
						
						If Flags & MaterialVector::#Style_Box Or Flags & MaterialVector::#Style_Circle
							If Width > Height
								\ImageWidth = Height
							Else
								\ImageWidth = Width
							EndIf
						Else
							If Width > Height
								\ImageYOffset = Round(Height * 0.1, #PB_Round_Up)
								\ImageXOffset = \ImageYOffset
								\ImageWidth = Width - 2 * \ImageXOffset
							Else
								\ImageXOffset = Round(Width * 0.1, #PB_Round_Up)
								\ImageYOffset = \ImageXOffset
								\ImageWidth = Width - 2 * \ImageXOffset
							EndIf
						EndIf
						
						\MaterialVectorStyle = Flags
					Else
				CompilerEndIf
					
						If \Image > -1
							
						EndIf
					
				CompilerIf Defined(MaterialVector,#PB_Module)
					EndIf
				CompilerEndIf
			EndWith
			
			SetGadgetData(Gadget, *Data)
			BindGadgetEvent(Gadget, @Handler_Canvas())
			
			Redraw(Gadget)
			
		EndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure Gadget(Gadget, X, Y, Width, Height, Text.s, Flags = #Default)
		Protected Result, *Data.GadgetData
		
		Result = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard)
		
		If Result
			If Gadget = #PB_Any
				Gadget = Result
			EndIf
			
			*Data = AllocateStructure(GadgetData)
			
			With *Data
				If Flags & #DarkTheme
					\BackColors(#Cold) = #Style_Dark_Back
					\BackColors(#Warm) = #Style_Dark_BackWarm
					\BackColors(#Hot) = #Style_Dark_BackHot
					
					\FrontColors(#Cold) = #Style_Dark_Front
					\FrontColors(#Warm) = #Style_Dark_FrontWarm
					\FrontColors(#Hot) = #Style_Dark_FrontHot
				Else
					\BackColors(#Cold) = #Style_Light_Back
					\BackColors(#Warm) = #Style_Light_BackWarm
					\BackColors(#Hot) = #Style_Light_BackHot
					
					\FrontColors(#Cold) = #Style_Light_Front
					\FrontColors(#Warm) = #Style_Light_FrontWarm
					\FrontColors(#Hot) = #Style_Light_FrontHot
				EndIf
				
				\Type = #Text
				\Text = Text
			EndWith
			
			SetGadgetData(Gadget, *Data)
			BindGadgetEvent(Gadget, @Handler_Canvas())
			
			Redraw(Gadget)
			
		EndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure Free(Gadget)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		UnbindGadgetEvent(Gadget, @Handler_Canvas())
		FreeStructure(*Data.GadgetData)
		FreeGadget(Gadget)
	EndProcedure
	
	Procedure BindEventHandler(Gadget, *Handler)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		
		*Data\Handler = *Handler
	EndProcedure
	
	Procedure SetColor(Gadget, Colortype, Color)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		
		If Colortype < 3
			*Data\BackColors(Colortype) = Color
		Else
			*Data\BackColors(Colortype - 3) = Color
		EndIf
		
		Redraw(Gadget)
	EndProcedure
	
	Procedure SetData(Gadget, *Data)
		Protected *GadgetData.GadgetData = GetGadgetData(Gadget)
		
		*GadgetData\Data = *Data
	EndProcedure
	
	Procedure GetData(Gadget)
		Protected *GadgetData.GadgetData = GetGadgetData(Gadget)
		
		ProcedureReturn *GadgetData\Data
	EndProcedure
	
	Procedure SetText(Gadget, Text.s)
		
	EndProcedure
	
	Procedure SetImage(Gadget, Image)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		
		CompilerIf Defined(MaterialVector,#PB_Module)
			If *Data\MaterialVector = #True
				*Data\Image = Image
			EndIf
		CompilerElse
			
		CompilerEndIf
		
		Redraw(Gadget)
	EndProcedure
	
	; Private procedures
	Procedure Handler_Canvas()
		Protected Gadget = EventGadget(), *Data.GadgetData = GetGadgetData(Gadget), Result
		
		Select EventType()
			Case #PB_EventType_MouseEnter
				*Data\State = #Warm
				Result = #True
			Case #PB_EventType_MouseLeave
				*Data\State = #Cold
				Result = #True
			Case #PB_EventType_LeftButtonDown
				*Data\State = #Hot
				Result = #True
			Case #PB_EventType_LeftButtonUp
				Protected MouseX = GetGadgetAttribute(Gadget, #PB_Canvas_MouseX), MouseY = GetGadgetAttribute(Gadget, #PB_Canvas_MouseY)
				If MouseX >= 0 And MouseX < *Data\Width And MouseY >= 0 And MouseY < *Data\Height
					
					If *Data\Handler
						CallFunctionFast(*Data\Handler, Gadget)
					EndIf
					
					*Data\State = #Warm
					Result = #True
				EndIf
		EndSelect
		
		If Result
			Redraw(Gadget)
		EndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure Redraw(Gadget)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		
		StartVectorDrawing(CanvasVectorOutput(Gadget))
		AddPathBox(0, 0, VectorOutputWidth(), VectorOutputHeight())
 		VectorSourceColor(*Data\BackColors(*Data\State))
 		FillPath()
 		
 		VectorSourceColor(*Data\FrontColors(*Data\State))
 		
 		If *Data\Type = #Text
 			
 		Else
 			If *Data\Image > -1
 				CompilerIf Defined(MaterialVector,#PB_Module)
 					If *Data\MaterialVector
 						MaterialVector::Draw(*Data\Image, *Data\ImageXOffset, *Data\ImageYOffset, *Data\ImageWidth, *Data\FrontColors(*Data\State), *Data\BackColors(*Data\State), *Data\MaterialVectorStyle)
 					Else
 				CompilerEndIf
 				
 				CompilerIf Defined(MaterialVector,#PB_Module)
 					EndIf
 				CompilerEndIf
 			EndIf
 		EndIf
 		
		StopVectorDrawing()
		
	EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
	
	IncludeFile "..\MaterialVector\MaterialVector.pbi"
	
	Procedure HandlerClose()
		End
	EndProcedure
	
	Procedure HandlerButton(Gadget)
		Debug "Button click!"
	EndProcedure
	
	OpenWindow(0, 0, 0, 400, 300, "CanvasButton example", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
	
	CanvasButton::GadgetImage(0, 10,10,40,40, MaterialVector::#Play, CanvasButton::#MaterialVectorIcon | CanvasButton::#DarkTheme)
	
	BindEvent(#PB_Event_CloseWindow, @HandlerClose())
	CanvasButton::BindEventHandler(0, @HandlerButton())
	
	Repeat
		WaitWindowEvent()
	ForEver
	
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 255
; Folding = DAAI-
; EnableXP