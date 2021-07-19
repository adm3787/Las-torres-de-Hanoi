unit HANOI_1;

interface
uses crt;
const
 enter=#13; arriba=#72; abajo=#80; derecha=#77; izquierda=#75;
type
 numeros=0..80;
 pila=^nodo;
 nodo=record
  disco,linea:numeros;
  sig:pila
 end;
var
 base_start,base_finish,color,nivel,piso,techo,lote_x:numeros;
 movimientos:word; hacer:char;
 aux,uno,dos,tres:pila; alternador,menu_jugar:boolean;

procedure texto_centrado(texto:string; lin,color:byte);
function poste(lote:char):numeros;
procedure numeros_123(val_piso:numeros);
procedure ocupa(val_poste,tam,y,tono:numeros; con:char);
procedure bases(val_piso,val_nivel:numeros);
procedure inicializo_pilas(var primera,segunda,tercera:pila; val_nivel,val_piso:numeros);
procedure disposicion_inicial(num_d_base:numeros; var base1,base2,base3:pila; val_piso,val_nivel:numeros);
procedure resaltar(x,y:numeros; caracter:char; q_tonos:boolean);
procedure levantar(var kbza,auxiliar:pila;var sac_pon:boolean; selector:char;var el_lote:numeros);
procedure colocar(var kbza,auxiliar:pila;var sac_pon:boolean; lote_ant:numeros; selector:char; var mov:word);
procedure representa(num:char; b_finish:numeros);
procedure Las_Torres_de_Hanoi;
procedure Jugar;
procedure final;

implementation
procedure texto_centrado(texto:string; lin,color:byte);
Begin gotoxy(39 - (length(texto) div 2),lin); textcolor(color); write(texto) End;
function poste(lote:char):numeros;
Begin
 case lote of
  '1':poste:=14;
  '2':poste:=41;
  '3':poste:=68
 end
End;
procedure numeros_123(val_piso:numeros);
var i:char;
Begin
 for i:='1' to '3' do
  begin gotoxy(poste(i)-1,val_piso); textcolor(8); write(i) end
End;
procedure ocupa(val_poste,tam,y,tono:numeros; con:char);
var c,x:numeros;
Begin
 x:=val_poste - tam; textcolor(tono);
 for c:=1 to tam do begin gotoxy(x,y); write(con,con); inc(x,2); end
End;
procedure bases(val_piso,val_nivel:numeros);
var i:char;
Begin for i:='1' to '3' do ocupa(poste(i),val_nivel,piso-1,15,'|') End;
procedure inicializo_pilas(var primera,segunda,tercera:pila; val_nivel,val_piso:numeros);
Begin
 new(primera); primera^.disco:=val_nivel+1; primera^.linea:=val_piso - 1;
 primera^.sig:= nil; segunda:=primera; tercera:=segunda
End;
procedure disposicion_inicial(num_d_base:numeros; var base1,base2,base3:pila; val_piso,val_nivel:numeros);
procedure construye_torre(var kbza:pila);
var auxiliar:pila; i,dim,el_lote:numeros;
Begin
 case num_d_base of
  1:el_lote:=14;
  2:el_lote:=41;
  3:el_lote:=68
 end;
 for i:=1 to val_nivel do
  begin
   new(auxiliar); dim:=val_nivel + 1 - i; auxiliar^.disco:=dim;
   auxiliar^.linea:=val_piso - 1 - i; auxiliar^.sig:=kbza;
   kbza:=auxiliar; ocupa(el_lote,dim,kbza^.linea,color,'X')
  end
End;
Begin
 Case num_d_base of
  1: construye_torre(uno);
  2: construye_torre(dos);
  3: construye_torre(tres)
 end
End;
procedure resaltar(x,y:numeros; caracter:char; q_tonos:boolean);
Begin
 gotoxy(x,y);
  if q_tonos then textcolor(15) else textcolor(12); write(caracter); delay(70);
 gotoxy(x,y);
  if q_tonos then if caracter='V'then textcolor(15) else textcolor(8) else textcolor(4); write(caracter)
End;
procedure levantar(var kbza,auxiliar:pila;var sac_pon:boolean; selector:char;var el_lote:numeros);
Begin
 if kbza^.sig <> nil then
  begin
   el_lote:=poste(selector); auxiliar:=kbza; kbza:=auxiliar^.sig;
   sac_pon:=not sac_pon;
   ocupa(el_lote,auxiliar^.disco,auxiliar^.linea,7,' ');
   ocupa(el_lote,auxiliar^.disco,techo,color,'X')
  end
End;
procedure colocar(var kbza,auxiliar:pila;var sac_pon:boolean; lote_ant:numeros; selector:char; var mov:word);
Begin
 if auxiliar^.disco < kbza^.disco then
  begin
   auxiliar^.linea:=kbza^.linea - 1; auxiliar^.sig:=kbza; kbza:=auxiliar;
   sac_pon:=not sac_pon;
   ocupa(lote_ant,kbza^.disco,techo,15,' ');
   ocupa(poste(selector),kbza^.disco,kbza^.linea,color,'X'); inc(mov)
  end
