module Components.LogIn.Signup_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Components.User.User as User exposing (..)
import Components.LogIn.Signup_model as Signup_model exposing (..)
import Components.LogIn.Signup_update as Signup_update exposing (..)


---- VIEW ----


view : Signup_model.Model -> Html Msg
view model =
    div[ class "signup" ]
    [
        div[ class "signup_body" ]
        [
            div[ class "signup_form" ]
            [
                h2 [][ text "Sign Up" ]
                , div[ class "signup_inform" ]
                [
                    case model.warning of
                        1 -> div[ class "wrong_input" ]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        2 -> div[ class "wrong_input" ]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "username:" ]
                                , input[ type_ "text", Html.Attributes.value model.username, onInput UserName ][]
                            ]
                    , case model.warning of
                        3 -> div[ class "wrong_input" ]
                            [
                                p[][ text "e-mail:" ]
                                , input[ placeholder "example@gmail.com",  type_ "email", Html.Attributes.value model.email, onInput Email ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "e-mail:" ]
                                , input[ placeholder "example@gmail.com",  type_ "email", Html.Attributes.value model.email, onInput Email ][]
                            ]
                    , case model.warning of 
                        4 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        5 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        7 -> div[ class "wrong_input" ]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "password:" ]
                                , input[ placeholder "6+ characters", type_ "password", Html.Attributes.value model.password, onInput Password ][]
                            ]
                    , case model.warning of
                        6 -> div[ class "wrong_input" ]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                        7 -> div[ class "wrong_input" ]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                        _ -> div[]
                            [
                                p[][ text "re-password:" ]
                                , input[ type_ "password", Html.Attributes.value model.repassword, onInput RePassword ][]
                            ]
                ]
                , div[ class "signup_error" ]
                [
                    case model.warning of
                        1 -> p[][ text "ENTER username!" ]
                        2 -> p[][ text "Username too SHORT!" ]
                        3 -> p[][ text "ENTER e-mail!" ]
                        4 -> p[][ text "ENTER password!" ]
                        5 -> p[][ text "Password too SHORT!" ]
                        6 -> p[][ text "REENTER password!" ]
                        7 -> p[][ text "Passwords do NOT match!" ]
                        _ -> p[][ text "" ]
                ]
                , div[ class "button" ]
                [
                    if model.username == "" || model.password == "" || model.repassword == "" || model.email == "" then
                        a [ class "unclick", onClick Submit ][ text "Enter" ]
                    else
                        a [ onClick Submit ][ text "Enter" ]
                ]
            ]
        ]
    ]