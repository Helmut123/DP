module Components.Header.Header_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Header.Header_model as Header_model exposing (..)
import Components.Header.Header_update as Header_update exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div[]
    [
        div [ class "topnav" ]
        [
            if model.logged then
                div [ class "logs" ][
                        a [ onClick ( Logout )][ text "Log Out" ]
                    ]
            else
                div [ class "logs" ][
                        a [ onClick ( SwapPage Login )][ text "Log In" ]
                        , a [ onClick ( SwapPage Signup )][ text "Sign Up" ]
                    ]
        ]
    ]