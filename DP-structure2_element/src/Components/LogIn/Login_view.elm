module Components.LogIn.Login_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.User.User as User exposing (..)
import Components.LogIn.Login_model as Login_model exposing (..)
import Components.LogIn.Login_update as Login_update exposing (..)


---- VIEW ----


view : Login_model.Model -> Html Msg
view model =
    div[ class "login" ]
    [
        div[ class "login_body" ]
        [
            div[ class "login_form" ]
            [
                h2 [][ text "Log In" ]
                , div[ class "login_inform" ]
                [
                    case model.warning of
                        1 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        2 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        _ -> div[]
                            [
                                p[ class "login_p" ][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                    
                    , case model.warning of
                        4 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        5 -> div[ class "wrong_input" ]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        _ -> div[]
                            [
                                p[ class "login_p" ][ text "password:" ]
                                , input[ type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                ]
                , div[ class "signup_error" ]
                [
                    case model.warning of
                        1 -> p[][ text "ENTER username!" ]
                        2 -> p[][ text "INVALID username!" ]
                        4 -> p[][ text "ENTER password!" ]
                        5 -> p[][ text "INVALID password!" ]
                        _ -> p[][ text "" ]
                ]
                , div[ class "button" ]
                [
                    if model.username == "" || model.password == "" then
                        a [ class "unclick", onClick Submit ][ text "Enter" ]
                    else
                        a [ onClick Submit ][ text "Enter" ]
                ]
            ]
        ]
    ]