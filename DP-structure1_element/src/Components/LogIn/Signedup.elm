module Components.Login.Signedup exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {}


init : Model
init = ( Model )



---- UPDATE ----


type Msg
    = NoOp
    | TryLog


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            ( model )
        TryLog -> 
            ( model )


---- VIEW ----


view : Model -> Html Msg
view model =
    div[]
    [
        div[ class "signedup" ]
        [
            div [ class "text" ]
            [
                div[ class "signedup_top"]
                [
                    p[ class "signedup_success par" ][ text "Successfully " ]
                    , p[ class "par" ][ text " Signed Up to scheduler!" ]
                ]
                , div[ class "signedup_bot" ]
                [
                    a[ class "par", onClick ( TryLog ) ][ text "Log in" ]
                    , p[ class "par" ][ text " now, to try all features" ]
                ]
            ]   
        ]
    ]
    