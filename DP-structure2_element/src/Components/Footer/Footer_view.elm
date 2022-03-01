module Components.Footer.Footer_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Footer.Footer_model as Footer_model exposing (..)
import Components.Footer.Footer_update as Footer_update exposing (..)


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
                    a [ id "footer_home", onClick ( FooterSwapPage Home ) ] [ text "elm" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [] [ text "Scheduler" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [ onClick ( FooterSwapPage ToDo ) ] [ text "To do" ]
                ]
                , div [ class "footer_heading" ]
                [
                    a [ onClick ( FooterSwapPage Ritual ) ] [ text "Rituals" ]
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
   