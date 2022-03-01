module Components.Button.Button_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Button.Button_model as Button_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | SwapStorage Button_model.Storage


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        SwapStorage storage ->
            { model | storage = storage }
