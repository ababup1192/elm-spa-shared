module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Json.Decode as Json
import Request exposing (Request)
import Time


type alias Flags =
    Json.Value


type alias Model =
    { timezone : Time.Zone }


type Msg
    = UpdateTimeZone Time.Zone


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { timezone = Time.utc }, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        UpdateTimeZone zone ->
            ( { model | timezone = zone }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
