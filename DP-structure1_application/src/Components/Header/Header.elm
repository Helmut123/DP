module Components.Header.Header exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.LogIn.Signup as Signup exposing (..)

---- MODEL ----


type alias Model =
    {
        page: Page
        , logged : Bool
    }


type Page = Login
    | Signup

init : Model
init = 
    ({
    page = Login
    , logged = False
    })



---- UPDATE ----


type Msg
    = NoOp
    | SwapPage Page
    | Logout


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        SwapPage page ->
            { model | page = page }
        Logout ->
            { model | logged = False }


changeLogged : Model -> Model
changeLogged model =
    if model.logged then
        { model | logged = False }
    else
        { model | logged = True }


---- VIEW ----


view : Model -> Html Msg
view model =
    div[]
    [
        div [ class "topnav" ]
        [
            if model.logged then
                div [ class "logs" ][
                        a [ href "/", onClick ( Logout )][ text "Log Out" ]
                    ]
            else
                div [ class "logs" ][
                        a [ href "/login", onClick ( SwapPage Login )][ text "Log In" ]
                        , a [ href "/signup", onClick ( SwapPage Signup )][ text "Sign Up" ]
                    ]
        ]
    ]

