module Components.Footer.Footer_update exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.Footer.Footer_model as Footer_model exposing (..)


---- UPDATE ----


type Msg
    = NoOp
    | FooterSwapPage Footer_model.Page


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        FooterSwapPage page ->
            { model | page = page }


