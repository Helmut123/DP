module Components.Login.Access_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Login.Access_model as Access_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | Log
    | Sig


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            ( model )
        Log ->
            ( model )
        Sig ->
            ( model )

