module Components.ToDo.Activity_view exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_, src, id)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Components.ToDo.Activity_model as Activity_model exposing (..)
import Components.ToDo.Activity_update as Activity_update exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div[ class "" ]
    [
        div[ class "activity" ]
        [
            div[ class "activity_info" ]
            [
                p[][ text model.name ]
            ]
            , div[ class "activity_edit" ]
            [
                a[ onClick AcitivityDone ][ img [ src "approve.png", id "approve" ][] ]
                , a[ onClick AcitivityRemove ][ img [ src "deny.png", id "deny" ][] ]
            ]
        ]
    ]