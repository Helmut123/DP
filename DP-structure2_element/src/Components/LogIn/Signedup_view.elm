module Components.Login.Signedup_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Login.Signedup_model as Signedup_model exposing (..)
import Components.Login.Signedup_update as Signedup_update exposing (..)


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