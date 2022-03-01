module Components.ToDo.Activity_model exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, type_, src, id)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)


---- MODEL ----


type alias Model =
    {
    name : String
    , active : Bool
    , id : Int
    }


init : Model
init = ( Model "" True -1 )