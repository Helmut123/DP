module Components.Button.Button exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Url


---- MODEL ----


type alias Model =
    {
       storage: Storage
       , url: Url.Url
    }

type Storage = Cookies
    | Session
    | Local


init : Url.Url -> ( Model, Cmd Msg )
init url = 
    ({
    storage = Local
    , url = url 
    }, Cmd.none)



---- UPDATE ----


type Msg
    = NoOp
    | SwapStorage Storage


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        SwapStorage storage ->
            { model | storage = storage }


getModel : ( Model, Cmd Msg ) -> Model
getModel  ( model, msg ) =
    model


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
                        a [ href "/", id "cookies", class "active_storage", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ href "/", id "local", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ href "/", id "session", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
                Local ->
                    div[ class "change_option" ]
                    [
                        a [ href "/", id "cookies", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ href "/", id "local", class "active_storage", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ href "/", id "session", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
                Session ->
                    div[ class "change_option" ]
                    [
                        a [ href "/", id "cookies", onClick ( SwapStorage Cookies ) ][ text "Cookies" ]
                        , a [ href "/", id "local", onClick ( SwapStorage Local ) ][ text "LocalStorage" ]
                        , a [ href "/", id "session", class "active_storage", onClick ( SwapStorage Session ) ][ text "SessionStorage" ]
                    ]
        ]
    ]
