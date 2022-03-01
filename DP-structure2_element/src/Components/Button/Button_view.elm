module Components.Button.Button_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Button.Button_update as Button_update exposing (..)
import Components.Button.Button_model as Button_model exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div[]
    [
        div[ class "change_button" ]
        [
            a [][ text "< ! >" ]
            , case model.storage of
                Cookies ->
                    div[ class "change_option" ]
                    [
                        a [ id "cookies", class "active_storage", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ id "local", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ id "session", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
                Local ->
                    div[ class "change_option" ]
                    [
                        a [ id "cookies", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ id "local", class "active_storage", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ id "session", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
                Session ->
                    div[ class "change_option" ]
                    [
                        a [ id "cookies", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ id "local", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ id "session", class "active_storage", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
        ]
    ]
