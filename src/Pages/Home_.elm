module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html exposing (a, p, text)
import Html.Attributes exposing (href)
import Page
import Request
import Shared exposing (Msg(..))
import Task
import Time
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared _ =
    Page.advanced
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { timeMaybe : Maybe Time.Posix }


init : ( Model, Effect Msg )
init =
    ( { timeMaybe = Nothing
      }
    , Effect.fromCmd <| Task.perform GotTime Time.now
    )



-- UPDATE


type Msg
    = GotTime Time.Posix


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotTime posix ->
            ( { model | timeMaybe = Just posix }, Effect.none )



-- VIEW


toTimeText : Time.Zone -> Time.Posix -> String
toTimeText zone posix =
    let
        hourText =
            String.fromInt <| Time.toHour zone posix

        minutesText =
            String.fromInt <| Time.toMinute zone posix

        secondsText =
            String.fromInt <| Time.toSecond zone posix
    in
    hourText ++ ":" ++ minutesText ++ ":" ++ secondsText


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Shared Test"
    , body =
        [ p [] [ a [ href <| Gen.Route.toHref Gen.Route.Calendar ] [ text "カレンダー表示へ" ] ]
        , p [] [ a [ href <| Gen.Route.toHref Gen.Route.Settings ] [ text "タイムゾーン設定画面へ" ] ]
        , case model.timeMaybe of
            Just time ->
                p [] [ text <| toTimeText shared.timezone time ]

            Nothing ->
                text ""
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every 1000 GotTime
        ]
