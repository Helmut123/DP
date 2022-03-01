module Components.Button.Button exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


---- MODEL ----


type alias Model =
    {
       storage: Storage
    }

type Storage = Cookies
    | Session
    | Local


init : Model
init = 
    ({
    storage = Local
    })



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
