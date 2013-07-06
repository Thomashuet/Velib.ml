{
  open Lexing

  type position = {
    lat : float;
    lng : float;
  }

  type station = {
    number : int;
    contract_name : string;
    name : string;
    address : string;
    position : position;
    banking : bool;
    bonus : bool;
    status : string;
    bike_stands : int;
    available_bike_stands : int;
    available_bikes : int;
    last_update : int;
  }
}

let sp = [' ' '\t' '\n']*

rule station s  = parse
| [' ' '\t' '\n' ',']
  { station s lexbuf }
| "\"number\"" sp ":" sp
  { station {s with number = int lexbuf} lexbuf }
| "\"contract_name\"" sp ":" sp
  { station {s with contract_name = string lexbuf} lexbuf }
| "\"name\"" sp ":" sp
  { station {s with name = string lexbuf} lexbuf }
| "\"address\"" sp ":" sp
  { station {s with address = string lexbuf} lexbuf }
| "\"position\"" sp ":" sp "{"
  { station {s with position = position s.position lexbuf} lexbuf }
| "\"banking\"" sp ":" sp
  { station {s with banking = bool lexbuf} lexbuf }
| "\"bonus\"" sp ":" sp
  { station {s with bonus = bool lexbuf} lexbuf }
| "\"status\"" sp ":" sp
  { station {s with status = string lexbuf} lexbuf }
| "\"bike_stands\"" sp ":" sp
  { station {s with bike_stands = int lexbuf} lexbuf }
| "\"available_bike_stands\"" sp ":" sp
  { station {s with available_bike_stands = int lexbuf} lexbuf }
| "\"available_bikes\"" sp ":" sp
  { station {s with available_bikes = int lexbuf} lexbuf }
| "\"last_update\"" sp ":" sp
  { station {s with last_update = int lexbuf} lexbuf }
| "}"
  { s }

and position p = parse
| [' ' '\t' '\n' ',']
  { position p lexbuf }
| "\"lat\"" sp ":" sp
  { position {p with lat = float lexbuf} lexbuf }
| "\"lng\"" sp ":" sp
  { position {p with lng = float lexbuf} lexbuf }
| "}"
  { p }

and bool = parse
| "true" { true }
| "false" { false }

and float = parse
| ['0'-'9' '.']+ as x { float_of_string x }

and int = parse
| ['0'-'9']+ as n { int_of_string n }

and string = parse
| '"' (([^'"'] | "\\\"")* as s)'"' { s }

and list_content f i = parse
| [' ' '\t' '\n' ','] { list_content f i lexbuf }
| "{" {
  let h = f i lexbuf in
  h :: list_content f i lexbuf
}
| "]" { [] }

and list f i = parse
| "[" { list_content f i lexbuf }