End;
procedure representa(num:char;b_finish:numeros);
var cad1:string[1]; num_push:numeros; cod:integer;
Begin
 cad1:=num; val(cad1,num_push,cod);
 if num_push = b_finish then resaltar(poste(num)-1,piso,num,false)
                        else resaltar(poste(num)-1,piso,num,true);
 if alternador then
                case num of
                 '1':levantar(uno,aux,alternador,num,lote_x);
                 '2':levantar(dos,aux,alternador,num,lote_x);
                 '3':levantar(tres,aux,alternador,num,lote_x)
                end
               else
                case num of
                 '1':colocar(uno,aux,alternador,lote_x,num,movimientos);
                 '2':colocar(dos,aux,alternador,lote_x,num,movimientos);
                 '3':colocar(tres,aux,alternador,lote_x,num,movimientos)
                end
End;
procedure Las_Torres_de_Hanoi;
const
Instrucciones: array[1..7] of string[78] =
('Para ganar hay que mover la Torre hacia la base indicada',
'Dicha base es aquella que tiene un numero rojo debajo',
'Solo hay dos posibles acciones: LEVANTAR disco - COLOCAR disco',
'Las acciones se realizan alternadamente. La primer accion es LEVANTAR',
'Presionando 1 , 2 o 3 se indica donde se llevara a cabo la accion vigente',
'No se puede COLOCAR un disco encima de otro de menor diametro',
'LEVANTAR + COLOCAR  =  1 MOVIMIENTO');
Partida: array[1..4] of string[64] =
('1312321321231312323121321312321321231321323121231312321321231312',
 '3231213213123231212313213231213213123213212313123231213213123213',
 '2123132132312123131232132123132132312132131232312123132132312123',
 '13123213212313123231213213123213212313213231212313123213212313');
var y_ant,y_act,como_jugar,ind_mues,ind_car:numeros; ralentizador:longint;
procedure escribe_opcion(opcion,tono:numeros);
Begin
 gotoxy(35,opcion); textcolor(tono+8);
 Case opcion of
  4: write('Jugar');
  6: begin
      write('Nivel'); gotoxy(wherex + 2,opcion); write(nivel:2)
     end;
  8: begin
      write('Color'); gotoxy(wherex + 2,opcion);
      textcolor(color); write('XX')
     end;
  10:begin
      write('Como jugar'); window(4,11,76,11); clrscr; window(1,1,80,25);
      gotoxy(40-(length(Instrucciones[como_jugar]) div 2),opcion+1);
      write(Instrucciones[como_jugar])
     end;
  12:begin gotoxy(35,13); write('Salir') end
 end
End;
procedure cambiar_resaltar(lado:char; op:numeros);
procedure Case_lado(x1,x2,mas:numeros);
Begin
 Case lado of
  izquierda: resaltar(x1,op + mas,'<',true);
  derecha: resaltar(x2,op + mas,'>',true)
 end
End;
procedure valor_numerico(flecha:char; min,max:numeros; var referente:numeros);
Begin
 Case flecha of
  derecha:if referente < max then inc(referente);
  izquierda:if min < referente then dec(referente)
 end
End;
Begin
 Case op of
  6:begin
     valor_numerico(lado,1,13,nivel); case_lado(41,44,0)
    end;
  8:begin
     valor_numerico(lado,1,15,color); case_lado(41,44,0)
    end;
 10:begin
     valor_numerico(lado,1,7,como_jugar); case_lado(3,77,1)
    end
 end
End;
procedure control(accion:char; var opcion:numeros);
Begin
 Case accion of
  enter:Case opcion of
         4:menu_jugar:=true;
         12:nivel:=14
        end;
  arriba:if 4 < opcion then dec(opcion,2);
  abajo:if opcion < 12 then inc(opcion,2);
  izquierda,derecha: cambiar_resaltar(accion,opcion)
 end
End;
Begin
 clrscr;
 gotoxy(29,1); textcolor(15); write('LAS TORRES DE HANOI');
 y_act:=4; escribe_opcion(y_act,3); textcolor(8);
 gotoxy(41,6); write('<  >'); gotoxy(41,8); write('<  >');
 gotoxy(3,11); write('<'); gotoxy(77,11); write('>');
 y_ant:=6; como_jugar:=1;
 repeat
  escribe_opcion(y_ant,7); inc(y_ant,2)
 until y_ant > 12;
 piso:=25; techo:=piso - (7 + 3);
 numeros_123(piso); gotoxy(67,piso); textcolor(red); write(3);
 bases(piso,7); inicializo_pilas(uno,dos,tres,7,piso);
 disposicion_inicial(1,uno,dos,tres,piso,7); alternador:=true;
 ind_mues:=1; ind_car:=1;
 repeat
  for ralentizador:=1 to 300000 do
    if keypressed then
                   begin
                    hacer:=readkey; y_ant:=y_act; control(hacer,y_act);
                    escribe_opcion(y_ant,7); escribe_opcion(y_act,3)
                   end;
  if (ind_mues <= 4)and(ind_car <= 64) then
     begin
      representa(partida[ind_mues][ind_car],3);
      if ind_mues = 4
       then
           if ind_car < 62 then inc(ind_car)
                          else ind_mues:=5
       else
           if ind_car < 64 then inc(ind_car)
                          else begin inc(ind_mues); ind_car:=1 end
     end
 until (nivel=14) or menu_jugar;
 clrscr
