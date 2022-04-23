module Pages.Settings exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Settings exposing (Params)
import Gen.Route
import Html exposing (a, button, p, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Page
import Request
import Shared
import Task
import Time
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { isSetting : Bool }


init : ( Model, Effect Msg )
init =
    ( { isSetting = False }, Effect.none )



-- UPDATE


type Msg
    = GetTimezone
    | GotTimezone Time.Zone


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GetTimezone ->
            ( model, Effect.fromCmd <| Task.perform GotTimezone Time.here )

        GotTimezone zone ->
            ( { model | isSetting = True }, Effect.fromShared <| Shared.UpdateTimeZone zone )



-- VIEW


view : Model -> View Msg
view model =
    { title = "Shared Test"
    , body =
        [ p [] [ a [ href <| Gen.Route.toHref Gen.Route.Home_ ] [ text "時刻表示へ" ] ]
        , p [] [ a [ href <| Gen.Route.toHref Gen.Route.Calendar ] [ text "カレンダー表示へ" ] ]
        , button [ onClick GetTimezone ] [ text "タイムゾーンを設定" ]
        , if model.isSetting then
            p [] [ text "タイムゾーンをセットしました！" ]

          else
            text ""
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
