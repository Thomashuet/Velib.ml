open Json

let (@) f g x = f (g x)

let ($) f x = f x

let default = {
  number = 0;
  contract_name = "";
  name = "";
  address = "";
  position = {lat = 0.; lng = 0.};
  banking = false;
  bonus = false;
  status = "";
  bike_stands = 0;
  available_bike_stands = 0;
  available_bikes = 0;
  last_update = 0;
}

let get_velib () =
  list station default
  @ Lexing.from_string
  @ Http_client.Convenience.http_get
  $ "https://api.jcdecaux.com/vls/v1/stations?contract=Paris&apiKey=" ^ Api.key

let () = begin
  Ssl.init();
  Http_client.Convenience.configure_pipeline
    (fun p ->
       let ctx = Ssl.create_context Ssl.TLSv1 Ssl.Client_context in
       let tct = Https_client.https_transport_channel_type ctx in
       p # configure_transport Http_client.https_cb_id tct
    )
end
