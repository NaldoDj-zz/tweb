//	{% LoadHrb( 'lib/tweb/tweb.hrb' ) %}

#include {% TWebInclude() %}

#define PATH_DATA 		HB_GetEnv( "PRGPATH" ) + '/data/'

function main()

    LOCAL o, oWeb	
	LOCAL hParam := GetMsgServer()
	local cPar1, cPar2 
	
	if !empty( hParam )

		cPar1 :=  hParam[ 'par1' ] 
		cPar2 :=  hParam[ 'par2' ] 
		
		USE ( PATH_DATA + 'charset.dbf' ) SHARED NEW VIA 'DBFCDX'
	
		dbgotop()						
		
		dbRlock()
		
		field->par1 := U8TOUNI( cPar1, 1 )	//#DEFINE UTYPE_ANSI          1  // ANSI
		field->par2 := cPar2


		AP_SetContentType( "application/json" )
	
		?? hb_jsonEncode( { 'parameters' => hParam } )		
		
		retu nil 
		
	else
	
		//	Init vars 
		
		cPar1 := 'àáèéíòóúñç'
		cPar2 := '早上好'
		
		?? 'Init vars...<hr>'
	
	endif 	
	
			
	
	//DEFINE WEB oWeb TITLE 'Test CharSet - Dbf' CHARSET 'utf-8' INIT 
	DEFINE WEB oWeb TITLE 'Test CharSet - Dbf' INIT 
	
	DEFINE FORM o
		
		HTML o PARAMS oWeb 
			
			<h3>					
				Charset: <$ oWeb:cCharset $>
			</h3><hr>	
			
		ENDTEXT		

	INIT FORM o

	
		ROWGROUP o			
			GET ID 'par1' 	VALUE cPar1 	GRID 6 LABEL 'Parameter 1 (par1)' OF o
			GET ID 'par2'	VALUE cPar2	GRID 6 LABEL 'Parameter 2 (par2)' OF o			
		ENDROW o		
		
		ROWGROUP o
			BUTTON LABEL 'Send' GRID 4 ACTION 'Save()' OF o      
		ENDROW o

		HTML o 
		
			<script>
			
			
				function Save(){
				
					var oPar = new Object()
						oPar[ 'par1'] = $( '#par1').val()
						oPar[ 'par2'] = $( '#par2').val()
						
					MsgServer( "charset-f.prg", oPar, PostSave )									
				}
				
				function PostSave( response ) {
					console.log( response )
					alert( 'Save done!. See console...')										
				}
				
				
			</script>
		
		ENDTEXT 
	
	END FORM o 
	
retu nil