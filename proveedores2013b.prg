SET DEFAULT TO \\migue-PC\PROVEEDORES2013B 
SET DECIMALS TO 2
SET POINT TO ","
SET SEPARATOR TO "."
SET CENTURY ON
SET DATE ITALIAN
_SCREEN.FontSize=25
SET DELETED ON

DO WHILE .t.

   CONST="s"
   CLEAR
   @ 1,1 say "INTRODUCIR FACTURAS (I)"
   @ 2,1 SAY "MANTENIMIENTO DE PROVEEDORES (P)"
   @ 3,1 SAY "CONSULTA MENSUAL DE UN PROVEEDOR (C)" GET CONST
   @ 4,1 SAY "SALIR (S)"
   @ 5,1 say "LISTADO MENSUAL (L)"
   @ 6,1 SAY "CONSULTA ANUAL DE UN PROVEEDOR (A)"
   READ
   CONST=LOWER(CONST)
   
   DO CASE
   
   
       CASE CONST="i"
           DO FACTURAS
           
           
       CASE CONST="p"
           DO MANPROV
           
       CASE CONST="c"
           DO CONSULPROVMES
       CASE const="l"
           DO listado    
                 
       CASE CONST="a"
           DO CONSULPROVAN
       
       CASE CONST="s"
           *QUIT
           clear
           cancel
           
  ENDCASE  
  
  ENDDO  
  
   
**************************************+
**************************************
******************************************



PROCEDURE FACTURAS      
SELECT 1
USE PROV2013B
WSEGUIR=.T.
DO WHILE WSEGUIR=.T.

STORE SPACE(21) TO WNUMFAC
STORE SPACE(20) TO WNIF
WIMPORTE=0
WFECHA=CTOD("01-01-2019")
wfechapag=CTOD("01-01-2019")
SEGUIR="N"

CLEAR

@ 1,1 SAY "INTRODUCCION DE FACTURAS DE PROVEEDORES"
@ 2,1 SAY "NUMERO DE FACTURA" GET WNUMFAC
@ 3,1 SAY "NIF" GET WNIF
@ 4,1 SAY "IMPORTE" GET WIMPORTE PICTURE "99,999.99"
@ 5,1 SAY "FECHA" GET WFECHA
@ 6,1 say "FECHA DE PAGO" GET WFECHAPAG
@ 7,1 SAY "SEGUIR S/N" GET SEGUIR
READ

*BUSCAR EN LA TABLA NUMERO DE FACTURA Y NIF
testigo=.f.
CLOSE DATABASES
USE prov2013b INDEX inFECniFfAC
REINDEX
SEEK DTOS(WFECHA)+wnif+wnumfac
IF FOUND()
  testigo=.t.
  WAIT "LA FACTURA YA EXISTE"

ENDIF
CLOSE DATABASES
cLOSE INDEXES
USE prov2013b

*SI YA EXISTE SACAR MENSAJE Y NO GRABAR



SEGUIR=UPPER(SEGUIR)
IF SEGUIR="S"
  WSEGUIR=.t. 
  ELSE 
  WSEGUIR=.F.
ENDIF

IF testigo=.f.
  APPEND BLANK
  REPLACE FACTURA WITH WNUMFAC
  REPLACE NIF WITH WNIF
  REPLACE IMPORTE WITH WIMPORTE

  REPLACE FECHA WITH WFECHA
  REPLACE FECHAPAG WITH WFECHAPAG
endif

SELECT * FROM NOMPROV WHERE NIF=WNIF INTO CURSOR CURSOR3
IF CURSOR3.NOMBRE=" "
     WNOMBRE=SPACE(40)
     
     CLEAR
     @ 1,1 SAY "INTRODUCCION DE PROVEEDOR NUEVO"
     @ 2,1 SAY "NOMBRE DE PROVEEDOR" GET WNOMBRE
     READ
     SELECT 2
     USE NOMPROV
     APPEND BLANK
     REPLACE NOMBRE WITH WNOMBRE
     REPLACE NIF WITH WNIF 
     SELECT 1
ELSE
     SELECT 1
ENDIF

ENDDO
CLOSE INDEXES 
CLOSE DATA

RETURN

***************************++
**************************+
***************************


PROCEDURE CONSULPROVMES

STORE SPACE(20) TO WNIF
ANNO=2019
MES=1



CLEAR

@ 1,1 SAY "CONSULTA DE UN PROVEEDOR"
@ 2,1 SAY "INTRODUCIR NIF DEL PROVEEDOR" GET WNIF
@ 3,1 SAY "INTRODUCIR MES EN NUMERO" GET MES
@ 4,1 SAY "INTRODUCIR A�O" GET ANNO
READ

CLEAR
SELECT * FROM NOMPROV WHERE NIF=WNIF INTO CURSOR cursor2
SELECT * FROM PROV2013B WHERE YEAR(FECHA)=ANNO.AND.MONTH(FECHA)=MES.AND.NIF=WNIF ORDER BY Factura INTO CURSOR CURSOR1

REPORT FORM PROVEEDORES2 TO PRINTER PROMPT PREVIEW
CLOSE DATABASES 
RETURN





***************************++
**************************+
***************************


PROCEDURE CONSULPROVAN

STORE SPACE(20) TO WNIF
ANNO=2019
MES=1



CLEAR

@ 1,1 SAY "CONSULTA DE UN PROVEEDOR"
@ 2,1 SAY "INTRODUCIR NIF DEL PROVEEDOR" GET WNIF
*@ 3,1 SAY "INTRODUCIR MES EN NUMERO" GET MES
@ 4,1 SAY "INTRODUCIR A�O" GET ANNO
READ

CLEAR
SELECT * FROM NOMPROV WHERE NIF=WNIF INTO CURSOR cursor2
SELECT * FROM PROV2013B WHERE YEAR(FECHA)=ANNO.AND.NIF=WNIF ORDER BY FACTURA INTO CURSOR CURSOR1

REPORT FORM PROVEEDORES3 TO PRINTER PROMPT PREVIEW
CLOSE DATABASES 
RETURN


*********************************+
*********************************
*************************************


PROCEDURE MANPROV

RETURN


********************************+
*************************************
************************


PROCEDURE listado

ANNO=2019
MES=1



CLEAR

@ 1,1 SAY "listado mensual"
*@ 2,1 SAY "INTRODUCIR NIF DEL PROVEEDOR" GET WNIF
@ 3,1 SAY "INTRODUCIR MES EN NUMERO" GET MES
@ 4,1 SAY "INTRODUCIR A�O" GET ANNO
READ

CLEAR
SELECT * FROM prov2013b JOIN NOMPROV ON PROV2013B.NIF=NOMPROV.NIF WHERE YEAR(fecha)=ANNO.and.month(fecha)=MES ORDER BY FACTURA INTO CURSOR cursor1


*SELECT * FROM PROV2013B WHERE YEAR(FECHA)=ANNO.AND.MONTH(FECHA)=MES INTO CURSOR CURSOR1

REPORT FORM PROVEEDORES TO PRINTER PROMPT PREVIEW
CLOSE DATABASES 





return