End;
procedure Jugar;
function caso_ideal(val_nivel:numeros):real;
Begin caso_ideal:=exp(val_nivel*(ln(2)))-1 End;
procedure parche;
Begin
 window(1,1,80,piso-1); clrscr; window(1,1,80,25); gotoxy(63,25); clreol
End;

procedure Iniciar;
Begin
 gotoxy(36,1); textcolor(green+8); write('LEVANTAR'); alternador:=true;
 techo:=piso - (nivel + 3); inicializo_pilas(uno,dos,tres,nivel,piso);
 bases(piso,nivel); textcolor(15); gotoxy(41,21); write(nivel:3);
 gotoxy(38,22); write(caso_ideal(nivel):4:0,' movimientos'); movimientos:=0;
 gotoxy(44,23); write(movimientos:4); numeros_123(piso);
 base_start:=random(3)+1;
 disposicion_inicial(base_start,uno,dos,tres,piso,nivel);
 repeat base_finish:=random(3)+1 until base_start <> base_finish;
 case base_finish of
  1: gotoxy(13,piso);
  2: gotoxy(40,piso);
  3: gotoxy(67,piso)
 end;
 textcolor(red+8); write(base_finish);
End;
function gano(b_finish:numeros; kbza1,kbza2,kbza3:pila; val_nivel:numeros):boolean;
function verifica_construccion(kbza:pila):boolean;
var i:numeros;
Begin
 i:=1;
 if kbza^.sig = nil then verifica_construccion:=false
                    else
                     begin
                      while (kbza^.disco = i)and(i <= val_nivel) do
                       begin kbza:=kbza^.sig; inc(i) end;
                      verifica_construccion:= (i = val_nivel + 1)
                    end
End;
Begin
 Case b_finish of
  1: gano:=verifica_construccion(uno);
  2: gano:=verifica_construccion(dos);
  3: gano:=verifica_construccion(tres)
 end
End;
Begin {Jugar}
 piso:=19; Iniciar; textcolor(15);
 gotoxy(35,21); write('Nivel:');
 gotoxy(26,22); write('Caso ideal:'); gotoxy(31,23); write('Movimientos:');
 gotoxy(1,25); write('<-Menu Principal');
 gotoxy(34,25); write('[V]Reiniciar');
 repeat
  if keypressed then
   begin
    hacer:=readkey;
    Case hacer of
     '1','2','3':begin
                  representa(hacer,base_finish);
                  if alternador then begin gotoxy(44,23); textcolor(15); write(movimientos:4) end;
                  if not gano(base_finish,uno,dos,tres,nivel)
                   then
                    begin
                     gotoxy(36,1);
                     if alternador then begin textcolor(green+8); write('LEVANTAR') end
                                   else begin textcolor(red+8); write('COLOCAR ') end;
                    end
                  else
                   begin
                    gotoxy(35,1); textcolor(15); write('TERMINADO'); gotoxy(63,25);
                    write('Siguiente Nivel'); write('->');
                    repeat
                     if keypressed then
                      begin
                       hacer:=readkey;
                       Case hacer of
                        izquierda:begin resaltar(1,25,'<',true); menu_jugar:=false end;
                        'v','V':begin resaltar(35,25,'V',true); parche; Iniciar; end;
                        derecha:begin
                                 resaltar(79,25,'>',true);
                                 if nivel < 13 then inc(nivel)
                                               else nivel:=1;
                                 Parche; Iniciar
                                end
                       end
                      end
                    until (upcase(hacer) = 'V') or (hacer = derecha) or not menu_jugar;
                   end
                 end;
     izquierda:begin resaltar(1,25,'<',true); menu_jugar:=false end;
     'v','V':begin resaltar(35,25,'V',true); parche; Iniciar; end;
    end
   end
 until not menu_jugar;
End;{Jugar}
procedure final;
Begin
 clrscr;
 texto_centrado('Realizado por:',3,15);
 texto_centrado('Agustin Dario Medina',7,15);
 texto_centrado('Terminado el 14/03/2012',12,15);
 texto_centrado('Ultima modificacion: 08/08/2014',13,15);
 texto_centrado('Agradecimientos',18,15);
 texto_centrado(' A mi primo "El Gabi" por prestarme su notebook',20,15);
 texto_centrado(' Presionar cualquier tecla para salir',25,7);
 repeat until keypressed; textcolor(7); clrscr
End;
BEGIN randomize; color:=1; nivel:=1; END.
