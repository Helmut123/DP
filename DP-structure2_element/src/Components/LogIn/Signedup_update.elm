module Components.Login.Signedup_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Login.Signedup_model as Signedup_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | TryLog


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            ( model )
        TryLog -> 
            ( model )