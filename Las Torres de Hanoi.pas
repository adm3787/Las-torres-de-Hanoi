program juego_2_2;
uses hanoi_1;
begin
 menu_jugar:=false;
 repeat
  if menu_jugar then Jugar
                else Las_Torres_de_Hanoi
 until nivel=14;
 final
end.
