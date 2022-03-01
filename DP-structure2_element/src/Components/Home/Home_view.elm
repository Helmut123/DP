module Components.Home.Home_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time
import Components.Home.Home_model as Home_model exposing (..)
import Components.Home.Home_update as Home_update exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "home" ]
    [
        div[ class "home_body" ]
        [
            img [ src "Elm.svg" ][]
            , div[ class "body_heading" ]
            [
                h2 [][ text "A delightful scheduler" ]
                , h2 [][ text "as reliable web application." ]
{-                , let
                    first = String.fromInt (model.carouselTime)
                in
                    h1 [][ text (first) ] -}
            ]
            , case model.active of
                First -> 
                    div[]
                    [
                        div[ class "carousel" ]
                        [
                            div[ class "slide", id "slide-1" ]
                            [
                                h3[][ text "\"It is the most productive online shceduler I have used.\"" ]
                                , p[][ text "Fano Adam, Software engineer" ]
                            ]
                        ]
                        , div[ class "dot" ]
                        [
                            a[ href "#slide-1", onClick ( SwapActive First 0 ) ][ span [ class "dots active" ][] ]
                            , a[ href "#slide-2", onClick ( SwapActive Second 5 ) ][ span [ class "dots" ][] ]
                            , a[ href "#slide-3", onClick ( SwapActive Third 10 ) ][ span [ class "dots" ][] ]
                        ]
                    ]
                Second -> 
                    div[]
                    [
                        div[ class "carousel" ]
                        [
                            div[ class "slide", id "slide-2" ]
                            [
                                h3[][ text "\"Using Scheduler, I can schedule and go to sleep!\"" ]
                                , p[][ text "Adam Fano, student, FIIT STU" ]
                            ]
                        ]
                        , div[ class "dot" ]
                        [
                            a[ href "#slide-1", onClick ( SwapActive First 0 ) ][ span [ class "dots" ][] ]
                            , a[ href "#slide-2", onClick ( SwapActive Second 5 ) ][ span [ class "dots active" ][] ]
                            , a[ href "#slide-3", onClick ( SwapActive Third 10 ) ][ span [ class "dots" ][] ]
                        ]
                    ]
                Third -> 
                    div[]
                    [
                        div[ class "carousel" ]
                        [
                            div[ class "slide", id "slide-3" ]
                            [
                                h3[][ text "\"I love how fast Scheduler is. I make a change and I get an immediate response.\"" ]
                                , p[][ text "Adam Fano, JIRA administrator, RPC" ]
                            ]
                        ]
                        , div[ class "dot" ]
                        [
                            a[ href "#slide-1", onClick ( SwapActive First 0 ) ][ span [ class "dots" ][] ]
                            , a[ href "#slide-2", onClick ( SwapActive Second 5 ) ][ span [ class "dots" ][] ]
                            , a[ href "#slide-3", onClick ( SwapActive Third 10 ) ][ span [ class "dots active" ][] ]
                        ]
                    ]
        ]
    ]