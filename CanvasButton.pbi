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
	
	Declare Special(Gadget, X, Y, Width, Height, Text.s, Image, Flags = #Default)
	
	Declare Gadget(Gadget, X, Y, Width, Height, Text.s, Flags = #Default)
	Declare GadgetImage(Gadget, X, Y, Width, Height, Image = -1, Flags = #Default)
	Declare SetColor(Gadget, Colortype, Color)
	Declare Free(Gadget)
	Declare BindEventHandler(Gadget, *Handler)
	Declare SetData(Gadget, *Data)
	Declare GetData(Gadget)
	Declare SetText(Gadget, Text.s)
	Declare SetImage(Gadget, Image)
	Declare SetFont(Gadget, Font)
	Declare SetState(Gadget, State)
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
		#Special
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
		
		Toggle.b
		ToggleState.b
		
		Font.i
		
		Image.i
		ImageWidth.i
		ImageHeight.i
		ImageXOffset.i
		ImageYOffset.i
		TextYOffset.i
		
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
		#Style_Dark_BackWarm = $FF433C39
		#Style_Dark_BackHot = $FF504943
		
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
	
	Global DefaultFont = LoadFont(#PB_Any, "Calibri", 12, #PB_Font_HighQuality)
	;}
	
	; Private procedures declaration
	Declare Handler_Canvas()
	
	Declare Redraw(Gadget)
	
	; Public procedures
	Procedure Special(Gadget, X, Y, Width, Height, Text.s, Image.i, Flags = #Default)
		Protected Result, *Data.GadgetData
		
		Result = Gadget(Gadget, X, Y, Width, Height, Text, Flags)
		
		If Result
			If Gadget = #PB_Any
				Gadget = Result
			EndIf
			*Data.GadgetData = GetGadgetData(Gadget)
			
			With *Data
				\Type = #Special
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
								\ImageYOffset = Round(Height * 0.35, #PB_Round_Up)
								\ImageXOffset = \ImageYOffset
								\ImageWidth = Width - 2 * \ImageXOffset
							Else
								\ImageXOffset = Round(Width * 0.35, #PB_Round_Up)
								\ImageYOffset = \ImageXOffset
								\ImageWidth = Width - 2 * \ImageXOffset
							EndIf
							
							\ImageYOffset = \ImageXOffset * 0.5
							
						EndIf
						
						\MaterialVectorStyle = Flags
					Else
					CompilerEndIf
					
					If \Image > -1
						\ImageYOffset = (72 - ImageHeight(\Image)) * 0.5
						\ImageXOffset = (128 - ImageWidth(\Image)) * 0.5
						\ImageWidth = 128
						\ImageHeight = 81
					EndIf
					
					CompilerIf Defined(MaterialVector,#PB_Module)
					EndIf
				CompilerEndIf
				
				
			EndWith
			
		EndIf
		Redraw(Gadget)
		ProcedureReturn Result
	EndProcedure
	
	Procedure GadgetImage(Gadget, X, Y, Width, Height, Image = -1, Flags = #Default)
		Protected Result, *Data.GadgetData
		
		Result = Gadget(Gadget, X, Y, Width, Height, "", Flags)
		
		If Result
			If Gadget = #PB_Any
				Gadget = Result
			EndIf
			*Data.GadgetData = GetGadgetData(Gadget)
			
			With *Data
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
				
				\Width = Width
				\Height = Height
				
				\Toggle = Flags & #ToggleButton
				
				\Type = #Text
				\Text = Text
				
				\Font = DefaultFont
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
		If Colortype < #ColorType_FrontCold
			*Data\BackColors(Colortype) = Color
		Else
			*Data\FrontColors(Colortype - #ColorType_FrontCold) = Color
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
	
	Procedure SetFont(Gadget, Font)
		Protected *GadgetData.GadgetData = GetGadgetData(Gadget)
		
		*GadgetData\Font = Font
		Redraw(Gadget)
	EndProcedure
	
	Procedure SetState(Gadget, State)
		Protected *GadgetData.GadgetData = GetGadgetData(Gadget)
		
		If Not *GadgetData\ToggleState = State
			*GadgetData\ToggleState = State
			If *GadgetData\ToggleState
				*GadgetData\State = #Hot
			Else
				*GadgetData\State = #Cold
			EndIf
			
			Redraw(Gadget)
		EndIf
		
	EndProcedure
	
	; Private procedures
	Procedure Handler_Canvas()
		Protected Gadget = EventGadget(), *Data.GadgetData = GetGadgetData(Gadget), Result
		
		Select EventType()
			Case #PB_EventType_MouseEnter
				If Not *Data\ToggleState
					*Data\State = #Warm
					Result = #True
				EndIf
			Case #PB_EventType_MouseLeave
				If *Data\ToggleState
					*Data\State = #Hot
				Else
					*Data\State = #Cold
				EndIf
				Result = #True
				
			Case #PB_EventType_LeftButtonDown
				*Data\State = #Hot
				Result = #True
			Case #PB_EventType_LeftButtonUp
				Protected MouseX = GetGadgetAttribute(Gadget, #PB_Canvas_MouseX), MouseY = GetGadgetAttribute(Gadget, #PB_Canvas_MouseY)
				If MouseX >= 0 And MouseX < *Data\Width And MouseY >= 0 And MouseY < *Data\Height
					
					If *Data\Toggle
						*Data\ToggleState = Bool(Not *Data\ToggleState)
					EndIf
					
					If *Data\Handler
						CallFunctionFast(*Data\Handler, Gadget)
					EndIf
					
					If Not *Data\ToggleState
						*Data\State = #Warm
						Result = #True
					EndIf
				EndIf
		EndSelect
		
		If Result
			Redraw(Gadget)
		EndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure Redraw(Gadget)
		Protected *Data.GadgetData = GetGadgetData(Gadget)
		Select *Data\Type 
			Case #Text
				StartDrawing(CanvasOutput(Gadget))
				Box(0,0, OutputWidth(), OutputHeight(), *Data\BackColors(*Data\State))
				DrawingFont(FontID(*Data\Font))
				DrawText((OutputWidth() - TextWidth(*Data\Text)) * 0.5, (OutputHeight() - TextHeight(*Data\Text)) * 0.5, *Data\Text, *Data\FrontColors(*Data\State), *Data\BackColors(*Data\State))
				
				StopDrawing()
			Case #Image
				StartVectorDrawing(CanvasVectorOutput(Gadget))
				AddPathBox(0, 0, VectorOutputWidth(), VectorOutputHeight())
				VectorSourceColor(*Data\BackColors(*Data\State))
				FillPath()
				
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
				StopVectorDrawing()
			Case #Special
				StartVectorDrawing(CanvasVectorOutput(Gadget))
				AddPathBox(0, 0, VectorOutputWidth(), VectorOutputHeight())
				VectorSourceColor(*Data\BackColors(*Data\State))
				FillPath()
				
				VectorFont(FontID(*Data\Font), 18)
				
				If *Data\Image > -1
					CompilerIf Defined(MaterialVector,#PB_Module)
						If *Data\MaterialVector
							MaterialVector::Draw(*Data\Image, *Data\ImageXOffset, *Data\ImageYOffset, *Data\ImageWidth, *Data\FrontColors(*Data\State), *Data\BackColors(*Data\State), *Data\MaterialVectorStyle)
							MovePathCursor((VectorOutputWidth() - VectorTextWidth(*Data\Text)) * 0.5, *Data\ImageYOffset * 1.5 + *Data\ImageWidth)
							VectorSourceColor(*Data\FrontColors(*Data\State))
							DrawVectorText(*Data\Text)
						Else
						CompilerEndIf
						
						MovePathCursor(*Data\ImageXOffset, *Data\ImageYOffset)
						DrawVectorImage(ImageID(*Data\Image))
						MovePathCursor(3, 72)
						VectorSourceColor(*Data\FrontColors(*Data\State))
						DrawVectorText(*Data\Text)
						
; 						If *Data\State
; 							AddPathBox(0, 0, *Data\Width, *Data\Height)
; 							StrokePath(1)
; 						EndIf
						
						CompilerIf Defined(MaterialVector,#PB_Module)
						EndIf
					CompilerEndIf
				EndIf
				StopVectorDrawing()
		EndSelect
	EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
	
; 	IncludeFile "..\MaterialVector\MaterialVector.pbi"
	
	Procedure HandlerClose()
		End
	EndProcedure
	
	Procedure HandlerButton(Gadget)
		Debug "Button click!"
	EndProcedure
	
	OpenWindow(0, 0, 0, 400, 300, "CanvasButton example", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
	
	CanvasButton::Gadget(0, 10, 10, 200, 40, "Testouille", CanvasButton::#DarkTheme | CanvasButton::#ToggleButton)
	
	BindEvent(#PB_Event_CloseWindow, @HandlerClose())
	CanvasButton::BindEventHandler(0, @HandlerButton())
	
	Repeat
		WaitWindowEvent()
	ForEver
	
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 475
; FirstLine = 223
; Folding = -bAi--
; EnableXP