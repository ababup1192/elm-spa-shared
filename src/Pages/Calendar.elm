module Pages.Calendar exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Calendar exposing (Params)
import Gen.Route
import Html exposing (a, p, text)
import Html.Attributes exposing (href)
import Page
import Request
import Shared
import Task
import Time
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { timeMaybe : Maybe Time.Posix }


init : ( Model, Cmd Msg )
init =
    ( { timeMaybe =
            Nothing
      }
    , Task.perform GotTime Time.now
    )



-- UPDATE


type Msg
    = GotTime Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTime posix ->
            ( { model | timeMaybe = Just posix }, Cmd.none )



-- VIEW


toDateText : Time.Zone -> Time.Posix -> String
toDateText zone time =
    let
        monthText =
            case Time.toMonth zone time of
                Time.Jan ->
                    "1"

                Time.Feb ->
                    "2"

                Time.Mar ->
                    "3"

                Time.Apr ->
                    "4"

                Time.May ->
                    "5"

                Time.Jun ->
                    "6"

                Time.Jul ->
                    "7"

                Time.Aug ->
                    "8"

                Time.Sep ->
                    "9"

                Time.Oct ->
                    "10"

                Time.Nov ->
                    "11"

                Time.Dec ->
                    "12"

        dayText =
            String.fromInt <| Time.toDay zone time

        weekDayText =
            case Time.toWeekday zone time of
                Time.Sun ->
                    "日"

                Time.Mon ->
                    "月"

                Time.Tue ->
                    "火"

                Time.Wed ->
                    "水"

                Time.Thu ->
                    "木"

                Time.Fri ->
                    "金"

                Time.Sat ->
                    "土"
    in
    monthText ++ "/" ++ dayText ++ "(" ++ weekDayText ++ ")"


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Shared Test"
    , body =
        [ p [] [ a [ href <| Gen.Route.toHref Gen.Route.Home_ ] [ text "時刻表示へ" ] ]
        , p [] [ a [ href <| Gen.Route.toHref Gen.Route.Settings ] [ text "タイムゾーン設定画面へ" ] ]
        , case model.timeMaybe of
            Just time ->
                p [] [ text <| toDateText shared.timezone time ]

            Nothing ->
                text ""
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
