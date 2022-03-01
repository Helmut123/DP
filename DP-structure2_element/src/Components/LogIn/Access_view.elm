module Components.Login.Access_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Login.Access_model as Access_model exposing (..)
import Components.Login.Access_update as Access_update exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div[]
    [
        div[ class "access" ]
        [
            div [ class "text" ]
            [
                div[ class "access_top"]
                [
                    p[ class "par" ][ text "Can" ]
                    , p[ class "access_success par" ][ text " NOT " ]
                    , p[ class "par" ][ text "access this feature!" ]
                ]
                , div[ class "access_bot" ]
                [
                    p[ class "par" ][ text "Please " ]
                    , a[ class "par", onClick ( Log )  ][ text "Log in" ]
                    , p[ class "par" ][ text " first to gain access" ]
                ]
                , div[ class "access_bottom" ]
                [
                    p[ class "par" ][ text "Don't have an account? " ]
                    , a[ class "par", onClick ( Sig )  ][ text "Sign up" ]
                ]
            ]   
        ]
    ]