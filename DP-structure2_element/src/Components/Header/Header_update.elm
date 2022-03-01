module Components.Header.Header_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Header.Header_model as Header_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | SwapPage Header_model.Page
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