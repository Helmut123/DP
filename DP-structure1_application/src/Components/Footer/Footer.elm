module Components.Footer.Footer exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {
        page: Page
    }

type Page = Home
    | ToDo
    | Ritual


init : Model
init = 
    ({
    page = Home
    })



---- UPDATE ----


type Msg
    = NoOp
    | FooterSwapPage Page


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        FooterSwapPage page ->
            { model | page = page }



---- VIEW ----


view : Model -> Html Msg
view model =
    div[][
        div [ class "footer" ]
        [
            div [ class "footer_body" ]
            [   
                div [ class "footer_heading" ]
                [
                    a [ href "/", id "footer_home", onClick ( FooterSwapPage Home ) ] [ text "elm" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [] [ text "Scheduler" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [ href "/todo", onClick ( FooterSwapPage ToDo ) ] [ text "To do" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [ href "/rituals", onClick ( FooterSwapPage Ritual ) ] [ text "Rituals" ]
                ]
                , div [ class "footer_heading" ]
                [
                    h2 [] [ text "Quick links" ]
                ]
                , div [ class "footer_heading" ]
                [
                    h2 [] [ text "Contact" ]
                ]
                , div [ class "under_footer" ]
                [
                    div [ class "footer_link" ]
                    [
                        h2 [] [ text " " ]
                    ]
                    , div [ class "footer_link" ]
                    [
                        h2 [] [ text " " ]
                    ]
                    , div [ class "footer_link" ]
                    [
                        h2 [] [ text " " ]
                    ]
                    , div [ class "footer_link" ]
                    [
                        h2 [] [ text " " ]
                    ]
                    , div [ class "footer_link" ]
                    [
                        a [] [ text "Install" ]
                        , a [] [ text "Packages" ]
                        , a [] [ text "Guide" ]
                    ]
                    , div [ class "footer_link" ]
                    [
                        a [] [ text "Contact me" ]
                        , div[ class "soc_networks" ][
                            a [] [ img [ src "fb.png" ][] ]
                            , a [] [ img [ src "tt.png" ][] ]
                            , a [] [ img [ src "ig.png" ][] ]
                        ]
                    ]
                ]
            ]
            
            , div [ class "footer_bottom" ]
            [
                a [] [ text "Compiler Source" ]
                , a [] [ text "Site Source" ]
                , a [] [ text "© 2020-2022 Fano Adam" ]
            ]
        ]
    ]
    